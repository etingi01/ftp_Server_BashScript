#to run this file, type: "./ftpupload.sh {filedir} {ftpserver} {username}"
stoixeia(){
exec 3<>/dev/tcp/$ftpserver/21
read line <&3;
echo $line
#you could gain access to ftpserver with an anonymous account replacing the $ftpusername with the word anonymous
echo USER $ftpusername >&3
read line <&3;
echo $line
#if you prefer the anonymous access, change the next line to "echo PASS >&3"
echo PASS $password >&3
read line <&3;
echo $line
}

passive(){
echo pasv >&3
read line <&3;
echo $line
echo $line
line2=`echo $line | cut -d' ' -f1`
#echo "$line2"
if [[ $line2 -eq 226 ]]; then
  #echo "Nai, isoutai"
  read line <&3;
echo $line
fi


answer=`echo $line | awk '{$1=$2=$3=$4=""; print}'|tr -d '('|tr -d ')'|tr -d '.'|tr -d " " ` #take only the Ip with the port:browse confirm wa
#echo $answer
array=(${answer//,/ })
#for i in "${!array[@]}"
#do
    #echo "$i=>${array[i]}"
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
   #echo -en "$result2\n"
   sizer=${#result2}
    #  echo "Size tou result= $sizer"

   while [ $sizer -ne 8 ] ; do
      result2="0""$result2"
      sizer=${#result2}
   done
   portnum="$result""$result2"	
   #echo -en "$portnum\n"

   decimalport="$((2#$portnum))"
  # echo $decimalport
  # echo port: $decimalport
   exec 5<>/dev/tcp/Panope.in.cs.ucy.ac.cy/$decimalport #here you have to change the ftpserver and put the ftp server where your account is maintained
   echo "connection ok"
}

createDirectory(){

echo mkd $1 >&3
     read line <&3;
    echo $line
    exec 5>&-
    exec 5<&-
   echo "connection ok"

}


storefile(){
 # echo TYPE A >&3
  #  read line <&3;
   # echo $line

    echo "$1" | xargs cat  >&5 

  echo stor $1 >&3
     read line <&3;
    echo $line
    exec 5>&-
    exec 5<&-
   echo "connection ok"
}



read -sp "Give the password of the user that you mentioned on the command line " password
ftpserver=$2
ftpusername=$3


stoixeia $ftpserver $ftpusername $password;
find $1 -type d
#echo "Pinakas"
table=()

while read -r -d $'\0'; do
    table+=("$REPLY")
done < <(find $1 -type d -print0)

for k in "${!table[@]}"
do
   #echo "$k=>${table[k]}"
  passive;
  createDirectory ${table[k]};
done

tablef=()
while read -r -d $'\0'; do
  tablef+=("$REPLY")
done < <(find $1 -type f -print0)

for k in "${!tablef[@]}"
do
   #echo "$k=>${tablef[k]}"
   passive;

#echo "$k=>${tablef[k]}"

     storefile ${tablef[k]};
done



exec 3>&-
exec 3<&-