# L4D2 MOTD and host banner

## Files

- `mymotd.txt` contains the MOTD HTML inline; it does not fetch a separate page or image.
- `motd-commands.html` is a separately hosted draft of the same text page, not used by the current `mymotd.txt`.
- `myhost.txt` points to `host5.html`.
- `host5.html` displays `host-new.png` at 471×180 pixels, preserving its 654×250 aspect ratio.

## Server deployment paths

The game files belong in `left4dead2/`:

- `mymotd.txt`
- `myhost.txt`

The FastDL banner files belong in `/var/www/l4d2-fastdl/motd-legacy/`:

- `host5.html`
- `host-new.png`
- `motd2.png` (older image MOTD)

`cfg/server.cfg` selects `mymotd.txt` and `myhost.txt`.
