object FQComponentTestForm: TFQComponentTestForm
  Left = 0
  Top = 0
  Caption = 'FQComponentTestForm'
  ClientHeight = 384
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 16
    Top = 96
    Width = 305
    Height = 273
    Caption = 'Panel1'
    TabOrder = 0
    object Panel2: TPanel
      Left = 24
      Top = 144
      Width = 257
      Height = 105
      Caption = 'Panel2'
      TabOrder = 0
      object Edit3: TEdit
        Tag = 1
        Left = 24
        Top = 16
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'Edit3'
      end
      object Button1: TButton
        Left = 24
        Top = 64
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 1
      end
    end
    object Edit1: TEdit
      Tag = 1
      Left = 24
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Tag = 2
      Left = 24
      Top = 51
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Edit2'
    end
    object Button2: TButton
      Tag = 1
      Left = 24
      Top = 88
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 3
    end
  end
  object Edit4: TEdit
    Left = 18
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit4'
  end
  object Timer1: TTimer
    Tag = 1
    Enabled = False
    Left = 32
    Top = 48
  end
end
