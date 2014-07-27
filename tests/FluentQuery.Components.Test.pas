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
  end;



implementation
uses System.Classes, VCL.StdCtrls, Vcl.ExtCtrls;

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
var
  LPassCount : Integer;
  LTimer : TTimer;
begin
  LPassCount := 0;
  for LTimer in ComponentQuery<TTimer>.Select.From(FTestForm) do
  begin
    LTimer.Interval := 500; // suppress warnings about not using LTimer
    Inc(LPassCount);
  end;
  CheckEquals(1, LPassCount);
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
    LComponent.Tag := 0; // suppress warnings about not using LPerson
    Inc(LPassCount);
  end;
  CheckEquals(FTestForm.ComponentCount, LPassCount);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Components', TestTQueryComponent.Suite);

end.
