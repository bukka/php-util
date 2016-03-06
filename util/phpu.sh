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
PHPU_CONF_OPT_MASTER="$PHPU_CONF/options-master.conf"
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
# PHP 7 build branch location
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
  $TEST_PHP_EXECUTABLE $PHPU_SRC/run-tests.php $*
}


# generate phpt file
function phpu_gentest {
  $PHPU_SRC_CLI $PHPU_SRC/scripts/dev/generate-phpt.phar $*
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
  PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS $PHPU_EXT_OPT"
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
  if [ -n "$PKG_CONFIG_PATH" ]; then
    ./configure $@
  else
    phpu_pkg_config ssl ./configure $@
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
  if [[ $PHPU_CURRENT_DIR == "src" ]] || [[ $PHPU_CURRENT_DIR == "std" ]] || [[ $PHPU_CURRENT_DIR == "sec" ]] || [[ $PHPU_CURRENT_DIR == "master" ]] || [[ $PHPU_CURRENT_DIR == "7" ]]; then
    if [[ ! "$*" =~ "no-debug" ]]; then
      PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS --enable-debug"
    fi
    if [[ ! "$*" =~ "no-zts" ]]; then
      PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS --enable-maintainer-zts"
    fi
    if [[ $PHPU_CURRENT_DIR == "master" ]] || [[ $PHPU_CURRENT_DIR == "7" ]]; then
      PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS --without-pear"
    fi
  elif [ -n "$PHPU_CONF_OPTS" ]; then
    PHPU_EXTRA_OPTS="$PHPU_EXTRA_OPTS $PHPU_CONF_OPTS"
  fi
  # set conf active ext and options path
  if [[ $PHPU_CURRENT_DIR == "master" ]] || [[ $PHPU_CURRENT_DIR == "7" ]]; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_MASTER"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_MASTER"
  elif [[ "${PHPU_CURRENT_BRANCH:6:1}" == "3" ]]; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_5_3"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_5_3"
  elif [[ "${PHPU_CURRENT_BRANCH:6:1}" =~ (2|1|0) ]]; then
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_5_2"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT_5_2"
  else
    PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT"
    PHPU_CONF_ACTIVE_OPT="$PHPU_CONF_OPT"
  fi
  # set extensions
  while read PHPU_EXT_NAME PHPU_EXT_TYPE PHPU_EXT_OPT ; do
    PHPU_EXT_DIR="$PHPU_EXT/$PHPU_EXT_NAME"
    if [ -d "$PHPU_EXT_DIR" ]; then
      PHPU_EXT_LIB="$PHPU_EXT_NAME.so"
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
  if [[ "${PHPU_CURRENT_BRANCH:4:1}" == "4" ]] || [[ "${PHPU_CURRENT_BRANCH:6:1}" =~ (3|2) ]]; then
    export PHP_AUTOCONF=$PHPU_AUTOCONF_213
  fi
  if [ -f Makefile ]; then
    make distclean
  fi
  if [ -f ./configure ]; then
    rm configure
  fi
  if [ -f ./config.cache ]; then
    rm config.cache
  fi
  ./buildconf --force
  echo "OPTIONS: " $PHPU_EXTRA_OPTS `cat "$PHPU_CONF_ACTIVE_OPT"`
  _phpu_configure $PHPU_EXTRA_OPTS `cat "$PHPU_CONF_ACTIVE_OPT"`
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
    elif [[ "$1" == "master" ]] || [[ "$1" == "7" ]]; then
      if [[ "$1" == "7" ]]; then
        cd "$PHPU_7"
      else
        cd "$PHPU_MASTER"
      fi
      PHPU_CONF_ACTIVE_EXT="$PHPU_CONF_EXT_MASTER"
      _phpu_init_install_vars master
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
    # copy ini from conf/ to the live config dir
    sudo cp $PHPU_INI_FILE "$PHPU_ETC"
    if make -j4 && sudo make install ; then
      # compile dynamic extension
      while read PHPU_EXT_NAME PHPU_EXT_TYPE PHPU_EXT_OPT ; do
        if [[ $PHPU_EXT_TYPE == 'dynamic' ]]; then
          PHPU_EXT_DIR="$PHPU_EXT/$PHPU_EXT_NAME"
          if [ -d "$PHPU_EXT_DIR" ]; then
            cd "$PHPU_EXT_DIR"
            if [ -f Makefile ]; then
              make distclean
            fi
            phpize
            _phpu_configure $PHPU_EXT_OPT
            make && sudo make install
          fi
        fi
      done < "$PHPU_CONF_ACTIVE_EXT"
      # restart httpd server
      if [[ "$1" != "master" ]] && [[ "$1" != "7" ]]; then
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
        PKG_CONFIG_PATH="/usr/local/ssl/lib/pkgconfig/" $@
        ;;
      *)
        echo "Unknown PKG_CONFIG_PATH for $PHPU_PKG"
        ;;
    esac
  fi
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
  test_master)
    phpu_test_master $@
    ;;
  test_build)
    phpu_test_build $@
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
  doc)
    phpu_doc $@
    ;;
  pkg)
    phpu_pkg_config $@
    ;;
  *)
    error "Unknown action $PHPU_ACTION"
    phpu_help
esac
