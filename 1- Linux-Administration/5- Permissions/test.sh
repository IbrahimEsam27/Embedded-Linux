#current user : ibrahim
mkdir ~/myteam
chmod 4 ~/myteam 

#switch to user : hema
su - hema 

cd /home/ibrahim/myteam/   #permission denied 

#Change the permissions of oldpasswd file to give owner read and writepermissions and for group write and execute and execute only for the others
sudo chmod 631 /home/ibrahim/myteam/

#default permissions for file is rw-rw-r
#default permissions for directory is rwxrwxr-x

umask 777   #make default permissions with nothing d--------- for directory and same for files

#cannot do any operation on file or directory 
#sudo can operate commands 
# difference between the “x” permission for a file and for a directory : for file x is for executing scripts , for directories is for using diresctory cannot use any thing inside the directory without x permission 

#making new directory
su - ibrahim
mkdir ~/new-dir
chmod +t ~/new-dir

#Allow these users to create files within the directory and directory
chmod 777 ~/new-dir

#made directories and files inside new-dir by many users and cannot edit each other 

#passwd command has and explain why it has S : rwsr-xr-x and it has s because i want to run it with its owner permissions and her the owner is the root  








