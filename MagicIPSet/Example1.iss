; -- Example1.iss --
; Demonstrates copying 3 files and creating an icon.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
AppName=MagicIPSet
AppVerName=MagicIPSet version 1.01
DefaultDirName={pf}\MagicIPSet
DefaultGroupName=MagicIPSet
UninstallDisplayIcon={app}\MagicIP.exe
Compression=lzma
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output

[Files]
Source: "MyIPSet.exe"; DestDir: "{app}"
Source: "NetworkProfile.ini"; DestDir: "{app}"

[Icons]
Name: "{group}\Magic IP Set"; Filename: "{app}\MagicIPSet.exe"
