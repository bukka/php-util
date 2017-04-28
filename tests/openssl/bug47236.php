<?php

$wrapper = 'ssl'; // never changes
$protocol = 'tls'; // or 'ssl' or 'sslv2' or 'sslv3'
$site_cert = NULL;
$context = stream_context_create();
$result = stream_context_set_option($context, $wrapper, 'capture_peer_cert', true);
if ($fp = stream_socket_client("$protocol://google.com:443", $errno, $errstr, 30, STREAM_CLIENT_CONNECT, $context)) {
    if ($options = stream_context_get_options($context)) {
        var_dump($options);
        if (isset($options[$wrapper]) &&
            isset($options[$wrapper]['peer_certificate'])) {
            $site_cert = $options[$wrapper]['peer_certificate'];
        }
    }
    fclose($fp);
}
if ($site_cert) {
    openssl_x509_export($site_cert, $str_cert);
    $pubkey = openssl_pkey_get_public($str_cert);
    $keyinfo = openssl_pkey_get_details($pubkey);
	var_dump($keyinfo);
}
