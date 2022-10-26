#!/bin/bash
#init led & button

   if [ $(id -u) -ne 0 ]; then
	echo "script starts"
   
	else
        echo -e "Install CAN NOT be run as root. Try without sudo\n"
        exit 1
	fi

echo 25 >/sys/class/gpio/export
echo out >/sys/class/gpio/gpio25/direction
echo 23 >/sys/class/gpio/export
echo in >/sys/class/gpio/gpio23/direction



#infinite loop
while [ 1 ]
do
#led ON
echo 1 >/sys/class/gpio/gpio25/value

echo  "-----> Test for Raspiaudio MIC+"


amixer set Micro 50%
amixer set Master 96%
sudo alsactl store

echo  "------Please PUSH on the Yellow ONBOARD button to continue this test"

#waiting button pressed
while [ `cat /sys/class/gpio/gpio23/value` = 1 ]; do
set i = 1
done
#led OFF
echo 0 >/sys/class/gpio/gpio25/value
#record 5s
arecord -d4 -f S16_LE -c1 -r44100 /home/$USER/test.wav&

#test channels L & R
speaker-test -l1 -c2 -t wav

#led BLINK
sudo echo 1 >/sys/class/gpio/gpio25/value
sleep 1
sudo echo 0 >/sys/class/gpio/gpio25/value


#led BLINK
sudo echo 1 >/sys/class/gpio/gpio25/value
sleep 1
sudo echo 0 >/sys/class/gpio/gpio25/value


echo "playing the recording"
#play record
aplay /home/$USER/test.wav

echo "------------------------------------------------------------------------"
echo "Test is done to adjust speakers volume and microphone gain run: alsamixer"

exit

done
#echo 25 >/sys/class/gpio/unexport
