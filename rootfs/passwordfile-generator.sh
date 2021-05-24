#!/bin/bash

echo "----------------------------"
echo "| Passwd File Generator |"
echo "----------------------------"
echo

rm -f /mosquitto/data/mosquitto.passwd
rm -f /mosquitto/data/mosquitto.passwd.tmp

mosquitto_passwd -c -b /mosquitto/data/mosquitto.passwd ${USERNAME} ${PASSWORD}

echo "--> Passwd file generated"
echo