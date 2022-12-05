#!/bin/bash
# changeVolume

# Arbitrary but unique message tag
msgTag="Volume"
iconMuted="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-muted.svg"

# Query amixer for the current volume and whether or not the speaker is muted
function get_volume {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F':' '{printf($2*100"\n")}'
}

function is_mute {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ |grep -o MUTED
}

volume=$(get_volume)

if [ ${volume} -lt 50 ]
then
  iconSound="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-medium.svg"
elif [ ${volume} -lt 20 ]
then
  iconSound="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-low.svg"
else
  iconSound="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-high.svg"
fi

case $1 in
  up)
    if is_mute; then
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    fi
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    dunstify -a "changeVolume" -u low -i ${iconSound} -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$volume" "Volume: ${volume}%"
	;;
  down)
    if is_mute; then
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    fi
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    dunstify -a "changeVolume" -u low -i ${iconSound} -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$volume" "Volume: ${volume}%"
	;;
  mute)
    	# Toggle mute
    if is_mute ; then
      dunstify -a "changeVolume" -u low -i ${iconSound} -h string:x-dunst-stack-tag:$msgTag "Volume ${volume}%" 
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    else
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      dunstify -a "changeVolume" -u low -i ${iconMuted} -h string:x-dunst-stack-tag:$msgTag "Volume muted" 
    fi
	;;
esac
# Play the volume changed sound
canberra-gtk-play -i audio-volume-change -d "changeVolume"
