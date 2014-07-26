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
  FluentQuery.Generics;

type
  TestTQueryIntegerGenerics = class(TTestCase)
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
uses
  System.SysUtils;

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
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count;
  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Take(MaxPassCount) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = MaxPassCount, 'Take = Collection.Count should enumerate all items');
end;

procedure TestTQueryIntegerGenerics.TestTakeGreaterThanCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count + 1;
  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Take(MaxPassCount) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = FIntegerCollection.Count, 'Take > collection.count should enumerate all items');
end;

procedure TestTQueryIntegerGenerics.TestTakeLowerThanCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count - 1;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Take(MaxPassCount) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = MaxPassCount, 'Take < collection.count should not enumerate all items');
end;

procedure TestTQueryIntegerGenerics.TestTakeOne;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Take(1) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = 1, 'Take(1) on a non-empty collection should enumerate one item');
end;

procedure TestTQueryIntegerGenerics.TestTakeWhere;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in GenericQuery<Integer>.Select
             .From(FIntegerCollection)
             .Take(5)
             .Where(LEvenNumbers) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = 2, 'Should enumerate even numbered items in the first 5');
end;

procedure TestTQueryIntegerGenerics.TestTakeWhile;
var
  LEnumerationCount, I : Integer;
  LFourOrLess : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;

  for I in GenericQuery<Integer>.Select
             .From(FIntegerCollection)
             .TakeWhile(LFourOrLess) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = 4, 'TakeWhile 4 or less should have enumerated 4 items');
end;

procedure TestTQueryIntegerGenerics.TestTakeWhileFalse;
var
  LEnumerationCount, I : Integer;
  LFalse : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LFalse := function (Value : Integer) : Boolean
            begin
              Result := False;
            end;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).TakeWhile(LFalse) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = 0, 'TakeWhile False should have enumerated zero items');
end;

procedure TestTQueryIntegerGenerics.TestTakeWhileTrue;
var
  LEnumerationCount, I : Integer;
  LTrue : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LTrue := function (Value : Integer) : Boolean
           begin
             Result := True;
           end;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).TakeWhile(LTrue) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = FIntegerCollection.Count, 'TakeWhile True should have enumerated all items');
end;

procedure TestTQueryIntegerGenerics.TestTakeZero;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := 0;
  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Take(MaxPassCount) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = MaxPassCount, 'Take = 0 should enumerate no items');
end;

procedure TestTQueryIntegerGenerics.TestFirst;
var
  I : Integer;
begin
  I := GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(2).First;

  CheckEquals(3, I);
end;

procedure TestTQueryIntegerGenerics.TestWhereNotEven;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in GenericQuery<Integer>.Select
             .From(FIntegerCollection)
             .WhereNot(LEvenNumbers) do
  begin
    Inc(LPassCount);
    Check(I mod 2 <> 0,
          'Should enumerate odd numbered items, but enumerated ' + I.ToString);
  end;
  Check(LPassCount = 5, 'Should enumerate even numbered items');
end;

procedure TestTQueryIntegerGenerics.TestWhereNotWhereEven;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in GenericQuery<Integer>.Select
             .From(FIntegerCollection)
             .WhereNot(GenericQuery<Integer>.Select.Where(LEvenNumbers)) do
  begin
    Inc(LPassCount);
    Check(I mod 2 <> 0,
          'Should enumerate odd numbered items, but enumerated ' + I.ToString);
  end;
  Check(LPassCount = 5, 'Should enumerate even numbered items');
end;

procedure TestTQueryIntegerGenerics.TestCreateList;
var
  LIntegerList : TList<Integer>;
  LFourOrLess : TPredicate<Integer>;
begin
  LFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;


  LIntegerList := GenericQuery<Integer>.Select
                    .From(FIntegerCollection)
                    .TakeWhile(LFourOrLess)
                    .ToTList;
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
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;
  for I in GenericQuery<Integer>.Select.From(FIntegerCollection) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;
  Check(LPassCount = FIntegerCollection.Count, 'Passthrough Query should enumerate all items');
end;

procedure TestTQueryIntegerGenerics.TestSkipEqualCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(LSkipCount) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = 0, 'Skip of Collection.Count should have enumerated zero items');
end;

procedure TestTQueryIntegerGenerics.TestSkipGreaterThanCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count + 2;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(LSkipCount) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = 0, 'Skip of Collection.Count + 2 should have enumerated zero items');
end;

procedure TestTQueryIntegerGenerics.TestSkipLowerThanCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count - 2;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(LSkipCount) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = 2, 'Skip of Collection.Count - 2 should have enumerated 2 items');
end;

procedure TestTQueryIntegerGenerics.TestSkipWhere;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in GenericQuery<Integer>.Select
             .From(FIntegerCollection)
             .Skip(5)
             .Where(LEvenNumbers) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = 3, 'Should enumerate even numbered items after 5');
end;

procedure TestTQueryIntegerGenerics.TestSkipWhile;
var
  LEnumerationCount, I : Integer;
  LFourOrLess : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).SkipWhile(LFourOrLess) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = 6, 'SkipWhile 4 or less should have enumerated 6 items');
end;

procedure TestTQueryIntegerGenerics.TestSkipWhileFalse;
var
  LEnumerationCount, I : Integer;
  LFalsePredicate : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LFalsePredicate := function (Value : Integer) : Boolean
                     begin
                       Result := False;
                     end;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).SkipWhile(LFalsePredicate) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = FIntegerCollection.Count, 'SkipWhile False should have enumerated all items');
end;

procedure TestTQueryIntegerGenerics.TestSkipWhileTrue;
var
  LEnumerationCount, I : Integer;
  LTruePredicate : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LTruePredicate := function (Value : Integer) : Boolean
                     begin
                       Result := True;
                     end;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).SkipWhile(LTruePredicate) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = 0, 'SkipWhile True should have enumerated zero items');
end;

procedure TestTQueryIntegerGenerics.TestSkipZero;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := 0;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Skip(LSkipCount) do
  begin
    Inc(LEnumerationCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LEnumerationCount = FIntegerCollection.Count, 'Skip of zero should have enumerated all items');
end;

procedure TestTQueryIntegerGenerics.TestWhereEven;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Where(LEvenNumbers) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;
  Check(LPassCount = 5, 'Should enumerate even numbered items');
end;

procedure TestTQueryIntegerGenerics.TestWhereAll;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := True;
                  end;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Where(LEvenNumbers) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = 10, 'Should enumerate all items');
end;

procedure TestTQueryIntegerGenerics.TestWhereTake;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in GenericQuery<Integer>.Select
             .From(FIntegerCollection)
             .Where(LEvenNumbers)
             .Take(3) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = 3, 'Should enumerate the first 3 even numbered items');
end;

procedure TestTQueryIntegerGenerics.TestWhereNone;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value > 10;
                  end;

  for I in GenericQuery<Integer>.Select.From(FIntegerCollection).Where(LEvenNumbers) do
  begin
    Inc(LPassCount);
    DummyInt := i;   // just to suppress warning about not using I
  end;

  Check(LPassCount = 0, 'Should enumerate no items');
end;

procedure TestTQueryIntegerGenerics.TestWhereSkip;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in GenericQuery<Integer>.Select
             .From(FIntegerCollection)
             .Where(LEvenNumbers)
             .Skip(3) do
  begin
    Inc(LPassCount);
    DummyInt := i;  // just to suppress warning about not using I
  end;

  Check(LPassCount = 2, 'Should enumerate 8 and 10, the last 2 even numbered items');
end;




initialization
  // Register any test cases with the test runner
  RegisterTest('Generics/TList<Integer>', TestTQueryIntegerGenerics.Suite);
end.

