# Installing cockpit and microscope on Windows

1. Download and install [WinPython](https://sourceforge.net/projects/winpython/files/WinPython_3.7/3.7.4.0/Winpython64-3.7.4.0.exe/download).

2. Download and install [git](https://github.com/git-for-windows/git/releases/download/v2.22.0.windows.1/Git-2.22.0-64-bit.exe).

3. Use git to clone this repository: open a command prompt and run:
```
git clone git@github.com:mickp/cockpit-windows-installation.git
```

4. Run ```setup.bat``` with elevated privileges (right click and choose 'Run as administrator').

Cockpit and microscope should now be installed under C:\Program Files\MicronOxford, and your python installation should have all necessary dependencies. 

Setup.py also creates a ```scripts``` folder, containing .bat files to start microscopy and cockpit, and configuration files that define some dummy devices. 

To run cockpit:
1. run ```_microscope.bat``` and wait a few seconds until all devices are served.
2. run ```_cockpit.bat``` to start cockpit.