unit FluentQuery.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery,
  System.Classes;

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
    procedure TestCreateList;
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
    procedure TestCreateObjectList;
  end;

  TestTQueryTStrings = class(TTestCase)
  strict private
    FStrings: TStrings;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestPassThrough;
    procedure TestSkipTake;
    procedure TestMatchesCaseSensitive;
    procedure TestNoMatchesCaseSensitive;
    procedure TestMatchesCaseInsensitive;
    procedure TestSkipTakeCreateStrings;
  end;

  TestTQueryString = class(TTestCase)
  strict private
    FStringCollection: TList<String>;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMatchesCaseSensitive;
    procedure TestNoMatchesCaseSensitive;
    procedure TestMatchesCaseInsensitive;
    procedure TestContainsCaseSensitive;
    procedure TestNotContainsCaseSensitive;
    procedure TestContainsCaseInsensitive;
    procedure TestStartsWithCaseSensitive;
    procedure TestNotStartsWithCaseSensitive;
    procedure TestStartsWithCaseInsensitive;
    procedure TestEndsWithCaseSensitive;
    procedure TestNotEndsWithCaseSensitive;
    procedure TestEndsWithCaseInsensitive;
  end;

  TestTQueryChar = class(TTestCase)
  strict private
    FStringVal: String;
  public
    procedure SetUp; override;
  published
    procedure TestPassthrough;
    procedure TestMatchesCaseSensitive;
    procedure TestNoMatchesCaseSensitive;
    procedure TestMatchesCaseInsensitive;
    procedure TestIsDigit;
    procedure TestIsInArray;
    procedure TestIsLetter;
    procedure TestIsLetterOrDigit;
    procedure TestIsLower;
    procedure TestIsNumber;
    procedure TestIsPunctuation;
    procedure TestIsSymbol;
    procedure TestIsUpper;
    procedure TestIsWhiteSpace;
    procedure TestIsUpperSkipTake;
    procedure TestCreateStringFromIsUpperSkipTake;
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
  end;

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

procedure TestTQueryInteger.TestCreateList;
var
  LIntegerList : TList<Integer>;
  LFourOrLess : TPredicate<Integer>;
begin
  LFourOrLess := function (Value : Integer) : Boolean
                 begin
                   Result := Value <= 4;
                 end;


  LIntegerList := CreateTList<Integer>.From(Query<Integer>
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

procedure TestTQueryPerson.TestCreateObjectList;
var
  LPersonList : TList<TPerson>;
  L18OrMore : TPredicate<TPerson>;
begin
  L18OrMore := function (Value : TPerson) : Boolean
               begin
                 Result := Value.Age >= 18;
               end;


  LPersonList := CreateTObjectList<TPerson>.From(Query<TPerson>
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


{ TestTQueryTStrings }

procedure TestTQueryTStrings.SetUp;
begin
  inherited;
  FStrings := TStringList.Create;
  FStrings.Add('1');
  FStrings.Add('2');
  FStrings.Add('3');
  FStrings.Add('4');
  FStrings.Add('5');
  FStrings.Add('6');
  FStrings.Add('7');
  FStrings.Add('8');
  FStrings.Add('9');
  FStrings.Add('10');
end;

procedure TestTQueryTStrings.TearDown;
begin
  FStrings.Free;
  inherited;
end;

procedure TestTQueryTStrings.TestMatchesCaseInsensitive;
var
  LPassCount : Integer;
  LString : String;
  LNameStrings : TStrings;
begin
  LNameStrings := TStringList.Create;
  try
    LNameStrings.Add('Malcolm');
    LNameStrings.Add('Julie');
    LNameStrings.Add('Jesse');
    LNameStrings.Add('Lauren');

    LPassCount := 0;
    for LString in StringQuery.From(LNameStrings).Matches('jesse') do
      Inc(LPassCount);
    Check(LPassCount = 1, 'Case Insensitive Matches Query should enumerate one string');
  finally
    LNameStrings.Free;
  end;
end;

procedure TestTQueryTStrings.TestMatchesCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
  LNameStrings : TStrings;
begin
  LNameStrings := TStringList.Create;
  try
    LNameStrings.Add('Malcolm');
    LNameStrings.Add('Julie');
    LNameStrings.Add('Jesse');
    LNameStrings.Add('Lauren');

    LPassCount := 0;
    for LString in StringQuery.From(LNameStrings).Matches('Jesse', False) do
      Inc(LPassCount);
    Check(LPassCount = 1, 'Case Sensitive Matches Query should enumerate one string');
  finally
    LNameStrings.Free;
  end;
end;

procedure TestTQueryTStrings.TestNoMatchesCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
  LNameStrings : TStrings;
begin
  LNameStrings := TStringList.Create;
  try
    LNameStrings.Add('Malcolm');
    LNameStrings.Add('Julie');
    LNameStrings.Add('Jesse');
    LNameStrings.Add('Lauren');

    LPassCount := 0;
    for LString in StringQuery.From(LNameStrings).Matches('jesse', False) do
      Inc(LPassCount);
    Check(LPassCount = 0, 'Case Sensitive Matches Query with no matches should enumerate zero strings');
  finally
    LNameStrings.Free;
  end;
end;

procedure TestTQueryTStrings.TestPassThrough;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in StringQuery.From(FStrings) do
    Inc(LPassCount);
  Check(LPassCount = FStrings.Count, 'Passthrough Query should enumerate all strings');
end;

procedure TestTQueryTStrings.TestSkipTake;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
//  for LString in StringQuery
//                   .From(FStrings)
//                   .Skip(4)
//                   .Take(3) do
  for LString in StringQuery
                   .From(FStrings)
                   .Skip(4)
                   .Take(3)do
  begin
    Inc(LPassCount);
    Check((LString = '5') or (LString = '6') or (LString = '7'), 'Should Enumerate 5, 6 and 7');
  end;
  Check(LPassCount = 3, 'Take(3) should enumerate 3 strings');
end;


procedure TestTQueryTStrings.TestSkipTakeCreateStrings;
var
  LStrings : TStrings;
begin

  LStrings := CreateTStrings.From(StringQuery
                             .From(FStrings)
                             .Skip(4)
                             .Take(3));
  try                   
    Check(LStrings.Count = 3, 'Should contain 3 strings');
  finally
    LStrings.Free;
  end;
end;

{ TestTQueryString }

procedure TestTQueryString.SetUp;
begin
  inherited;
  FStringCollection := TList<String>.Create;
  FStringCollection.Add('One');
  FStringCollection.Add('Two');
  FStringCollection.Add('Three');
  FStringCollection.Add('Four');
  FStringCollection.Add('Five');
  FStringCollection.Add('Six');
  FStringCollection.Add('Seven');
  FStringCollection.Add('Eight');
  FStringCollection.Add('Nine');
  FStringCollection.Add('Ten');
end;

procedure TestTQueryString.TearDown;
begin
  inherited;
  FStringCollection.Free;
end;

procedure TestTQueryString.TestContainsCaseInsensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in StringQuery.From(FStringCollection).Contains('e') do
    Inc(LPassCount);
  Check(LPassCount = 7, 'Case Insensitive Contains ''e'' Query should enumerate seven strings');
end;

procedure TestTQueryString.TestContainsCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in StringQuery.From(FStringCollection).Contains('e', False) do
    Inc(LPassCount);
  Check(LPassCount = 6, 'Case Sensitive Contains ''e'' Query should enumerate six strings');
end;

procedure TestTQueryString.TestEndsWithCaseInsensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  FStringCollection.Add('seventeeN');

  for LString in StringQuery.From(FStringCollection).EndsWith('n') do
    Inc(LPassCount);
  Check(LPassCount = 3, 'Case Insensitive EndsWith ''n'' Query should enumerate three strings');
end;

procedure TestTQueryString.TestEndsWithCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  FStringCollection.Add('seventeeN');

  for LString in StringQuery.From(FStringCollection).EndsWith('n', False) do
    Inc(LPassCount);
  Check(LPassCount = 2, 'Case Sensitive EndsWith ''n'' Query should enumerate two strings');
end;

procedure TestTQueryString.TestMatchesCaseInsensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in StringQuery.From(FStringCollection).Matches('six') do
    Inc(LPassCount);
  Check(LPassCount = 1, 'Case Insensitive Matches Query should enumerate one string');
end;

procedure TestTQueryString.TestMatchesCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
//  for LString in StringQuery.From(FStringCollection).Matches('Six', False) do
  for LString in StringQuery.From(FStringCollection).Matches('Six', False) do
    Inc(LPassCount);
  Check(LPassCount = 1, 'Case Sensitive Matches Query should enumerate one string');
end;

procedure TestTQueryString.TestNoMatchesCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in StringQuery.From(FStringCollection).Matches('six', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive Matches Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestNotContainsCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in StringQuery.From(FStringCollection).Contains('s', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive Contains ''s'' Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestNotEndsWithCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in StringQuery.From(FStringCollection).EndsWith('N', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive EndsWith ''N'' Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestNotStartsWithCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in StringQuery.From(FStringCollection).StartsWith('s', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive StartsWith ''s'' Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestStartsWithCaseInsensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  FStringCollection.Add('seventeen');

  for LString in StringQuery.From(FStringCollection).StartsWith('S') do
    Inc(LPassCount);
  Check(LPassCount = 3, 'Case Insensitive StartsWith ''S'' Query should enumerate three strings');
end;

procedure TestTQueryString.TestStartsWithCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  FStringCollection.Add('seventeen');

  for LString in StringQuery.From(FStringCollection).StartsWith('S', False) do
    Inc(LPassCount);
  Check(LPassCount = 2, 'Case Sensitive StartsWith ''S'' Query should enumerate two strings');
end;

{ TestTQueryChar }

procedure TestTQueryChar.SetUp;
begin
  inherited;
  //NB: no lowercase z
  FStringVal := 'abcdefghijklmnopqrstuvwxy 1234567890 !@#$%^&*() ABCDEFGHIJKLMNOPQRSTUVWXYZ';
end;


procedure TestTQueryChar.TestCreateStringFromIsUpperSkipTake;
var
  LResultString : String;
begin
  LResultString := CreateString.From(Query<Char>
                                    .From(FStringVal)
                                    .IsUpper
                                    .Skip(5)
                                    .Take(4));

  Check(LResultString.Length = 4, 'Take(4) should enumerate 4 chars');
  Check(LResultString = 'FGHI', 'IsUpper.Skip(5).Take(4) should enumerate F, G, H and then I');
end;

procedure TestTQueryChar.TestIsDigit;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsDigit do
    Inc(LPassCount);
  Check(LPassCount = 10, 'IsDigit Query should enumerate 10 chars');
end;

procedure TestTQueryChar.TestIsInArray;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsInArray(['1', '2', ')', '+', 'a']) do
    Inc(LPassCount);
  Check(LPassCount = 4, 'IsInArray Query should enumerate 4 chars');
end;

procedure TestTQueryChar.TestIsLetter;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsLetter do
    Inc(LPassCount);
  Check(LPassCount = 51, 'IsLetter Query should enumerate 51 chars');
end;

procedure TestTQueryChar.TestIsLetterOrDigit;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsLetterOrDigit do
    Inc(LPassCount);
  Check(LPassCount = 61, 'IsLetterOrDigit Query should enumerate 61 chars');
end;

procedure TestTQueryChar.TestIsLower;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsLower do
    Inc(LPassCount);
  Check(LPassCount = 25, 'IsLower Query should enumerate 25 chars');
end;

procedure TestTQueryChar.TestIsNumber;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsNumber do
    Inc(LPassCount);
  Check(LPassCount = 10, 'IsNumber Query should enumerate 10 chars');
end;

procedure TestTQueryChar.TestIsPunctuation;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsPunctuation do
    Inc(LPassCount);
  Check(LPassCount = 8, 'IsPunctuation Query should enumerate 8 chars');
end;

procedure TestTQueryChar.TestIsSymbol;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsSymbol do
    Inc(LPassCount);
  Check(LPassCount = 2, 'IsSymbol Query should enumerate 2 chars');
end;

procedure TestTQueryChar.TestIsUpper;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsUpper do
    Inc(LPassCount);
  Check(LPassCount = 26, 'IsUpper Query should enumerate 26 chars');
end;

procedure TestTQueryChar.TestIsUpperSkipTake;
var
  LChar : Char;
  LResultString : String;
begin
  for LChar in Query<Char>
                 .From(FStringVal)
                 .IsUpper
                 .Skip(5)
                 .Take(4) do
  begin
    LResultString := LResultString + LChar;
  end;
  Check(LResultString.Length = 4, 'Take(4) should enumerate 4 chars');
  Check(LResultString = 'FGHI', 'IsUpper.Skip(5).Take(4) should enumerate F, G, H and then I');
end;

procedure TestTQueryChar.TestIsWhiteSpace;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).IsWhiteSpace do
    Inc(LPassCount);
  Check(LPassCount = 3, 'IsWhitespace Query should enumerate 3 chars');
end;

procedure TestTQueryChar.TestMatchesCaseInsensitive;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).Matches('Y') do
    Inc(LPassCount);
  Check(LPassCount = 2, 'Case Insensitive Matches Query should enumerate two chars');
end;

procedure TestTQueryChar.TestMatchesCaseSensitive;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).Matches('y', False) do
    Inc(LPassCount);
  Check(LPassCount = 1, 'Case Sensitive Matches Query should enumerate one char');
end;

procedure TestTQueryChar.TestNoMatchesCaseSensitive;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal).Matches('z', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive Matches Query with no matches should enumerate zero chars');
end;

procedure TestTQueryChar.TestPassthrough;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in Query<Char>.From(FStringVal) do
    Inc(LPassCount);
  Check(LPassCount = FStringVal.Length, 'Passthrough Query should enumerate all items');
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
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query<Pointer>
                    .From(FList)
                    .IsAssigned do
    Inc(LPassCount);
  Check(LPassCount = 4, 'IsAssigned Query should enumerate four items');
end;


procedure TestTQueryTList.TestPassThrough;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query<Pointer>.From(FList) do
    Inc(LPassCount);
  Check(LPassCount = FList.Count, 'Passthrough Query should enumerate all items');
end;


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
  for LPointer in Query<Pointer>
                    .From(FList)
                    .IsAssigned do
    Inc(LPassCount);
  Check(LPassCount = 4, 'IsAssigned Query should enumerate four items');
end;

procedure TestTQueryPointer.TestPassThrough;
var
  LPassCount : Integer;
  LPointer : Pointer;
begin
  LPassCount := 0;
  for LPointer in Query<Pointer>.From(FList) do
    Inc(LPassCount);
  Check(LPassCount = FList.Count, 'Passthrough Query should enumerate all items');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('TList<Integer>', TestTQueryInteger.Suite);
  RegisterTest('TObjectList<TPerson>', TestTQueryPerson.Suite);
  RegisterTest('TStrings', TestTQueryTStrings.Suite);
  RegisterTest('TList<String>', TestTQueryString.Suite);
  RegisterTest('String', TestTQueryChar.Suite);
  RegisterTest('TList', TestTQueryTList.Suite);
  RegisterTest('TList<Pointer>', TestTQueryPointer.Suite);
end.

