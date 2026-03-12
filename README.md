# aic8800-drivers-for-r36s-darkos
"vibe-compiled" drivers for aic8800 based wifi cards on the R36s console using dArkOS.

(i call it vibe compiled because i had the tiniest clue of what i was doing, i was heavily relying on chatGPT)

built from: https://github.com/shenmintao/aic8800d80

# Installation

```bash
git clone https://github.com/sometgirldotonline/aic8800-drivers-for-r36s-darkos aicdriver
cd aicdriver
bash install.sh
```

that's it. 

# Usage
For some fucking reason UDEV wouldn't work, so you have to press Start > Options > Tools > 0FixAICWifi every time you connect it. Sorry.

(if you can get UDEV working, make an issue post, please)

Also you might need to use a terminal to install `usb_modeswitch` but I think that was installed already.
