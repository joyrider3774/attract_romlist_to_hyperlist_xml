program AttractRomListToHyperListXMl;

uses
  Vcl.Forms,
  FrmMain in 'FrmMain.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
