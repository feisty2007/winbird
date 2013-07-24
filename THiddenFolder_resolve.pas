unit THiddenFolder;

interface

uses
  SysUtils, Windows, Classes;
const
  MAX_HIDDEN = 42;
type
  HiddenFolder = record
    Description: string;
    CLSID: string;
  end;

  TFolderHidden = class
  public
    constructor Create;
    procedure Hidden(dirName: string; i: Integer);
    procedure Unhidden(dirName: string);
    function GetHiddenNames: TStringList;
  private
    HiddenRecord: array[0..MAX_HIDDEN] of HiddenFolder;
  end;

implementation

{ TFolderHidden }

constructor TFolderHidden.Create;
var
  i: Integer;
begin
  HiddenRecord[0].Description := 'excel';
  HiddenRecord[0].clsid := '{00020810-0000-0000-C000-000000000046}';

  HiddenRecord[1].Description := 'word';
  HiddenRecord[1].clsid := '{00020900-0000-0000-C000-000000000046}';

  HiddenRecord[2].Description := 'media';
  HiddenRecord[2].clsid := '{00022603-0000-0000-C000-000000000046}';

  HiddenRecord[3].Description := 'CAB';
  HiddenRecord[3].clsid := '{0CD7A5C0-9F37-11CE-AE65-08002B2E1262}';

  HiddenRecord[4].Description := '计划任务';
  HiddenRecord[4].clsid := '{148BD520-A2AB-11CE-B11F-00AA00530503}';

  HiddenRecord[5].Description := '搜索-计算机';
  HiddenRecord[5].clsid := '{1f4de370-d627-11d1-ba4f-00a0c91eedba}';

  HiddenRecord[6].Description := '网上邻居';
  HiddenRecord[6].clsid := '{208D2C60-3AEA-1069-A2D7-08002B30309D}';

  HiddenRecord[7].Description := '我的电脑';
  HiddenRecord[7].clsid := '{20D04FE0-3AEA-1069-A2D8-08002B30309D}';

  HiddenRecord[8].Description := '控制面板';
  HiddenRecord[8].clsid := '{21EC2020-3AEA-1069-A2DD-08002B30309D}';

  HiddenRecord[9].Description := '打印机';
  HiddenRecord[9].clsid := '{2227A280-3AEA-1069-A2DE-08002B30309D}';

  HiddenRecord[10].Description := 'html';
  HiddenRecord[10].clsid := '{25336920-03f9-11cf-8fd0-00aa00686f13}';

  HiddenRecord[11].Description := 'mht';
  HiddenRecord[11].clsid := '{3050F3D9-98B5-11CF-BB82-00AA00BDCE0B}';

  HiddenRecord[12].Description := 'mshta';
  HiddenRecord[12].clsid := '{3050f4d8-98B5-11CF-BB82-00AA00BDCE0B}';

  HiddenRecord[13].Description := '我的文档';
  HiddenRecord[13].clsid := '{450D8FBA-AD25-11D0-98A8-0800361B1103}';

  HiddenRecord[14].Description := 'XML';
  HiddenRecord[14].clsid := '{48123bc4-99d9-11d1-a6b3-00c04fd91555}';

  HiddenRecord[15].Description := '回收站(满)';
  HiddenRecord[15].clsid := '{5ef4af3a-f726-11d0-b8a2-00c04fc309a4}';

  HiddenRecord[16].Description := '回收站';
  HiddenRecord[16].clsid := '{645FF040-5081-101B-9F08-00AA002F954E}';

  HiddenRecord[17].Description := 'ftp_folder';
  HiddenRecord[17].clsid := '{63da6ec0-2e98-11cf-8d82-444553540000}';

  HiddenRecord[18].Description := '网络和拨号连接';
  HiddenRecord[18].clsid := '{7007ACC7-3202-11D1-AAD2-00805FC1270E}';

  HiddenRecord[19].Description := '写字板文档';
  HiddenRecord[19].clsid := '{73FDDC80-AEA9-101A-98A7-00AA00374959}';

  HiddenRecord[20].Description := 'Temporary Offline Files Cleaner';
  HiddenRecord[20].clsid := '{750fdf0f-2a26-11d1-a3ea-080036587f03}';

  HiddenRecord[21].Description := '用户和密码';
  HiddenRecord[21].clsid := '{7A9D77BD-5403-11d2-8785-2E0420524153}';

  HiddenRecord[22].Description := 'Internet 临时文件';
  HiddenRecord[22].clsid := '{7BD29E00-76C1-11CF-9DD0-00A0C9034933}';

  HiddenRecord[23].Description := '已下载的程序文件的清除程序';
  HiddenRecord[23].clsid := '{8369AB20-56C9-11D0-94E8-00AA0059CE02}';

  HiddenRecord[24].Description := '公文包';
  HiddenRecord[24].clsid := '{85BBD920-42A0-1069-A2E4-08002B30309D}';

  HiddenRecord[25].Description := 'ActiveX 高速缓存文件夹';
  HiddenRecord[25].clsid := '{88C6C381-2E85-11D0-94DE-444553540000}';

  HiddenRecord[26].Description := 'mail';
  HiddenRecord[26].clsid := '{9E56BE60-C50F-11CF-9A2C-00A0C90A90CE}';

  HiddenRecord[27].Description := '历史记录';
  HiddenRecord[27].clsid := '{FF393560-C2A7-11CF-BFF4-444553540000}';

  HiddenRecord[28].Description := '目录';
  HiddenRecord[28].clsid := '{fe1290f0-cfbd-11cf-a330-00aa00c16e65}';

  HiddenRecord[29].Description := 'Internet Explorer';
  HiddenRecord[29].clsid := '{FBF23B42-E3F0-101B-8488-00AA003E56F8}';

  HiddenRecord[30].Description := 'Snapshot File';
  HiddenRecord[30].clsid := '{FACB5ED2-7F99-11D0-ADE2-00A0C90DC8D9}';

  HiddenRecord[31].Description := '预订文件夹';
  HiddenRecord[31].clsid := '{F5175861-2688-11d0-9C5E-00AA00A45957}';

  HiddenRecord[32].Description := 'MyDocs Drop Target';
  HiddenRecord[32].clsid := '{ECF03A32-103D-11d2-854D-006008059367}';

  HiddenRecord[33].Description := 'Policy Package';
  HiddenRecord[33].clsid := '{ecabaebd-7f19-11d2-978E-0000f8757e2a}';

  HiddenRecord[34].Description := '搜索结果';
  HiddenRecord[34].clsid := '{e17d4fc0-5564-11d1-83f2-00a0c90dc849}';

  HiddenRecord[35].Description := '添加网上邻居';
  HiddenRecord[35].clsid := '{D4480A50-BA28-11d1-8E75-00C04FA31A86}';

  HiddenRecord[36].Description := 'Paint';
  HiddenRecord[36].clsid := '{D3E34B21-9D75-101A-8C3D-00AA001A1652}';

  HiddenRecord[37].Description := '管理工具';
  HiddenRecord[37].clsid := '{D20EA4E1-3957-11d2-A40B-0C5020524153}';

  HiddenRecord[38].Description := '字体';
  HiddenRecord[38].clsid := '{D20EA4E1-3957-11d2-A40B-0C5020524152}';

  HiddenRecord[39].Description := 'Web Folders';
  HiddenRecord[39].clsid := '{BDEADF00-C265-11d0-BCED-00A0C90AB50F}';

  HiddenRecord[40].Description := 'DocFind Command';
  HiddenRecord[40].clsid := '{B005E690-678D-11d1-B758-00A0C90564FE}';

  HiddenRecord[41].Description := '脱机文件夹';
  HiddenRecord[41].clsid := '{AFDB1F70-2A4C-11d2-9039-00C04F8EEB3E}';

  HiddenRecord[42].Description := '打印机';
  HiddenRecord[42].clsid := '{2227A280-3AEA-1069-A2DE-08002B30309D';

//      SetLength(FHiddenItems,MAX_HIDDEN);
//
//      for i :=0  to MAX_HIDDEN do
//      begin
//          FHiddenItems[i]:=HiddenRecord[i].Description;
//      end;
end;

function TFolderHidden.GetHiddenNames: TStringList;
var
  i: integer;
begin
  result := TStringList.Create;

  for i := 0 to MAX_HIDDEN do
  begin
    Result.Add(HiddenRecord[i].Description);
  end;
end;

procedure TFolderHidden.Hidden(dirname: string; i: Integer);
var
  cls: string;
begin
  cls := HiddenRecord[i].CLSID;

  RenameFile(dirName, dirname + '.' + cls);
end;

procedure TFolderHidden.Unhidden(dirname: string);
var
  i: integer;
  strs: TStringList;

  function GetShortName(str: TStringList): string;
  var
    j: integer;
    count: integer;
  begin
    count := str.Count - 1;

    result := str[0];
    for j := 1 to count - 1 do
    begin
      result := result + '.' + str[j];
    end;
  end;

  function isInHiddenList(clsid: string): Boolean;
  var
    k: integer;
  begin
    result := False;
    for k := 0 to MAX_HIDDEN do
    begin
      if HiddenRecord[k].CLSID = clsid then
      begin
        result := true;
        Break;
      end;
    end;
  end;
begin
  strs := TStringList.Create;

  i := ExtractStrings(['.'], [], PChar(dirName), strs);

  if isInHiddenList(strs[i - 1]) then
    RenameFile(dirName, GetShortName(strs));
end;

end.
