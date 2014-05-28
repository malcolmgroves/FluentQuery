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
    procedure TestEquals;
    procedure TestNotEquals;
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
    procedure TestMatchesCaseSensitiveNone;
    procedure TestMatchesCaseInsensitive;
    procedure TestContainsCaseSensitive;
    procedure TestContainsCaseSensitiveNone;
    procedure TestContainsCaseInsensitive;
    procedure TestWhereNotContainsCaseInsensitive;
    procedure TestWhereNotPredicateContainsCaseInsensitive;
    procedure TestStartsWithCaseSensitive;
    procedure TestStartsWithCaseSensitiveNone;
    procedure TestStartsWithCaseInsensitive;
    procedure TestEndsWithCaseSensitive;
    procedure TestEndsWithCaseSensitiveNone;
    procedure TestEndsWithCaseInsensitive;
    procedure TestSubstring;
    procedure TestSubstringIndexGreaterThanLength;
    procedure TestSubstringLength;
    procedure TestName;
    procedure TestNameValueIsEmpty;
    procedure TestNameIsNotFound;
  end;

  TestFluentStringPredicate = class(TTestCase)
  published
    procedure TestListboxFilterPredicate;
  end;


implementation
uses
  FMX.Listbox,
  FluentQuery.Core.Types,
  SysUtils;


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

procedure TestTQueryTStrings.TestEquals;
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
    LNameStrings.Add('jesse');
    LNameStrings.Add('Lauren');

    LPassCount := 0;
    for LString in Query.From(LNameStrings).Equals('jesse') do
      Inc(LPassCount);
    Check(LPassCount = 1, 'Equals Query should enumerate one string');
  finally
    LNameStrings.Free;
  end;
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
    LNameStrings.Add('jesse');

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

procedure TestTQueryTStrings.TestNotEquals;
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
    LNameStrings.Add('jesse');
    LNameStrings.Add('Lauren');

    LPassCount := 0;
    for LString in Query.From(LNameStrings).NotEquals('jesse') do
      Inc(LPassCount);
    Check(LPassCount = 4, 'NotEquals Query should enumerate four strings');
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
  for LString in Query.From(FStringCollection).Matches('Six', False) do
    Inc(LPassCount);
  Check(LPassCount = 1, 'Case Sensitive Matches Query should enumerate one string');
end;

procedure TestTQueryString.TestMatchesCaseSensitiveNone;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).Matches('six', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive Matches Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestContainsCaseSensitiveNone;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).Contains('s', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive Contains ''s'' Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestEndsWithCaseSensitiveNone;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).EndsWith('N', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive EndsWith ''N'' Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestWhereNotContainsCaseInsensitive;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).WhereNot(Query.Contains('e')) do
    Inc(LPassCount);
  Check(LPassCount = 3, 'WhereNot(Case Insensitive Contains ''e'') Query should enumerate seven strings');
end;

procedure TestTQueryString.TestWhereNotPredicateContainsCaseInsensitive;
var
  LPassCount : Integer;
  LString : String;
  LContainsE : TPredicate<string>;
begin
  LPassCount := 0;
  LContainsE := Query.Contains('e').Predicate;

  for LString in Query.From(FStringCollection).WhereNot(LContainsE) do
    Inc(LPassCount);
  Check(LPassCount = 3, 'WhereNot(Predicate(Case Insensitive Contains ''e'')) Query should enumerate seven strings');
end;

procedure TestTQueryString.TestStartsWithCaseSensitiveNone;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  for LString in Query.From(FStringCollection).StartsWith('s', False) do
    Inc(LPassCount);
  Check(LPassCount = 0, 'Case Sensitive StartsWith ''s'' Query with no matches should enumerate zero strings');
end;

procedure TestTQueryString.TestSubstring;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;

  for LString in Query.From(FStringCollection).SubString(2) do
  begin
    case LPassCount of
      0 : CheckEqualsString('e', LString);
      1 : CheckEqualsString('o', LString);
      2 : CheckEqualsString('ree', LString);
      3 : CheckEqualsString('ur', LString);
      4 : CheckEqualsString('ve', LString);
      5 : CheckEqualsString('x', LString);
      6 : CheckEqualsString('ven', LString);
      7 : CheckEqualsString('ght', LString);
      8 : CheckEqualsString('ne', LString);
      9 : CheckEqualsString('n', LString);
    end;

    Inc(LPassCount);
  end;
  CheckEquals(FStringCollection.Count,  LPassCount);
end;

procedure TestTQueryString.TestSubstringIndexGreaterThanLength;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;

  for LString in Query.From(FStringCollection).SubString(99) do
  begin
    case LPassCount of
      0..9 : CheckEqualsString('', LString);
    end;

    Inc(LPassCount);
  end;
  CheckEquals(FStringCollection.Count,  LPassCount);
end;

procedure TestTQueryString.TestSubstringLength;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;

  for LString in Query.From(FStringCollection).SubString(2, 1) do
  begin
    case LPassCount of
      0 : CheckEqualsString('e', LString);
      1 : CheckEqualsString('o', LString);
      2 : CheckEqualsString('r', LString);
      3 : CheckEqualsString('u', LString);
      4 : CheckEqualsString('v', LString);
      5 : CheckEqualsString('x', LString);
      6 : CheckEqualsString('v', LString);
      7 : CheckEqualsString('g', LString);
      8 : CheckEqualsString('n', LString);
      9 : CheckEqualsString('n', LString);
    end;

    Inc(LPassCount);
  end;
  CheckEquals(FStringCollection.Count,  LPassCount);
end;

procedure TestTQueryString.TestName;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  FStringCollection.Add('Param=Hello World');

  for LString in Query.From(FStringCollection).Value('param') do
  begin
    Inc(LPassCount);
    CheckEquals('Hello World', LString);
  end;
  CheckEquals(1, LPassCount);
end;

procedure TestTQueryString.TestNameIsNotFound;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;

  for LString in Query.From(FStringCollection).Value('param') do
    Inc(LPassCount);
  CheckEquals(0, LPassCount);
end;

procedure TestTQueryString.TestNameValueIsEmpty;
var
  LPassCount : Integer;
  LString : String;
begin
  LPassCount := 0;
  FStringCollection.Add('Param=');

  for LString in Query.From(FStringCollection).Value('param') do
  begin
    Inc(LPassCount);
    CheckEquals('', LString);
  end;
  CheckEquals(LPassCount, 1);
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

