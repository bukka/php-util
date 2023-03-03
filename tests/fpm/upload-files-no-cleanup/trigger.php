<?php
$ssl = false;
$ip = '';
$host = 'localhost';
$path = '/index.php';
$file = 'Hey, look at me, Im a temporary file content.';
$scheme = ($ssl ? 'ssl://' : '');
$files = 20;
$requests  = 10;
$gvars = 1000;
$port = 8080;
$grepeat = 1;
$EOL = "\r\n";
$body = '';

$files = 1;
$requests  = 1;
$gvars = 0;
$boundary = 'aXbXcX';

for($i = 0; $i < $files; $i++){
    $body.= "--$boundary$EOL";
    $body.='Content-Disposition: form-data; name="tmp_file"; filename="future_temporary_file"'.$EOL;
    $body.='Content-Type: text/plain'.$EOL;
    $body.= $EOL;
    $body.= $file.$EOL;
}

for($i = 0; $i < $gvars; $i++){
    $body.= "--$boundary$EOL";
    $body.='Content-Disposition: form-data; name="some_garbage['.$i.']"'.$EOL;
    $body.= $EOL;
    $body.= str_repeat('A', $grepeat).$EOL;
}

$body.= "--$boundary--$EOL";

$header ='POST '.$path.' HTTP/1.1'.$EOL;
$header.='Content-Type: multipart/form-data; boundary=---------------------------xxxxxxxxxxxx'.$EOL;
$header.='User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:56.0) Gecko/20160101 Firefox/56.0'.$EOL;
$header.='Host: '.$host.':'.$port.$EOL.$EOL;
//$header.='Content-Length: '.strlen($body).$EOL;
//$header.='Connection: close'.$EOL.$EOL;

echo $EOL.($requests * $files).' files will be sent to '.$host.$EOL.$EOL;

for($i = 1; $i <= $requests; $i++){
    echo 'Sending files #'.$i.'	'."\n";
    $fp = stream_socket_client($scheme.($ip ? $ip : $host).':'.$port, $errno, $errstr, 30);
    $req = $header.$body;
    echo $req;
    fwrite($fp, $req);
    //stream_socket_shutdown($fp, STREAM_SHUT_RDWR);
    fclose($fp);
    echo 'OK'.$EOL;
    usleep(10000);
}   