# ftp_Server_BashScript
This is an ftp server in Bash Script.
Two services are offered:
1. Upload files on the remote machine (ftpupload.sh)
2. Analyze files that are existed in the remote machine (ftpanalyse.sh)

ftpupload.sh:
-> to run the file type in the command line: ./ftpupload.sh {filedir} {ftpserver} {username}
filedir is the directory of the files you want to upload in the local machine. The same directory tree will be created in the remote machine.
ftpserver is the file transfer server
username is the username of one ftp account in the ftpserver. You can have anonymous access changing the lines 6-11 (instructions in comments)

ftpanalyze.sh:
This program allow you to analyse the files (.txt, .html, .jpeg, .jpg, .bmp, .gif, other types of files are ignored) on the remote machine. In the some cases the files are downloaded locally, in some others this is not necessary. 
->to run the file type in the command line: ./ftpanalyze.sh [options] {ftpserver} {username}
ftpserver is the file transfer server
username is the username of one ftp account in the ftpserver. You can have anonymous access changing the lines 6-11 (instructions in comments)
[options]:
show-dir : The home dir's content of remote machine is shown on the screen. The files are not dowloaded locally.
show-file <path/filename> : The file's content of the second argument is shown on the screen. The file is downloaded locally.
find-string <path/> <string> : This command will search for the <string> in the directory defined in the <path/>. The lines of the files that include the <string> will be shown on the screen.
show-dir-R <path/> : This command has the same results with the command "ls -R <path/>". All files in the path will be shown  recursively on the screen.
show-urls : All the links that exist in all files of the account are shown on the screen. The files are temporarily downlowded locally.
analyze-html : With this option, the server searches in all .html files and finds the content that it is not included in HTML TAGS (<>). Then, it is created a local dictionart with the different words and their frequency.

