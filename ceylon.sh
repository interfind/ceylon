#!/usr/bin/env bash

#----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---
### LEGAL INFO ################################################################
# Ceylon 1.0 - Copyright (C) 2021 Dipl.-Ing. Ulrich Bentrup, interfind.de     #
#                                                                             #
# This program is free software: you can redistribute it and/or modify        #
# it under the terms of the GNU General Public License as published by        #
# the Free Software Foundation, either version 3 of the License, or           #
# (at your option) any later version.                                         #
#                                                                             #
# This program is distributed in the hope that it will be useful,             #
# but WITHOUT ANY WARRANTY; without even the implied warranty of              #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                #
# GNU General Public License for more details.                                #
#                                                                             #
# You should have received a copy of the GNU General Public License           #
# along with this program. If not, see <http://www.gnu.org/licenses/>.        #
### LEGAL INFO ################################################################

### BEGIN STATIC ##############################################################
C_PROG_ID="470e6f9a-40e5-11ec-93d1-9bfc2b7a6954";
C_PROG_MAIN="ceylon";
C_PROG_NAME="ceylon/${C_PROG_MAIN}";
C_PROG_VERSION="1.0";
C_PROG_DIR="/opt/ceylon/";

C_PROG_DIRBASE="${C_PROG_DIR}${C_PROG_MAIN}.sh";
C_PROG_DIRNAME="$(dirname ${C_PROG_DIRBASE})/";
C_PROG_BASENAME="$(basename ${C_PROG_DIRBASE})";
C_PROG_PROMPT="${C_PROG_NAME}_${C_PROG_VERSION}> ";

C_PROG_BATCH="false";
### END STATIC ################################################################

### BEGIN INCLUDE #############################################################
if [[ "$1" != "batch" ]]; then
   source "/opt/ceylon/catalog.sh" "batch";
   source "/opt/ceylon/service.sh" "batch";
fi;
### END INCLUDE ###############################################################

### BEGIN BASIC_FUNCTION ######################################################
function edit()   { vi $0; }
function reload() { exec $0; }
### END BASIC FUNCTION ########################################################

### BEGIN FUNCTION_BASIC ######################################################
function init() {
   if [[ "$1" != "" ]]; then C_PROG_BATCH="true"; fi;

   resize -s ${CC_CONFIG_XTERM_SIZE} >/dev/null;
}

function edit() {
   if [[ "$1" == "" ]]; then vi $0; fi;
   if [[ "$1" != "" ]]; then vi $1; fi;
}

function reload() {
   exec $C_PROG_DIRBASE;
}
### END FUNCTION_BASIC ########################################################

### BEGIN ARCHIVE #############################################################
function archive() {
   local DATE=$(get_date);
   local SRC=${C_PROG_NAME};
   local DST=${C_ARCHIVE_DIR}${DATE}_${C_PROG_NAME}_${C_PROG_VERSION}.tar.gz;

   if [[ -f "$DST" ]]; then rm $DST; fi;

   cd /opt;
   tar -czvf $DST $SRC;
   cd -;
}
### END ARCHIVE ###############################################################

### BEGIN CATALOG #############################################################
function catalog() {
   local CATALOG_SH="${CC_CATALOG_SH}";

   eval $CATALOG_SH;
}
### END CATALOG ###############################################################

### BEGIN SERVICE #############################################################
function service() {
   local SERVICE_SH="${CC_SERVICE_SH}";

   eval $SERVICE_SH;
}
### END SERVICE ###############################################################

### BEGIN DOCKER ##############################################################
function docker() {
   local DOCKER_SH="${CC_UTILS_SYS_DOCKER_DOCKER_SH}";

   eval $DOCKER_SH;
}
### END DOCKER ################################################################

### BEGIN MYSQL ###############################################################
function mysql() {
   local MYSQL_SH="${CC_UTILS_FILE_MYSQL_MYSQL_SH}";

   eval $MYSQL_SH;
}
### END MYSQL #################################################################

### BEGIN MANUEL ##############################################################
function manual() {
   echo "Manual";
}
### END MANUAL ################################################################

### BEGIN REPORT ##############################################################
function report() {
   echo "Report";
}
### END REPORT ################################################################

### BEGIN LOOP ################################################################
function loop() {
   local CMD_LINE="";

   echo "$CC_LEGAL_WARRANTY_HINT_TXT";

   if [[ "$1" != "" ]];
      then C_PROG_BATCH="true";
      else echo -ne "$C_PROG_PROMPT";
   fi;

   while true
   do
      if [[ "$BATCH" == "true" ]];
         then
            cmd=$1; p0=$2; p1=$3; p2=$4; p3=$5; p4=$6; p5=$7; p6=$8; p7=$9;
         else
            read cmd p0 p1 p2 p3 p4 p5 p6 p7;
      fi;

      CALL=$(echo "$p0 $p1 $p2 $p3 $p4 $p5 $p6 $p7" | xargs);
      CMD_LINE=$(echo "$cmd $p0 $p1 $p2 $p3 $p4 $p5 $p6 $p7" | xargs);

      case "$CMD_LINE" in
         ###_MARKER_HELP_BEGIN_###
         "0")        catalog;;   # call the catalog prog
         "1")        service;;   # call the service prog
         "2")        mysql;;     # call the mysql prog
         "3")        docker;;    # call the docker prog

         "p")        exec ${CC_APPS_CSPF_CSPF_PNL} ${C_PROG_DIRBASE};;  # show panel
         "e")        edit;;      # edit this file
         "r")        reload;;
         "h"*)       help | more;;

         "c"*)       batch -o y -c "$CALL";; # unix native command
         "x")        exit;;      # exit program

         "info"*)    info $p0;;  # global info
         "legal"*)   legal $p0;; # legal info
         ###_MARKER_HELP_END_###

         "batch") break;;           # batch command
         *) if [[ $CMD_LINE != "" ]]; then
               echo "\"$CMD_LINE\" is an invalid command.";
            fi;;
      esac

      if [[ "$C_PROG_BATCH" == "true" ]]; then break; fi;

      echo -ne "$C_PROG_PROMPT";
   done
}
### END LOOP ##################################################################

### BEGIN CLEAN ###############################################################
function clean() {
   echo -en "";
}
### END CLEAN #################################################################

### BEGIN RUN_LOOP ############################################################
init $1;
loop $1 $2 $3 $4 $5 $6 $7 $8 $9;
clean;
### END RUN_LOOP ##############################################################

