object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Attract RomList to Hyperlist XML Converter'
  ClientHeight = 141
  ClientWidth = 603
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblAttractromlist: TLabel
    Left = 6
    Top = 5
    Width = 105
    Height = 13
    Caption = 'Attract RomList folder'
  end
  object lblProgress: TLabel
    Left = 8
    Top = 79
    Width = 577
    Height = 13
    AutoSize = False
    Caption = 'Select the Attract RomList Folder first'
  end
  object lblCredits: TLabel
    Left = 8
    Top = 121
    Width = 577
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Created by Willems Davy aka joyrider3774'
  end
  object edtAttractRomList: TEdit
    Left = 6
    Top = 24
    Width = 579
    Height = 21
    TabOrder = 0
    OnChange = edtAttractRomListChange
  end
  object btnParse: TButton
    Left = 174
    Top = 51
    Width = 153
    Height = 25
    Caption = 'Convert To HyperList XML'
    Enabled = False
    TabOrder = 1
    OnClick = btnParseClick
  end
  object btnSelectFolder: TButton
    Left = 6
    Top = 51
    Width = 162
    Height = 25
    Caption = 'Select Attract RomList Folder'
    TabOrder = 2
    OnClick = btnSelectFolderClick
  end
  object pbProgress: TProgressBar
    Left = 6
    Top = 98
    Width = 579
    Height = 17
    Step = 1
    TabOrder = 3
  end
  object chkSkipDuplicates: TCheckBox
    Left = 333
    Top = 56
    Width = 252
    Height = 17
    Caption = 'Skip duplicate game names'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
