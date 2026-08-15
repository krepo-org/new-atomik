import os, re

config_dir = os.path.expanduser("~/.config")
appletsrc = os.path.join(config_dir, "plasma-org.kde.plasma.desktop-appletsrc")
plasmashellrc = os.path.join(config_dir, "plasmashellrc")


def read_section(path, name):
    if not os.path.exists(path):
        return []
    out = []
    current = None
    with open(path) as f:
        for line in f:
            line = line.rstrip("\n")
            if line.startswith("[") and line.endswith("]"):
                current = line
            elif current == name and line.strip():
                out.append(line)
    return out


def read_updates(path):
    if not os.path.exists(path):
        return ""
    with open(path) as f:
        content = f.read()
    m = re.search(r"(\[Updates\].*)", content, re.DOTALL)
    return m.group(1).rstrip("\n") if m else ""


# Bottom panel: kicker + icontasks(pinned) + spacer + systemtray
panel = """\
[Containments][2]
activityId=
formfactor=2
immutability=2
lastScreen=0
location=4
plugin=org.kde.panel

[Containments][2][Applets][3]
immutability=2
plugin=org.kde.plasma.kicker

[Containments][2][Applets][3][Configuration]
popupWidth=600

[Containments][2][Applets][5]
immutability=2
plugin=org.kde.plasma.icontasks

[Containments][2][Applets][5][Configuration][General]
iconSize=32
launchers=preferred://browser,applications:org.kde.dolphin.desktop,applications:org.kde.konsole.desktop,applications:systemsettings.desktop
groupingStrategy=1
showOnlyPinned=false

[Containments][2][Applets][6]
immutability=2
plugin=org.kde.plasma.panelspacer

[Containments][2][Applets][6][Configuration][General]
expanding=true

[Containments][2][Applets][9]
immutability=2
plugin=org.kde.plasma.systemtray

[Containments][2][Applets][9][Applets][10]
immutability=2
plugin=org.kde.plasma.vault

[Containments][2][Applets][9][Applets][11]
immutability=2
plugin=org.kde.kscreen

[Containments][2][Applets][9][Applets][12]
immutability=2
plugin=org.kde.plasma.cameraindicator

[Containments][2][Applets][9][Applets][13]
immutability=2
plugin=org.kde.plasma.clipboard

[Containments][2][Applets][9][Applets][14]
immutability=2
plugin=org.kde.plasma.devicenotifier

[Containments][2][Applets][9][Applets][15]
immutability=2
plugin=org.kde.plasma.keyboardindicator

[Containments][2][Applets][9][Applets][16]
immutability=2
plugin=org.kde.plasma.keyboardlayout

[Containments][2][Applets][9][Applets][17]
immutability=2
plugin=org.kde.plasma.manage-inputmethod

[Containments][2][Applets][9][Applets][18]
immutability=2
plugin=org.kde.plasma.networkmanagement

[Containments][2][Applets][9][Applets][19]
immutability=2
plugin=org.kde.plasma.notifications

[Containments][2][Applets][9][Applets][20]
immutability=2
plugin=org.kde.plasma.printmanager

[Containments][2][Applets][9][Applets][21]
immutability=2
plugin=org.kde.plasma.volume

[Containments][2][Applets][9][Applets][21][Configuration][General]
migrated=true

[Containments][2][Applets][9][Applets][22]
immutability=2
plugin=org.kde.plasma.weather

[Containments][2][Applets][9][Applets][23]
immutability=2
plugin=org.kde.plasma.brightness

[Containments][2][Applets][9][Applets][24]
immutability=2
plugin=org.kde.plasma.battery

[Containments][2][Applets][9][Applets][25]
immutability=2
plugin=org.kde.plasma.bluetooth

[Containments][2][Applets][9][General]
AppletOrder=10;11;12;13;14;15;16;17;18;25;19;20;21;22;23;24
extraItems=org.kde.plasma.vault,org.kde.kscreen,org.kde.plasma.battery,org.kde.plasma.bluetooth,org.kde.plasma.brightness,org.kde.plasma.cameraindicator,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.keyboardindicator,org.kde.plasma.keyboardlayout,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.networkmanagement,org.kde.plasma.notifications,org.kde.plasma.printmanager,org.kde.plasma.volume,org.kde.plasma.weather
knownItems=org.kde.plasma.vault,org.kde.kscreen,org.kde.plasma.battery,org.kde.plasma.bluetooth,org.kde.plasma.brightness,org.kde.plasma.cameraindicator,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.keyboardindicator,org.kde.plasma.keyboardlayout,org.kde.plasma.manage-inputmethod,org.kde.plasma.mediacontroller,org.kde.plasma.networkmanagement,org.kde.plasma.notifications,org.kde.plasma.printmanager,org.kde.plasma.volume,org.kde.plasma.weather

[Containments][2][General]
AppletOrder=3;5;6;9

"""

screendump = read_section(appletsrc, "[ScreenMapping]")

with open(appletsrc, "w") as f:
    f.write(panel)
    f.write("\n")
    f.write("[ScreenMapping]\n")
    f.write("\n".join(screendump) + "\n" if screendump else "")

# Bottom panel: auto-hide (1), fit content (1), centered (4), floating (1)
view = """\
[PlasmaViews][Panel 2]
alignment=4
floating=1
opacity=0.85
panelLengthMode=1
panelVisibility=1
shell=org.kde.plasma.desktop

[PlasmaViews][Panel 2][Defaults]
thickness=44

"""

updates = read_updates(plasmashellrc)
if updates:
    view += "\n" + updates + "\n"

with open(plasmashellrc, "w") as f:
    f.write(view)
