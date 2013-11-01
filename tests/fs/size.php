<?php
function file_get_size($file) {
    //open file
    $fh = fopen($file, "r"); 
    //declare some variables
    $size = "0";
    $char = "";
    //set file pointer to 0; I'm a little bit paranoid, you can remove this
    fseek($fh, 0, SEEK_SET);
    //set multiplicator to zero
    $count = 0;
    while (true) {
        //jump 1 MB forward in file
        fseek($fh, 1048576, SEEK_CUR);
        //check if we actually left the file
        if (($char = fgetc($fh)) !== false) {
            //if not, go on
            $count ++;
        } else {
            //else jump back where we were before leaving and exit loop
            fseek($fh, -1048576, SEEK_CUR);
            break;
        }
    }
    //we could make $count jumps, so the file is at least $count * 1.000001 MB large
    //1048577 because we jump 1 MB and fgetc goes 1 B forward too
    $size = $count;
    fclose($fh);
    return $size;
}

if ($argc > 1) {
	echo file_get_size($argv[1]);
}
?>
