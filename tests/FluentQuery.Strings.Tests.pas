unit FluentQuery.Strings.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.Strings,
  System.Classes;

type
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
    procedure TestEnumerateUnboundQuery;
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

  TestFluentStringPredicate = class(TTestCase)
  published
    procedure TestListboxFilterPredicate;
  end;


implementation
uses
  FMX.Listbox,
  FluentQuery.Core.Types;


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

procedure TestTQueryTStrings.TestEnumerateUnboundQuery;
var
  Value : String;
  PassCount : Integer;
begin
  PassCount := 0;

  ExpectedException := ENilEnumeratorException;
  for Value in Query.Take(3) do
    Inc(PassCount);
  StopExpectingException('Enumerating an UnboundQuery should have raised an ENilEnumeratorException');

  Check(PassCount = 0, 'Unbound Query should return no items');
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
    for LString in Query.From(LNameStrings).Matches('jesse') do
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
    for LString in Query.From(LNameStrings).Matches('Jesse', False) do
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
    for LString in Query.From(LNameStrings).Matches('jesse', False) do
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
  for LString in Query.From(FStrings) do
    Inc(LPassCount);
  Check(LPassCount = FStrings.Count, 'Passthrough Query should enumerate all strings');
end;

procedure TestTQueryTStrings.TestSkipTake;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
//  for LString in Query
//                   .From(FStrings)
//                   .Skip(4)
//                   .Take(3) do
  for LString in Query
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

  LStrings := Query
                .From(FStrings)
                .Skip(4)
                .Take(3)
                .ToTStrings;
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
  for LString in Query.From(FStringCollection).Contains('e') do
    Inc(LPassCount);
  Check(LPassCount = 7, 'Case Insensitive Contains ''e'' Query should enumerate seven strings');
end;

procedure TestTQueryString.TestContainsCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).Contains('e', False) do
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

  for LString in Query.From(FStringCollection).EndsWith('n') do
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

  for LString in Query.From(FStringCollection).EndsWith('n', False) do
    Inc(LPassCount);
  Check(LPassCount = 2, 'Case Sensitive EndsWith ''n'' Query should enumerate two strings');
end;

procedure TestTQueryString.TestMatchesCaseInsensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).Matches('six') do
    Inc(LPassCount);
  Check(LPassCount = 1, 'Case Insensitive Matches Query should enumerate one string');
end;

procedure TestTQueryString.TestMatchesCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
//  for LString in Query.From(FStringCollection).Matches('Six', False) do
  for LString in Query.From(FStringCollection).Matches('Six', False) do
    Inc(LPassCount);
  Check(LPassCount = 1, 'Case Sensitive Matches Query should enumerate one string');
end;

procedure TestTQueryString.TestNoMatchesCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).Matches('six', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive Matches Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestNotContainsCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).Contains('s', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive Contains ''s'' Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestNotEndsWithCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).EndsWith('N', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive EndsWith ''N'' Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestNotStartsWithCaseSensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).StartsWith('s', False) do
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

  for LString in Query.From(FStringCollection).StartsWith('S') do
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

  for LString in Query.StartsWith('S', False).From(FStringCollection) do
    Inc(LPassCount);
  Check(LPassCount = 2, 'Case Sensitive StartsWith ''S'' Query should enumerate two strings');
end;


{ TestFluentStringPredicate }

procedure TestFluentStringPredicate.TestListboxFilterPredicate;
var
  Listbox : FMX.Listbox.TListBox;
begin
  Listbox := FMX.Listbox.TListBox.Create(nil);
  try
    Listbox.Items.Add('One');
    Listbox.Items.Add('Two');
    Listbox.Items.Add('three');
    Listbox.Items.Add('Four');
    Listbox.Items.Add('fivE');
    Listbox.Items.Add('Six');
    Listbox.Items.Add('seven');

    Listbox.FilterPredicate := Query
                                 .EndsWith('e')
                                 .Predicate;

    Check(Listbox.Count = 3, 'Filter on items ending in ''e'' should result in 3 items');

    Listbox.FilterPredicate := Query
                                 .EndsWith('e', False)
                                 .Predicate;

    Check(Listbox.Count = 2, 'Filter on items ending in ''e'' or ''E'' should result in 3 items');

    Listbox.FilterPredicate := nil;
    Check(Listbox.Count = 7, 'No Filter should result in 7 items');
  finally
    Listbox.Free;
  end;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Strings', TestTQueryTStrings.Suite);
  RegisterTest('Strings', TestTQueryString.Suite);
  RegisterTest('Strings', TestFluentStringPredicate.Suite);
end.

