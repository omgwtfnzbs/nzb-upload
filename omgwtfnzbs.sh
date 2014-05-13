#!/bin/bash

   cookiedata="omg.cookie";
   nzb_directory="scr/moviesd"
   tempfile="/tmp/omgwtfnzbs.org.nzb-upload.parser"

   if [[ ! -f $cookiedata ]]; then
      echo ""
      echo "Error: cookie file not set!"
      echo ""
      exit
   fi

   if [ ! -d "$nzb_directory" ]; then
      echo ""
      echo "Error: nzb_directory does not exist!"
      echo ""
      exit

    else

    cd $nzb_directory

    for nzbfile in *.nzb; do

    [[ -d "$nzbfile" ]] || 

    release="${nzbfile%.nzb}" 
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

    nfofile=$(find "$(pwd)" -name "$release.nfo")
    release=$(echo "$release" | xargs)

    if [ "$nfofile" != "" ]; then

    /usr/bin/curl -s -k -b "$cookiedata" -F "rlsname=$release" -F "catid=15" -F "mats=$format" -F "language=$language" -F "nzb=@$nzbfile" -F "nfo=@$nfofile" -F "upload=upload" https://omgwtfnzbs.org/nzb-upload.php --location > $tempfile
    response=$(cat $tempfile | grep -o '<response>.*</response>' | sed -e 's/<[^>]*>//g')

    rm "$nfofile" > /dev/null 2>&1
    rm "$nzbfile" > /dev/null 2>&1

    else 

    /usr/bin/curl -s -k -b "$cookiedata" -F "rlsname=$release" -F "catid=15" -F "mats=$format" -F "language=$language" -F "nzb=@$nzbfile" -F "upload=upload" https://omgwtfnzbs.org/nzb-upload.php --location > $tempfile
    response=$(cat $tempfile | grep -o '<response>.*</response>' | sed -e 's/<[^>]*>//g')

    rm "$nzbfile" > /dev/null 2>&1
    
    fi

    echo $response

    sleep 0.05;

    done

    fi
