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

# set base directory
if readlink ${BASH_SOURCE[0]} > /dev/null; then
  PHPU_ROOT="$( dirname "$( dirname "$( readlink ${BASH_SOURCE[0]} )" )" )"
else  
  PHPU_ROOT="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
fi

PHPU_CONF=$PHPU_ROOT/conf
PHPU_CONF_FILE=$PHPU_CONF/options.conf
PHPU_SRC=$PHPU_ROOT/src
PHPU_CLI=$PHPU_SRC/sapi/cli/php
PHPU_BUILD=$PHPU_ROOT/build

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

# configure php
function phpu_conf {
  EXTRA_OPTS="--with-config-file-path=/etc"
  if [ $# -gt 0 ]; then
	EXTRA_OPTS="$EXTRA_OPTS $*"
  else
	EXTRA_OPTS="$EXTRA_OPTS --enable-debug --enable-maintainer-zts"
  fi
  ./buildconf --force
  ./configure $EXTRA_OPTS `cat $PHPU_CONF_FILE`
}

# create new build
function phpu_new {
  if [ -n "$1" ]; then
	BRANCH=$1
	NAME=$BRANCH
	CONF_OPTS=""
	shift
	for PARAM in $@; do
	  if [[ "$PARAM" == "debug" ]] && [ -z "$HAS_DEBUG" ]; then
		HAS_DEBUG=1
		CONF_OPTS=$CONF_OPTS" --enable-debug"
		NAME=$NAME"_debug"
	  fi
	  if [[ "$PARAM" == "zts" ]] && [ -z "$HAS_ZTS" ]; then
		HAS_DEBUG=1
		CONF_OPTS=$CONF_OPTS" --enable-maintainer-zts"
		NAME=$NAME"_zts"
	  fi
	done
	cd $PHPU_SRC
	if git branch --track $BRANCH upstream/$BRANCH; then
	  cd $PHPU_BUILD
	  git clone ../src $NAME
	  cd $NAME
	  git checkout $BRANCH
	  phpu_conf $CONF_OPTS
	fi
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
  sync)
    phpu_sync $@
    ;;
  *)
    error "Unknown action $ACTION"
    phpu_help
esac
