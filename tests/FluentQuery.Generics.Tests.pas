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

unit FluentQuery.Generics.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.Generics,
  FluentQuery.Tests.Base,
  System.SysUtils;

type
  TestTQueryIntegerGenerics = class(TFluentQueryIntegerTestCase)
  strict private
    FIntegerCollection: TList<Integer>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestTakeLowerThanCount;
    procedure TestTakeEqualCount;
    procedure TestTakeGreaterThanCount;
    procedure TestTakeZero;
    procedure TestTakeOne;
    procedure TestWhereEven;
    procedure TestWhereNotWhereEven;
    procedure TestWhereNotEven;
    procedure TestWhereNone;
    procedure TestWhereAll;
    procedure TestWhereTake;
    procedure TestTakeWhere;
    procedure TestSkipLowerThanCount;
    procedure TestSkipEqualCount;
    procedure TestSkipGreaterThanCount;
    procedure TestSkipZero;
    procedure TestWhereSkip;
    procedure TestSkipWhere;
    procedure TestSkipWhileTrue;
    procedure TestSkipWhileFalse;
    procedure TestSkipWhile;
    procedure TestTakeWhileFalse;
    procedure TestTakeWhileTrue;
    procedure TestTakeWhile;
    procedure TestCreateList;
    procedure TestFirst;
  end;

var
  DummyInt : Integer; // used to suppress warnings about not using loop variables in tests

implementation


procedure TestTQueryIntegerGenerics.SetUp;
begin
  FIntegerCollection := TList<Integer>.Create;
  FIntegerCollection.Add(1);
  FIntegerCollection.Add(2);
  FIntegerCollection.Add(3);
  FIntegerCollection.Add(4);
  FIntegerCollection.Add(5);
  FIntegerCollection.Add(6);
  FIntegerCollection.Add(7);
  FIntegerCollection.Add(4);
  FIntegerCollection.Add(9);
  FIntegerCollection.Add(10);
end;

procedure TestTQueryIntegerGenerics.TearDown;
begin
  FIntegerCollection.Free;
  FIntegerCollection := nil;
end;


procedure TestTQueryIntegerGenerics.TestTakeEqualCount;
begin
  CheckEquals(FIntegerCollection.Count, GenericQuery<Integer>.Select.From(FIntegerCollection).Take(FIntegerCollection.Count).Count);
end;

procedure TestTQueryIntegerGenerics.TestTakeGreaterThanCount;
begin
  CheckEquals(FIntegerCollection.Count, GenericQuery<Integer>
                                    .Select
                                    .From(FIntegerCollection)
                                    .Take(FIntegerCollection.Count + 1)
                                    .Count);
end;

procedure TestTQueryIntegerGenerics.TestTakeLowerThanCount;
begin
  CheckEquals(FIntegerCollection.Count - 1, GenericQuery<Integer>
                                              .Select
                                              .From(FIntegerCollection)
                                              .Take(FIntegerCollection.Count - 1)
                                              .Count);
end;

procedure TestTQueryIntegerGenerics.TestTakeOne;
begin
  CheckEquals(1, GenericQuery<Integer>.Select.From(FIntegerCollection).Take(1).Count);
end;

procedure TestTQueryIntegerGenerics.TestTakeWhere;
begin
  CheckEquals(2, GenericQuery<Integer>.Select
                   .From(FIntegerCollection)
                   .Take(5)
                   .Where(FEvenNumbers)
                   .Count);
end;

procedure TestTQueryIntegerGenerics.TestTakeWhile;
begin
  CheckEquals(4, GenericQuery<Integer>.Select
                   .From(FIntegerCollection)
                   .TakeWhile(FFourOrLess)
                   .Count);
end;

procedure TestTQueryIntegerGenerics.TestTakeWhileFalse;
begin
  CheckEquals(0, GenericQuery<Integer>.Select.From(FIntegerCollection).TakeWhile(FFalsePredicate).Count);
end;

procedure TestTQueryIntegerGenerics.TestTakeWhileTrue;
begin
  CheckEquals(FIntegerCollection.Count, GenericQuery<Integer>.Select.From(FIntegerCollection).TakeWhile(FTruePredicate).Count);
end;

procedure TestTQueryIntegerGenerics.TestTakeZero;
begin
  CheckEquals(0, GenericQuery<Integer>.Select.From(FIntegerCollection).Take(0).Count);
end;

procedure TestTQueryIntegerGenerics.TestFirst;
begin
  CheckEquals(3, GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(2).First);
end;

procedure TestTQueryIntegerGenerics.TestWhereNotEven;
begin
  CheckExpectedCountWithInnerCheck(GenericQuery<Integer>.Select.From(FIntegerCollection).WhereNot(FEvenNumbers),
                                   function (Arg : Integer) : Boolean
                                   begin
                                     Result := Arg mod 2 <> 0;
                                   end,
                                   5, 'Should enumerate odd numbered items only');
end;

procedure TestTQueryIntegerGenerics.TestWhereNotWhereEven;
begin
  CheckExpectedCountWithInnerCheck(GenericQuery<Integer>
                                    .Select
                                    .From(FIntegerCollection)
                                    .WhereNot(GenericQuery<Integer>
                                                .Select
                                                .Where(FEvenNumbers)),
                                   function (Arg : Integer) : Boolean
                                   begin
                                     Result := Arg mod 2 <> 0;
                                   end,
                                   5, 'Should enumerate odd numbered items only');

end;

procedure TestTQueryIntegerGenerics.TestCreateList;
var
  LIntegerList : TList<Integer>;
begin
  LIntegerList := GenericQuery<Integer>.Select
                    .From(FIntegerCollection)
                    .TakeWhile(FFourOrLess)
                    .AsTList;
  try
    Check(LIntegerList.Count = 4, 'Should have 4 items in list');
    Check(LIntegerList.Items[0] = 1, 'First item should be 1');
    Check(LIntegerList.Items[1] = 2, 'Second item should be 2');
    Check(LIntegerList.Items[2] = 3, 'Third item should be 3');
    Check(LIntegerList.Items[3] = 4, 'Fourth item should be 4');
  finally
    LIntegerList.Free;
  end;
end;

procedure TestTQueryIntegerGenerics.TestPassThrough;
begin
  CheckEquals(FIntegerCollection.Count, GenericQuery<Integer>.Select.From(FIntegerCollection).Count);
end;

procedure TestTQueryIntegerGenerics.TestSkipEqualCount;
begin
  CheckEquals(0, GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(FIntegerCollection.Count).Count);
end;

procedure TestTQueryIntegerGenerics.TestSkipGreaterThanCount;
begin
  CheckEquals(0, GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(FIntegerCollection.Count + 2).Count);
end;

procedure TestTQueryIntegerGenerics.TestSkipLowerThanCount;
begin
  CheckEquals(2, GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(FIntegerCollection.Count - 2).Count);
end;

procedure TestTQueryIntegerGenerics.TestSkipWhere;
begin
  CheckEquals(3, GenericQuery<Integer>.Select
                   .From(FIntegerCollection)
                   .Skip(5)
                   .Where(FEvenNumbers)
                   .Count);
end;

procedure TestTQueryIntegerGenerics.TestSkipWhile;
begin
  CheckEquals(6, GenericQuery<Integer>.Select.From(FIntegerCollection).SkipWhile(FFourOrLess).Count);
end;

procedure TestTQueryIntegerGenerics.TestSkipWhileFalse;
begin
  CheckEquals(FIntegerCollection.Count, GenericQuery<Integer>.Select.From(FIntegerCollection).SkipWhile(FFalsePredicate).Count);
end;

procedure TestTQueryIntegerGenerics.TestSkipWhileTrue;
begin
  CheckEquals(0, GenericQuery<Integer>.Select.From(FIntegerCollection).SkipWhile(FTruePredicate).Count);
end;

procedure TestTQueryIntegerGenerics.TestSkipZero;
begin
  CheckEquals(FIntegerCollection.Count, GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(0).Count);
end;

procedure TestTQueryIntegerGenerics.TestWhereEven;
begin
  CheckEquals(5, GenericQuery<Integer>.Select.From(FIntegerCollection).Where(FEvenNumbers).Count);
end;

procedure TestTQueryIntegerGenerics.TestWhereAll;
begin
  CheckEquals(10, GenericQuery<Integer>.Select.From(FIntegerCollection).Where(FTruePredicate).Count);
end;

procedure TestTQueryIntegerGenerics.TestWhereTake;
begin
  CheckEquals(3, GenericQuery<Integer>.Select
                   .From(FIntegerCollection)
                   .Where(FEvenNumbers)
                   .Take(3)
                   .Count);
end;

procedure TestTQueryIntegerGenerics.TestWhereNone;
begin
  CheckEquals(0, GenericQuery<Integer>.Select.From(FIntegerCollection).Where(FGreaterThanTen).Count);
end;

procedure TestTQueryIntegerGenerics.TestWhereSkip;
begin
  CheckEquals(2, GenericQuery<Integer>.Select
                   .From(FIntegerCollection)
                   .Where(FEvenNumbers)
                   .Skip(3)
                   .Count);
end;




initialization
  // Register any test cases with the test runner
  RegisterTest('Generics/TList<Integer>', TestTQueryIntegerGenerics.Suite);
end.

