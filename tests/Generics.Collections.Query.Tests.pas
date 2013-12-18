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
    procedure TestSkipWhileTrue;
    procedure TestSkipWhileFalse;
    procedure TestSkipWhile;
    procedure TestTakeWhileFalse;
    procedure TestTakeWhileTrue;
    procedure TestTakeWhile;
    procedure TestList;
    procedure TestFirst;
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
    procedure TestObjectList;
  end;


implementation
uses
  System.SysUtils, System.Classes;

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

  for I in Query<Integer>
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

  for I in Query<Integer>.From(FIntegerCollection).TakeWhile(LFourOrLess) do
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

  for I in Query<Integer>.From(FIntegerCollection).TakeWhile(LFalse) do
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

  for I in Query<Integer>.From(FIntegerCollection).TakeWhile(LTrue) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = FIntegerCollection.Count, 'TakeWhile True should have enumerated all items');
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

procedure TestTQueryInteger.TestFirst;
var
  LPassCount, I : Integer;
begin
  LPassCount := 0;

  for I in Query<Integer>.From(FIntegerCollection).First do
    Inc(LPassCount);

  Check(LPassCount = 1, 'First on a non-empty collection should enumerate one item');
end;

procedure TestTQueryInteger.TestList;
var
  LIntegerList : TList<Integer>;
  LFourOrLess : TPredicate<Integer>;
begin
  LFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;


  LIntegerList := List<Integer>.From(Query<Integer>
                                      .From(FIntegerCollection)
                                      .TakeWhile(LFourOrLess));
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

  for I in Query<Integer>
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

  for I in Query<Integer>.From(FIntegerCollection).SkipWhile(LFourOrLess) do
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

  for I in Query<Integer>.From(FIntegerCollection).SkipWhile(LFalsePredicate) do
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

  for I in Query<Integer>.From(FIntegerCollection).SkipWhile(LTruePredicate) do
    Inc(LEnumerationCount);

  Check(LEnumerationCount = 0, 'SkipWhile True should have enumerated zero items');
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

  for I in Query<Integer>
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

  for I in Query<Integer>
             .From(FIntegerCollection)
             .Where(LEvenNumbers)
             .Skip(3) do
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

procedure TestTQueryPerson.TestObjectList;
var
  LPersonList : TList<TPerson>;
  L18OrMore : TPredicate<TPerson>;
begin
  L18OrMore := function (Value : TPerson) : Boolean
               begin
                 Result := Value.Age >= 18;
               end;


  LPersonList := ObjectList<TPerson>.From(Query<TPerson>
                                            .From(FPersonCollection)
                                            .Where(L18OrMore),
                                          False);
  try
    Check(LPersonList.Count = 2, 'Should have 4 items in list');
    Check(LPersonList.Items[0].Name = 'Malcolm', 'First item should be Malcolm');
    Check(LPersonList.Items[1].Name = 'Julie', 'Second item should be Julie');
  finally
    LPersonList.Free;
  end;
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

