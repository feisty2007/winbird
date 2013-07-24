; -- Example1.iss --
; Demonstrates copying 3 files and creating an icon.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
AppName=Winbird
AppVerName=Winbird 0.2
DefaultDirName={pf}\Winbird
DefaultGroupName=WinBird
UninstallDisplayIcon={app}\Modify.exe
Compression=lzma
SolidCompression=yes
OutputDir=.

[Files]
Source: "ModifyWin.exe"; DestDir: "{app}"
Source: "mp3info.exe"; DestDir: "{app}"
Source: "ProcessWalk.exe"; DestDir: "{app}"
Source: "wbCleaner.exe"; DestDir: "{app}"


[Icons]
Name: "{group}\Winbird"; Filename: "{app}\ModifyWin.exe"
Name: "{group}\MP3 Rename"; Filename: "{app}\mp3info.exe"
Name: "{group}\Process Walk"; Filename: "{app}\ProcessWalk.exe"
Name: "{group}\SysCleaner"; Filename: "{app}\wbCleaner.exe"
