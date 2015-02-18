<?php

$json = json_decode('["\uD900"]');
$jsond = jsond_decode('["\uD900"]', true, 512, JSOND_VALID_ESCAPED_UNICODE);
if ($jsond === NULL) {
	var_dump(jsond_last_error_msg());
}
var_dump(bin2hex($json[0]), bin2hex($jsond[0]), $json === $jsond);

