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
if systemctl --version > /dev/null 2>&1 ; then
  # if systemd is used
  PHPU_HTTPD_RESTART="systemctl restart httpd.service"
else
  # otherwise we try OpenRC
  PHPU_HTTPD_RESTART="/etc/init.d/apache2 restart"
fi

PHPU_NUM_CORES=`cat /proc/cpuinfo | grep processor | wc -l`
PHPU_MAKE_J="make -j$PHPU_NUM_CORES"

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
PHPU_CONF_OPT_MASTER="$PHPU_CONF/options-master.conf"
PHPU_CONF_OPT_MASTER_SANITIZE="$PHPU_CONF/options-master-sanitize.conf"
PHPU_CONF_OPT_8="$PHPU_CONF/options-8.conf"
PHPU_CONF_OPT_74="$PHPU_CONF/options-74.conf"
PHPU_CONF_OPT_7="$PHPU_CONF/options-7.conf"
PHPU_CONF_OPT_5="$PHPU_CONF/options-5.conf"
PHPU_CONF_OPT_5_3="$PHPU_CONF/options-5-3.conf"
PHPU_CONF_OPT_5_2="$PHPU_CONF/options-5-2.conf"
PHPU_CONF_EXT="$PHPU_CONF/ext.conf"
PHPU_CONF_EXT_MASTER="$PHPU_CONF/ext-master.conf"
PHPU_CONF_EXT_5_3="$PHPU_CONF/ext-5-3.conf"
PHPU_CONF_EXT_5_2="$PHPU_CONF/ext-5-2.conf"
# master build branch location
PHPU_MASTER="$PHPU_ROOT/master"
PHPU_MASTER_EXT="$PHPU_MASTER/ext"
PHPU_MASTER_CLI="$PHPU_MASTER/sapi/cli/php"
# PHP 8.2 build branch location
PHPU_82="$PHPU_ROOT/82"
PHPU_82_EXT="$PHPU_82/ext"
PHPU_82_CLI="$PHPU_82/sapi/cli/php"
# PHP 8.1 build branch location
PHPU_81="$PHPU_ROOT/81"
PHPU_81_EXT="$PHPU_81/ext"
PHPU_81_CLI="$PHPU_81/sapi/cli/php"
# PHP 8.0 build branch location
PHPU_80="$PHPU_ROOT/80"
PHPU_80_EXT="$PHPU_80/ext"
PHPU_80_CLI="$PHPU_80/sapi/cli/php"
# PHP 7.4 build branch location
PHPU_74="$PHPU_ROOT/74"
PHPU_74_EXT="$PHPU_74/ext"
PHPU_74_CLI="$PHPU_74/sapi/cli/php"
# PHP 7.3 build branch location
PHPU_73="$PHPU_ROOT/73"
PHPU_73_EXT="$PHPU_73/ext"
PHPU_73_CLI="$PHPU_73/sapi/cli/php"
# PHP 7.2 build branch location
PHPU_72="$PHPU_ROOT/72"
PHPU_72_EXT="$PHPU_72/ext"
PHPU_72_CLI="$PHPU_72/sapi/cli/php"
# PHP 7.1 build branch location
PHPU_71="$PHPU_ROOT/71"
PHPU_71_EXT="$PHPU_71/ext"
PHPU_71_CLI="$PHPU_71/sapi/cli/php"
# PHP 7.0 build branch location
PHPU_7="$PHPU_ROOT/7"
PHPU_7_EXT="$PHPU_7/ext"
PHPU_7_CLI="$PHPU_7/sapi/cli/php"
# PHP 5.6 build branch location
PHPU_SRC="$PHPU_ROOT/src"
PHPU_SRC_EXT="$PHPU_SRC/ext"
PHPU_SRC_CLI="$PHPU_SRC/sapi/cli/php"
# PHP 5.5 build branch location
PHPU_STD="$PHPU_ROOT/std"
PHPU_STD_EXT="$PHPU_STD/ext"
PHPU_STD_CLI="$PHPU_STD/sapi/cli/php"
# PHP 5.4 build branch location
PHPU_SEC="$PHPU_ROOT/sec"
PHPU_SEC_EXT="$PHPU_SEC/ext"
PHPU_SEC_CLI="$PHPU_SEC/sapi/cli/php"
# extension dir
PHPU_EXT="$PHPU_ROOT/ext"
# directory for other builds
PHPU_BUILD="$PHPU_ROOT/build"
# documentation dir
PHPU_DOC="$PHPU_ROOT/doc"
PHPU_DOC_HTML="$PHPU_DOC/output/php-chunked-xhtml"
PHPU_DOC_RESULT="$PHPU_DOC/result"
PHPU_DOC_REFERENCE="$PHPU_DOC/en/reference"
# OpenSSL base dir
PHPU_OPENSSL_BASE_DIR="/usr/local/"
# The directory prefix for version 1.0.x is empty
PHPU_OPENSSL_VERSION_DIR="ssl"
# Dockerfiles
PHPU_DOCKER_DIR="$PHPU_ROOT/docker"


# show error
function error {
  echo "Error: $1" >&2
}
# show help
function phpu_help {
  echo "Usage: phpu <command> [<command_arguments>]"
  echo "Commands:"
  echo "  conf [<branch> [debug] [zts]] "
  echo "  exe [<phpcli_args>]"
  echo "  test [<path>]"
  echo "  testloc [<path>]"
  echo "  gentest [gentest-params]"
  echo "  new <branch> [debug] [zts]"
  echo "  use <branch> [debug] [zts]"
  echo "  sync [<branch> [debug] [zts]]"
  echo "  doc (move|rmts) <extension_name>"
  echo "  docker (build|run) <branch>"
}

# print and run the arguments
function phpu_print_and_run {
  echo $@
  $@
}

# execute script
function phpu_exe {
  $PHPU_SRC_CLI $@
}

# test custom build test(s)
function phpu_test_build {
  if [ -z "$1" ]; then
    error "Please specify build name as the first parameter"
    exit
  fi
  PHPU_BUILD_DIR="$PHPU_BUILD/$1"
  if [ ! -d "$PHPU_BUILD_DIR" ]; then
    error "No such build directory $PHPU_BUILD_DIR"
    exit
  fi
  PHPU_BUILD_CLI="$PHPU_BUILD_DIR/sapi/cli/php"
  shift
  export TEST_PHP_EXECUTABLE=$PHPU_BUILD_CLI
  $TEST_PHP_EXECUTABLE $PHPU_BUILD_DIR/run-tests.php $*
}


# run php 8.2 test(s)
function phpu_test_82 {
  export TEST_PHP_EXECUTABLE=$PHPU_82_CLI
  $TEST_PHP_EXECUTABLE $PHPU_82/run-tests.php $*
}

# run php 8.1 test(s)
function phpu_test_81 {
  export TEST_PHP_EXECUTABLE=$PHPU_81_CLI
  $TEST_PHP_EXECUTABLE $PHPU_81/run-tests.php $*
}

# run php 8.0 test(s)
function phpu_test_80 {
  export TEST_PHP_EXECUTABLE=$PHPU_80_CLI
  $TEST_PHP_EXECUTABLE $PHPU_80/run-tests.php $*
}

# run php 7.4 test(s)
function phpu_test_74 {
  export TEST_PHP_EXECUTABLE=$PHPU_74_CLI
  $TEST_PHP_EXECUTABLE $PHPU_74/run-tests.php $*
}

# run php 7.3 test(s)
function phpu_test_73 {
  export TEST_PHP_EXECUTABLE=$PHPU_73_CLI
  $TEST_PHP_EXECUTABLE $PHPU_73/run-tests.php $*
}

# run php 7.2 test(s)
function phpu_test_72 {
  export TEST_PHP_EXECUTABLE=$PHPU_72_CLI
  $TEST_PHP_EXECUTABLE $PHPU_72/run-tests.php $*
}

# run php 7.1 test(s)
function phpu_test_71 {
  export TEST_PHP_EXECUTABLE=$PHPU_71_CLI
  $TEST_PHP_EXECUTABLE $PHPU_71/run-tests.php $*
}

# run php 7 test(s)
function phpu_test_7 {
  export TEST_PHP_EXECUTABLE=$PHPU_7_CLI
  $TEST_PHP_EXECUTABLE $PHPU_7/run-tests.php $*
}

# run master test(s)
function phpu_test_master {
  export TEST_PHP_EXECUTABLE=$PHPU_MASTER_CLI
  $TEST_PHP_EXECUTABLE $PHPU_MASTER/run-tests.php $*
}

# run src test(s)
function phpu_test_src {
  export TEST_PHP_EXECUTABLE=$PHPU_SRC_CLI
  $TEST_PHP_EXECUTABLE $PHPU_SRC/run-tests.php $*
}

# run std test(s)
function phpu_test_std {
  export TEST_PHP_EXECUTABLE=$PHPU_STD_CLI
  $TEST_PHP_EXECUTABLE $PHPU_STD/run-tests.php $*
}

# run sec test(s)
function phpu_test_sec {
  export TEST_PHP_EXECUTABLE=$PHPU_SEC_CLI
  $TEST_PHP_EXECUTABLE $PHPU_SEC/run-tests.php $*
}

# run live test(s) - use installed php
function phpu_test_live {
  export TEST_PHP_EXECUTABLE=/usr/local/bin/php
  export FPM_RUN_RESOURCE_HEAVY_TESTS=1
  PHPU_GIT_TOP_LEVEL=`git rev-parse --show-toplevel`
  if [ -f "$PHPU_GIT_TOP_LEVEL/run-tests.php" ]; then
    PHPU_RUN_TEST_LIVE_PATH=$PHPU_GIT_TOP_LEVEL/run-tests.php
  else
    PHPU_RUN_TEST_LIVE_PATH=$PHPU_MASTER/run-tests.php
  fi
  $TEST_PHP_EXECUTABLE $PHPU_RUN_TEST_LIVE_PATH $*
}


# generate phpt file
function phpu_gentest {
  $PHPU_SRC_CLI $PHPU_SRC/scripts/dev/generate-phpt.phar $*
}

# check whether branch version is for PHP 5
function _phpu_branch_version_is_5 {
  PHPU_CURRENT_BRANCH_PREFIX=${PHPU_CURRENT_BRANCH:0:5}
  PHPU_CURRENT_BRANCH_PREFIX_UPPER=${PHPU_CURRENT_BRANCH_PREFIX^^}

  if [[ $PHPU_CURRENT_BRANCH_PREFIX_UPPER == "PHP-5" ]]; then
    return 0
  else
    return 1
  fi
}

# check whether version is equal to 5.3
function _phpu_branch_version_eq_5_3 {
  if _phpu_branch_version_is_5 && [[ ${PHPU_CURRENT_BRANCH:6:1} == 3 ]]; then
    return 0
  else
    return 1
  fi
}

# check whether version is equal or lower than 5.3
function _phpu_branch_version_le_5_3 {
  if _phpu_branch_version_is_5 && [[ ${PHPU_CURRENT_BRANCH:6:1} =~ (1|2|3) ]]; then
    return 0
  else
    return 1
  fi
}

# check whether version is equal or lower than 5.2
function _phpu_branch_version_le_5_2 {
  if _phpu_branch_version_is_5 && [[ ${PHPU_CURRENT_BRANCH:6:1} =~ (1|2) ]]; then
    return 0
  else
    return 1
  fi
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
      PHPU_HAS_ZTS=1
      PHPU_CONF_OPTS="$PHPU_CONF_OPTS --enable-maintainer-zts"
      PHPU_NAME=$PHPU_NAME"_zts"
    fi
  done
  PHPU_BUILD_NAME="$PHPU_BUILD/$PHPU_NAME"
}

# init installation variables
function _phpu_init_install_vars {
  PHPU_CURRENT_BRANCH=`git branch | sed -n 's/^\* //p'`
  if [ -n "$1" ] && [ -d "$PHPU_CONF/$1" ]; then
    PHPU_CONF_INI_DIR="$1"
  else
    PHPU_CONF_INI_DIR="$PHPU_CURRENT_BRANCH"
  fi
  PHPU_INI_DIR="$PHPU_CONF/$PHPU_CONF_INI_DIR"
  PHPU_INI_FILE="$PHPU_INI_DIR/php.ini"
  PHPU_INI_FILE_TMP="${PHPU_INI_FILE}.tmp"
}

# configure extension statically (not working)
function _phpu_ext_static_conf {
  cp -r "$PHPU_EXT_DIR" "$PHPU_SRC_EXT_DIR"
  PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS $PHPU_EXT_OPT1 $PHPU_EXT_OPT2 $PHPU_EXT_OPT3"
  _phpu_ext_dynamic_clean
}

# configure extension dynamically
function _phpu_ext_dynamic_conf {
  # add extension loading cmd to php.ini if it's not there
  if ! grep -q $PHPU_EXT_LIB "$PHPU_INI_FILE" ; then
    
    awk 'BEGIN { search = 1; show = 0 } {
if (search) {
if (show == 2) { search = 0; printf("extension='$PHPU_EXT_LIB'\n"); }
else if (show == 1) show++;
else if (index($0, "Extension") > 0) show = 1;
} print $0;
}' "$PHPU_INI_FILE" > "$PHPU_INI_FILE_TMP"
    mv "$PHPU_INI_FILE_TMP" "$PHPU_INI_FILE"
  fi
}

# configure extension dynamically
function _phpu_ext_dynamic_clean {
  # delete record in php.ini if exists
  if grep -q $PHPU_EXT_LIB "$PHPU_INI_FILE" ; then
    awk '{ if (index($0, "'$PHPU_EXT_LIB'") == 0) print $0 }' "$PHPU_INI_FILE" > "$PHPU_INI_FILE_TMP"
    mv "$PHPU_INI_FILE_TMP" "$PHPU_INI_FILE"
  fi
}

# run configure script
function _phpu_configure {
  echo "OPTIONS: $@"
  if [ -n "$PKG_CONFIG_PATH" ]; then
    ./configure -C $@
  else
    phpu_pkg_config ssl ./configure -C $@
  fi
}

# configure php
function phpu_conf {
  _phpu_init_install_vars
  # copy conf
  if [ ! -d "$PHPU_INI_DIR" ]; then
    mkdir -p "$PHPU_INI_DIR"
    if [ -f php.ini-development ]; then
      PHPU_INI_FILE_SRC=php.ini-development
    elif [ -f php.ini-recommended ]; then
      PHPU_INI_FILE_SRC=php.ini-recommended
    else
      rm -rf "$PHPU_INI_DIR"
      error "No source ini file found"
      exit
    fi
    cp "$PHPU_INI_FILE_SRC" "$PHPU_INI_FILE"
  fi
  # extra options for configure
  PHPU_EXTRA_OPTS="--with-config-file-path=$PHPU_ETC"
  PHPU_CURRENT_DIR=$( basename `pwd` )
  if [[ $PHPU_CURRENT_DIR =~ ^(src|std|sec|master|7|71|72|73|74|80|81|82)$ ]]; then
    if [[ ! "$*" =~ "no-debug" ]]; then
      PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS --enable-debug"
    fi
    if [[ "$*" =~ "sanitize" ]]; then
      PHPU_SANITIZE=1
      PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS --enable-memory-sanitizer"
      export CC=clang
      export CXX=clang++
      export CFLAGS="-DZEND_TRACK_ARENA_ALLOC"
    fi
    if [[ "$*" =~ "presanit" ]]; then
      PHPU_SANITIZE=1
    fi
    if [[ ! "$*" =~ "no-zts" ]]; then
      if [[ $PHPU_CURRENT_DIR =~ ^(src|std|sec|7|71|72|73|74)$ ]]; then
        PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS --enable-maintainer-zts"
      else
        PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS --enable-zts"
      fi
    fi
    if [[ $PHPU_CURRENT_DIR =~ ^(src|std|sec|7|71|72|73|74)$ ]]; then
      PHPU_EXT_LIB_EXTENSION=".so"
    fi
  elif [ -n "$PHPU_CONF_OPTS" ]; then
    PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS $PHPU_CONF_OPTS"
  fi
  # check if pkg config path for OpenSSL 1.1 should be used
  if [[ "$*" =~ "openssl101" ]]; then
     PHPU_OPENSSL_VERSION_DIR=ssl101
  elif [[ "$*" =~ "openssl102" ]]; then
    PHPU_OPENSSL_VERSION_DIR=ssl102
  elif [[ "$*" =~ "openssl110" ]]; then
    PHPU_OPENSSL_VERSION_DIR=ssl110
  elif [[ "$*" =~ "openssl111" ]]; then
    PHPU_OPENSSL_VERSION_DIR=ssl111
  elif [[ "$*" =~ "openssl30" ]]; then
    PHPU_OPENSSL_VERSION_DIR=ssl30
  elif [[ "$*" =~ "libressl25" ]]; then
    PHPU_OPENSSL_VERSION_DIR=libressl25
  elif [[ "$*" =~ "libressl26" ]]; then
    PHPU_OPENSSL_VERSION_DIR=libressl26
  elif [[ "$*" =~ "libressl27" ]]; then
    PHPU_OPENSSL_VERSION_DIR=libressl27
  else
    if [[ $PHPU_CURRENT_DIR =~ ^(src|std|sec)$ ]]; then
      PHPU_OPENSSL_VERSION_DIR=ssl102
    else
      PHPU_OPENSSL_VERSION_DIR=ssl111
    fi
  fi
  # set conf active ext and options path
  if [[ $PHPU_CURRENT_DIR =~ ^(master|81|82)$ ]]; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_MASTER"
    if [ "$PHPU_SANITIZE" == "1" ]; then
      PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_MASTER_SANITIZE"
    else
      PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_MASTER"
    fi
  elif [[ $PHPU_CURRENT_DIR == 80 ]]; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_MASTER"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_8"
  elif [[ $PHPU_CURRENT_DIR == 74 ]]; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_74"
  elif [[ $PHPU_CURRENT_DIR =~ ^(7|71|72|73)$ ]]; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_7"
  elif _phpu_branch_version_eq_5_3; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_5_3"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_5_3"
  elif _phpu_branch_version_le_5_2; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_5_2"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_5_2"
  else
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_5"
  fi
  # modify ld path
  phpu_ld_path
  # set extensions
  while read PHPU_EXT_NAME PHPU_EXT_TYPE PHPU_EXT_OPT1 PHPU_EXT_OPT2 PHPU_EXT_OPT3; do
    PHPU_EXT_DIR="$PHPU_EXT/$PHPU_EXT_NAME"
    if [ -d "$PHPU_EXT_DIR" ]; then
      PHPU_EXT_LIB="$PHPU_EXT_NAME$PHPU_EXT_LIB_EXTENSION"
      PHPU_SRC_EXT_DIR="$PHPU_SRC_EXT/$PHPU_EXT_NAME"
      # delete source ext dir
      if [ -d "$PHPU_SRC_EXT_DIR" ]; then
        rm -rf "$PHPU_SRC_EXT_DIR"
      fi
      # configure extension
      if [[ $PHPU_EXT_TYPE == 'static' ]]; then
        _phpu_ext_static_conf
      elif [[ $PHPU_EXT_TYPE == 'dynamic' ]]; then
        _phpu_ext_dynamic_conf
      else
        _phpu_ext_dynamic_clean
      fi
    fi
  done < "$PHPU_CONF_ACTIVE_EXT"
  # use old autoconf for PHP-5.3 and lower
  if _phpu_branch_version_le_5_3; then
    export PHP_AUTOCONF=$PHPU_AUTOCONF_213
  fi
  if [ -f Makefile ]; then
    make clean
    make distclean
  fi
  if [ -f ./configure ]; then
    rm configure
  fi
  if [ -f ./config.cache ]; then
    rm config.cache
  fi
  ./buildconf --force
 _phpu_configure $PHPU_EXTRA_OPTS `cat "$PHPU_CONF_ACTIVE_OPT"`
}

# run make
function phpu_make {
  if [ "$1" == "sanitize" ]; then
    shift
    export CC=clang
    export CXX=clang++
    export CFLAGS="-DZEND_TRACK_ARENA_ALLOC"
  fi
  make $@
}


# create new build
function phpu_new {
  if [ -n "$1" ]; then
    _phpu_process_params $@
    cd "$PHPU_SRC"
    # creat build dir if not exists
    if [ ! -d "$PHPU_BUILD" ]; then
      mkdir -p "$PHPU_BUILD"
    fi
    # check if build dir alreay exists
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
    # remove branch if exists (easy way how to get up to date code)
    if git branch --list | grep -q $PHPU_BRANCH; then
      git branch -D $PHPU_BRANCH
    fi

    # check if the branch is branch or just a tag
    if git branch --list --all | grep -q upstream/$PHPU_BRANCH; then
      PHPU_NEW_BRANCH_FLAGS="--track"
      PHPU_NEW_BRANCH_COMMIT="upstream/$PHPU_BRANCH"
      PHPU_NEW_CHECKOUT_FLAGS=""
      PHPU_NEW_CHECKOUT_COMMIT=""
    elif git tag --list | grep -q $PHPU_BRANCH; then
      PHPU_NEW_BRANCH_FLAGS=""
      PHPU_NEW_BRANCH_COMMIT="$PHPU_BRANCH"
      PHPU_NEW_CHECKOUT_FLAGS="-b"
      PHPU_NEW_CHECKOUT_COMMIT="origin/$PHPU_BRANCH"
    else
      error "No such branch or tag called $PHPU_BRANCH"
      exit
    fi

    # create branch that either tracks upstream branch or is from tag
    if git branch $PHPU_NEW_BRANCH_FLAGS $PHPU_BRANCH $PHPU_NEW_BRANCH_COMMIT; then
      cd "$PHPU_BUILD"
      # copy
      git clone ../src $PHPU_NAME
      cd $PHPU_NAME
      # set the branch
      git checkout $PHPU_NEW_CHECKOUT_FLAGS $PHPU_BRANCH $PHPU_NEW_CHECKOUT_COMMIT
      # run configuration
      phpu_conf
    fi
  fi
}

function phpu_use {
  # branch parameter has to be supplied
  if [ -n "$1" ]; then
    sudo -l > /dev/null
    # check if it's master
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT"
    if [[ "$1" == "src" ]]; then
      cd "$PHPU_SRC"
      _phpu_init_install_vars src
    elif [[ "$1" == "std" ]]; then
      cd "$PHPU_STD"
      _phpu_init_install_vars std
    elif [[ "$1" == "sec" ]]; then
       cd "$PHPU_SEC"
      _phpu_init_install_vars sec
    elif [[ "$1" =~ ^(master|7|71|72|73|74|80|81|82)$ ]]; then
      if [[ "$1" == "7" ]]; then
        cd "$PHPU_7"
      elif [[ "$1" == "71" ]]; then
        cd "$PHPU_71"
      elif [[ "$1" == "72" ]]; then
        cd "$PHPU_72"
      elif [[ "$1" == "73" ]]; then
        cd "$PHPU_73"
      elif [[ "$1" == "74" ]]; then
        cd "$PHPU_74"
      elif [[ "$1" == "80" ]]; then
        cd "$PHPU_80"
        PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_MASTER"
      elif [[ "$1" == "82" ]]; then
        cd "$PHPU_82"
        PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_MASTER"
      elif [[ "$1" == "81" ]]; then
        cd "$PHPU_81"
        PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_MASTER"
      else
        cd "$PHPU_MASTER"
        PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_MASTER"
      fi
      _phpu_init_install_vars
    else
      # otherwis check if the build exists
      _phpu_process_params $@
      if [ -d "$PHPU_BUILD_NAME" ]; then
        cd "$PHPU_BUILD_NAME"
      else
        # if not print error
        echo "The $PHPU_NAME has not been created yet"
        exit
      fi
      # check if active ext for 5.2 or 5.3 should be used
      if [[ "${PHPU_BRANCH:6:1}" == "3" ]]; then
        PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_5_3"
      elif [[ "${PHPU_BRANCH:6:1}" =~ (2|1|0) ]]; then
        PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_5_2"
      fi
      _phpu_init_install_vars
    fi
    # create live config dir if if it does not exist
    if [ ! -d "$PHPU_ETC" ]; then
      sudo mkdir -p "$PHPU_ETC"
    fi
    # modify ld path
    phpu_ld_path
    # copy ini from conf/ to the live config dir
    sudo cp $PHPU_INI_FILE "$PHPU_ETC"
    # compile and install php-src
    if $PHPU_MAKE_J && sudo make install ; then
      # check if OpenSSL 1.1 is used and if so set version variable
      if php -i | awk '{ if (found) print $0; else if ($0 == "openssl") found = 1; }' | grep -q 'OpenSSL 1.1.0'; then
        PHPU_OPENSSL_VERSION_DIR=ssl110
      elif php -i | awk '{ if (found) print $0; else if ($0 == "openssl") found = 1; }' | grep -q 'OpenSSL 1.1.1'; then
        PHPU_OPENSSL_VERSION_DIR=ssl111
      fi
      # compile dynamic extension
      while read PHPU_EXT_NAME PHPU_EXT_TYPE PHPU_EXT_OPT1 PHPU_EXT_OPT2 PHPU_EXT_OPT3; do
        if [[ $PHPU_EXT_TYPE == 'dynamic' ]]; then
          PHPU_EXT_DIR="$PHPU_EXT/$PHPU_EXT_NAME"
          if [ -d "$PHPU_EXT_DIR" ]; then
            cd "$PHPU_EXT_DIR"
            if [ -f Makefile ]; then
              make clean
              make distclean
            fi
            rm -f configure.ac
            rm -f configure.in
            rm -f aclocal.m4
            phpize
            _phpu_configure $PHPU_EXT_OPT1 $PHPU_EXT_OPT2 $PHPU_EXT_OPT3
            $PHPU_MAKE_J && sudo make install
          else
            echo "No directory $PHPU_EXT_DIR"
          fi
        fi
      done < "$PHPU_CONF_ACTIVE_EXT"
      # restart httpd server
      if ! [[ "$1" =~ ^(master|7|71|72|73|74|80|81|82)$ ]]; then
        sudo $PHPU_HTTPD_RESTART
      fi
    fi
  fi
}

function phpu_update {
  if [ -z "$1" ]; then
    PHPU_UPDATE_TYPE=src
    PHPU_UPDATE_BRANCH=PHP-5.6
  else
    PHPU_UPDATE_TYPE="$1"
    PHPU_UPDATE_BRANCH=master
  fi
  case $PHPU_UPDATE_TYPE in
    src)
      cd "$PHPU_SRC"
      ;;
    master)
      cd "$PHPU_MASTER"
      ;;
    "7")
      cd "$PHPU_7"
      ;;
    "71")
      cd "$PHPU_71"
      ;;
    "72")
      cd "$PHPU_72"
      ;;
    "73")
      cd "$PHPU_73"
      ;;
    "74")
      cd "$PHPU_74"
      ;;
    "80")
      cd "$PHPU_80"
      ;;
    "81")
      cd "$PHPU_81"
      ;;
    "82")
      cd "$PHPU_82"
      ;;
    *)
      echo "Unknown branch to update"
      exit
      ;;
  esac
  
  git fetch upstream
  git merge upstream/$PHPU_UPDATE_BRANCH
}

function phpu_doc {
  if [ -n "$1" ] && [ -n "$2" ]; then
    if [[ "$1" == "move" ]]; then
      # move documentation generated files to the standalone directory
      PHPU_DOC_RESULT_EXT="$PHPU_DOC_RESULT/$2"
      if [ -d "$PHPU_DOC_RESULT_EXT" ]; then
        rm -rf "$PHPU_DOC_RESULT_EXT"
      fi
      mkdir -p "$PHPU_DOC_RESULT_EXT"
      for PHPU_DOC_FILE in `find $PHPU_DOC_HTML -name "*$2*"`; do
        cp "$PHPU_DOC_FILE" "$PHPU_DOC_RESULT_EXT/"`basename $PHPU_DOC_FILE`
      done
    elif [[ "$1" == "rmts" ]]; then
      # remove trailing space in all source files
      PHPU_DOC_REFERENCE_EXT="$PHPU_DOC_REFERENCE/$2"
      for PHPU_DOC_FILE in `find "$PHPU_DOC_REFERENCE_EXT" -name '*.xml'`; do
        sed -i 's/[ \t]*$//' $PHPU_DOC_FILE
      done
    fi
  else
    echo "Extension name missing"
  fi
}

# setting of pkg config directory
function phpu_pkg_config {
  if [ -n "$1" ]; then
    PHPU_PKG="$1"
    shift
    case $PHPU_PKG in
      ssl)
        if [ "$PHPU_OPENSSL_VERSION_DIR" == "ssl30" ]; then
          PKG_CONFIG_LIB_DIR=lib64
        else
          PKG_CONFIG_LIB_DIR=lib
        fi
        PKG_CONFIG_PATH="$PHPU_OPENSSL_BASE_DIR$PHPU_OPENSSL_VERSION_DIR/$PKG_CONFIG_LIB_DIR/pkgconfig" $@
        ;;
      *)
        echo "Unknown PKG_CONFIG_PATH for $PHPU_PKG"
        ;;
    esac
  fi
}

# modify LD_LIBRARY_PATH to prefer /usr/local/lib
function phpu_ld_path {
  phpu_print_and_run export LD_LIBRARY_PATH=/usr/local/lib:/lib64:/lib
}

function phpu_docker {
  if [ -z "$1" ]; then
    error "Docker action not set"
    phpu_help
    exit
  elif [ -z "$2" ]; then
    error "Docker PHP branch not set"
    phpu_help
    exit
  fi
  PHPU_DOCKER_ACTION=$1
  shift
  PHPU_DOCKER_BRANCH=$1
  shift
  
  PHPU_DOCKER_WORKDIR=$PHPU_ROOT/$PHPU_DOCKER_BRANCH
  if [ ! -d "$PHPU_DOCKER_WORKDIR" ]; then
    error "Docker workdir $PHPU_DOCKER_WORKDIR is not a directory"
    exit
  fi
  
  # set type of Dockerfile
  if [ -n "$1" ]; then
    PHPU_DOCKER_TYPE=$1
    shift
  else
    PHPU_DOCKER_TYPE=standard-ubuntu-22-04
  fi
  # set Dockerfile path
  PHPU_DOCKERFILE="$PHPU_DOCKER_DIR/$PHPU_DOCKER_TYPE.dockerfile"
  if [ ! -f $PHPU_DOCKERFILE ]; then
    error "Dockerfile $PHPU_DOCKERFILE does not exist"
    exit
  fi
  # set image
  PHPU_DOCKER_IMAGE=php_local_${PHPU_DOCKER_TYPE}_$PHPU_DOCKER_BRANCH
  # execute action
  case $PHPU_DOCKER_ACTION in
    build)
      cp $PHPU_DOCKERFILE $PHPU_DOCKER_WORKDIR/Dockerfile
      cd $PHPU_DOCKER_WORKDIR
      make clean
      docker build -t $PHPU_DOCKER_IMAGE .
      rm $PHPU_DOCKER_WORKDIR/Dockerfile
      echo "build done"
      ;;
    run)
      docker run $@ -ti $PHPU_DOCKER_IMAGE
      ;;
    *)
      error "Invalid docker action $PHPU_DOCKER_ACTION"
      phpu_help
      ;;
  esac
}

# se action
if [ -n "$1" ]; then
  PHPU_ACTION=$1
  shift
else
  PHPU_ACTION=help
fi  
  
case $PHPU_ACTION in
  help)
    phpu_help $@
    ;;
  exe)
    phpu_exe $@
    ;;
  test)
    phpu_test_live $@
    ;;
  test_src)
    phpu_test_src $@
    ;;
  test_std)
    phpu_test_std $@
    ;;
  test_sec)
    phpu_test_sec $@
    ;;
  test_7)
    phpu_test_7 $@
    ;;
  test_71)
    phpu_test_71 $@
    ;;
  test_72)
    phpu_test_72 $@
    ;;
  test_73)
    phpu_test_73 $@
    ;;
  test_74)
    phpu_test_74 $@
    ;;
  test_80)
    phpu_test_80 $@
    ;;
  test_81)
    phpu_test_81 $@
    ;;
  test_82)
    phpu_test_82 $@
    ;;
  test_master)
    phpu_test_master $@
    ;;
  test_build)
    phpu_test_build $@
    ;;
  docker)
    phpu_docker $@
    ;;
  gentest)
    phpu_gentest $@
    ;;
  conf)
    phpu_conf $@
    ;;
  make)
    phpu_make $@
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
  doc)
    phpu_doc $@
    ;;
  pkg)
    phpu_pkg_config $@
    ;;
  ldp)
    phpu_ld_path $@
    ;;
  *)
    error "Unknown action $PHPU_ACTION"
    phpu_help
esac
