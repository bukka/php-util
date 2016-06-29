--TEST--
Test bug #25: fann_create_standard_array with 0-neuron layer
--FILE--
<?php
   
$num_layers = 2;
$num_neurons1 = 0;
$num_neurons2 = 2;

var_dump( fann_create_standard_array( $num_layers, array( $num_neurons1, $num_neurons2 ) ) );

?>
--EXPECTF--
