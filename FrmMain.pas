unit FrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, System.Threading;
type

  TRomListConvertThread = class(TThread)
  private
    FLabel: TLabel;
    FProgressBar: TProgressBar;
    FGameName, FFilename, FAttractRomListDir: string;
    FLinesCount, FLine: Integer;
    FDone, FSkipDuplicates: Boolean;
    procedure UpdateUI;
    procedure doParse(const aFileName:String);
  protected
    procedure Execute; override;
  public
    constructor Create(const aRomDir: String; SkipDuplicates:Boolean; UiLabel: TLabel; ProgressBar: TProgressBar);
  end;

  TMainForm = class(TForm)
    edtAttractRomList: TEdit;
    lblAttractromlist: TLabel;
    btnParse: TButton;
    btnSelectFolder: TButton;
    lblProgress: TLabel;
    pbProgress: TProgressBar;
    lblCredits: TLabel;
    chkSkipDuplicates: TCheckBox;
    procedure btnSelectFolderClick(Sender: TObject);
    procedure edtAttractRomListChange(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    RomListConvertThread : TRomListConvertThread;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

constructor TRomListConvertThread.Create(const aRomDir: String; SkipDuplicates:Boolean; UiLabel: TLabel; ProgressBar: TProgressBar);
begin
  inherited Create(True);
  FLabel := UiLabel;
  FAttractRomListDir := aRomDir;
  FProgressBar := ProgressBar;
  FSkipDuplicates := SkipDuplicates;
  FDone := False;
end;

procedure TRomListConvertThread.UpdateUI;
begin
  if FDone then
  begin
    FLabel.Caption := 'All Done!';
    FProgressBar.Position := 0;
    FProgressBar.Max := 1;
  end
  else
  begin
    FLabel.Caption := 'File ' + FFilename + '--> Game (' + IntToStr(FLine) + '/' + IntToStr(FLinesCount) + '): ' + FGameName;
    FProgressBar.Max := FLinesCount;
    FProgressBar.Position := FLine;
  end;
end;

procedure TRomListConvertThread.Execute;
var
  searchRec: TSearchRec;
begin
  if DirectoryExists(FAttractRomListDir) then
  begin
    if FindFirst(FAttractRomListDir +'\*.txt', faNormal, searchRec)  = 0 then
    begin
      repeat
        doParse(FAttractRomListDir + '\' + searchRec.Name);
      until (FindNext(searchrec) <> 0) or Terminated;
      findclose(searchrec);
    end;
  end;
  FDone := True;
  Synchronize(UpdateUi);
end;

procedure TRomListConvertThread.doParse(const aFileName:String);

  function FixStrings(const s: String): string;
  begin
    Result := StringReplace(s, '&', '&amp;', [rfReplaceAll]);
    Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
    Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
    Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  end;

var
  sList, sList2, GameList: TStringList;
  sHeader: string;
  sStream: TStreamWriter;
  Teller, index1, index2: Integer;
begin
  sHeader := '<?xml version="1.0"?>'#13#10 +
            '<menu>'#13#10 +
	          '    <header>'#13#10 +
		        '        <listname>' + StringReplace(ExtractFileName(aFileName), ExtractFileExt(aFileName), '', [] ) + '</listname>'#13#10 +
		        '        <lastlistupdate>' + formatDateTime('DD/MM/YYYY', now) + '</lastlistupdate>'#13#10 +
		        '        <listversion>1.3</listversion>'#13#10 +
		        '        <exporterversion>Attract HyperList XML Exporter by willems davy</exporterversion>'#13#10 +
	          '    </header>';
  sList := TStringList.Create;
  sList2 := TStringList.Create;
  GameList := TStringList.Create;
  CreateDir(ExtractFileDir(aFilename) + '\HyerList\');
  sStream := TStreamWriter.Create(ExtractFileDir(aFilename) + '\HyerList\' + ChangeFileExt(ExtractFileName(aFileName), '.xml'));
  try

    if FileExists(aFileName) then
    begin
      FFilename := ExtractFileName(aFileName);
      sStream.WriteLine(sHeader);
      sList.LoadFromFile(aFileName);
      for Teller := 0 to sList.Count -1 do
      begin
        //skip comments
        if Length(sList[Teller]) > 0 then
          if sList[Teller][1] = '#' then Continue;
        sList2.Clear;
        index1 := Pos(';', sList[Teller]);
        index2 := 1;
        if index1 > 0 then
        begin
          while index1 > 0 do
          begin
            sList2.Add(Copy(sList[Teller],Index2, Index1-Index2));
            Index2 := index1+1;
            index1 := Pos(';', sList[Teller], Index2);
          end;
          FLinesCount := sList.Count;
          FLine := Teller+1;
          FGameName := sList2[0];
          if FSkipDuplicates then
            if GameList.IndexOf(FGameName) > -1 then Continue;
          GameList.Add(FGameName);
          Synchronize(UpdateUi);
          if sList2.Count >= 7 then
          begin
            sStream.WriteLine('    <game name="'+ FixStrings(sList2[0]) + '" index="" image="">');
            sStream.WriteLine('       <description>' + FixStrings(sList2[1]) + '</description>');
            sStream.WriteLine('       <cloneof>' + FixStrings(sList2[3]) + '</cloneof>');
            sStream.WriteLine('       <crc></crc>');
            sStream.WriteLine('       <manufacturer>' + FixStrings(sList2[5]) + '</manufacturer>');
            sStream.WriteLine('       <year>' + FixStrings(sList2[4]) + '</year>');
            sStream.WriteLine('       <genre>' + FixStrings(sList2[6]) + '</genre>');
            sStream.WriteLine('       <rating></rating>');
            sStream.WriteLine('       <enabled>Yes</enabled>');
            sStream.WriteLine('    </game>');
          end;
        end;
        if Terminated then Break;
      end;
      sStream.WriteLine('</menu>');
    end;
  finally
    FreeAndNil(GameList);
    FreeAndNil(sList2);
    FreeAndNil(sList);
    FreeAndNil(sStream);
  end;
end;

procedure TMainForm.btnParseClick(Sender: TObject);
begin
  if Assigned(RomListConvertThread) then
  begin
    RomListConvertThread.Terminate;
    RomListConvertThread.WaitFor;
    RomListConvertThread.Free;
  end;
  RomListConvertThread := TRomListConvertThread.Create(edtAttractRomList.Text, chkSkipDuplicates.Checked, lblProgress, pbProgress);
  RomListConvertThread.Start;
end;

procedure TMainForm.btnSelectFolderClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
      EdtAttractRomList.Text := FileName;
  finally
    Free;
  end;
end;


procedure TMainForm.edtAttractRomListChange(Sender: TObject);
begin
  btnParse.Enabled := DirectoryExists(edtAttractRomList.Text);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  RomListConvertThread := nil;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(RomListConvertThread) then
  begin
    RomListConvertThread.Terminate;
    RomListConvertThread.WaitFor;
    RomListConvertThread.Free;
  end;
end;

end.
