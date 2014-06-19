#!/bin/bash

   cookie_file_location=$1
   category=$2
   nzb_file=$3

   #optional
   nfo_file=$4

   if [[ ! -f "$cookie_file_location" ]]; then

      echo ""
      echo "Error: cookie information not set!"
      echo ""
      exit

   fi

   arr=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34)

   if [[ ! ${arr[*]} =~ "$category" ]]; then

      echo ""
      echo "Error: invalid category number"
      echo ""
      exit

   fi

   if [ ! -f "$nzb_file" ]; then

      echo ""
      echo "Error: nzb file does not exist!"
      echo ""
      exit

    else

    tempfile="/tmp/omgwtfnzbs.org.nzb-upload.parser.tmp"

    minus_path="${nzb_file##*/}"
    release="${minus_path%.nzb}" 
    string=${release,,}

    if [[ "$string" =~ (.pal.) ]]; then
      format="1"
    elif [[ "$string" =~ (.ntsc.) ]]; then
      format="2"
    else 
      format="4"
    fi

    if [[ "$string" =~ (.danish.) ]]; then
      language="1"
    elif [[ "$string" =~ (.dutch.) ]]; then
      language="2"
    elif [[ "$string" =~ (.flemish.) ]]; then
      language="2"
    elif [[ "$string" =~ (.finnish.) ]]; then
      language="3"
    elif [[ "$string" =~ (.french.) ]]; then
      language="4"
    elif [[ "$string" =~ (.truefrench.) ]]; then
      language="4"
    elif [[ "$string" =~ (.german.) ]]; then
      language="5"
    elif [[ "$string" =~ (.norwegian.) ]]; then
      language="6"
    elif [[ "$string" =~ (.spanish.) ]]; then
      language="7"
    elif [[ "$string" =~ (.swedish.) ]]; then
      language="8"
    elif [[ "$string" =~ (.multi.) ]]; then
      language="9"
    else 
      language="0"
    fi

    
    release=$(echo "$release" | xargs)
    curl=$(which curl)

    if [[ -f "$nfo_file" ]]; then

      $curl -s -k -b "$cookie_file_location" -F "rlsname=$release" -F "catid=$category" -F "mats=$format" -F "language=$language" -F "nzb=@$nzb_file" -F "nfo=@$nfo_file" -F "upload=upload" https://omgwtfnzbs.org/nzb-upload.php --location > $tempfile
      response=$(cat $tempfile | grep -o '<response>.*</response>' | sed -e 's/<[^>]*>//g')

    else 

      $curl -s -k -b "$cookie_file_location" -F "rlsname=$release" -F "catid=$category" -F "mats=$format" -F "language=$language" -F "nzb=@$nzb_file" -F "upload=upload" https://omgwtfnzbs.org/nzb-upload.php --location > $tempfile
      response=$(cat $tempfile | grep -o '<response>.*</response>' | sed -e 's/<[^>]*>//g')
    
    fi

      echo ""
      echo $response
      echo ""

    fi
