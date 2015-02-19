unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,IniFiles;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    procedure Memo1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  StrGetVolumeID:string;
  StrEncryption:string;
  Strkylinpath:string;

implementation

{$R *.dfm}

uses Unit1;
function Rc4(i_Encrypt:integer; s_EncryptText,
  s_EncryptPassword:string; i_EncryptLevel:integer = 1):string;
var
  v_EncryptModified, v_EncryptCipher, v_EncryptCipherBy:string;
  i_EncryptCountA, i_EncryptCountB, i_EncryptCountC, i_EncryptCountD,
    i_EncryptCountE, i_EncryptCountF, i_EncryptCountG, i_EncryptCountH,
    v_EncryptSwap:integer;
  av_EncryptBox:array[0..256, 0..2] of integer;

begin
  if (i_Encrypt <> 0) and (i_Encrypt <> 1) then
  begin
    result := '';
  end
  else if (s_EncryptText = '') or (s_EncryptPassword = '') then
  begin
    result := '';
  end
  else
  begin
    if (i_EncryptLevel <= 0) or (Int(i_EncryptLevel) <> i_EncryptLevel) then
      i_EncryptLevel := 1;
    if Int(i_EncryptLevel) > 10 then i_EncryptLevel := 10;
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
            Chr(Ord(s_EncryptText[i_EncryptCountG]) xor
            Ord(s_EncryptPassword[i_EncryptCountH]) xor 255);
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
            Ord(s_EncryptPassword[i_EncryptCountA mod Length(s_EncryptPassword) +
            1]);
          av_EncryptBox[i_EncryptCountA, 0] := i_EncryptCountA;
        end;
        for i_EncryptCountA := 0 to 255 do
        begin
          i_EncryptCountB := (i_EncryptCountB + av_EncryptBox[i_EncryptCountA][0]
            + av_EncryptBox[i_EncryptCountA][1]) mod 256;
          v_EncryptSwap := av_EncryptBox[i_EncryptCountA][0];
          av_EncryptBox[i_EncryptCountA][0] :=
            av_EncryptBox[i_EncryptCountB][0];
          av_EncryptBox[i_EncryptCountB][0] := v_EncryptSwap;
        end;
        for i_EncryptCountA := 1 to Length(s_EncryptText) do
        begin
          i_EncryptCountC := (i_EncryptCountC + 1) mod 256;
          i_EncryptCountD := (i_EncryptCountD +
            av_EncryptBox[i_EncryptCountC][0]) mod 256;
          i_EncryptCountE := av_EncryptBox[(av_EncryptBox[i_EncryptCountC][0] +
            av_EncryptBox[i_EncryptCountD][0]) mod 256][0];
          v_EncryptCipherBy := inttostr(Ord(s_EncryptText[i_EncryptCountA]) xor
            i_EncryptCountE);
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
            Ord(s_EncryptPassword[i_EncryptCountA mod Length(s_EncryptPassword) +
            1]);
          av_EncryptBox[i_EncryptCountA, 0] := i_EncryptCountA;
        end;
        for i_EncryptCountA := 0 to 255 do
        begin
          i_EncryptCountB := (i_EncryptCountB + av_EncryptBox[i_EncryptCountA, 0]
            + av_EncryptBox[i_EncryptCountA, 1]) mod 256;
          v_EncryptSwap := av_EncryptBox[i_EncryptCountA, 0];
          av_EncryptBox[i_EncryptCountA, 0] := av_EncryptBox[i_EncryptCountB,
            0];
          av_EncryptBox[i_EncryptCountB, 0] := v_EncryptSwap;
        end;
        for i_EncryptCountA := 1 to Length(s_EncryptText) do
        begin
          if (i_EncryptCountA mod 2) <> 0 then
          begin
            i_EncryptCountC := ((i_EncryptCountC + 1) mod 256);
            i_EncryptCountD := ((i_EncryptCountD +
              av_EncryptBox[i_EncryptCountC, 0]) mod 256);
            i_EncryptCountE := av_EncryptBox[((av_EncryptBox[i_EncryptCountC, 0]
              + av_EncryptBox[i_EncryptCountD, 0]) mod 256), 0];
            v_EncryptCipherBy := inttostr(StrToInt64('$' +
              s_EncryptText[i_EncryptCountA] + s_EncryptText[i_EncryptCountA + 1])
              xor i_EncryptCountE);
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
            Chr((Ord(s_EncryptText[i_EncryptCountG]) xor
            Ord(s_EncryptPassword[i_EncryptCountH]) xor 255));
        end;
        s_EncryptText := v_EncryptModified;
      end;
    end;
    result := s_EncryptText;
  end;
end;

///==================================================================================

function GetVolumeID: string;
var
  vVolumeNameBuffer: array[0..255]of Char;
  vVolumeSerialNumber: DWORD;
  vMaximumComponentLength: DWORD;
  vFileSystemFlags: DWORD;
  vFileSystemNameBuffer: array[0..255]of Char;
begin
  if GetVolumeInformation('c:\', vVolumeNameBuffer, SizeOf(vVolumeNameBuffer),
     @vVolumeSerialNumber, vMaximumComponentLength, vFileSystemFlags,
     vFileSystemNameBuffer, SizeOf(vFileSystemNameBuffer))   then
  begin
    Result := IntToHex(vVolumeSerialNumber, 8);
  end;
end;

procedure TForm2.Memo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   memo1.Text:='';
end;

end.
