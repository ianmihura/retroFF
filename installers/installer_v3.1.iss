#define MyAppName "RetroFF Ultimate"
#define AppVersion "3.1"
#define AppPublisher "Superusers Mediapro"
#define AppExeName "retroFF.exe"
#define AppSourceName "retroFF.ps1"
#define SettingsExeName "settings.exe"
#define SettingsSourceName "settings.json"
#define AppIcoName "retroff_r.ico"

[Setup]
AppId={{D2BACE24-8C65-4FFD-8851-C8FAB20FC25D}
AppName={#MyAppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName=C:\Program Files\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=RetroFF_Installer
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Types]
Name: "compact"; Description: "Default installation (I already have ffmpeg)"
Name: "full"; Description: "Full installation (I don't have ffmpeg)"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "program"; Description: "RetroFF Ultimate"; Types: full compact custom; Flags: fixed
Name: "ffmpeg"; Description: "ffmpeg files"; Types: full
Name: "ffmpeg\ffmpeg"; Description: "ffmpeg.exe"; Types: full
Name: "ffmpeg\ffplay"; Description: "ffplay.exe"; Types: full
Name: "ffmpeg\ffprobe"; Description: "ffprobe.exe"; Types: full

[Files]
Source: "..\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion; Components: program
Source: "..\{#AppSourceName}"; DestDir: "{app}"; Flags: ignoreversion; Components: program
Source: "..\settings\{#SettingsExeName}"; DestDir: "{app}"; Flags: ignoreversion; Components: program
Source: "..\settings\{#SettingsSourceName}"; DestDir: "{app}"; Flags: ignoreversion; Components: program
Source: "..\ico\{#AppIcoName}"; DestDir: "{app}"; Flags: ignoreversion; Components: program
Source: "..\ffmpeg\ffmpeg.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: ffmpeg\ffmpeg
Source: "..\ffmpeg\ffplay.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: ffmpeg\ffplay
Source: "..\ffmpeg\ffprobe.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: ffmpeg\ffprobe

[Icons]
Name: "..\ico\{#AppIcoName}"; Filename: "{app}\{#AppExeName}"

[Registry]
Root: HKCR; Subkey: "*\shell\RetroFF"; Flags: uninsdeletekey deletekey;
Root: HKCR; Subkey: "*\shell\RetroFF"; ValueType: string; ValueName: "MUIVerb"; ValueData: Transcode with {#MyAppName}
Root: HKCR; Subkey: "*\shell\RetroFF"; ValueType: string; ValueName: "subcommands";
Root: HKCR; Subkey: "*\shell\RetroFF"; ValueType: string; ValueName: "icon"; ValueData: "{app}\{#AppIcoName}"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\1h264"; ValueType: string; ValueData: "To h.264"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\1h264\command"; ValueType: string; ValueData: "powershell.exe retroFF -file """"""%1"""""" -preset h264"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\2low"; ValueType: string; ValueData: "To h.264 Low"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\2low\command"; ValueType: string; ValueData: "powershell.exe retroFF -file """"""%1"""""" -preset h264_low"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\3dnxhd"; ValueType: string; ValueData: "To DNxHD"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\3dnxhd\command"; ValueType: string; ValueData: "powershell.exe retroFF -file """"""%1"""""" -preset dnxhd"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\4xdcam"; ValueType: string; ValueData: "To XDCAM"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\4xdcam\command"; ValueType: string; ValueData: "powershell.exe retroFF -file """"""%1"""""" -preset xdcam"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\5custom"; ValueType: string; ValueData: "To Custom Preset"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\5custom\command"; ValueType: string; ValueData: "powershell.exe retroFF -file """"""%1"""""" -preset custom"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\9logs"; ValueType: dword; ValueName: CommandFlags; ValueData: 00000032
Root: HKCR; Subkey: "*\shell\RetroFF\shell\9logs"; ValueType: string; ValueData: "To h.264 - with Logs"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\9logs\command"; ValueType: string; ValueData: "powershell.exe retroFF -file """"""%1"""""" -preset h264 -log"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\runas"; ValueType: dword; ValueName: CommandFlags; ValueData: 00000050
Root: HKCR; Subkey: "*\shell\RetroFF\shell\runas"; ValueType: string; ValueData: "Advanced settings"
Root: HKCR; Subkey: "*\shell\RetroFF\shell\runas\command"; ValueType: string; ValueData: "powershell.exe retroFF -config"

Root: HKCR; Subkey: "Directory\Background\shell\RetroFF"; Flags: uninsdeletekey deletekey;
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF"; ValueType: string; ValueName: "MUIVerb"; ValueData: Transcode with {#MyAppName}
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF"; ValueType: string; ValueName: "subcommands";
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF"; ValueType: string; ValueName: "icon"; ValueData: "{app}\{#AppIcoName}"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\1h264"; ValueType: string; ValueData: "To h.264"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\1h264\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder . -preset h264"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\2low"; ValueType: string; ValueData: "To h.264 Low"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\2low\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder . -preset h264_low"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\3dnxhd"; ValueType: string; ValueData: "To DNxHD"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\3dnxhd\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder . -preset dnxhd"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\4xdcam"; ValueType: string; ValueData: "To XDCAM"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\4xdcam\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder . -preset xdcam"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\5custom"; ValueType: string; ValueData: "To Custom Preset"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\5custom\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder . -preset custom"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\9logs"; ValueType: dword; ValueName: CommandFlags; ValueData: 00000032
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\9logs"; ValueType: string; ValueData: "To h.264 - with Logs"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\9logs\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder . -preset h264 -log"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\runas"; ValueType: dword; ValueName: CommandFlags; ValueData: 00000050
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\runas"; ValueType: string; ValueData: "Advanced settings"
Root: HKCR; Subkey: "Directory\Background\shell\RetroFF\shell\runas\command"; ValueType: string; ValueData: "powershell.exe retroFF -config"

Root: HKCR; Subkey: "Directory\shell\RetroFF"; Flags: uninsdeletekey deletekey;
Root: HKCR; Subkey: "Directory\shell\RetroFF"; ValueType: string; ValueName: "MUIVerb"; ValueData: Transcode with {#MyAppName}
Root: HKCR; Subkey: "Directory\shell\RetroFF"; ValueType: string; ValueName: "subcommands";
Root: HKCR; Subkey: "Directory\shell\RetroFF"; ValueType: string; ValueName: "icon"; ValueData: "{app}\{#AppIcoName}"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\1h264"; ValueType: string; ValueData: "To h.264"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\1h264\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder """"""%1"""""" -preset h264"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\2low"; ValueType: string; ValueData: "To h.264 Low"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\2low\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder """"""%1"""""" -preset h264_low"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\3dnxhd"; ValueType: string; ValueData: "To DNxHD"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\3dnxhd\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder """"""%1"""""" -preset dnxhd"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\4xdcam"; ValueType: string; ValueData: "To XDCAM"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\4xdcam\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder """"""%1"""""" -preset xdcam"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\5custom"; ValueType: string; ValueData: "To Custom Preset"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\5custom\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder """"""%1"""""" -preset custom"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\9logs"; ValueType: dword; ValueName: CommandFlags; ValueData: 00000032
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\9logs"; ValueType: string; ValueData: "To h.264 - with Logs"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\9logs\command"; ValueType: string; ValueData: "powershell.exe retroFF -folder """"""%1"""""" -preset h264 -log"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\runas"; ValueType: dword; ValueName: CommandFlags; ValueData: 00000050
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\runas"; ValueType: string; ValueData: "Advanced settings"
Root: HKCR; Subkey: "Directory\shell\RetroFF\shell\runas\command"; ValueType: string; ValueData: "powershell.exe retroFF -config"

Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};C:\Program Files\{#MyAppName}"; Check: NeedsAddPath('C:\Program Files\{#MyAppName}')

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  { look for the path with leading and trailing semicolon }
  { Pos() returns 0 if not found }
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;
