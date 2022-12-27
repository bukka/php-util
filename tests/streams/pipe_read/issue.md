The plain wrapper is usually used for file but also for pipes created by `proc_open`. Currently EOF is set only after an empty read (0 bytes returned). There is a special case for files, memory and temp ops to do another read if less than requested bytes is returned. It might be convenient to do the same for pipes to identify whether EOF is reached. This is exactly what glibc fread does and it might make sense to apply the same logic for PHP fread.

To give an example, lets consider following script called `pipe_eof_test.php`:
```php
<?php
$descriptorspec=array(
	0 => STDIN,
	1 => array("pipe", "w"),
	2 => STDERR
);
$p = proc_open(['echo', '-n', '01234567890123456789'], $descriptorspec, $fd);

$res = '';
$size = $argv[1];
while (strlen($s = fread($fd[1], $size)) == $size) {
	$res .= $s;
}
$res .= $s;

fprintf(STDERR, "Result: %s, EOF: %d\n", $res, feof($fd[1]));
```
It is basically reading from a pipe where is written 20 bytes (echo...). The result differs depending on the size of the requested bytes. So the EOF is 0 if `$size` is over 20 but it is 1 if it is below 20 which can be seen when running script

```
$ php pipe_eof_test.php 32
Result: 01234567890123456789, EOF: 0
$ php pipe_eof_test.php 16
Result: 01234567890123456789, EOF: 1
```
The reason is that all available bytes are read internally to 8k buffer on the first read. In the first case, we use only a single read and less bytes is returned. In the second case, we need second read because all 16 bytes are returned. 

The thing to consider is whether 


 This would be more consistent as following case would be the same