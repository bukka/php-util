<?php

    // C:\Users\User\Desktop\php-openssl-certificate-example.cmd

    // @echo off

    // title PHP Development Server

    // cd "%cd%"

    // "C:\php\php.exe" "php-openssl-certificate-example.php"

    // pause

    // C:\Users\User\Desktop\php-openssl-certificate-example.php [PID:9676][PHP:7.3.3]

    //-------------------------------------------------
    // HEAD
    //-------------------------------------------------

    declare( strict_types = 1 );

    header( 'Content-Type:text/plain' );

    error_reporting( E_ALL );

    ini_set( 'display_errors', '1' );

    ini_set( 'html_errors', '0' );

    define( 'CORE_DIR', dirname( __FILE__ ) . DIRECTORY_SEPARATOR );

    isset( $argv ) or trigger_error( 'This is a command terminal application.', E_USER_ERROR );

    echo __FILE__ . ' [PID:' . getmypid() . '][PHP:' . phpversion() . ']' . PHP_EOL . PHP_EOL;

    extension_loaded( 'openssl' ) or dl( 'openssl' ) or trigger_error( 'The openssl extension is required.', E_USER_ERROR );

    //-------------------------------------------------
    // CERTIFICATE LOCATIONS
    //-------------------------------------------------

    $array_of_certificate_locations = openssl_get_cert_locations();

    echo var_export( $array_of_certificate_locations, true ) . PHP_EOL;

    // The ".rnd" file is created at the point of execution. In my case on the desktop. And not as planned in the specified directory.

    // $file_path = $array_of_certificate_locations[ 'default_default_cert_area' ] . DIRECTORY_SEPARATOR . '.rnd';

    // file_exists( $file_path ) or touch( $file_path );

    // is_writeable( $file_path ) or trigger_error( 'The file (' . $file_path . ') does not exist or is not writable.', E_USER_ERROR );

    //-------------------------------------------------
    // CREATE PRIVATE AND PUBLIC KEY
    //-------------------------------------------------

    $options = array();

    $options[ 'config' ] = '/usr/local/ssl111/ssl/openssl-2.cnf'; // Returns: only public key

    // $options[ 'config' ] = realpath( 'C:\usr\local\ssl\renamed_openssl.cnf' ); // Returns: only public key

    // $options[ 'config' ] = realpath( 'C:\usr\local\ssl\openssl.cnf' ); // Returns: private and public key

    // $options[ 'encrypt_key' ] = true; // If I set this value true, where do I deposit the password?

    $options[ 'digest_alg' ] = 'sha512';

    $options[ 'private_key_bits' ] = 1024;

    $options[ 'private_key_type' ] = OPENSSL_KEYTYPE_RSA;

    $openssl_resource = openssl_pkey_new( $options );
    if (!$openssl_resource) {
        while ($err = openssl_error_string()) var_dump($err);
        exit;
    }

    // openssl_pkey_export( $openssl_resource, $private_key, $passphrase = 'password' ); // Is $passphrase set only if encrypt_key is true?

    openssl_pkey_export( $openssl_resource, $private_key, null, $options );

    echo $private_key . PHP_EOL . PHP_EOL;

    $public_key = openssl_pkey_get_details( $openssl_resource );

    $public_key = $public_key[ 'key' ];

    echo $public_key . PHP_EOL . PHP_EOL;

    //-------------------------------------------------
    // PLAINTEXT
    //-------------------------------------------------

    // $plaintext = 'plaintext data goes here';

    // echo $plaintext . PHP_EOL . PHP_EOL;

    //-------------------------------------------------
    // OPENSSL PRIVATE ENCRYPT
    //-------------------------------------------------

    // Encrypt data with the private key.

    // openssl_private_encrypt( $plaintext, $private_encrypted, $private_key );

    // echo 'openssl_private_encrypt' . PHP_EOL . PHP_EOL . bin2hex( $private_encrypted ) . PHP_EOL . PHP_EOL;

    //-------------------------------------------------
    // OPENSSL PUBLIC DECRYPT
    //-------------------------------------------------

    // Data encrypted with the private key, now decrypted with the public key.

    // openssl_public_decrypt( $private_encrypted, $public_decrypted, $public_key );

    // echo 'openssl_public_decrypt' . PHP_EOL . PHP_EOL . $public_decrypted . PHP_EOL . PHP_EOL;

    //-------------------------------------------------
    // OPENSSL PUBLIC ENCRYPT
    //-------------------------------------------------

    // Encrypt data with the public key.

    // openssl_public_encrypt( $plaintext, $public_encrypted, $public_key );

    // echo 'openssl_public_encrypt' . PHP_EOL . PHP_EOL . bin2hex( $public_encrypted ) . PHP_EOL . PHP_EOL;

    //-------------------------------------------------
    // OPENSSL PRIVATE DECRYPT
    //-------------------------------------------------

    // Data encrypted with the public key, now decrypted with the private key.

    // openssl_private_decrypt( $public_encrypted, $private_decrypted, $private_key );

    // echo 'openssl_private_decrypt' . PHP_EOL . PHP_EOL . $private_decrypted . PHP_EOL . PHP_EOL;

    //-------------------------------------------------
    // ERROR HANDLING
    //-------------------------------------------------

    // echo openssl_error_string() . PHP_EOL . PHP_EOL;

?>
