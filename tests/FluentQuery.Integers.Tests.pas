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

unit FluentQuery.Integers.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.Integers;

type
  TestTQueryInteger = class(TTestCase)
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
    procedure TestWhereEven;
    procedure TestIsEven;
    procedure TestIsOdd;
    procedure TestIsPositive;
    procedure TestIsNegative;
    procedure TestIsZero;
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
    procedure TestSum;
    procedure TestAverage;
    procedure TestAverageEmptyResultSet;
    procedure TestMax;
    procedure TestMin;
  end;

  TestIntegerRange = class(TTestCase)
  published
    procedure Test1To10PassThrough;
    procedure Test0To10PassThrough;
    procedure TestNegativeToPositivePassThrough;
    procedure TestNegativeTo0PassThrough;
    procedure Test0To0PassThrough;
    procedure TestStartAtNegativeMaxIntPassThrough;
    procedure TestEndAtMaxIntPassThrough;
    procedure TestMinGreaterThanMax;
    procedure TestReverseStartAtMaxIntPassThrough;
    procedure TestReverseEndAtNegativeMaxIntPassThrough;
    procedure Test1To10Evens;
  end;


implementation
uses
  System.SysUtils, Math, FluentQuery.Core.Types;

procedure TestTQueryInteger.SetUp;
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

procedure TestTQueryInteger.TearDown;
begin
  FIntegerCollection.Free;
  FIntegerCollection := nil;
end;


procedure TestTQueryInteger.TestTakeEqualCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count;
  for I in Query.From(FIntegerCollection).Take(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = MaxPassCount, 'Take = Collection.Count should enumerate all items');
end;

procedure TestTQueryInteger.TestTakeGreaterThanCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count + 1;
  for I in Query.From(FIntegerCollection).Take(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = FIntegerCollection.Count, 'Take > collection.count should enumerate all items');
end;

procedure TestTQueryInteger.TestTakeLowerThanCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count - 1;

  for I in Query.From(FIntegerCollection).Take(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = MaxPassCount, 'Take < collection.count should not enumerate all items');
end;

procedure TestTQueryInteger.TestTakeWhere;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query
             .From(FIntegerCollection)
             .Take(5)
             .Where(LEvenNumbers) do
    Inc(LPassCount);

  Check(LPassCount = 2, 'Should enumerate even numbered items in the first 5');
end;

procedure TestTQueryInteger.TestTakeWhile;
var
  LEnumerationCount, I : Integer;
  LFourOrLess : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;

  for I in Query
             .From(FIntegerCollection)
             .TakeWhile(LFourOrLess) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 4, 'TakeWhile 4 or less should have enumerated 4 items');
end;

procedure TestTQueryInteger.TestTakeWhileFalse;
var
  LEnumerationCount, I : Integer;
  LFalse : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LFalse := function (Value : Integer) : Boolean
            begin
              Result := False;
            end;

  for I in Query.From(FIntegerCollection).TakeWhile(LFalse) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 0, 'TakeWhile False should have enumerated zero items');
end;

procedure TestTQueryInteger.TestTakeWhileTrue;
var
  LEnumerationCount, I : Integer;
  LTrue : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LTrue := function (Value : Integer) : Boolean
           begin
             Result := True;
           end;

  for I in Query.From(FIntegerCollection).TakeWhile(LTrue) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = FIntegerCollection.Count, 'TakeWhile True should have enumerated all items');
end;

procedure TestTQueryInteger.TestTakeZero;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := 0;
  for I in Query.From(FIntegerCollection).Take(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = MaxPassCount, 'Take = 0 should enumerate no items');
end;

procedure TestTQueryInteger.TestFirst;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query.From(FIntegerCollection).First do
    Inc(LPassCount);

  Check(LPassCount = 1, 'First on a non-empty collection should enumerate one item');
end;

procedure TestTQueryInteger.TestIsEven;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query.From(FIntegerCollection).Even do
    Inc(LPassCount);
  Check(LPassCount = 5, 'Should enumerate even numbered items');
end;

procedure TestTQueryInteger.TestIsNegative;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query.From(FIntegerCollection).Negative do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Should enumerate zero items');

  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(0);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(-10);
  FIntegerCollection.Add(-5);

  LPassCount := 0;
  for I in Query.From(FIntegerCollection).Negative do
    Inc(LPassCount);
  Check(LPassCount = 4, 'Should enumerate four items');
end;

procedure TestTQueryInteger.TestIsOdd;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query.From(FIntegerCollection).Odd do
    Inc(LPassCount);
  Check(LPassCount = 5, 'Should enumerate odd numbered items');
end;

procedure TestTQueryInteger.TestIsPositive;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query.From(FIntegerCollection).Positive do
    Inc(LPassCount);
  Check(LPassCount = 10, 'Should enumerate ten items');

  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(0);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(-10);
  FIntegerCollection.Add(-5);

  LPassCount := 0;
  for I in Query.From(FIntegerCollection).Positive do
    Inc(LPassCount);
  Check(LPassCount = 10, 'Should enumerate ten items');
end;

procedure TestTQueryInteger.TestIsZero;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query.From(FIntegerCollection).Zero do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Should enumerate zero items');

  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(0);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(-10);
  FIntegerCollection.Add(-5);

  LPassCount := 0;
  for I in Query.From(FIntegerCollection).Zero do
    Inc(LPassCount);
  Check(LPassCount = 1, 'Should enumerate one item');
end;

procedure TestTQueryInteger.TestMax;
var
  Value : Integer;
begin
  Value := Query.From(FIntegerCollection).Max;
  Check(Value = 10, 'Max should return 10');

  Value := Query.From(FIntegerCollection).Odd.Max;
  Check(Value = 9, 'Odd.Max should return 9');
end;

procedure TestTQueryInteger.TestMin;
var
  Value : Integer;
begin
  Value := Query.From(FIntegerCollection).Min;
  Check(Value = 1, 'Min should return 1');

  Value := Query.From(FIntegerCollection).Even.Min;
  Check(Value = 2, 'Even.Min should return 2');
end;

procedure TestTQueryInteger.TestWhereNotEven;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query
             .From(FIntegerCollection)
             .WhereNot(LEvenNumbers) do
  begin
    Inc(LPassCount);
    Check(I mod 2 <> 0,
          'Should enumerate odd numbered items, but enumerated ' + I.ToString);
  end;
  Check(LPassCount = 5, 'Should enumerate even numbered items');
end;

procedure TestTQueryInteger.TestWhereNotWhereEven;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query
             .From(FIntegerCollection)
             .WhereNot(Query.Where(LEvenNumbers)) do
  begin
    Inc(LPassCount);
    Check(I mod 2 <> 0,
          'Should enumerate odd numbered items, but enumerated ' + I.ToString);
  end;
  Check(LPassCount = 5, 'Should enumerate even numbered items');
end;

procedure TestTQueryInteger.TestAverage;
var
  Value : Double;
begin
  Value := Query.From(FIntegerCollection).Average;
  Check(SameValue(Value, 5.1), 'Average should return 5.1');

  Value := Query.From(FIntegerCollection).Even.Average;
  Check(SameValue(Value, 5.2), 'Even.Average should return 5.2');
end;

procedure TestTQueryInteger.TestAverageEmptyResultSet;
var
  Value : Double;
begin
  ExpectedException := EEmptyResultSetException;
  Value := Query.From(FIntegerCollection).Zero.Average;
  StopExpectingException('Calling Average on an Empty ResultSet should fail');
end;

procedure TestTQueryInteger.TestCreateList;
var
  LIntegerList : TList<Integer>;
  LFourOrLess : TPredicate<Integer>;
begin
  LFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;


  LIntegerList := Query
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

procedure TestTQueryInteger.TestPassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;
  for I in Query.From(FIntegerCollection) do
    Inc(LPassCount);
  Check(LPassCount = FIntegerCollection.Count, 'Passthrough Query should enumerate all items');
end;

procedure TestTQueryInteger.TestSkipEqualCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count;

  for I in Query.From(FIntegerCollection).Skip(LSkipCount) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 0, 'Skip of Collection.Count should have enumerated zero items');
end;

procedure TestTQueryInteger.TestSkipGreaterThanCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count + 2;

  for I in Query.From(FIntegerCollection).Skip(LSkipCount) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 0, 'Skip of Collection.Count + 2 should have enumerated zero items');
end;

procedure TestTQueryInteger.TestSkipLowerThanCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count - 2;

  for I in Query.From(FIntegerCollection).Skip(LSkipCount) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 2, 'Skip of Collection.Count - 2 should have enumerated 2 items');
end;

procedure TestTQueryInteger.TestSkipWhere;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query
             .From(FIntegerCollection)
             .Skip(5)
             .Where(LEvenNumbers) do
    Inc(LPassCount);

  Check(LPassCount = 3, 'Should enumerate even numbered items after 5');
end;

procedure TestTQueryInteger.TestSkipWhile;
var
  LEnumerationCount, I : Integer;
  LFourOrLess : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;

  for I in Query.From(FIntegerCollection).SkipWhile(LFourOrLess) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 6, 'SkipWhile 4 or less should have enumerated 6 items');
end;

procedure TestTQueryInteger.TestSkipWhileFalse;
var
  LEnumerationCount, I : Integer;
  LFalsePredicate : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LFalsePredicate := function (Value : Integer) : Boolean
                     begin
                       Result := False;
                     end;

  for I in Query.From(FIntegerCollection).SkipWhile(LFalsePredicate) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = FIntegerCollection.Count, 'SkipWhile False should have enumerated all items');
end;

procedure TestTQueryInteger.TestSkipWhileTrue;
var
  LEnumerationCount, I : Integer;
  LTruePredicate : TPredicate<Integer>;
begin
  LEnumerationCount := 0;
  LTruePredicate := function (Value : Integer) : Boolean
                     begin
                       Result := True;
                     end;

  for I in Query.From(FIntegerCollection).SkipWhile(LTruePredicate) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 0, 'SkipWhile True should have enumerated zero items');
end;

procedure TestTQueryInteger.TestSkipZero;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := 0;

  for I in Query.From(FIntegerCollection).Skip(LSkipCount) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = FIntegerCollection.Count, 'Skip of zero should have enumerated all items');
end;

procedure TestTQueryInteger.TestSum;
var
  Value : Integer;
begin
  Value := Query.From(FIntegerCollection).Sum;
  Check(Value = 51, 'Sum should return 51');

  Value := Query.From(FIntegerCollection).Even.Sum;
  Check(Value = 26, 'Even.Sum should return 26');
end;

procedure TestTQueryInteger.TestWhereEven;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query.From(FIntegerCollection).Where(LEvenNumbers) do
    Inc(LPassCount);
  Check(LPassCount = 5, 'Should enumerate even numbered items');
end;

procedure TestTQueryInteger.TestWhereAll;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := True;
                  end;

  for I in Query.From(FIntegerCollection).Where(LEvenNumbers) do
    Inc(LPassCount);

  Check(LPassCount = 10, 'Should enumerate all items');
end;

procedure TestTQueryInteger.TestWhereTake;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query
             .From(FIntegerCollection)
             .Where(LEvenNumbers)
             .Take(3) do
    Inc(LPassCount);

  Check(LPassCount = 3, 'Should enumerate the first 3 even numbered items');
end;

procedure TestTQueryInteger.TestWhereNone;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value > 10;
                  end;

  for I in Query.From(FIntegerCollection).Where(LEvenNumbers) do
    Inc(LPassCount);

  Check(LPassCount = 0, 'Should enumerate no items');
end;

procedure TestTQueryInteger.TestWhereSkip;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query
             .From(FIntegerCollection)
             .Where(LEvenNumbers)
             .Skip(3) do
    Inc(LPassCount);

  Check(LPassCount = 2, 'Should enumerate 8 and 10, the last 2 even numbered items');
end;



{ TestIntegerRange }

procedure TestIntegerRange.Test0To0PassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(0, 0) do
    Inc(LPassCount);

  CheckEquals(1, LPassCount);
end;

procedure TestIntegerRange.Test0To10PassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(0, 10) do
    Inc(LPassCount);

  CheckEquals(11, LPassCount);
end;

procedure TestIntegerRange.Test1To10Evens;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(1, 10).Even do
  begin
    Inc(LPassCount);
    CheckEquals(0, I mod 2);
  end;

  CheckEquals(5, LPassCount);
end;

procedure TestIntegerRange.Test1To10PassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(1, 10) do
    Inc(LPassCount);

  CheckEquals(10, LPassCount);
end;

procedure TestIntegerRange.TestEndAtMaxIntPassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(MaxInt - 10) do
    Inc(LPassCount);

  CheckEquals(11, LPassCount);
end;

procedure TestIntegerRange.TestMinGreaterThanMax;
var
  LPassCount, I, LPreviousI : Integer;
begin
  LPassCount := 0;
  LPreviousI := MaxInt;

  for I in Range(10, 1) do
  begin
    Inc(LPassCount);
    Check(I < LPreviousI, 'Should be counting down');
  end;

  CheckEquals(10, LPassCount);
end;

procedure TestIntegerRange.TestNegativeTo0PassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(-10, 0) do
    Inc(LPassCount);

  CheckEquals(11, LPassCount);
end;

procedure TestIntegerRange.TestNegativeToPositivePassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(-10, 10) do
    Inc(LPassCount);

  CheckEquals(21, LPassCount);
end;

procedure TestIntegerRange.TestReverseEndAtNegativeMaxIntPassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(-MaxInt + 10, -MaxInt) do
    Inc(LPassCount);

  CheckEquals(11, LPassCount);
end;

procedure TestIntegerRange.TestReverseStartAtMaxIntPassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(MaxInt, MaxInt - 10) do
    Inc(LPassCount);

  CheckEquals(11, LPassCount);
end;

procedure TestIntegerRange.TestStartAtNegativeMaxIntPassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Range(-MaxInt, -MaxInt + 10) do
    Inc(LPassCount);

  CheckEquals(11, LPassCount);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Integers/TList<Integer>', TestTQueryInteger.Suite);
  RegisterTest('Integers/Range', TestIntegerRange.Suite);
end.

