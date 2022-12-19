<?php
file_put_contents("./source", "bar");
file_put_contents("./dest", "foo");
$sourceHandle = fopen("./source", "r");
$destHandle = fopen("./dest", "a");
stream_copy_to_stream($sourceHandle, $destHandle);
fclose($sourceHandle);
fclose($destHandle);
var_dump(file_get_contents("./dest"));
