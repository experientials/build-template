# Setup Alpine in Rpi

In order to setup Alpine v3.14:
* follow this [guideline created by garrym](https://github.com/garrym/raspberry-pi-alpine). Note: There are some _optional_ packages that are installed after running `setup.sh` script
* Setup ssh to enable remote login (permit root login as well)
* Change the /etc/apk/repositories to fetch packages from v3.14 (or edge)

# Setup dependencies for openCV

* Install the packages found in [docker alpine-openCV container](https://github.com/petronetto/opencv-alpine/blob/master/Dockerfile) 
Note: Remove the ttags from the mirror websites. 

