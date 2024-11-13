# pi-voice

Voice assistant stack for Raspberry Pi, integrating [Rhasspy](https://rhasspy.readthedocs.io/) with wake word detection and text-to-speech.

## Services

### openWakeWord
Listens for wake words via UDP audio streams from Rhasspy satellites and publishes to MQTT (Hermes protocol) to trigger speech-to-text.

- Receives audio over UDP (16 kHz, WAV chunks)
- Runs [openWakeWord](https://github.com/dscripka/openWakeWord) models
- Publishes `hermes/hotword/{wakeword}/detected` to MQTT
- Supports multiple rooms/satellites simultaneously

### mary-piper
MaryTTS-compatible HTTP API for [Piper TTS](https://github.com/rhasspy/piper), used by Rhasspy for speech synthesis.

- Exposes `/process` and `/voices` endpoints
- Supports custom voice models (`.onnx` files)
- Polish voice included: `pl_PL-gosia-medium`

### Rhasspy (optional)
Configuration for the Polish (`pl`) profile is in `rhasspy/profiles/pl/`. Currently commented out in `pi-voice.yaml`.

## Setup

```bash
# Deploy to Raspberry Pi
scp -r ./ pi@pi-voice:/home/pi/pi-voice

# Start services
docker compose -f pi-voice.yaml up -d
```

## Credentials & Tokens

The following files contain secrets and are excluded from git via `.gitignore`. Copy and fill them in manually on the target machine.

### OpenAI Whisper (`rhasspy/profiles/pl/whisper.openai.sh`)
Replace `YOUR_OPENAI_API_KEY` with a key from [platform.openai.com/api-keys](https://platform.openai.com/api-keys):
```bash
-H "Authorization: Bearer YOUR_OPENAI_API_KEY"
```

### Google Text-to-Speech (`rhasspy/profiles/pl/googleTts.sh`)
Replace `YOUR_GOOGLE_BEARER_TOKEN` with a token obtained via `gcloud auth print-access-token` and `YOUR_GOOGLE_PROJECT_ID` with your GCP project ID:
```bash
-H "X-Goog-User-Project: YOUR_GOOGLE_PROJECT_ID"
-H "Authorization: Bearer YOUR_GOOGLE_BEARER_TOKEN"
```

### Google WaveNet credentials (`rhasspy/profiles/pl/tts/googlewavenet/credentials.json`)
Fill in OAuth2 credentials from [Google Cloud Console](https://console.cloud.google.com/apis/credentials):
```json
{
  "client_id": "YOUR_GOOGLE_CLIENT_ID",
  "client_secret": "YOUR_GOOGLE_CLIENT_SECRET",
  "quota_project_id": "YOUR_GOOGLE_PROJECT_ID",
  "refresh_token": "YOUR_GOOGLE_REFRESH_TOKEN",
  "type": "authorized_user"
}
```

## Configuration

### openWakeWord (`openWakeWord/config.yaml`)

```yaml
mqtt:
  broker: pi-master.local
  port: 1883

oww:
  model_names:
    - alexa
    - /other-models/ok_home.tflite
  activation_threshold: 0.2
  deactivation_threshold: 0.1
  vad_threshold: 0.3
  enable_speex_noise_suppression: true

udp_ports:
  floor1: 12202
  bedroom: 12203
  office: 12204
```

### UDP Audio (Rhasspy satellites)
Each Rhasspy satellite streams audio to a dedicated UDP port. Configure in Rhasspy under `microphone > udp_audio`.

## Custom Wake Word Models
Place `.tflite` model files in `openWakeWord/other-models/` and reference them in `config.yaml`.

## Custom TTS Voices
Place `.onnx` and `.onnx.json` files in `mary-piper/custom/`.
