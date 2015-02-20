{ version :1.3
  function:update files from google code or github

  using idhttp download update file

  author:ring hacker

  Compiled date:  May 2 2014 }
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtActns, ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.Menus, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IniFiles,
  IdHTTP, System.Zip, TLhelp32, shellapi, IdAntiFreezeBase, Vcl.IdAntiFreeze,
  Vcl.Imaging.pngimage, ActiveX, ShlObj, Registry, ComObj, Wininet;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Label3: TLabel;
    IdHTTP2: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    Timer1: TTimer;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdSSLIOHandlerSocketOpenSSL2: TIdSSLIOHandlerSocketOpenSSL;
    Label1: TLabel;
    Timer3: TTimer;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);

    procedure N1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure IdHTTP2WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP2Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTP2WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure Timer2Timer(Sender: TObject);

  type

    TOSVersion = (osUnknown, os95, os98, osME, osNT3, osNT4, os2K, osXP, os2K3);
  private
    { Private declarations }
    // ---------------------------------------

    // ---------------------------------------

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  i: integer;

  filename, StrProcessName: string; // kylin process name
  // ----------------------------------

  // ----------------------------------
  a, b, s: string;
  // -------------------------------解压目录文件目录全局申明  开始
  path, StrObject, StrInfor: string;
  IntLengh: integer;
  // ------------------------解压目录文件目录全局申明 结束

  myinifile, myinifile1: Tinifile; // ini格式文件申明

  wnd: cardinal;
  rec: TRect;
  w, h: integer;
  x, y: integer;
  strDesk: string;
  Strkylinpath: string;
  StrKey: string;
  StrKeyWrite: string;
  StrVerification: string;

implementation

{$R *.dfm}

uses Unit2;

function IsWOW64: BOOL;
begin
  Result := False;
  if GetProcAddress(GetModuleHandle(kernel32), 'IsWow64Process') <> nil then
    IsWow64Process(GetCurrentProcess, Result);
end;

function Rc4(i_Encrypt: integer; s_EncryptText, s_EncryptPassword: string;
  i_EncryptLevel: integer = 1): string;
var
  v_EncryptModified, v_EncryptCipher, v_EncryptCipherBy: string;
  i_EncryptCountA, i_EncryptCountB, i_EncryptCountC, i_EncryptCountD,
    i_EncryptCountE, i_EncryptCountF, i_EncryptCountG, i_EncryptCountH,
    v_EncryptSwap: integer;
  av_EncryptBox: array [0 .. 256, 0 .. 2] of integer;

begin
  if (i_Encrypt <> 0) and (i_Encrypt <> 1) then
  begin
    Result := '';
  end
  else if (s_EncryptText = '') or (s_EncryptPassword = '') then
  begin
    Result := '';
  end
  else
  begin
    if (i_EncryptLevel <= 0) or (Int(i_EncryptLevel) <> i_EncryptLevel) then
      i_EncryptLevel := 1;
    if Int(i_EncryptLevel) > 10 then
      i_EncryptLevel := 10;
    if i_Encrypt = 1 then
    begin
      for i_EncryptCountF := 0 to i_EncryptLevel do
      begin
        i_EncryptCountG := 0;
        i_EncryptCountH := 0;
        v_EncryptModified := '';
        for i_EncryptCountG := 1 to Length(s_EncryptText) do
        begin
          if i_EncryptCountH = Length(s_EncryptPassword) then
          begin
            i_EncryptCountH := 1;
          end
          else
          begin
            inc(i_EncryptCountH);
          end;
          v_EncryptModified := v_EncryptModified +
            Chr(Ord(s_EncryptText[i_EncryptCountG])
            xor Ord(s_EncryptPassword[i_EncryptCountH]) xor 255);
        end;
        s_EncryptText := v_EncryptModified;
        i_EncryptCountA := 0;
        i_EncryptCountB := 0;
        i_EncryptCountC := 0;
        i_EncryptCountD := 0;
        i_EncryptCountE := 0;
        v_EncryptCipherBy := '';
        v_EncryptCipher := '';
        v_EncryptSwap := 0;
        for i_EncryptCountA := 0 to 255 do
        begin
          av_EncryptBox[i_EncryptCountA, 1] :=
            Ord(s_EncryptPassword[i_EncryptCountA mod Length
            (s_EncryptPassword) + 1]);
          av_EncryptBox[i_EncryptCountA, 0] := i_EncryptCountA;
        end;
        for i_EncryptCountA := 0 to 255 do
        begin
          i_EncryptCountB := (i_EncryptCountB + av_EncryptBox[i_EncryptCountA]
            [0] + av_EncryptBox[i_EncryptCountA][1]) mod 256;
          v_EncryptSwap := av_EncryptBox[i_EncryptCountA][0];
          av_EncryptBox[i_EncryptCountA][0] :=
            av_EncryptBox[i_EncryptCountB][0];
          av_EncryptBox[i_EncryptCountB][0] := v_EncryptSwap;
        end;
        for i_EncryptCountA := 1 to Length(s_EncryptText) do
        begin
          i_EncryptCountC := (i_EncryptCountC + 1) mod 256;
          i_EncryptCountD := (i_EncryptCountD + av_EncryptBox[i_EncryptCountC]
            [0]) mod 256;
          i_EncryptCountE := av_EncryptBox
            [(av_EncryptBox[i_EncryptCountC][0] + av_EncryptBox[i_EncryptCountD]
            [0]) mod 256][0];
          v_EncryptCipherBy := inttostr(Ord(s_EncryptText[i_EncryptCountA])
            xor i_EncryptCountE);
          v_EncryptCipher := v_EncryptCipher +
            IntToHex(strtoint(v_EncryptCipherBy), 2);

        end;
        s_EncryptText := v_EncryptCipher;
      end;

    end
    else
    begin
      for i_EncryptCountF := 0 to i_EncryptLevel do
      begin
        i_EncryptCountB := 0;
        i_EncryptCountC := 0;
        i_EncryptCountD := 0;
        i_EncryptCountE := 0;
        v_EncryptCipherBy := '';
        v_EncryptCipher := '';
        v_EncryptSwap := 0;
        for i_EncryptCountA := 0 to 255 do
        begin
          av_EncryptBox[i_EncryptCountA, 1] :=
            Ord(s_EncryptPassword[i_EncryptCountA mod Length
            (s_EncryptPassword) + 1]);
          av_EncryptBox[i_EncryptCountA, 0] := i_EncryptCountA;
        end;
        for i_EncryptCountA := 0 to 255 do
        begin
          i_EncryptCountB := (i_EncryptCountB + av_EncryptBox[i_EncryptCountA,
            0] + av_EncryptBox[i_EncryptCountA, 1]) mod 256;
          v_EncryptSwap := av_EncryptBox[i_EncryptCountA, 0];
          av_EncryptBox[i_EncryptCountA, 0] :=
            av_EncryptBox[i_EncryptCountB, 0];
          av_EncryptBox[i_EncryptCountB, 0] := v_EncryptSwap;
        end;
        for i_EncryptCountA := 1 to Length(s_EncryptText) do
        begin
          if (i_EncryptCountA mod 2) <> 0 then
          begin
            i_EncryptCountC := ((i_EncryptCountC + 1) mod 256);
            i_EncryptCountD :=
              ((i_EncryptCountD + av_EncryptBox[i_EncryptCountC, 0]) mod 256);
            i_EncryptCountE := av_EncryptBox
              [((av_EncryptBox[i_EncryptCountC, 0] + av_EncryptBox
              [i_EncryptCountD, 0]) mod 256), 0];
            v_EncryptCipherBy :=
              inttostr(StrToInt64('$' + s_EncryptText[i_EncryptCountA] +
              s_EncryptText[i_EncryptCountA + 1]) xor i_EncryptCountE);
            v_EncryptCipher := v_EncryptCipher +
              Chr(strtoint(v_EncryptCipherBy));
          end;
        end;
        s_EncryptText := v_EncryptCipher;
        i_EncryptCountG := 0;
        i_EncryptCountH := 0;
        v_EncryptModified := '';
        for i_EncryptCountG := 1 to Length(s_EncryptText) do
        begin
          if i_EncryptCountH = Length(s_EncryptPassword) then
          begin
            i_EncryptCountH := 1;
          end
          else
          begin
            i_EncryptCountH := i_EncryptCountH + 1;
          end;
          v_EncryptModified := v_EncryptModified +
            Chr((Ord(s_EncryptText[i_EncryptCountG])
            xor Ord(s_EncryptPassword[i_EncryptCountH]) xor 255));
        end;
        s_EncryptText := v_EncryptModified;
      end;
    end;
    Result := s_EncryptText;
  end;
end;

/// ==================================================================================

function GetVolumeID: string;
var
  vVolumeNameBuffer: array [0 .. 255] of Char;
  vVolumeSerialNumber: DWORD;
  vMaximumComponentLength: DWORD;
  vFileSystemFlags: DWORD;
  vFileSystemNameBuffer: array [0 .. 255] of Char;
begin
  if GetVolumeInformation('c:\', vVolumeNameBuffer, SizeOf(vVolumeNameBuffer),
    @vVolumeSerialNumber, vMaximumComponentLength, vFileSystemFlags,
    vFileSystemNameBuffer, SizeOf(vFileSystemNameBuffer)) then
  begin
    Result := IntToHex(vVolumeSerialNumber, 8);
  end;
end;

function CreateShortcut(Exe: string; Lnk: string = ''; Dir: string = '';
  ID: integer = -1): Boolean;
var
  IObj: IUnknown;
  ILnk: IShellLink;
  IPFile: IPersistFile;
  PIDL: PItemIDList;
  InFolder: array [0 .. MAX_PATH] of Char;
  LinkFileName: WideString;
begin
  Result := False;
  if not FileExists(Exe) then
    Exit;
  if Lnk = '' then
    Lnk := ChangeFileExt(ExtractFileName(Exe), '');

  IObj := CreateComObject(CLSID_ShellLink);
  ILnk := IObj as IShellLink;
  ILnk.SetPath(PChar(Exe));
  ILnk.SetWorkingDirectory(PChar(ExtractFilePath(Exe)));

  if (Dir = '') and (ID = -1) then
    ID := CSIDL_DESKTOP;
  if ID > -1 then
  begin
    SHGetSpecialFolderLocation(0, ID, PIDL);
    SHGetPathFromIDList(PIDL, InFolder);
    LinkFileName := Format('%s\%s.lnk', [InFolder, Lnk]);
  end
  else
  begin
    Dir := ExcludeTrailingPathDelimiter(Dir);
    if not DirectoryExists(Dir) then
      Exit;
    LinkFileName := Format('%s\%s.lnk', [Dir, Lnk]);
  end;

  IPFile := IObj as IPersistFile;
  if IPFile.Save(PWideChar(LinkFileName), False) = 0 then
    Result := True;
end; { CreateShortcut 函数结束 }

function GetShellFolders(strDir: string): string;
const
  regPath = '\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';
var
  Reg: TRegistry;
  strFolders: string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(regPath, False) then
    begin
      strFolders := Reg.ReadString(strDir);
    end;
  finally
    Reg.Free;
  end;
  Result := strFolders;
end;

{ 获取桌面 }

function GetDeskeptPath: string;
begin
  Result := GetShellFolders('Desktop'); // 是取得桌面文件夹的路径
end;

function BytesToStr(iBytes: integer): String;
var
  iKb: integer;
begin
  iKb := Round(iBytes / 1024);
  if iKb > 1000 then
    Result := Format('%.2f MB', [iKb / 1024])
  else
    Result := Format('%d KB', [iKb]);
end;

function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: Boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then
      Result := integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function PosEx(const Source, Sub: string; Index: integer): integer;
var
  Buf: string;
  i, Len, C: integer;
begin
  C := 0;
  Result := 0;
  Buf := Source;
  i := Pos(Sub, Source);
  Len := Length(Sub);
  while i <> 0 do
  begin
    inc(C);
    inc(Result, i);
    Delete(Buf, 1, i + Len - 1);
    i := Pos(Sub, Buf);
    if C >= Index then
      Break;
    if i > 0 then
      inc(Result, Len - 1);
  end;
  if C < Index then
    Result := 0;
end;

// -------------------截取字符串函数    开始
function split(src, dec: string): TStringList;
var
  i: integer;
  str: string;
begin
  Result := TStringList.Create;
  repeat
    i := Pos(dec, src);
    str := copy(src, 1, i - 1);
    if (str = '') and (i > 0) then
    begin
      Delete(src, 1, Length(dec));
      continue;
    end;
    if i > 0 then
    begin
      Result.Add(str);
      Delete(src, 1, i + Length(dec) - 1);
    end;
  until i <= 0;
  if src <> '' then
    Result.Add(src);
end;
// -------------------截取字符串函数结束
// --------------------------------------------------------------------
// 判断文件独占性

function IsFileInUse(fName: string): Boolean;
var
  HFileRes: HFILE;
begin
  Result := False; // 返回值为假(即文件不被使用)
  if not FileExists(fName) then
    Exit; // 如果文件不存在则退出
  HFileRes := CreateFile(PChar(fName), GENERIC_READ or GENERIC_WRITE,
    0 { this is the trick! } , nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  // 如果CreateFile返回失败那么Result为真(即文件正在被使用)
  if not Result then // 如果CreateFile函数返回是成功
    CloseHandle(HFileRes); // 那么关闭句柄
end;
// --------------------------------------------------------------------

procedure TForm1.Button1Click(Sender: TObject);

var
  h: TIdHTTP;
  res: String;
  MyStream: TMemoryStream;
  DownLoadFileX64: TFileStream;
  DownLoadFileX86: TFileStream;

begin

  Button1.Enabled := False;
  Label1.visible := True;
  ProgressBar1.visible := True;
  strDesk := GetDeskeptPath;

  if IsWOW64 then
  begin
    KillTask('巴豆X64.exe');
    sleep(2000);
    DownLoadFileX64 := TFileStream.Create(strDesk + '\巴豆X64.exe', fmCreate);
    StatusBar1.Panels[2].text := 'X64系统';
    try
      Label1.Caption := '正在为你下载';
      IdHTTP2.Get
        ('https://raw.githubusercontent.com/chinatwilight/badoufrmmain/master/BadouX64.exe',
        DownLoadFileX64);
    except
      showmessage('请检查你的网络,然后重试');

    end;
    DownLoadFileX64.Free;

  end

  else
  begin
    KillTask('巴豆X86.exe');
    sleep(2000);
    StatusBar1.Panels[2].text := 'X86系统';
    DownLoadFileX86 := TFileStream.Create(strDesk + '\巴豆X86.exe', fmCreate);
    try
      Label1.Caption := '正在为你下载';
      IdHTTP2.Get
        ('https://raw.githubusercontent.com/chinatwilight/badoufrmmain/master/BadouX86.exe',
        DownLoadFileX86);
    except
      showmessage('请检查你的网络,然后重试');

    end;
    DownLoadFileX86.Free;

  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ExitProcess(0);
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  StrIni, filename: string;
  StrLocal, StrServer, hack, hack1, StrLocal1: string;

  // -----------------------版本判断，字符串截取
  ss: TStringList;

  str, dec: string;
  // -----------------------版本判断，字符串截取
  test: String;
  i, g: integer;
  // --------------------------------判断本地和服务器版本数值大小
  StrSplitLocal, StrSplitServer, hacker: string;
  t, y, g1: integer;
  // --------------------------------decide the server with local version Number Variable
  ServerNum, LocalNum: integer;
  // ================================================declare the download function Variable Code begin

  res: String;
  MyStream, tStream: TMemoryStream;
  // =========================================== Declare the download function Variable Code end
begin
  // Edit3.text := GetVolumeID;

  ProgressBar1.visible := False;
  Label1.visible := False;
  // StrKey := Edit3.text;
  Strkylinpath := GetEnvironmentVariable('APPDATA') + '\kylinagent\'; // 以前一直用这个
  // showmessage(Strkylinpath);

  // showmessage(Strkylinpath);
  // showmessage(strDesk);
  Application.ShowMainForm := False;
  // begin on reading the version information
  StrKeyWrite := Rc4(1, StrKey, 'sheismysin', 4); // rc4加密序列号

  path := ExtractFilePath(Application.ExeName);
  g := 0;
  // Edit2.text := '';

  myinifile := Tinifile.Create(path + '\LocalVerson.ini');
  StrIni := myinifile.ReadString('version', 'info', '');
  // read version of client
  // Edit2.text := StrIni;
  StrLocal := StrIni;
  { myinifile:=Tinifile.Create(path+'\LocalVerson.ini');
    myinifile.writestring('localmachine','key',StrKeyWrite);//read version of client
    myinifile.Destroy; }

  // =========================================== download the version information form github server code begin
  MyStream := TMemoryStream.Create;
  try
    IdHTTP1.Get
      ('https://raw.githubusercontent.com/chinatwilight/badoufrmmain/master/ServerVerson.ini',
      MyStream);
  except
    Label1.Caption := '从服务器获取版本信息失败,请检查你的网络!';
    halt;
    MyStream.Free;
    Exit;
  end;
  MyStream.SaveToFile(path + '\ServerVerson.ini');
  MyStream.Free;

  // ===========================================  download the version information form github server code ending

  myinifile := Tinifile.Create(path + '\ServerVerson.ini');
  StrInfor := myinifile.ReadString('version', 'info', '');
  myinifile.Destroy;

  // Edit1.text := StrInfor;
  StrServer := StrInfor;
  hack := StrServer + '|' + StrLocal + '|';

  // 读取版本信息 结束
  // ----------------------------------判断版本是否需要升级
  // -----------------------------------------------------------------获取本地版本数值    begin
  // memo1.Text:='';
  for i := 0 to 6 do
  begin // 遍历文本，把每行数据存入数组
    dec := '.';
    ss := split(hack, dec);
    test := ss[g];

    ss.Free;
    g := g + 1;
    StrLocal1 := StrLocal1 + test;
    // memo3.Text:= StrLocal1;
    hacker := StrLocal1;
  end;
  // -------------------------------------------------------------获取本地版本数值  结束

  g := PosEx(hacker, '|', 1); // 返回5

  g1 := PosEx(hacker, '|', 2); // 返回5

  // memo1.Text:=Copy(hacker,g+1,g1-g-1);
  LocalNum := strtoint(copy(hacker, g + 1, g1 - g - 1));
  // memo2.Text:=Copy(hacker,1,g-1);
  ServerNum := strtoint(copy(hacker, 1, g - 1));

  // -----------------------获取升级文件目标路径

  IntLengh := Length(path) - 8;
  StrObject := copy(path, 1, IntLengh) + '\proxy tool\';

  // -----------------------获取升级文件目标路径

  if ServerNum > LocalNum then
  begin
    // ShowMessage('test');

    Form1.show;
    Timer3.Enabled := True;

    myinifile := Tinifile.Create(Strkylinpath + 'LocalVerson.ini');
    // showmessage(Strkylinpath+'\LocalVerson.ini');

    StrVerification := myinifile.ReadString('localmachine', 'key', StrKeyWrite);
    // write rc4 key to localmachine
    myinifile.Destroy;

  end
  else
  begin
    showmessage('你已经最新版本!');
    Form1.Hide;
    sleep(50);
    Application.Terminate;

  end;

end;

procedure TForm1.N1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);

begin

  filename := Strkylinpath + 'proxy.ini';
  myinifile := Tinifile.Create(filename);
  StrProcessName := myinifile.ReadString('AppPath', 'path', '');
  myinifile.Destroy;
  // Edit2.text := StrInfor;
  Button1.Enabled := False;
  myinifile := Tinifile.Create(path + '\LocalVerson.ini');
  myinifile.writestring('version', 'info', StrInfor);
  myinifile.Destroy;
  StatusBar1.Panels[0].text := '欢迎使用巴豆软件';
  // Edit2.text := Edit1.text;
  Timer1.Enabled := False;

end;

procedure TForm1.Timer2Timer(Sender: TObject);

const
  FLAG_ICC_FORCE_CONNECTION = 1;
begin
  { if InternetCheckConnection('http://www.baidu.com',
    FLAG_ICC_FORCE_CONNECTION, 0) then
    Label5.Caption := '网络正常'
    else
    Label5.Caption := '网络离线,请检查网络';
    idhttp2.Disconnect;
    Timer1.Enabled := False;
  }

end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  // Button1.visible := True;
  Timer3.Enabled := False;
    Label1.Caption := '获取版本信息成功';
  Button1.Click;
end;

procedure TForm1.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  Label1.Caption := '版本信息获取成功';
end;

procedure TForm1.IdHTTP2Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  strpo: string;
  strmax: string;

begin

  StatusBar1.Panels[1].text := '已经下载文件:' + BytesToStr(AWorkCount);
  ProgressBar1.Position := AWorkCount;
  try
    ProgressBar1.Position := AWorkCount;
    // Label1.Caption := '升级文件下载进度:'+IntToStr((ProgressBar1.Position * 100) div ProgressBar1.Max) + '%';

  except
    showmessage('网络错误');
  end;
  Update;

end;

procedure TForm1.IdHTTP2WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  try
    ProgressBar1.Max := AWorkCountMax;
    StatusBar1.Panels[0].text := '总计文件大小:' + BytesToStr(AWorkCountMax);

    Update;
  except
    showmessage('网络错误');
  end;

end;

procedure TForm1.IdHTTP2WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin

  // showmessage('SUCCESS') ;
  ProgressBar1.Position := 0;
  Label1.Caption := '版本下载完成';
  Timer1.Enabled := True;
end;

end.
