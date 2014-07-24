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

unit FluentQuery.GenericObjects.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.GenericObjects;

type
  TPerson = class
  public
    Name : string;
    Age : Integer;
    constructor Create(Name : string; Age : Integer);
  end;

  TCustomer = class(TPerson)
  end;

  TSpecialCustomer = class(TCustomer)

  end;

  TestTQueryPerson = class(TTestCase)
  strict private
    FPersonCollection: TObjectList<TPerson>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestToObjectList;
    procedure TestMapBefore;
    procedure TestMapAfter;
    procedure TestIsAssigned;
    procedure TestIsA;
  end;

var
  DummyInt : Integer; // used to suppress warnings about not using loop variables in tests

implementation
uses
  System.SysUtils;


{ TPerson }

constructor TPerson.Create(Name: string; Age: Integer);
begin
  self.Name := Name;
  self.Age := Age;
end;

{ TestTQueryPerson }

procedure TestTQueryPerson.SetUp;
begin
  inherited;
  FPersonCollection := TObjectList<TPerson>.Create;
  FPersonCollection.Add(TPerson.Create('Malcolm', 43));
  FPersonCollection.Add(TPerson.Create('Julie', 41));
  FPersonCollection.Add(TPerson.Create('Jesse', 5));
  FPersonCollection.Add(TPerson.Create('Lauren', 3));
end;

procedure TestTQueryPerson.TearDown;
begin
  inherited;
  FPersonCollection.Free;
end;

procedure TestTQueryPerson.TestToObjectList;
var
  LPersonList : TObjectList<TPerson>;
  L18OrMore : TPredicate<TPerson>;
begin
  L18OrMore := function (Value : TPerson) : Boolean
               begin
                 Result := Value.Age >= 6;
               end;


  LPersonList := Query.Select<TPerson>
                      .From(FPersonCollection)
                      .Where(L18OrMore)
                      .ToTObjectList(False);
  try
    CheckEquals(2, LPersonList.Count);
    CheckEquals('Malcolm', LPersonList.Items[0].Name);
    CheckEquals('Julie', LPersonList.Items[1].Name);
  finally
    LPersonList.Free;
  end;
end;

procedure TestTQueryPerson.TestIsAssigned;
var
  LPassCount : Integer;
  LPerson : TPerson;
begin
  LPassCount := 0;
  FPersonCollection.Insert(1, nil);
  FPersonCollection.Insert(3, nil);

  for LPerson in Query.Select<TPerson>
                    .From(FPersonCollection)
                    .IsAssigned do
  begin
    Inc(LPassCount);
    LPerson.Age := LPerson.Age + 1; // suppress warnings about not using LPerson
  end;
  Check(LPassCount = 4, 'IsAssigned Query should enumerate four items');
end;

procedure TestTQueryPerson.TestIsA;
var
  LPassCount : Integer;
  LPerson : TPerson;
begin
  LPassCount := 0;
  FPersonCollection.Insert(2, TCustomer.Create('Acme', 3));
  FPersonCollection.Insert(3, TCustomer.Create('Spacely''s Sprockets', 0));
  FPersonCollection.Insert(3, TSpecialCustomer.Create('Foo', 0));

  for LPerson in Query.Select<TPerson>
                    .From(FPersonCollection)
                    .IsA(TCustomer) do
  begin
    Inc(LPassCount);
    LPerson.Age := LPerson.Age + 1; // suppress warnings about not using LPerson
  end;
  CheckEquals(3, LPassCount);
end;

procedure TestTQueryPerson.TestMapAfter;
var
  LPassCount : Integer;
  LAged6OrMore : TPredicate<TPerson>;
  LIncrementAge : TProc<TPerson>;
  LPerson : TPerson;
begin
  LPassCount := 0;
  LIncrementAge := procedure (Value : TPerson)
                   begin
                     Value.Age := Value.Age + 1;
                   end;

  LAged6OrMore := function (Value : TPerson) : Boolean
               begin
                 Result := Value.Age >= 6;
               end;


  for LPerson in Query.Select<TPerson>
                      .From(FPersonCollection)
                      .Where(LAged6OrMore)
                      .Map(LIncrementAge) do
  begin
    LPerson.Age := LPerson.Age + 1; // suppress warnings about not using LPerson
    Inc(LPassCount);
  end;
  CheckEquals(2, LPassCount);
end;

procedure TestTQueryPerson.TestMapBefore;
var
  LPassCount : Integer;
  LAged6OrMore : TPredicate<TPerson>;
  LIncrementAge : TProc<TPerson>;
  LPerson : TPerson;
begin
  LPassCount := 0;
  LIncrementAge := procedure (Value : TPerson)
                   begin
                     Value.Age := Value.Age + 1;
                   end;

  LAged6OrMore := function (Value : TPerson) : Boolean
               begin
                 Result := Value.Age >= 6;
               end;


  for LPerson in Query.Select<TPerson>
                      .From(FPersonCollection)
                      .Map(LIncrementAge)
                      .Where(LAged6OrMore) do
  begin
    LPerson.Age := LPerson.Age + 1; // suppress warnings about not using LPerson
    Inc(LPassCount);
  end;
  CheckEquals(3, LPassCount);
end;


procedure TestTQueryPerson.TestPassThrough;
var
  LPassCount : Integer;
  LPerson : TPerson;
begin
  LPassCount := 0;
  for LPerson in Query.Select<TPerson>.From(FPersonCollection) do
  begin
    LPerson.Age := LPerson.Age + 1; // suppress warnings about not using LPerson
    Inc(LPassCount);
  end;
  Check(LPassCount = FPersonCollection.Count, 'Passthrough Query should enumerate all items');
end;



initialization
  // Register any test cases with the test runner
  RegisterTest('Generics/TObjectList<TPerson>', TestTQueryPerson.Suite);
end.

