#!/vendor/bin/sh

/vendor/bin/tinymix 'QUAT_MI2S_RX Audio Mixer MultiMedia5' 1 > /dev/null 2>&1
/vendor/bin/tinyplay /vendor/etc/audio/silence_48k.wav -d 13 > /dev/null 2>&1 &
TINYPLAY_PID=$!> /dev/null 2>&1
sleep 2
kill $TINYPLAY_PID > /dev/null 2>&1
sleep 0.1
/vendor/bin/tinymix 'QUAT_MI2S_RX Audio Mixer MultiMedia5' 0 > /dev/null 2>&1
