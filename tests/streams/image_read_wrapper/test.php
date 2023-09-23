<?php

class FSStreamWrapper {
	public $context;

	public $handle;

	function stream_open( $file, $mode ) {
		$this->handle = fopen( str_replace( 'fs://', '', $file ), $mode );
		return true;
	}
	function stream_read( $count ) {
		return fread( $this->handle, $count );
	}
	function stream_eof() {
		return feof( $this->handle );
	}
	function stream_seek( $offset, $whence ) {
		return fseek( $this->handle, $offset, $whence ) === 0;
	}
	function stream_stat() {
		return fstat( $this->handle );
	}
	function url_stat( $file ) {
		return stat( str_replace( 'fs://', '', $file ) );
	}
	function stream_tell() {
		return ftell( $this->handle );
	}
	function stream_close() {
		fclose( $this->handle );
	}
	function stream_set_option( $options ) {
		var_dump( __FUNCTION__ );
		exit; // this is never called
	}
	function stream_metadata() {
		var_dump( __FUNCTION__ );
		exit; // this is never called
	}
	function stream_truncate() {
		var_dump( __FUNCTION__ );
		exit; // this is never called
	}
	function stream_cast() {
		var_dump( __FUNCTION__ );
		exit; // this is never called
	}
	function stream_flush() {
		var_dump( __FUNCTION__ );
		exit; // this is never called
	}
}

stream_register_wrapper( 'fs', 'FSStreamWrapper' );

$stream_wrapper_file = file_get_contents( 'fs://test.jpg' );
$fs_file = file_get_contents( 'test.jpg' );

var_dump( $stream_wrapper_file === $fs_file ); // true.
var_dump( filesize( 'fs://test.jpg' ) === filesize( 'test.jpg' ) ); // true.

var_dump(getimagesize( 'test.jpg', $info ));
var_dump(getimagesize( 'fs://test.jpg', $info ));
//var_dump(getimagesize( 'fs://test.jpg' ));

echo "done\n";
