FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN pip3 install numpy==1.26.4
RUN pip3 install openwakeword==0.6.0
RUN pip3 install paho-mqtt==1.6.1
RUN pip3 install pyyaml==6.0
RUN pip3 install speexdsp-ns
RUN pip3 install speexdsp-ns
COPY detect.py .

CMD [ "python3", "-u", "detect.py", "-c", "/config/config.yaml"]