#!/bin/bash

init_hive() {
  local src=$BASH_SOURCE
  local version=$1
  local cwd=
  if [[ $src = /* ]] ;then
    cwd=${src%/*}
  else
    cwd=$PWD/$src
    cwd=${cwd%/*}
  fi
  local hivedir=${cwd%/*}
  HIVE_HOME=$hivedir/apache-hive-$version
  [ ! -e "$HIVE_HOME" ] && echo -e "\e[31m invalid hive distribution $version. \e[0m" && return
  export HIVE_HOME
  local np=
  for p in ${PATH//:/ } ;do
    [[ $p != $hivedir/apache-hive-* ]] && np+=$p:
  done
  PATH=$HIVE_HOME/bin:${np%:}
  export PATH
}

if [ $# -ne 1 ] ;then
  echo -e "\e[31m usage: ${BASH_SOURCE##*/} <version>\e[0m"
else
  init_hive $*
fi
