# Navicat 17 macOS Unlimited Trial Reset Script

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

## Disclaimer

**This script is for free use and personal study only. Usage must strictly adhere to the open-source license agreement. Commercial use and any profit-making activities are strictly prohibited. The author assumes no responsibility for any consequences resulting from illegal use!**

## Unlimited 14-Day Trial: Reset official software anytime to 14 days
![alt text](image.png)

## Notice

- **This script is for macOS only, not for Windows.**
- **If you encounter any bugs, please report an issue.**

## Usage Instructions

- **Download**: Download the latest version from the [Navicat Premium](https://www.navicat.com.cn/download/navicat-premium) official website.

### macOS
1. Open Terminal and navigate to this folder.
2. Run the installer script:
   ```bash
   ./install.sh
   ```
   *This will set up a background task to automatically reset the trial every night at 12:00 AM. You never need to run it manually again.*

### Windows
1. Open the folder in File Explorer.
2. Right-click on **`install.bat`** and select **"Run as Administrator"**.
   *This will create a Scheduled Task to automatically reset the registry keys every night at 12:00 AM.*

## How It Works

- Deletes the data corresponding to keys `91F6C435D172C8163E0689D3DAD3F3E9` and `B966DBD409B87EF577C9BBF3363E9614` in the `~/Library/Preferences/com.navicat.NavicatPremium.plist` file.
  As shown (press Space to preview):
  ![](image/img1.png)
- Deletes hidden files starting with `.` in the `~/Library/Application\ Support/PremiumSoft\ CyberTech/Navicat\ CC/Navicat\ Premium/` directory.
  As shown:
  ![](image/img.png)

## Troubleshooting

Some users reported that the script did not work. Please follow these steps to check:

- Ensure you are using the correct version.
- **Quit Navicat** before running the script.
- **Restart your Mac** and try running the script again.
- Verify if the data has been successfully deleted as described in the "How It Works" section.

## Acknowledgements / Other Scripts
- You can try the `reset_navicat_52pojie.sh` script, provided by [52pojie](https://www.52pojie.cn/forum.php?mod=viewthread&tid=1669993). The principle is the same. Thanks to [@Dr-Octopus-dev](https://github.com/yhan219/navicat_reset_mac/issues/16). **Contact for removal if infringed.**
- You can try `reset_navicat_new.sh`, thanks to [pretend-m](https://github.com/pretend-m/navicat_for_mac_reset).

## License

![](image/LGPL.svg)
