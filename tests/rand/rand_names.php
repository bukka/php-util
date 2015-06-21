<?php
$vowels = array("a", "e", "o", "u");
$consonants = array("b", "c", "d", "v", "g", "t");

function randVowel()
{
	global $vowels;
	return $vowels[array_rand($vowels, 1)];
}

function randConsonant()
{
	global $consonants;
	return $consonants[array_rand($consonants, 1)];
}

echo ucfirst("" . randConsonant() . "" . randVowel() . "" . "" . randConsonant() . "" . randVowel() . "" . randVowel() . "");

