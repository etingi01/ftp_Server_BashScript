#to run this file, type "./ftpanalyze.sh [options] {ftpserver} {username}"
stoixeia(){
exec 3<>/dev/tcp/$ftpserver/21
read line <&3;
echo $line
echo USER $ftpusername >&3
read line <&3;
echo $line
echo PASS $password >&3
read line <&3;
echo $line
}

passive(){
#echo "exei dosei password 1234"
echo pasv >&3
read line <&3;
echo $line
#echo $line
line2=`echo $line | cut -d' ' -f1`
#echo "$line2"
if [[ $line2 -eq 226 ]]; then
#  echo "Nai, isoutai"
  read line <&3;
#echo $line
fi


answer=`echo $line | awk '{$1=$2=$3=$4=""; print}'|tr -d '('|tr -d ')'|tr -d '.'|tr -d " " ` #take only the Ip with port:browse confirm wa
#echo $answer
array=(${answer//,/ })
#for i in "${!array[@]}"
#do
#    echo "$i=>${array[i]}"
#done
#echo "exei dosei password 1234"
por1=${array[4]}
por2=${array[5]}
convertIntvalToBase $por1 $por2
}



function convertIntvalToBase () # (Val Base)
{
   val=$1
   vel=`echo $2 | tr -d '\r' `
   base=2
   result=""
   while [ $val -ne 0 ] ; do
        result=$(( $val % $base ))$result #residual is next digit
        val=$(( $val / $base ))
   done
   #echo -en "$result\n"
   sizer=${#result}
   #echo "Size tou result= $sizer"
   while [ $sizer -ne 8 ]; do
      result="0""$result"
      sizer=${#result}
   done

 	 #echo "$2"
   base2=2
   result2=""
   #echo "$result2 = none"
   while [ $vel -ne 0 ] ; do
        result2=$(( $vel % $base2 ))$result2 #residual is next digit
        vel=$(( $vel / $base2 ))
   done
  # echo -en "$result2\n"
   sizer=${#result2}
   #   echo "Size tou result= $sizer"

   while [ $sizer -ne 8 ] ; do
      result2="0""$result2"
      sizer=${#result2}
   done
   portnum="$result""$result2"	
  # echo -en "$portnum\n"

   decimalport="$((2#$portnum))"
  # echo $decimalport
  # echo port: $decimalport
   exec 5<>/dev/tcp/Panope.in.cs.ucy.ac.cy/$decimalport
   echo "connection ok"
}

getList(){
echo cwd /home/$ftpusername >&3
read line <&3;
echo $line

echo list >&3
     read line <&5;
    echo $line
    while read line <&5; do
    echo $line
  done
   read line <&3;
    echo $line
     read line <&3;
    echo $line
    exec 5>&-
    exec 5<&-
   #echo "connection ok"
}

showFile(){
  echo retr $1 >&3
   read line <&3;
    echo $line
    read line <&3;
    echo $line

      read line <&5;
    echo $line
     while read line <&5; do
    echo $line
  done
    exec 5>&-
    exec 5<&-
}


findString() {
  #echo "Parametros 1:"
  #echo $1
  see="$1"
  echo pwd >&3
  read line <&3;
  #echo $line

  echo cwd $1 >&3
  read line <&3;
  #echo $line

  echo list >&3
  read line <&3;
  #echo $line

 # read line <&5;
  #echo $line
  table=()
  while read line <&5; do
    #echo $line
    table+=("$line")
  done

  exec 5>&-
  exec 5<&-
  fileString "table[@]" $see
}

fileString() {
#echo "fileString"
arxeia=("${!1}")
see2="$2"

for k in "${!arxeia[@]}"
do
   #echo "$k=>${arxeia[k]}"
  arxeio="${arxeia[k]}"

  if [[ $arxeio != d* ]]; then
    arxeio2=`echo "$arxeio"| awk '{print $9}'`
    dirarxeiou="$see2""/""$arxeio2"
    #echo "dirarxeiou: $dirarxeiou"
    takefile $dirarxeiou $arxeio2 $k
   fi 
done

}


takefile() {
  see3="$1"
  #echo "$see3"
  passive;
  #echo "meta to passive"
  echo cwd "/home/$ftpusername" >&3
  read line <&3;
  #echo $line
  echo retr $see3 >&3
   read line <&3;
    echo $line
    read line <&3;
    echo $line
    #echo "$2"
    de="$2"
    de2=${de##*.}
    echo "$de2"
  if  [[ $de2 =~ "html" ]]; then 
    #echo "here"
    #echo "$2"
    onlyName=${de%%.*}
    #$de3=`echo "$de2" | tr -d '\r'`
    store="/tmp/$USER/""$onlyName"".""$de2"
    cat <&5 | tee $store >/dev/null 
    tableNames+=("$store")
    #echo "telos if"

  fi
  if  [[ $de2 =~ "txt" ]]; then 
    #echo "here"
    #echo "$2"
    onlyName=${de%%.*}
    $de2=`echo "$de2" | tr -d '\r'`
    store="/tmp/$USER/""$onlyName"".""$de2"
    cat <&5 | tee $store >/dev/null 
    tableNames+=("$store")
    #echo "telos if"
  fi


    #ls /tmp/$USER

    exec 5>&-
    exec 5<&-

}

printFilesRecurse() {
  passive;
  #echo "PrintFilesRecurse"
  #echo "orisma $1"
  echo cwd /home/$ftpusername >&3
  read line <&3;
  #echo $line
  echo cwd $1 >&3
  read line <&3;
  #echo $line
if [[ $line != 550* ]]; then

  echo list >&3
  read line <&3;
  #echo $line
  read line <&3;
  #echo $line
  local tableRec=()
  while read line <&5; do
    #echo $line
    fakelos=`echo $1 | tr -d '\r'`
    line2=`echo "$line"| awk '{print $9}'`
     line2=`echo $line2 | tr -d '\r'`
    newline="$fakelos/$line2"
    echo "new File/Dir: $newline" >>/tmp/$USER/helping3.txt
    tableRec+=("$line")
  done


  for k in "${!tableRec[@]}"
do
   arxeio="${tableRec[k]}"

  if [[ $arxeio != d* ]]; then
    arxeio2=`echo "$arxeio"| awk '{print $9}'`
    if [[ $arxeio ]]; then
      path3=`echo $1 | tr -d '\r'`
      filename="$path3/$arxeio2"
    #echo  "filename= $filename"
  fi
    tableRec[k]=''
    exec 5>&-
    exec 5<&-
   else

    dire=`echo "$arxeio"| awk '{print $9}'`
    if [[ $arxeio ]]; then
      path3=`echo $1 | tr -d '\r'`
      dire=`echo $dire | tr -d '\r'`
      filename="$path3"
       #echo "directory: $filename"
  fi
    katalogos=""
    katalogos="$path3/$dire"
    tableRec[k]=''
    #echo "Katalogos: $katalogos"
     #echo pwd >&3
  #read line <&3;
  #echo $line
     exec 5>&-
    exec 5<&-
    printFilesRecurse $katalogos
   fi
done
fi
}


printLinksRecurse() {
  passive;
  #echo "PrintLinksRecurse"
  #echo "orisma $1"
  echo cwd /home/$ftpusername >&3
  read line <&3;
  #echo $line
  echo cwd $1 >&3
  read line <&3;
  #echo $line
if [[ $line != 550* ]]; then

  echo list >&3
  read line <&3;
  #echo $line
  read line <&3;
  #echo $line
  local tableRec=()
  while read line <&5; do
    #echo $line
    if [[ $line != l* ]]; then
      echo "none" >helping2.txt

      else
        #echo "vrike Link"
         echo "LinkFound:">>helping.txt
      echo "$line" >>helping.txt

    fi
    fakelos=`echo $1 | tr -d '\r'`
    line2=`echo "$line"| awk '{print $9}'`
     line2=`echo $line2 | tr -d '\r'`
    newline="$fakelos/$line2"
    
    tableRec+=("$line")
  done


  for k in "${!tableRec[@]}"
do
   arxeio="${tableRec[k]}"

  if [[ $arxeio != d* ]]; then
    arxeio2=`echo "$arxeio"| awk '{print $9}'`
    if [[ $arxeio ]]; then
      path3=`echo $1 | tr -d '\r'`
      filename="$path3/$arxeio2"
    #echo  "filename= $filename"
  fi
    tableRec[k]=''
    exec 5>&-
    exec 5<&-
   else

    dire=`echo "$arxeio"| awk '{print $9}'`
    if [[ $arxeio ]]; then
      path3=`echo $1 | tr -d '\r'`
      dire=`echo $dire | tr -d '\r'`
      filename="$path3"
       #echo "directory: $filename"
  fi
    katalogos=""
    katalogos="$path3/$dire"
    tableRec[k]=''
    #echo "Katalogos: $katalogos"
     #echo pwd >&3
  #read line <&3;
  #echo $line
     exec 5>&-
    exec 5<&-
    printLinksRecurse $katalogos
   fi
done
fi
}

makeLeksiko() {
  

    cd /tmp/$USER ;ls /tmp/$USER | tr ' ' '\n'|grep '.html'|xargs cat | sed '/</ {:k s/<[^>]*>//g; /</ {N; bk}}' | tr -d '\-\-\>' |sed -e '/./b' -e :n -e 'N;s/\n$//;tn'|tr ' ' '\n'|tr -s '\n'| tr '[A-Z]' '[a-z]' |sort|uniq -c | tee /tmp/$USER/lexicon.txt


}




read -sp "Give the password of the user that you mentioned on the command line " password
echo ""

ftpserver="${@:(-2):1}"
echo "Server $second_to_last"

ftpusername="${@:(-1):1}"
echo "Username $first_to_last"

stoixeia;

option=$1
if [[ $option =~ "show-dir-R" ]]; then

 path2=$2
 
 printFilesRecurse $path2

  metavliti="/tmp/$USER/helping3.txt"
 cat "$metavliti"
 cd /tmp/$USER; rm /tmp/$USER/helping3.txt
    cd -
elif [[ $option =~ "show-dir" ]]; then
  passive;
  getList;
fi

if [[ $option =~ "show-file" ]]; then
var=$2

    de2=${var##*.}
    #echo "$de2"
  if  [[ $de2 =~ "html" ]]; then 
    passive;
    showFile $var 

  fi
  if [[ $de2 =~ "txt" ]]; then
    passive;
    showFile $var 
  fi

  if [[ $de2 =~ "jpeg" ]]; then

    passive;
    showFile $var 
  fi

  if [[ $de2 =~ "jpg" ]]; then

    passive;
    showFile $var 
  fi
  
  if [[ $de2 =~ "bmp" ]]; then
    passive;
    showFile $var 

  fi
  if [[ $de2 =~ "gif" ]]; then
    passive;
    showFile $var 

  fi 

fi 


if [[ $option =~ "find-string" ]]; then
 tableNames=()
  path2=$2
  string=$3
#echo "path: $path2  String: $string"

  passive;
  findString $path2 $string
  for k in "${!tableNames[@]}"
  do
  # echo "$k=>${tableNames[k]}"
    cat "${tableNames[k]}" | grep "$string"
    #rm ${tableNames[k]}
    #cd -
 done

fi


if [[ $option =~ "show-urls" ]]; then 
  pathforE="/home/$ftpusername"
  touch helping.txt
  printLinksRecurse $pathforE
  cat helping.txt
  rm helping.txt
  rm helping2.txt
fi

if [[ $option =~ "analyze-html" ]]; then
makeLeksiko 

fi

#username="askisi2"
#echo "Search for Links"

#printLinksRecurse $pathforE
#cat helping.txt
#rm helping.txt
#rm helping2.txt




exec 3>&-
exec 3<&-