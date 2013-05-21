#!/bin/bash
if readlink ${BASH_SOURCE[0]} > /dev/null; then
  ROOT="$( dirname "$( dirname "$( readlink ${BASH_SOURCE[0]} )" )" )"
else  
  ROOT="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
fi
FANNDOC_AWK="$ROOT/util/fanndoc.awk"
FCE_DIR="$ROOT/doc/en/reference/fann/functions/*.xml"
for FCE in $FCE_DIR; do
  if grep -q '<refpurpose>Description' $FCE ; then
	FCE_TMP="$FCE.tmp"
	awk -f $FANNDOC_AWK $FCE > $FCE_TMP
	mv $FCE_TMP $FCE
  fi
done





