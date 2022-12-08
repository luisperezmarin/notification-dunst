#!/bin/bash
# changeVolume

# Arbitrary but unique message tag
msgTag="Brightness"
iconBrightness="/usr/share/icons/Faba/48x48/notifications/notification-display-brightness.svg"

# Query amixer for the current volume and whether or not the speaker is muted
function get_brightness {
  brightnessctl info intel_backlight |grep Current|cut -d"(" -f2 |grep -o '[0-9]\{1,3\}'
}

brightness=$(get_brightness)

case $1 in
  up)
      brightnessctl set +5% &>/dev/null
      brightness=$(get_brightness)
      dunstify -a "changeBrightness" -u low -i ${iconBrightness} -h string:x-dunst-stack-tag:$msgTag \
      -h int:value:"$brightness" "Brightness: ${brightness}%"
	;;
  down)
      brightnessctl set 5%- &>/dev/null
      brightness=$(get_brightness)
      dunstify -a "changeBrightness" -u low -i ${iconBrightness} -h string:x-dunst-stack-tag:$msgTag \
      -h int:value:"$brightness" "Brightness: ${brightness}%"
	;;
esac
# Play the volume changed sound
canberra-gtk-play -i audio-volume-change -d "changeBrightness"
