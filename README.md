# adb.sh

# Enable ADB over wifi
```
su
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```
