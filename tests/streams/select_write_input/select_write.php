<?php

// See "Actual Results" section for description of code and (extremely simple) usage directives

$file_bufsize = 64;
$stdin_bufsize = 1024;
$stdout_bufsize = 1024;

$delayms = 10000;

$inputfile = __DIR__ . '/input.txt';

$file = fopen($inputfile, 'r');
$filesize = fstat($file)['size'];

for (;;) {
	
	$proc = proc_open("cat",
		[['pipe', 'r'], ['pipe', 'w'], ['pipe', 'w']], $pipes);
	
	/*1*/ #stream_set_read_buffer($file, 0);
	
	$readbytes = $proc_in = $proc_out = $proc_err = $zerowrites = 0;
	$proc_sendq = ""; 
	$stdin_done = false;
	
	print "starting\n";
	
	for (;;) {
		
		$read = $write = $except = [];
		
		foreach ([1, 2] as $i) if (!feof($pipes[$i])) $read[] = $pipes[$i];
		
		if (!$stdin_done && $proc_sendq != "") $write[] = $pipes[0];
		
		/*2*/ if ($filesize - $readbytes > 0) $read[] = $file;
		
		dump_fds($read, $write, $pipes, $file);
		print "=>  <sel";
		if ($read || $write) {
			#/*3a*/ stream_select($read, $write, $except, null);
			/*3b*/ stream_select($read, $write, $except, 0);
		}
		print "ect>  =>  ";
		dump_fds($read, $write, $pipes, $file);
		print "\n";
		
		foreach ($read as $rfd) {
			switch ($rfd) {
				case $file:
					// file input
					$data = fread($file, min($file_bufsize, $filesize - $readbytes));
					$readbytes += strlen($data);
					$proc_sendq .= $data;
					break;
				case $pipes[1]:
				case $pipes[2]:
					// process stdout or stderr (which is input from PHP's POV)
					// cat never writes stderr so use stdout's bufsize
					$l = strlen($data = fread($rfd, $stdout_bufsize));
					if ($rfd == $pipes[1]) {
						$proc_out += $l; $s = "out";
					} else {
						$proc_err += $l; $s = "err";
					}
					print "\nstd".$s.": \"".$data."\"\n\n";
			}
		}
		
		// only $pipes[0] will ever be in the $write array
		if (in_array($pipes[0], $write) && $proc_sendq != "") {
			$len = fwrite($pipes[0], $proc_sendq, $stdin_bufsize);
			if ($len == 0) {
				if ($zerowrites++ == 5) {
					// note zerowrites is zeroed just below; this counts
					// a series of successive write failures as fatal.
					print "\n\nI/O error\n\n";
					die;
				}
			} else {
				$proc_in += $len;
				$zerowrites = 0;
				$proc_sendq = substr($proc_sendq, $len);
				if ($proc_in == $filesize) {
					fclose($pipes[0]);
					$stdin_done = true;
					print "\nstdin done\n\n";
				}
			}
		}
		
		print "file($readbytes)  buf:".strlen($proc_sendq)
			."  proc(I:$proc_in O:$proc_out E:$proc_err)\n";
		
		// if process has quit AND its stdout/stderr are closed, it's done.
		if (!proc_get_status($proc)['running'] && feof($pipes[1]) &&
			feof($pipes[2])
		) { print "\n\nbreaking\n"; break; }
		
		usleep($delayms);
		print "\n";
	}
	print "\nloop finished => proc_close()\n";
	fclose($pipes[1]); fclose($pipes[2]); proc_close($proc);
}
/* Aesthetic printing function, buried at the bottom to improve
 * general readability. Implementation unimportant */
function dump_fds($read, $write, $pipes, $file) {
	foreach (['R' => $read, 'W' => $write] as $label => $fds) {
		print $label.": [ ";
		foreach ($fds as $f) {
			print ($f == $file ? 'file' : ['in', 'out', 'err']
				[array_search($f, $pipes)]).'#'.(int)$f.' ';
		}
		print "]  ";
	}
}