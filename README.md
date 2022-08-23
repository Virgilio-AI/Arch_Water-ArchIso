## this is the script to create the arch water ISO
this uses archiso and is fully configurable just like archiso
this is  a fork of the official arch linux arch iso but it includes water linux installer with all necessary packages, this is an offline installer so it means that once you have the iso you can burn in to a usb and boot into it from a laptop and you can install water linux entirely offline :)
## compile
to compile you can just run 

``` console
# run the build file to build the iso
sudo sh build.sh
# will ask for the password during the process so don't let it all by itself
# if will ask if you want to update the databases, is to update the databases
# that are from the AUR
```


## test the iso
 to test the iso just run the run.sh command with a path into the created iso, 
 the created iso will default to out/archWaterLinux-2021.08.17-x86_64.iso 
 example
 ```
 sudo sh run.sh out/archWaterLinux-2021.08.17-x86_64.iso
 ```
 
 ## clean all the working files
 ```
 ./celanForCommit.sh
 ```


# Notes
if you want a specific package to be in the iso, just add it these 4 files

packages.txt
packages.x86_64
airootfs/root.packages.txt
airootfs/root/packages.x86_64



file
- suggestions are accepted
