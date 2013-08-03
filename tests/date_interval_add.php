<?php
$i0 = new Dateinterval('P1Y4D');
$i1 = new DateInterval('P1Y3D');
$i0->invert = 1;

$i2 = $i0->add($i1); /* -1 day */
var_dump($i2->format('%y-%m-%d %h-%i-%s'));
var_dump($i2->invert);

$i2 = $i0->sub($i1); /* -(2 years and 7 days) */
var_dump($i2->format('%y-%m-%d %h-%i-%s'));
var_dump($i2->invert);

$i0->invert = 0;
$i2 = $i0->sub($i1);
var_dump($i2->format('%y-%m-%d %h-%i-%s'));
var_dump($i2->invert);

$i0 = new Dateinterval('P1Y4DT3H');
$i1 = new DateInterval('P1Y4DT3H2M');
$i2 = $i0->sub($i1); /* -2 minutes */
var_dump($i2->format('%y-%m-%d %h-%i-%s'));
var_dump($i2->invert);

$i2 = $i1->sub($i0);
var_dump($i2->format('%y-%m-%d %h-%i-%s'));
var_dump($i2->invert);
