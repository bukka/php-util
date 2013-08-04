<?php
$im = new Imagick();
$im->newImage(100, 100, 'none');
$color = "red";
$im->borderImage($color, 2, 2); 
