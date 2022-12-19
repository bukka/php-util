<?php

$connection = ldap_connect("ldaps://ldap.google.com");

$bind_results = ldap_bind($connection, 'AnyUsername','AnyPassword');
