#!/usr/bin/env bash

# WAV data is avaiable via STDIN
wav_file=/profiles/pl/speech.wav
cat > $wav_file

START_TIME=$SECONDS
#curl http://192.168.88.51:5020/inference \
curl https://31.42.6.203:5022/inference \
  -X POST \
  -H "Content-Type: multipart/form-data" \
  -F file=@$wav_file \
  -F temperature=0.0 \
  -F temperature_inc=0.2 \
  -F response_format=text \
  -k \
| sed -e "s/[[:punct:]]//g" | sed -e "s/\(.*\)/\L\1/"

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "time" >> /profiles/pl/log
echo $ELAPSED_TIME >>  /profiles/pl/log
#echo "\n" > /home/pi/.config/rhasspy/profiles/pl/log.txt
# sed removes punctuation and makes lower case

# Transcription on STDOUT
