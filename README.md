Here’s your **clean, properly formatted** `README.md` ready to paste into your GitHub repo:

````markdown
# vcam-dup

Simple Bash script to create **two virtual webcams** from a single physical webcam, without using OBS.

Uses:
- [`v4l2loopback`](https://github.com/umlaeute/v4l2loopback) to create virtual devices
- [`ffmpeg`](https://ffmpeg.org/) to duplicate the video feed
- Auto-restarts `ffmpeg` if it crashes
- Shows a red/green heartbeat for live/no-signal status

---

## Features
- Hide the real camera from other apps
- Create two virtual cameras (e.g. `/dev/video10` and `/dev/video11`)
- Duplicate the webcam stream in real time
- Auto-recover if `ffmpeg` stops
- Color-coded heartbeat in the terminal

---

## Requirements
Install required packages:
```bash
sudo apt update
sudo apt install v4l2loopback-dkms ffmpeg v4l-utils
````

Load the loopback module manually (if needed):

```bash
sudo modprobe v4l2loopback devices=2 video_nr=10,11 card_label=VCam1,VCam2 exclusive_caps=0
```

---

## Usage

Make script executable:

```bash
chmod +x vcam-dup.sh
```

Run:

```bash
./vcam-dup.sh
```

Stop and restore real webcam access:

```bash
./vcam-dup.sh --unlock
```

---

## Example Output

```plaintext
✅ Virtual cams are ready!
➡ App 1: select '/dev/video10'
➡ App 2: select '/dev/video11'
Heartbeat: OK — signal is live
```

If the signal drops:

```plaintext
Heartbeat: NO SIGNAL
```

---

## License

MIT License – feel free to use and modify.

```

If you want, I can also add **a quick diagram** in Markdown showing the webcam → v4l2loopback → apps flow, which would make your README more attractive.
```
