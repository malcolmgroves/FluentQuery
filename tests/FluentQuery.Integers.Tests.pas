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
  FluentQuery.Integers,
  FLuentQuery.Tests.Base,
  System.SysUtils;

type
  TestTQueryInteger = class(TFluentQueryIntegerTestCase)
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
    procedure TestSkipWhileUnboundQuery;
    procedure TestTakeWhileFalse;
    procedure TestTakeWhileTrue;
    procedure TestTakeWhile;
    procedure TestTakeWhileLessEqual4Evens;
    procedure TestTake5Evens;
    procedure TestTake1;
    procedure TestTakeWhileUnboundQuery;
    procedure TestTakeWhileUnboundQueryEvens;
    procedure TestSkipWhileUnboundQueryTakeWhileUnbundQuery;
    procedure TestTakeUntil;
    procedure TestSkipUntil;
    procedure TestSkipUntilTakeUntil;
    procedure TestTakeUntilUnboundQuery;
    procedure TestSkipUntilUnboundQuery;
    procedure TestSkipUntilUnboundQueryTakeUntilUnboundQuery;
    procedure TestTakeBetweenUnboundQueries;
    procedure TestTakeBetweenValues;
    procedure TestCreateList;
    procedure TestFirst;
    procedure TestFirstOnEmpty;
    procedure TestSum;
    procedure TestAverage;
    procedure TestAverageEmptyResultSet;
    procedure TestMax;
    procedure TestMin;
    procedure TestMapInc;
    procedure TestMapIncEvens;
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
//    procedure TestPerf;
  end;


implementation
uses
  Math, FluentQuery.Core.Types, System.Diagnostics;

var
  DummyInt : Integer; // used ot suppress warnings about unused Loop variable
  DummyDouble : Double;


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
begin
  CheckEquals(FIntegerCollection.Count, Query.From(FIntegerCollection).Take(FIntegerCollection.Count).Count);
end;

procedure TestTQueryInteger.TestTakeGreaterThanCount;
begin
  CheckEquals(FIntegerCollection.Count, Query.From(FIntegerCollection).Take(FIntegerCollection.Count + 1).Count);
end;

procedure TestTQueryInteger.TestTakeLowerThanCount;
begin
  CheckEquals(FIntegerCollection.Count - 1, Query.From(FIntegerCollection).Take(FIntegerCollection.Count - 1).Count);
end;

procedure TestTQueryInteger.TestTakeUntil;
begin
  CheckEquals(8, Query.From(FIntegerCollection).TakeUntil(9).Count);
end;

procedure TestTQueryInteger.TestTakeUntilUnboundQuery;
begin
  CheckEquals(8, Query.From(FIntegerCollection).TakeUntil(Query.Equals(9)).Count);
end;

procedure TestTQueryInteger.TestTakeWhere;
begin
  CheckEquals(2, Query.From(FIntegerCollection).Take(5).Where(FEvenNumbers).Count);
end;

procedure TestTQueryInteger.TestTakeWhile;
begin
  CheckEquals(4, Query.From(FIntegerCollection).TakeWhile(FFourOrLess).Count);
end;

procedure TestTQueryInteger.TestTake1;
begin
  CheckEquals(1, Query.From(FIntegerCollection).Take(1).Count);
end;

procedure TestTQueryInteger.TestTake5Evens;
begin
  CheckEquals(2, Query.From(FIntegerCollection).Take(5).Even.Count);
end;

procedure TestTQueryInteger.TestTakeBetweenUnboundQueries;
begin
  CheckEquals(5, Query.From(FIntegerCollection).TakeBetween(Query.Equals(4), Query.Equals(9)).Count);
end;

procedure TestTQueryInteger.TestTakeBetweenValues;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query.From(FIntegerCollection).TakeBetween(4, 7) do
  begin
    Inc(LPassCount);
    case LPassCount of
      1 : CheckEquals(4, I);
      2 : CheckEquals(5, I);
      3 : CheckEquals(6, I);
    end;
    DummyInt := i;   // just to suppress warning about not using I
  end;

  CheckEquals(3, LPassCount);
end;

procedure TestTQueryInteger.TestTakeWhileFalse;
begin
  CheckEquals(0, Query.From(FIntegerCollection).TakeWhile(FFalsePredicate).Count);
end;

procedure TestTQueryInteger.TestTakeWhileLessEqual4Evens;
begin
  CheckEquals(2, Query.From(FIntegerCollection).TakeWhile(FFourOrLess).Even.Count);
end;

procedure TestTQueryInteger.TestTakeWhileTrue;
begin
  CheckEquals(FIntegerCollection.Count, Query.From(FIntegerCollection).TakeWhile(FTruePredicate).Count);
end;

procedure TestTQueryInteger.TestTakeWhileUnboundQuery;
begin
  CheckEquals(4, Query.From(FIntegerCollection).TakeWhile(Query.LessThanOrEquals(4)).Count);
end;

procedure TestTQueryInteger.TestTakeWhileUnboundQueryEvens;
begin
  CheckEquals(2, Query.From(FIntegerCollection).TakeWhile(Query.LessThanOrEquals(4)).Even.Count);
end;

procedure TestTQueryInteger.TestTakeZero;
begin
  CheckEquals(0, Query.From(FIntegerCollection).Take(0).Count);
end;

procedure TestTQueryInteger.TestFirst;
begin
  CheckEquals(2, Query.From(FIntegerCollection).Even.First);
end;

procedure TestTQueryInteger.TestFirstOnEmpty;
begin
  ExpectedException := EEmptyResultSetException;
  Query.From(FIntegerCollection).GreaterThan(1000).First;
  StopExpectingException;
end;

procedure TestTQueryInteger.TestIsEven;
begin
  CheckEquals(5, Query.From(FIntegerCollection).Even.Count);
end;

procedure TestTQueryInteger.TestIsNegative;
begin
  CheckEquals(0, Query.From(FIntegerCollection).Negative.Count);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(0);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(-10);
  FIntegerCollection.Add(-5);
  CheckEquals(4, Query.From(FIntegerCollection).Negative.Count);
end;

procedure TestTQueryInteger.TestIsOdd;
begin
  CheckEquals(5, Query.From(FIntegerCollection).Odd.Count);
end;

procedure TestTQueryInteger.TestIsPositive;
begin
  CheckEquals(10, Query.From(FIntegerCollection).Positive.Count);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(0);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(-10);
  FIntegerCollection.Add(-5);
  CheckEquals(10, Query.From(FIntegerCollection).Positive.Count);
end;

procedure TestTQueryInteger.TestIsZero;
begin
  CheckEquals(0, Query.From(FIntegerCollection).Zero.Count);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(0);
  FIntegerCollection.Add(-1);
  FIntegerCollection.Add(-10);
  FIntegerCollection.Add(-5);
  CheckEquals(1, Query.From(FIntegerCollection).Zero.Count);
end;

procedure TestTQueryInteger.TestMapInc;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query
             .From(FIntegerCollection)
             .Map(FInc) do
  begin
    Inc(LPassCount);
    case LPassCount of
      1 : CheckEquals(2, I);
      2 : CheckEquals(3, I);
      3 : CheckEquals(4, I);
      4 : CheckEquals(5, I);
      5 : CheckEquals(6, I);
      6 : CheckEquals(7, I);
      7 : CheckEquals(8, I);
      8 : CheckEquals(5, I);
      9 : CheckEquals(10, I);
      10 : CheckEquals(11, I);
    end;
  end;
  CheckEquals(10, LPassCount);
end;

procedure TestTQueryInteger.TestMapIncEvens;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query
             .From(FIntegerCollection)
             .Where(Query.Even.Predicate)
             .Map(FInc) do
  begin
    Inc(LPassCount);
    case LPassCount of
      1 : CheckEquals(3, I);
      2 : CheckEquals(5, I);
      3 : CheckEquals(7, I);
      4 : CheckEquals(5, I);
      5 : CheckEquals(11, I);
    end;
  end;
  CheckEquals(5, LPassCount);
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
begin
  CheckExpectedCountWithInnerCheck(Query.From(FIntegerCollection).WhereNot(FEvenNumbers),
                                   function (Value : Integer) : Boolean
                                   begin
                                    Result := Value mod 2 <> 0;
                                   end,
                                   5,
                                   'Should only enumerate odd numbered items');
end;

procedure TestTQueryInteger.TestWhereNotWhereEven;
begin
  CheckExpectedCountWithInnerCheck(Query.From(FIntegerCollection).WhereNot(Query.Where(FEvenNumbers)),
                                   function (Value : Integer) : Boolean
                                   begin
                                    Result := Value mod 2 <> 0;
                                   end,
                                   5,
                                   'Should only enumerate odd numbered items');
end;

procedure TestTQueryInteger.TestAverage;
begin
  Check(SameValue(Query.From(FIntegerCollection).Average, 5.1), 'Average should return 5.1');
  Check(SameValue(Query.From(FIntegerCollection).Even.Average, 5.2), 'Even.Average should return 5.2');
end;

procedure TestTQueryInteger.TestAverageEmptyResultSet;
begin
  ExpectedException := EEmptyResultSetException;
  DummyDouble := Query.From(FIntegerCollection).Zero.Average;
  StopExpectingException('Calling Average on an Empty ResultSet should fail');
end;

procedure TestTQueryInteger.TestCreateList;
var
  LIntegerList : TList<Integer>;
begin
  LIntegerList := Query
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

procedure TestTQueryInteger.TestPassThrough;
begin
  CheckEquals(FIntegerCollection.Count, Query.From(FIntegerCollection).Count);
end;

procedure TestTQueryInteger.TestSkipEqualCount;
begin
  CheckEquals(0, Query.From(FIntegerCollection).Skip(FIntegerCollection.Count).Count);
end;

procedure TestTQueryInteger.TestSkipGreaterThanCount;
begin
  CheckEquals(0, Query.From(FIntegerCollection).Skip(FIntegerCollection.Count + 2).Count);
end;

procedure TestTQueryInteger.TestSkipLowerThanCount;
begin
  CheckEquals(2, Query.From(FIntegerCollection).Skip(FIntegerCollection.Count - 2).Count);
end;

procedure TestTQueryInteger.TestSkipUntil;
begin
  CheckEquals(7, Query.From(FIntegerCollection).SkipUntil(4).Count);
end;

procedure TestTQueryInteger.TestSkipUntilTakeUntil;
begin
  CheckEquals(5, Query.From(FIntegerCollection).SkipUntil(4).TakeUntil(9).Count);
end;

procedure TestTQueryInteger.TestSkipUntilUnboundQuery;
begin
  CheckEquals(7, Query.From(FIntegerCollection).SkipUntil(Query.Equals(4)).Count);
end;

procedure TestTQueryInteger.TestSkipUntilUnboundQueryTakeUntilUnboundQuery;
begin
  CheckEquals(5, Query.From(FIntegerCollection).SkipUntil(Query.Equals(4)).TakeUntil(Query.Equals(9)).Count);
end;

procedure TestTQueryInteger.TestSkipWhere;
begin
  CheckEquals(3, Query.From(FIntegerCollection).Skip(5).Where(FEvenNumbers).Count);
end;

procedure TestTQueryInteger.TestSkipWhile;
begin
  CheckEquals(6, Query.From(FIntegerCollection).SkipWhile(FFourOrLess).Count);
end;

procedure TestTQueryInteger.TestSkipWhileFalse;
begin
  CheckEquals(FIntegerCollection.Count, Query.From(FIntegerCollection).SkipWhile(FFalsePredicate).Count);
end;

procedure TestTQueryInteger.TestSkipWhileTrue;
begin
  CheckEquals(0, Query.From(FIntegerCollection).SkipWhile(FTruePredicate).Count);
end;

procedure TestTQueryInteger.TestSkipWhileUnboundQuery;
begin
  CheckEquals(6, Query.From(FIntegerCollection).SkipWhile(Query.LessThanOrEquals(4)).Count);
end;

procedure TestTQueryInteger.TestSkipWhileUnboundQueryTakeWhileUnbundQuery;
begin
  CheckEquals(4, Query.From(FIntegerCollection).TakeWhile(Query.LessThanOrEquals(8)).SkipWhile(Query.LessThanOrEquals(4)).Count);
end;

procedure TestTQueryInteger.TestSkipZero;
begin
  CheckEquals(FIntegerCollection.Count, Query.From(FIntegerCollection).Skip(0).Count);
end;

procedure TestTQueryInteger.TestSum;
begin
  CheckEquals(51, Query.From(FIntegerCollection).Sum);
  CheckEquals(26, Query.From(FIntegerCollection).Even.Sum);
end;

procedure TestTQueryInteger.TestWhereEven;
begin
  CheckEquals(5, Query.From(FIntegerCollection).Where(FEvenNumbers).Count);
end;

procedure TestTQueryInteger.TestWhereAll;
begin
  CheckEquals(10, Query.From(FIntegerCollection).Where(FTruePredicate).Count);
end;

procedure TestTQueryInteger.TestWhereTake;
begin
  CheckEquals(3, Query.From(FIntegerCollection).Where(FEvenNumbers).Take(3).Count);
end;

procedure TestTQueryInteger.TestWhereNone;
begin
  CheckEquals(0, Query.From(FIntegerCollection).Where(FGreaterThanTen).Take(3).Count);
end;

procedure TestTQueryInteger.TestWhereSkip;
begin
  CheckEquals(2, Query.From(FIntegerCollection).Where(FEvenNumbers).Skip(3).Count);
end;



{ TestIntegerRange }

procedure TestIntegerRange.Test0To0PassThrough;
begin
  CheckEquals(1, Range(0, 0).Count);
end;

procedure TestIntegerRange.Test0To10PassThrough;
begin
  CheckEquals(11, Range(0, 10).Count);
end;

procedure TestIntegerRange.Test1To10Evens;
begin
  CheckEquals(5, Range(1, 10).Even.Count);
end;

procedure TestIntegerRange.Test1To10PassThrough;
begin
  CheckEquals(10, Range(1, 10).Count);
end;

procedure TestIntegerRange.TestEndAtMaxIntPassThrough;
begin
  CheckEquals(11, Range(MaxInt - 10).Count);
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
begin
  CheckEquals(11, Range(-10, 0).Count);
end;

procedure TestIntegerRange.TestNegativeToPositivePassThrough;
begin
  CheckEquals(21, Range(-10, 10).Count);
end;

//procedure TestIntegerRange.TestPerf;
//var
//  LPassCount, I : Integer;
//  LStopWatch : TStopWatch;
//begin
//  LPassCount := 0;
//
//  LStopWatch := TStopwatch.StartNew;
//  try
//    for I in Range(-1000000, 1000000).Positive.Even.GreaterThan(3000) do
//    begin
//      Inc(LPassCount);
//      DummyInt := i;   // just to suppress warning about not using I
//    end;
//  finally
//    LStopWatch.Stop;
//  end;
//  Check(LStopWatch.ElapsedMilliseconds < 0, Format('Slow! Expected %d Actual %d', [0, LStopWatch.ElapsedMilliseconds]));
//end;

procedure TestIntegerRange.TestReverseEndAtNegativeMaxIntPassThrough;
begin
  CheckEquals(11, Range(-MaxInt + 10, -MaxInt).Count);
end;

procedure TestIntegerRange.TestReverseStartAtMaxIntPassThrough;
begin
  CheckEquals(11, Range(MaxInt, MaxInt - 10).Count);
end;

procedure TestIntegerRange.TestStartAtNegativeMaxIntPassThrough;
begin
  CheckEquals(11, Range(-MaxInt, -MaxInt + 10).Count);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Integers/TList<Integer>', TestTQueryInteger.Suite);
  RegisterTest('Integers/Range', TestIntegerRange.Suite);
end.

