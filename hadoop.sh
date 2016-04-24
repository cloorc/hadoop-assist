#!/bin/bash

init_hadoop () {
  [ -z "$JAVA_HOME" ] && echo -e "\e[31m environment JAVA_HOME has not been set.\e[0m" && return
  export JAVA_HOME=$JAVA_HOME
  
  local HADOOP_CD=
  if [[ $BASH_SOURCE = /* ]] ;then
    HADOOP_CD=$(dirname ${BASH_SOURCE})
  else
    src=$PWD/$BASH_SOURCE
    HADOOP_CD=${src%/*}
  fi
  local HADOOP_WC=$(dirname ${HADOOP_CD})
  HADOOP_HOME=${HADOOP_WC}/hadoop-$1
  
  [ ! -e "$HADOOP_HOME" ] && echo -e "\e[31m hadoop distribution $1 doesn't exist.\e[0m" && return

  export HADOOP_HOME
  export HADOOP_CONF_DIR=${HADOOP_CD}/etc/hadoop
  export HADOOP_LOG_DIR=${HADOOP_CD}/logs/hadoop
  export HADOOP_PID_DIR=${HADOOP_CD}/pid
  export HADOOP_LOGLEVEL=INFO

  local hadoopenv=${HADOOP_CD}/etc/hadoop/hadoop-env.sh
  local elist="JAVA_HOME HADOOP_CONF_DIR HADOOP_LOG_DIR HADOOP_PID_DIR HADOOP_LOGLEVEL"
  for e in $elist ;do
    local v=$(eval echo \$$e)
    grep -q -G "^export $e" $hadoopenv
    if [ $? -eq 0 ] ;then
      sed -i "s/export $e=.*/export $e=${v////\\/}/g" $hadoopenv
    else
      sed -i "/export JAVA_HOME=/aexport $e=${v////\\/}" $hadoopenv
    fi
  done

  local exported=
  echo $PATH|/bin/grep -q $HADOOP_HOME/bin && exported=true
  [ -z "$exported" ] && {
    local np=
    for p in ${PATH//:/ } ;do
      [ "${HADOOP_HOME%/hadoop-*}" != "${p%/hadoop-*}" ] && np+=$p:
    done
    PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:${np%:}
    export PATH
  }
}

if [ $# -eq 1 ] ;then
  init_hadoop $1
else
  echo -e "\e[31m usage: ${BASH_SOURCE##*/} <hadoop-version> \e[0m"
fi
