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
    procedure TestAtMostLowerThanCount;
    procedure TestAtMostEqualCount;
    procedure TestAtMostGreaterThanCount;
    procedure TestAtMostZero;
    procedure TestWhere;
    procedure TestWhereNone;
    procedure TestWhereAll;
    procedure TestWhereAtMost;
    procedure TestAtMostWhere;
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


procedure TestTQueryInteger.TestAtMostEqualCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count;
  for I in Query<Integer>.From(FIntegerCollection).AtMost(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = MaxPassCount, 'AtMost = Collection.Count should enumerate all items');
end;

procedure TestTQueryInteger.TestAtMostGreaterThanCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count + 1;
  for I in Query<Integer>.From(FIntegerCollection).AtMost(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = FIntegerCollection.Count, 'AtMost > collection.count should enumerate all items');
end;

procedure TestTQueryInteger.TestAtMostLowerThanCount;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := FIntegerCollection.Count - 1;

  for I in Query<Integer>.From(FIntegerCollection).AtMost(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = MaxPassCount, 'AtMost < collection.count should not enumerate all items');
end;

procedure TestTQueryInteger.TestAtMostWhere;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query<Integer>.From(FIntegerCollection).AtMost(5).Where(LEvenNumbers) do
    Inc(LPassCount);

  Check(LPassCount = 2, 'Should enumerate even numbered items in the first 5');
end;

procedure TestTQueryInteger.TestAtMostZero;
var
  LPassCount, I, MaxPassCount : Integer;
begin
  LPassCount := 0;
  MaxPassCount := 0;
  for I in Query<Integer>.From(FIntegerCollection).AtMost(MaxPassCount) do
    Inc(LPassCount);

  Check(LPassCount = MaxPassCount, 'AtMost = 0 should enumerate no items');
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

procedure TestTQueryInteger.TestWhereAtMost;
var
  LPassCount, I : Integer;
  LEvenNumbers : TPredicate<Integer>;
begin
  LPassCount := 0;

  LEvenNumbers := function (Value : Integer) : Boolean
                  begin
                    Result := Value mod 2 = 0;
                  end;

  for I in Query<Integer>.From(FIntegerCollection).Where(LEvenNumbers).AtMost(3) do
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

