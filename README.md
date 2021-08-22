## this is the script to create the arch water ISO
this uses archiso and is fully configurable just like archiso

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


# Notes
if you want a specific package to be in the iso, just add it into packages.x86_64
file
- suggestions are accepted
