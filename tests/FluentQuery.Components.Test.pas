{****************************************************}
{                                                    }
{  FluentQuery                                       }
{                                                    }
{  Copyright (C) 2013 Malcolm Groves                 }
{                                                    }
{  http://www.malcolmgroves.com                      }
{                                                    }
{****************************************************}
{                                                    }
{  This Source Code Form is subject to the terms of  }
{  the Mozilla Public License, v. 2.0. If a copy of  }
{  the MPL was not distributed with this file, You   }
{  can obtain one at                                 }
{                                                    }
{  http://mozilla.org/MPL/2.0/                       }
{                                                    }
{****************************************************}
unit FluentQuery.Components.Test;

interface
uses
  TestFramework,
  FluentQuery.Components,
  FluentQuery.Components.Test.Form;

type
  TestTQueryComponent = class(TTestCase)
  private
    FTestForm : TFQComponentTestForm;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestVisual;
    procedure TestNonVisual;
    procedure TestNonExistant;
    procedure TestTagEquals;
    procedure TestTagEqualsTagNotFound;
    procedure TestHasPropertyColor;
    procedure TestHasTagEquals1;
    procedure TestHasTagGreaterThanZero;
    procedure TestHasCaptionEqualsHello;
    procedure TestHasCaptionStartingWithHel;
    procedure TestIsAWinControlHasEnabledFalse;
  end;



implementation
uses System.Classes, VCL.StdCtrls, Vcl.ExtCtrls, System.TypInfo, VCL.Controls,
     FluentQuery.Integers, FluentQuery.Strings;

{ TestTQueryComponent }

procedure TestTQueryComponent.SetUp;
begin
  inherited;
  FTestForm := TFQComponentTestForm.Create(nil);
end;

procedure TestTQueryComponent.TearDown;
begin
  inherited;
  FTestForm.Free;
end;

procedure TestTQueryComponent.TestNonVisual;
begin
  CheckEquals(1, ComponentQuery<TTimer>.Select.From(FTestForm).Count);
end;

procedure TestTQueryComponent.TestVisual;
var
  LPassCount : Integer;
  LEdit : TEdit;
begin
  LPassCount := 0;
  for LEdit in ComponentQuery<TEdit>.Select.From(FTestForm) do
  begin
    LEdit.Text := 'Hello'; // suppress warnings about not using LEdit
    Inc(LPassCount);
  end;
  CheckEquals(4, LPassCount);
end;

procedure TestTQueryComponent.TestHasPropertyColor;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>
                      .Select
                      .From(FTestForm)
                      .HasProperty('Color', tkInteger) do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(6, LPassCount);
end;

procedure TestTQueryComponent.TestHasTagEquals1;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>
                      .Select
                      .From(FTestForm)
                      .IntegerProperty('Tag', 1) do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(4, LPassCount);
end;

procedure TestTQueryComponent.TestHasTagGreaterThanZero;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>
                      .Select
                      .From(FTestForm)
                      .IntegerProperty('Tag', IntegerQuery.GreaterThan(0)) do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(5, LPassCount);
end;

procedure TestTQueryComponent.TestIsAWinControlHasEnabledFalse;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>
                      .Select
                      .From(FTestForm)
                      .IsA(TWinControl)
                      .BooleanProperty('Enabled', False) do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(2, LPassCount);
end;

procedure TestTQueryComponent.TestHasCaptionEqualsHello;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>
                      .Select
                      .From(FTestForm)
                      .StringProperty('Caption', 'HeLLo') do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(2, LPassCount);
end;

procedure TestTQueryComponent.TestHasCaptionStartingWithHel;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>
                      .Select
                      .From(FTestForm)
                      .StringProperty('Caption', StringQuery.StartsWith('HEL')) do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(2, LPassCount);
end;

procedure TestTQueryComponent.TestNonExistant;
var
  LPassCount : Integer;
  LMemo : TMemo;
begin
  LPassCount := 0;
  for LMemo in ComponentQuery<TMemo>.Select.From(FTestForm) do
  begin
    LMemo.Text := 'Hello'; // suppress warnings about not using LMemo
    Inc(LPassCount);
  end;
  CheckEquals(0, LPassCount);
end;

procedure TestTQueryComponent.TestPassThrough;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>.Select.From(FTestForm) do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(FTestForm.ComponentCount, LPassCount);
end;

procedure TestTQueryComponent.TestTagEquals;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>
                      .Select
                      .From(FTestForm)
                      .TagEquals(1) do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(4, LPassCount);
end;

procedure TestTQueryComponent.TestTagEqualsTagNotFound;
var
  LPassCount : Integer;
  LComponent : TComponent;
begin
  LPassCount := 0;
  for LComponent in ComponentQuery<TComponent>
                      .Select
                      .From(FTestForm)
                      .TagEquals(32) do
  begin
    LComponent.Tag := 0; // suppress warnings about not using LComponent
    Inc(LPassCount);
  end;
  CheckEquals(0, LPassCount);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Components', TestTQueryComponent.Suite);

end.
