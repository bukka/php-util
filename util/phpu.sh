#!/bin/bash
#  +----------------------------------------------------------------------+
#  | PHP Version 5                                                        |
#  +----------------------------------------------------------------------+
#  | Copyright (c) 1997-2007 The PHP Group                                |
#  +----------------------------------------------------------------------+
#  | This source file is subject to version 3.01 of the PHP license,      |
#  | that is bundled with this package in the file LICENSE, and is        |
#  | available through the world-wide-web at the following url:           |
#  | http://www.php.net/license/3_01.txt                                  |
#  | If you did not receive a copy of the PHP license and are unable to   |
#  | obtain it through the world-wide-web, please send a note to          |
#  | license@php.net so we can mail you a copy immediately.               |
#  +----------------------------------------------------------------------+
#  | Author: Jakub Zelenka <jakub.php@gmail.com>                          |
#  +----------------------------------------------------------------------+
#
#  PHP utility script

# autoconf file for PHP 5.3-
PHPU_AUTOCONF_213=autoconf-2.13

# apache httpd restart command
PHPU_HTTPD_RESTART="systemctl restart httpd.service"

# set base directory
if readlink ${BASH_SOURCE[0]} > /dev/null; then
  PHPU_ROOT="$( dirname "$( dirname "$( readlink ${BASH_SOURCE[0]} )" )" )"
else  
  PHPU_ROOT="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
fi

# php.ini final location
PHPU_ETC=/usr/local/etc
# configuration files
PHPU_CONF="$PHPU_ROOT/conf"
PHPU_CONF_OPT="$PHPU_CONF/options.conf"
PHPU_CONF_EXT="$PHPU_CONF/ext.conf"
# master build branch location
PHPU_SRC="$PHPU_ROOT/src"
PHPU_SRC_EXT="$PHPU_SRC/ext"
# extension dir
PHPU_EXT="$PHPU_ROOT/ext"
# directory for other builds
PHPU_BUILD="$PHPU_ROOT/build"
# cli file source
PHPU_CLI="$PHPU_SRC/sapi/cli/php"


# show error
function error {
  echo "Error: $1" >&2
}

# show help
function phpu_help {
  echo "Usage: phpu <command> [<command_arguments>]"
  echo "Commands:"
  echo "  conf [<branch> [debug] [zts]] "
  echo "  test [<path>]"
  echo "  gentest [gentest-params]"
  echo "  new <branch> [debug] [zts]"
  echo "  use <branch> [debug] [zts]"
  echo "  sync [<branch> [debug] [zts]]"
}

# execute script
function phpu_exe {
  $PHPU_CLI $@
}

# run test(s)
function phpu_test {
  export TEST_PHP_EXECUTABLE=$PHPU_CLI
  $TEST_PHP_EXECUTABLE $PHPU_SRC/run-tests.php $*
}

# generate phpt file
function phpu_gentest {
  $PHPU_CLI $PHPU_SRC/scripts/dev/generate-phpt.phar $*
}

# process params for phpu_new
function _phpu_process_params {
  PHPU_BRANCH=$1
  PHPU_NAME=$PHPU_BRANCH
  PHPU_CONF_OPTS=""
  shift
  for PARAM in $@; do
	if [[ "$PARAM" == "debug" ]] && [ -z "$PHPU_HAS_DEBUG" ]; then
	  PHPU_HAS_DEBUG=1
	  PHPU_CONF_OPTS="$PHPU_CONF_OPTS --enable-debug"
	  PHPU_NAME=$PHPU_NAME"_debug"
	fi
	if [[ "$PARAM" == "zts" ]] && [ -z "$PHPU_HAS_ZTS" ]; then
	  PHPU_HAS_DEBUG=1
	  PHPU_CONF_OPTS="$PHPU_CONF_OPTS --enable-maintainer-zts"
	  PHPU_NAME=$PHPU_NAME"_zts"
	fi
  done
  PHPU_BUILD_NAME="$PHPU_BUILD/$PHPU_NAME"
}

function _phpu_init_install_vars {
  PHPU_CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
  PHPU_INI_DIR="$PHPU_CONF/$PHPU_CURRENT_BRANCH"
  PHPU_INI_FILE="$PHPU_INI_DIR/php.ini"
}

# configure extension statically
function _phpu_ext_static {
  echo "STATIC: $PHPU_EXT_NAME $PHPU_EXT_OPT"
}

# configure extension dynamically
function _phpu_ext_dynamic {
  if ! grep -q $PHPU_EXT_LIB "$PHPU_INI_FILE" ; then
	PHPU_INI_FILE_TMP="${PHPU_INI_FILE}.tmp"
	awk 'BEGIN { search = 1; show = 0 } {
if (search) {
if (show == 2) { search = 0; printf("extension='$PHPU_EXT_LIB'\n"); }
else if (show == 1) show++;
else if (index($0, "Extension") > 0) show = 1;
} print $0;
}' "$PHPU_INI_FILE" > "$PHPU_INI_FILE_TMP"
	mv "$PHPU_INI_FILE_TMP" "$PHPU_INI_FILE"
  fi
  echo "DYNAMIC: $PHPU_EXT_NAME $PHPU_EXT_OPT"
}

# configure php
function phpu_conf {
  _phpu_init_install_vars
  # copy conf
  if [ ! -d "$PHPU_INI_DIR" ]; then
	mkdir -p "$PHPU_INI_DIR"
	cp php.ini-development "$PHPU_INI_FILE"
  fi
  # extra options for configure
  PHPU_EXTRA_OPTS="--with-config-file-path=$PHPU_ETC $*"
  PHPU_CURRENT_DIR=$( basename `pwd` )
  if [[ $PHPU_CURRENT_DIR == "src" ]]; then
	PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS --enable-debug --enable-maintainer-zts"
  fi
  # set extensions
  while read PHPU_EXT_NAME PHPU_EXT_TYPE PHPU_EXT_OPT ; do
	PHPU_EXT_DIR="$PHPU_EXT/$PHPU_EXT_NAME"
	if [ -d "$PHPU_EXT_DIR" ]; then
	  PHPU_EXT_LIB="$PHPU_EXT_NAME.so"
	  PHPU_SRC_EXT_DIR="$PHPU_SRC_EXT/$PHPU_EXT_NAME"
	  if [[ $PHPU_EXT_TYPE == 'static' ]]; then
		_phpu_ext_static
	  else
		_phpu_ext_dynamic
	  fi
	fi
  done < "$PHPU_CONF_EXT"
  exit
   # use old autoconf for PHP-5.3 and lower
  if [[ "${PHPU_CURRENT_BRANCH:4:1}" == "4" ]] || [[ "${PHPU_CURRENT_BRANCH:6:1}" =~ (3|2|1|0) ]]; then
	export PHP_AUTOCONF=$PHPU_AUTOCONF_213
  fi
  ./buildconf --force
  ./configure $PHPU_EXTRA_OPTS `cat "$PHPU_CONF_OPT"`
}


# create new build
function phpu_new {
  if [ -n "$1" ]; then
	_phpu_process_params $@
	cd "$PHPU_SRC"
	if [ -d "$PHPU_BUILD/$PHPU_NAME" ]; then
	  echo "Build $PHPU_NAME already exists"
	  while true; do
		echo -n "Do you want to replace it [y/N]: "
		read CONFIRM
		case $CONFIRM in
		  y|Y|YES|yes|Yes)
			rm -rf "$PHPU_BUILD_NAME"
			break
			;;
		  n|N|no|NO|No|"")
			exit
		esac
	  done
	fi
	if git branch --list | grep -q $PHPU_BRANCH; then
	  git branch -d $PHPU_BRANCH
	fi
	if git branch --track $PHPU_BRANCH upstream/$PHPU_BRANCH; then
	  cd "$PHPU_BUILD"
	  git clone ../src $PHPU_NAME
	  cd $PHPU_NAME
	  git checkout $PHPU_BRANCH
	  phpu_conf $PHPU_CONF_OPTS
	fi
  fi
}

function phpu_use {
  if [ -n "$1" ]; then
	sudo -l > /dev/null
	if [[ "$1" == "master" ]]; then
	  cd "$PHPU_SRC"
	  _phpu_init_install_vars
	else
	  _phpu_process_params $@
	  if [ -d "$PHPU_BUILD_NAME" ]; then
		cd "$PHPU_BUILD_NAME"
		_phpu_init_install_vars
		if [ ! -d "$PHPU_ETC" ]; then
		  sudo mkdir -p "$PHPU_ETC"
		fi

	  else
		echo "The $PHPU_NAME has not been created yet"
		exit
	  fi
	fi
	sudo cp "$PHPU_INI_FILE" "$PHPU_ETC"
	make && sudo make install && sudo $PHPU_HTTPD_RESTART
  fi
}

function phpu_update {
  if [ -z "$1" ] || [[ "$1" == "master" ]]; then
	cd $PHPU_SRC
	git fetch upstream
	git merge upstream/master
  fi
}

# se action
if [ -n "$1" ]; then
  ACTION=$1
  shift
else
  ACTION=help
fi  
  
case $ACTION in
  help)
    phpu_help $@
    ;;
  exe)
	phpu_exe $@
	;;
  test)
    phpu_test $@
    ;;
  gentest)
	phpu_gentest $@
	;;
  conf)
    phpu_conf $@
    ;;
  new)
    phpu_new $@
    ;;
  use)
    phpu_use $@
    ;;
  update)
	phpu_update $@
	;;
  install)
	sudo -l > /dev/null
	phpu_new $@
	phpu_use $@
	;;
  sync)
    phpu_sync $@
    ;;
  *)
    error "Unknown action $ACTION"
    phpu_help
esac
