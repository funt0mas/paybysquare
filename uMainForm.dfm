object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Pay by Square text generator demo (Delphi XE2)'
  ClientHeight = 640
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblIBAN: TLabel
    Left = 16
    Top = 16
    Caption = 'IBAN'
  end
  object edtIBAN: TEdit
    Left = 170
    Top = 13
    Width = 300
    TabOrder = 0
  end
  object lblSwift: TLabel
    Left = 16
    Top = 46
    Caption = 'SWIFT/BIC'
  end
  object edtSwift: TEdit
    Left = 170
    Top = 43
    Width = 180
    TabOrder = 1
  end
  object lblAmount: TLabel
    Left = 16
    Top = 76
    Caption = 'Suma'
  end
  object edtAmount: TEdit
    Left = 170
    Top = 73
    Width = 120
    TabOrder = 2
  end
  object lblCurrency: TLabel
    Left = 16
    Top = 106
    Caption = 'Mena (iba EUR)'
  end
  object edtCurrency: TEdit
    Left = 170
    Top = 103
    Width = 80
    TabOrder = 3
  end
  object lblVS: TLabel
    Left = 16
    Top = 136
    Caption = 'Variabilný symbol'
  end
  object edtVS: TEdit
    Left = 170
    Top = 133
    Width = 180
    TabOrder = 4
  end
  object lblSS: TLabel
    Left = 16
    Top = 166
    Caption = 'Špecifický symbol'
  end
  object edtSS: TEdit
    Left = 170
    Top = 163
    Width = 180
    TabOrder = 5
  end
  object lblKS: TLabel
    Left = 16
    Top = 196
    Caption = 'Konštantný symbol'
  end
  object edtKS: TEdit
    Left = 170
    Top = 193
    Width = 180
    TabOrder = 6
  end
  object lblNote: TLabel
    Left = 16
    Top = 226
    Caption = 'Poznámka pre prijímateľa'
  end
  object edtNote: TEdit
    Left = 170
    Top = 223
    Width = 560
    TabOrder = 7
  end
  object lblName: TLabel
    Left = 16
    Top = 256
    Caption = 'Názov príjemcu'
  end
  object edtName: TEdit
    Left = 170
    Top = 253
    Width = 300
    TabOrder = 8
  end
  object lblDueDate: TLabel
    Left = 16
    Top = 286
    Caption = 'Dátum splatnosti'
  end
  object dtpDueDate: TDateTimePicker
    Left = 170
    Top = 283
    Width = 180
    Date = 46000.000000000000000000
    Time = 46000.000000000000000000
    TabOrder = 9
  end
  object btnGenerate: TButton
    Left = 16
    Top = 320
    Width = 120
    Height = 30
    Caption = 'Generovať'
    TabOrder = 10
    OnClick = btnGenerateClick
  end
  object btnCopy: TButton
    Left = 146
    Top = 320
    Width = 160
    Height = 30
    Caption = 'Kopírovať do schránky'
    TabOrder = 11
    OnClick = btnCopyClick
  end
  object btnLoadDemo: TButton
    Left = 316
    Top = 320
    Width = 150
    Height = 30
    Caption = 'Načítať demo údaje'
    TabOrder = 12
    OnClick = btnLoadDemoClick
  end
  object lblOutput: TLabel
    Left = 16
    Top = 366
    Caption = 'Výstupný Pay by Square string'
  end
  object memoOutput: TMemo
    Left = 16
    Top = 386
    Width = 714
    Height = 230
    ScrollBars = ssVertical
    TabOrder = 13
    WordWrap = True
  end
end
