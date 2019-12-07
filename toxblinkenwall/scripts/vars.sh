#! /bin/bash

##### -------------------------------------
# pick first available framebuffer device
# change for your needs here!
export fb_device=$(ls -1 /dev/fb*|head -1)
##### -------------------------------------

##### -------------------------------------
export FB_WIDTH=640
export FB_HEIGHT=480

if [ "$IS_ON""x" == "RASPI""x" ]; then
  export BKWALL_WIDTH=640
  export BKWALL_HEIGHT=480
elif [ "$IS_ON""x" == "BLINKENWALL""x" ]; then
  export BKWALL_WIDTH=192
  export BKWALL_HEIGHT=144
fi

if [ "$HD""x" == "RASPIHD""x" ]; then
  export BKWALL_WIDTH=1280
  export BKWALL_HEIGHT=720
  export FB_WIDTH=1280
  export FB_HEIGHT=720
fi

# TODO: dont hardcode "fb0" here!!
stride_=$(cat /sys/class/graphics/fb0/stride)
bits_per_pixel_=$(cat /sys/class/graphics/fb0/bits_per_pixel)
virtual_size=$(cat /sys/class/graphics/fb0/virtual_size)
# TODO: dont hardcode "fb0" here!!

# change values to actual framebuffer resolution --------
if [ "$IS_ON""x" == "RASPI""x" ]; then
  export BKWALL_WIDTH=$(echo $virtual_size |cut -d"," -f1)
  export BKWALL_HEIGHT=$(echo $virtual_size |cut -d"," -f2)
  export FB_WIDTH=$BKWALL_WIDTH
  export FB_HEIGHT=$BKWALL_HEIGHT
fi
# change values to actual framebuffer resolution --------

if [[ $bits_per_pixel_ -lt 8 ]]; then
  # TODO: the result will be wrong, but its not DIV by zero error!
  tmp1=1
  export FB_WIDTH=640
  export FB_HEIGHT=480
  export BKWALL_WIDTH=640
  export BKWALL_HEIGHT=480
  export real_width=640
else
  tmp1=$[ $bits_per_pixel_ / 8 ]
  export real_width=$[ $stride_ / $tmp1 ]
fi

##### -------------------------------------

#####################################################
# pick last available video device
# change for your needs here!
video_device=$(ls -1 /dev/video*|tail -1)

d_try="$video_device"
v4l2-ctl -I "$d_try" > /dev/null 2> /dev/null
res_ok=$?

if [ $res_ok -ne 0 ]; then
    # ok, most likely new linux kernel, with useless metadata devices
    ls -1 /dev/video*|sort -V -r| while read d_try ; do
        v4l2-ctl -I "$d_try" > /dev/null 2> /dev/null
        res_ok=$?
        if [ $res_ok -eq 0 ]; then
            video_device="$d_try"
            break
        fi
    done
fi

export video_device
#
#####################################################
