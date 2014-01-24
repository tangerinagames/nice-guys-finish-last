#!/bin/sh

INTENT="org.love2d.android/.GameActivity"

# clean the old files
adb shell rm -r /sdcard/lovegame

# create the dest dir
adb shell mkdir /sdcard/lovegame

# copy the files
adb push . /sdcard/lovegame

# Run the apk inside the application
adb shell am start -S -n $INTENT
