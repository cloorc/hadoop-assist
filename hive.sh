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

  [ -z "$HADOOP_HOME" ] && echo -e "\e[31m environment HADOOP_HOME has not been set. \e[0m" && return

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

  cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-default.xml -f
  cp $HIVE_HOME/conf/hive-env.sh.template $HIVE_HOME/conf/hive-env.sh -f
  cp $HIVE_HOME/conf/hive-log4j2.properties.template $HIVE_HOME/conf/hive-log4j2.properties -f
  sed -i "/# HADOOP_HOME=.*/aHADOOP_HOME=${HADOOP_HOME////\\/}" $HIVE_HOME/conf/hive-env.sh
  local v=$cwd/logs/hive
  sed -i "s/\(property.hive.log.dir = \).*/\1${v////\\/}/g" $HIVE_HOME/conf/hive-log4j2.properties
}

if [ $# -ne 1 ] ;then
  echo -e "\e[31m usage: ${BASH_SOURCE##*/} <version>\e[0m"
else
  init_hive $*
fi
