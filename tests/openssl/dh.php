<?php
$details = [
  'p' => base64_decode('3Pk6C4g5cuwOGZiaxaLOMQ4dN3F+jZVxu3Yjcxhm5h73Wi4niYsFf5iRwuJ6Y5w/KbYIFFgc07LKOYbSaDcFV31FwuflLcgcehcYduXOp0sUSL/frxiCjv0lGfFOReOCZjSvGUnltTXMgppIO4p2Ij5dSQolfwW9/xby+yLFg6s='),
  'g' => base64_decode('Ag=='),
  'priv_key' => base64_decode('jUdcV++P/m7oUodWiqKqKXZVenHRuj92Ig6Fmzs7QlqVdUc5mNBxmEWjug+ObffanPpOeab/LyXwjNMzevtBz3tW4oROau++9EIMJVVQr8fW9zdYBJcYieC5l4t8nRj5/Uu/Z0G2rWVLBleSi28mqqNEvnUs7uxYxrar69lwQYs=')
];

$opensslKeyResource = openssl_pkey_new(['dh' => $details]);
$data = openssl_pkey_get_details($opensslKeyResource);

printf("Private key:\n%s\n", base64_encode($data['dh']['priv_key']));
printf("Public key:\n%s\n", base64_encode($data['dh']['pub_key']));
