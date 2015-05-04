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

unit FluentQuery.Pointers.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.Pointers,
  System.Classes;

type
  TestTQueryPointer = class(TTestCase)
  strict private
    FList: TList<Pointer>;
    FObject1, FObject2, FObject3 : TObject;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestIsAssigned;
  end;

  TestTQueryTList = class(TTestCase)
  strict private
    FList: TList;
    FObject1, FObject2, FObject3 : TObject;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestIsAssigned;
    procedure TestWhereNotIsAssigned;
    procedure TestWhereNotIsAssignedPredicate;
    procedure TestTakeWhileIsAssigned;
  end;



implementation
uses
  SysUtils;

var
  DummyPointer : Pointer; // used to suppress warnings in tests about unused loop variables

{ TestTQueryPointer }

procedure TestTQueryPointer.SetUp;
begin
  inherited;
  FList := TList<Pointer>.Create;
  FObject1 := TObject.Create;
  FObject2 := TObject.Create;
  FObject3 := TObject.Create;

  FList.Add(FObject1);
  FList.Add(nil);
  FList.Add(FObject2);
  FList.Add(Pointer(1234));
  FList.Add(FObject3);
end;

procedure TestTQueryPointer.TearDown;
begin
  FObject1.Free;
  FObject2.Free;
  FObject3.Free;
  FList.Free;
  inherited;
end;

procedure TestTQueryPointer.TestIsAssigned;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query
                    .From(FList)
                    .IsAssigned do
  begin
    Inc(LPassCount);
    DummyPointer := LPointer; // suppress warnings about unused loop variable
  end;
  Check(LPassCount = 4, 'IsAssigned Query should enumerate four items');
end;

procedure TestTQueryPointer.TestPassThrough;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query.From(FList) do
  begin
    Inc(LPassCount);
    DummyPointer := LPointer; // suppress warnings about unused loop variable
  end;
  Check(LPassCount = FList.Count, 'Passthrough Query should enumerate all items');
end;


{ TestTQueryTList }

procedure TestTQueryTList.SetUp;
begin
  inherited;
  FList := TList.Create;
  FObject1 := TObject.Create;
  FObject2 := TObject.Create;
  FObject3 := TObject.Create;

  FList.Add(FObject1);
  FList.Add(nil);
  FList.Add(FObject2);
  FList.Add(Pointer(1234));
  FList.Add(FObject3);
end;

procedure TestTQueryTList.TearDown;
begin
  FObject1.Free;
  FObject2.Free;
  FObject3.Free;
  FList.Free;
  inherited;
end;

procedure TestTQueryTList.TestIsAssigned;
begin
  Check(Query.From(FList).IsAssigned.Count = 4, 'IsAssigned Query should enumerate four items');
end;


procedure TestTQueryTList.TestWhereNotIsAssigned;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query
                    .From(FList)
                    .WhereNot(Query.IsAssigned) do
  begin
    Inc(LPassCount);
    DummyPointer := LPointer; // suppress warnings about unused loop variable
  end;
  Check(LPassCount = FList.Count - 4, 'WhereNot(IsAssigned) Query should enumerate all but four items');
end;

procedure TestTQueryTList.TestWhereNotIsAssignedPredicate;
var
  LPassCount : Integer;
  LPointer : Pointer;
  LIsAssigned : TPredicate<Pointer>;
begin
  LPassCount := 0;
  LIsAssigned := Query.IsAssigned.Predicate;

  for LPointer in Query
                    .From(FList)
                    .WhereNot(LIsAssigned) do
  begin
    Inc(LPassCount);
    DummyPointer := LPointer; // suppress warnings about unused loop variable
  end;
  Check(LPassCount = FList.Count - 4, 'WhereNot(Predicate(IsAssigned)) Query should enumerate all but four items');
end;

procedure TestTQueryTList.TestPassThrough;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query.From(FList) do
  begin
    Inc(LPassCount);
    DummyPointer := LPointer; // suppress warnings about unused loop variable
  end;
  Check(LPassCount = FList.Count, 'Passthrough Query should enumerate all items');
end;


procedure TestTQueryTList.TestTakeWhileIsAssigned;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query
                    .From(FList)
                    .TakeWhile(Query.IsAssigned) do
  begin
    Inc(LPassCount);
    DummyPointer := LPointer; // suppress warnings about unused loop variable
  end;
  Check(LPassCount = 1, 'TakeWhile(IsAssigned) Query should enumerate only the first item');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Pointers/TList<Pointer>', TestTQueryPointer.Suite);
  RegisterTest('Pointers/TList', TestTQueryTList.Suite);
end.

