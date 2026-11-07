# dashcam-viewer

A tiny, dependency-free web viewer for dashcam clips that are filed as `YYYY-MM-DD/Normal|Parking|Event/NAME.MP4`
(the layout written by [70mai-dashcam-sync](https://github.com/davewins/70mai-dashcam-sync)). No database, no
application server: just nginx plus a shell loop running ffmpeg.

- Date picker, flagged with **⚠ event** and **● parking** counts so you can see which days need a look.
- Thumbnail grid per day, filter by Normal / Parking / Event, click to play, switch front and rear, download.
- Thumbnails are made once per clip by ffmpeg and cached (320 px JPEG, one frame 3 s in).
- Clips are mounted read-only; the viewer never changes them. There is **no authentication**: keep it on your LAN
  or put it behind a reverse proxy that has one.
- Front and rear files are paired by the 6-digit clip counter in the file name.

```bash
git clone https://github.com/davewins/dashcam-viewer && cd dashcam-viewer
export CLIPS_DIR=/path/to/Dashcam DATA_DIR=/path/to/cache    # DATA_DIR/thumbs is created by ffmpeg's user
mkdir -p "$DATA_DIR/thumbs" && docker compose up -d           # then open http://localhost:8230/
```

`PORT`, `BIND` (for example `192.168.1.10` to listen on one interface only), `PUID`/`PGID` (must be able to read the
clips and write `DATA_DIR/thumbs`) are optional. A day can be linked directly: `http://host:8230/#2026-10-01`.

## Playback

70mai clips are H.265 (HEVC). Safari, Edge and the Home Assistant companion apps play them; Chrome depends on your
hardware. If the video stays black, use Download and play it in VLC. Transcoding is deliberately not included.

## Home Assistant

`homeassistant/dashcam_event_alert.yaml` sends a notification when an Event or Parking clip arrives (using the MQTT
messages from 70mai-dashcam-sync), linking to that day in the viewer. A Lovelace `iframe` card pointing at the viewer
also works.

## Licence

MIT.
