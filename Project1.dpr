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
  // CreateMutex建立互斥对象，并且给互斥对象起一个唯一的名字。
  myMutex := CreateMutex(nil, False, 'onionhacker123');
  // 程序没有被运行过
  if WaitForSingleObject(myMutex, 0) <> wait_TimeOut then
  begin
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Turquoise Gray');
    Application.Title := '下载提示';
    Application.CreateForm(TForm1, Form1);
  Application.Run;
  end;

end.
