unit Generics.Collections.Query.Tests;

interface

uses
  TestFramework, System.Generics.Collections, Generics.Collections.Query;

type
  // Test methods for class TQueryEnumerator

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
    procedure TestWhere;
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
  end;

  TPerson = class
  public
    Name : string;
    Age : Integer;
    constructor Create(Name : string; Age : Integer);
  end;

  TestTQueryPerson = class(TTestCase)
  strict private
    FPersonCollection: TObjectList<TPerson>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
  end;


implementation
uses
  System.SysUtils;

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
  FIntegerCollection.Add(8);
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
  for I in Query<Integer>.From(FIntegerCollection).Take(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = MaxPassCount, 'Take = Collection.Count should enumerate all items');
end;

procedure TestTQueryInteger.TestTakeGreaterThanCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count + 1;
  for I in Query<Integer>.From(FIntegerCollection).Take(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = FIntegerCollection.Count, 'Take > collection.count should enumerate all items');
end;

procedure TestTQueryInteger.TestTakeLowerThanCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count - 1;

  for I in Query<Integer>.From(FIntegerCollection).Take(MaxPassCount) do
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

  for I in Query<Integer>.From(FIntegerCollection).Take(5).Where(LEvenNumbers) do
    Inc(LPassCount);

  Check(LPassCount = 2, 'Should enumerate even numbered items in the first 5');
end;

procedure TestTQueryInteger.TestTakeZero;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := 0;
  for I in Query<Integer>.From(FIntegerCollection).Take(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = MaxPassCount, 'Take = 0 should enumerate no items');
end;

procedure TestTQueryInteger.TestPassThrough;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;
  for I in Query<Integer>.From(FIntegerCollection) do
    Inc(LPassCount);
  Check(LPassCount = FIntegerCollection.Count, 'Passthrough Query should enumerate all items');
end;

procedure TestTQueryInteger.TestSkipEqualCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count;

  for I in Query<Integer>.From(FIntegerCollection).Skip(LSkipCount) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 0, 'Skip of Collection.Count should have enumerated zero items');
end;

procedure TestTQueryInteger.TestSkipGreaterThanCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count + 2;

  for I in Query<Integer>.From(FIntegerCollection).Skip(LSkipCount) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 0, 'Skip of Collection.Count + 2 should have enumerated zero items');
end;

procedure TestTQueryInteger.TestSkipLowerThanCount;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := FIntegerCollection.Count - 2;

  for I in Query<Integer>.From(FIntegerCollection).Skip(LSkipCount) do
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

  for I in Query<Integer>.From(FIntegerCollection).Skip(5).Where(LEvenNumbers) do
    Inc(LPassCount);

  Check(LPassCount = 3, 'Should enumerate even numbered items after 5');
end;

procedure TestTQueryInteger.TestSkipZero;
var
  LEnumerationCount, I, LSkipCount : Integer;
begin
  LEnumerationCount := 0;
  LSkipCount := 0;

  for I in Query<Integer>.From(FIntegerCollection).Skip(LSkipCount) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = FIntegerCollection.Count, 'Skip of zero should have enumerated all items');
end;

procedure TestTQueryInteger.TestWhere;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query<Integer>.From(FIntegerCollection).Where(LEvenNumbers) do
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

  for I in Query<Integer>.From(FIntegerCollection).Where(LEvenNumbers) do
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

  for I in Query<Integer>.From(FIntegerCollection).Where(LEvenNumbers).Take(3) do
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

  for I in Query<Integer>.From(FIntegerCollection).Where(LEvenNumbers) do
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

  for I in Query<Integer>.From(FIntegerCollection).Where(LEvenNumbers).Skip(3) do
    Inc(LPassCount);

  Check(LPassCount = 2, 'Should enumerate 8 and 10, the last 2 even numbered items');
end;

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

procedure TestTQueryPerson.TestPassThrough;
var
  LPassCount : Integer;
  LPerson : TPerson;
begin
  LPassCount := 0;
  for LPerson in Query<TPerson>.From(FPersonCollection) do
    Inc(LPassCount);
  Check(LPassCount = FPersonCollection.Count, 'Passthrough Query should enumerate all items');
end;


initialization
  // Register any test cases with the test runner
  RegisterTest('TQuery', TestTQueryInteger.Suite);
  RegisterTest('TQuery', TestTQueryPerson.Suite);
end.

