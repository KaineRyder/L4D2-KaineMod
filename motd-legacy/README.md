# L4D2 legacy MOTD files

This folder contains minimal HTTP-hosted MOTD and server banner pages for the old Left 4 Dead 2 HTML renderer. The HTML uses only basic markup and same-folder PNG images.

## Deploy

Copy `motd.html`, `motd.png`, `host.html`, and `host.png` into the HTTP document root at `fastdl/motd-legacy/` on the FastDL host configured in `cfg/fastdl.cfg`. The files must be publicly readable over plain HTTP. Check that these URLs return the pages directly with status `200` and do not redirect to HTTPS:

`http://124.221.228.21/fastdl/motd-legacy/motd.html`

`http://124.221.228.21/fastdl/motd-legacy/host.html`

Then copy this folder's `mymotd.txt` and `myhost.txt` into the server's `left4dead2/` directory and restart the game server. `cfg/server.cfg` already selects both files. Put the supplied logo image in this folder as `host.png` before uploading.

If the game keeps showing an old cached page after you update it, rename `motd.html` (for example, `motd2.html`) and change the URL in `mymotd.txt` to match.

## Compatibility notes

- Keep the page and image on the same HTTP host and in the same directory.
- Do not use HTTPS redirects, JavaScript, external CSS, web fonts, or modern layout features.
- `motd.png` is re-encoded as a 24-bit RGB PNG and scaled to 960×480 for the legacy renderer.
