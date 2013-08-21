<?php
$im = new Imagick();
$im->newImage(200, 200, 'red');
$color = "red";
//$im->borderImage($color, 2, 2); 
$im->destroy();
echo PHP_VERSION;
