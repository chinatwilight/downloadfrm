program Project1;

uses
  windows,
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  myMutex: HWND;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  // CreateMutex����������󣬲��Ҹ����������һ��Ψһ�����֡�
  myMutex := CreateMutex(nil, False, 'onionhacker123');
  // ����û�б����й�
  if WaitForSingleObject(myMutex, 0) <> wait_TimeOut then
  begin
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Turquoise Gray');
    Application.Title := '������ʾ';
    Application.CreateForm(TForm1, Form1);
  Application.Run;
  end;

end.
