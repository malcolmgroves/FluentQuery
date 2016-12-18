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
  System.Classes,
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Tests.Base;

type
  TestTQueryTStrings = class(TFluentQueryTestCase<String>)
  strict private
    FStrings: TStrings;
    FNameStrings : TStrings;
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

  TestTQueryString = class(TFluentQueryTestCase<String>)
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
    procedure TestValue;
    procedure TestValueNameIsEmpty;
    procedure TestValueNameIsNotFound;
  end;

  TestFluentStringPredicate = class(TTestCase)
  published
    procedure TestListboxFilterPredicate;
  end;


implementation
uses
  FMX.Listbox;


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

  FNameStrings := TStringList.Create;
  FNameStrings.Add('Malcolm');
  FNameStrings.Add('Julie');
  FNameStrings.Add('Jesse');
  FNameStrings.Add('Lauren');
end;

procedure TestTQueryTStrings.TearDown;
begin
  FStrings.Free;
  FNameStrings.Free;
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
begin
  FNameStrings.Add('jesse');
  CheckEquals(1, Query.From(FNameStrings).Equals('jesse').Count);
end;

procedure TestTQueryTStrings.TestMatchesCaseInsensitive;
begin
  CheckEquals(1, Query.From(FNameStrings).Matches('jesse').Count);
end;

procedure TestTQueryTStrings.TestMatchesCaseSensitive;
begin
  FNameStrings.Add('jesse');
  CheckEquals(1, Query.From(FNameStrings).Matches('Jesse', False).Count);
end;

procedure TestTQueryTStrings.TestNoMatchesCaseSensitive;
begin
  CheckEquals(0, Query.From(FNameStrings).Matches('jesse', False).Count);
end;

procedure TestTQueryTStrings.TestNotEquals;
begin
  FNameStrings.Add('jesse');
  CheckEquals(4, Query.From(FNameStrings).NotEquals('jesse').Count);
end;

procedure TestTQueryTStrings.TestPassThrough;
begin
  CheckEquals(FStrings.Count, Query.From(FStrings).Count);
end;

procedure TestTQueryTStrings.TestSkipTake;
begin
  CheckExpectedCountWithInnerCheck(Query.From(FStrings).Skip(4).Take(3),
                                   function (Arg : String) : Boolean
                                   begin
                                     Result := (Arg = '5') or (Arg = '6') or (Arg = '7');
                                   end,
                                   3, 'Should Enumerate 5, 6 and 7');
end;


procedure TestTQueryTStrings.TestSkipTakeCreateStrings;
var
  LStrings : TStrings;
begin
  LStrings := Query
                .From(FStrings)
                .Skip(4)
                .Take(3)
                .AsTStrings;
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
begin
  CheckEquals(7, Query.From(FStringCollection).Contains('e').Count);
end;

procedure TestTQueryString.TestContainsCaseSensitive;
begin
  CheckEquals(6, Query.From(FStringCollection).Contains('e', False).Count);
end;

procedure TestTQueryString.TestEndsWithCaseInsensitive;
begin
  FStringCollection.Add('seventeeN');
  CheckEquals(3, Query.From(FStringCollection).EndsWith('n').Count);
end;

procedure TestTQueryString.TestEndsWithCaseSensitive;
begin
  CheckEquals(2, Query.From(FStringCollection).EndsWith('n', False).Count);
end;

procedure TestTQueryString.TestMatchesCaseInsensitive;
begin
  CheckEquals(1, Query.From(FStringCollection).Matches('six').Count);
end;

procedure TestTQueryString.TestMatchesCaseSensitive;
begin
  CheckEquals(1, Query.From(FStringCollection).Matches('Six', False).Count);
end;

procedure TestTQueryString.TestMatchesCaseSensitiveNone;
begin
  CheckEquals(0, Query.From(FStringCollection).Matches('six', False).Count);
end;

procedure TestTQueryString.TestContainsCaseSensitiveNone;
begin
  CheckEquals(0, Query.From(FStringCollection).Contains('s', False).Count);
end;

procedure TestTQueryString.TestEndsWithCaseSensitiveNone;
begin
  CheckEquals(0, Query.From(FStringCollection).EndsWith('N', False).Count);
end;

procedure TestTQueryString.TestWhereNotContainsCaseInsensitive;
begin
  CheckEquals(3, Query.From(FStringCollection).WhereNot(Query.Contains('e')).Count);
end;

procedure TestTQueryString.TestWhereNotPredicateContainsCaseInsensitive;
begin
  CheckEquals(3, Query.From(FStringCollection).WhereNot(Query.Contains('e').Predicate).Count);
end;

procedure TestTQueryString.TestStartsWithCaseSensitiveNone;
begin
  CheckEquals(0, Query.From(FStringCollection).StartsWith('s', False).Count);
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

procedure TestTQueryString.TestValue;
begin
  FStringCollection.Add('Param=Hello World');
  CheckExpectedCountWithInnerCheck(Query.From(FStringCollection).Value('param'),
                                   function (Arg : String) : Boolean
                                   begin
                                     Result := Arg = 'Hello World';
                                   end,
                                   1, 'String should be Hello World');
end;

procedure TestTQueryString.TestValueNameIsNotFound;
begin
  CheckEquals(0, Query.From(FStringCollection).Value('param').Count);
end;

procedure TestTQueryString.TestValueNameIsEmpty;
begin
  FStringCollection.Add('Param=');
  CheckExpectedCountWithInnerCheck(Query.From(FStringCollection).Value('param'),
                                   function (Arg : String) : Boolean
                                   begin
                                     Result := Arg = '';
                                   end,
                                   1, 'String should be empty');
end;

procedure TestTQueryString.TestStartsWithCaseInsensitive;
begin
  FStringCollection.Add('seventeen');
  CheckEquals(3, Query.From(FStringCollection).StartsWith('S').Count);
end;

procedure TestTQueryString.TestStartsWithCaseSensitive;
begin
  FStringCollection.Add('seventeen');
  CheckEquals(2, Query.StartsWith('S', False).From(FStringCollection).Count);
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


