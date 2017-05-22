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
begin
  CheckEquals(4, PointerQuery.From(FList).IsAssigned.Count);
end;

procedure TestTQueryPointer.TestPassThrough;
begin
  CheckEquals(FList.Count, PointerQuery.From(FList).Count);
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
  CheckEquals(4, PointerQuery.From(FList).IsAssigned.Count);
end;


procedure TestTQueryTList.TestWhereNotIsAssigned;
begin
  CheckEquals(FList.Count - 4, PointerQuery.From(FList).WhereNot(PointerQuery.IsAssigned).Count);
end;

procedure TestTQueryTList.TestWhereNotIsAssignedPredicate;
begin
  CheckEquals(FList.Count - 4, PointerQuery.From(FList).WhereNot(PointerQuery
                                                                  .IsAssigned
                                                                  .Predicate).Count);
end;

procedure TestTQueryTList.TestPassThrough;
begin
  CheckEquals(FList.Count, PointerQuery.From(FList).Count);
end;


procedure TestTQueryTList.TestTakeWhileIsAssigned;
begin
  CheckEquals(1, PointerQuery.From(FList).TakeWhile(PointerQuery.IsAssigned).Count);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Pointers/TList<Pointer>', TestTQueryPointer.Suite);
  RegisterTest('Pointers/TList', TestTQueryTList.Suite);
end.

