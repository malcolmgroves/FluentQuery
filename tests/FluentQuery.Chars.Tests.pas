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

unit FluentQuery.Chars.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery.Chars,
  System.SysUtils;

type
  TestTQueryChar = class(TTestCase)
  strict private
    FStringVal: String;
  public
    procedure SetUp; override;
  published
    procedure TestPassthrough;
    procedure TestMatchesCaseSensitive;
    procedure TestEquals;
    procedure NotEquals;
    procedure TestNoMatchesCaseSensitive;
    procedure TestMatchesCaseInsensitive;
    procedure TestIsDigit;
    procedure TestIsInArray;
    procedure TestIsLetter;
    procedure TestIsLetterOrDigit;
    procedure TestIsLower;
    procedure TestIsNumber;
    procedure TestWhereNotIsNumber;
    procedure TestIsPunctuation;
    procedure TestIsSymbol;
    procedure TestIsUpper;
    procedure TestIsWhiteSpace;
    procedure TestIsUpperSkipTake;
    procedure TestCreateStringFromIsUpperSkipTake;
    procedure TestSkipWhileQueryIsLetter;
    procedure TestTakeWhileQueryIsLetter;
  end;


  TestFluentCharPredicate = class(TTestCase)
  private
    function AcceptableCount(CharPredicate : TPredicate<Char>) : Integer;
  published
    procedure TestCharPredicate;
  end;

implementation

var
  DummyChar : Char; // used to suppress wanrng about unused loop variable in tests

{ TestTQueryChar }

procedure TestTQueryChar.NotEquals;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).NotEquals('y') do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = FStringVal.Length - 1, 'NotEquals Query should enumerate all but one char');
end;

procedure TestTQueryChar.SetUp;
begin
  inherited;
  //NB: no lowercase z
  FStringVal := 'abcdefghijklmnopqrstuvwxy 1234567890 !@#$%^&*() ABCDEFGHIJKLMNOPQRSTUVWXYZ';
end;


procedure TestTQueryChar.TestTakeWhileQueryIsLetter;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).TakeWhile(CharQuery.IsLetter) do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 25, 'Takewhile(IsLetter) Query should enumerate the first 25 items');
end;

procedure TestTQueryChar.TestCreateStringFromIsUpperSkipTake;
var
  LResultString : String;
begin
  LResultString := CharQuery
                     .From(FStringVal)
                     .IsUpper
                     .Skip(5)
                     .Take(4)
                     .ToAString;

  Check(LResultString.Length = 4, 'Take(4) should enumerate 4 chars');
  Check(LResultString = 'FGHI', 'IsUpper.Skip(5).Take(4) should enumerate F, G, H and then I');
end;

procedure TestTQueryChar.TestEquals;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).Equals('y') do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 1, 'Equals Query should enumerate one char');
end;

procedure TestTQueryChar.TestIsDigit;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsDigit do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 10, 'IsDigit Query should enumerate 10 chars');
end;

procedure TestTQueryChar.TestIsInArray;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsInArray(['1', '2', ')', '+', 'a']) do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 4, 'IsInArray Query should enumerate 4 chars');
end;

procedure TestTQueryChar.TestIsLetter;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsLetter do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 51, 'IsLetter Query should enumerate 51 chars');
end;

procedure TestTQueryChar.TestIsLetterOrDigit;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsLetterOrDigit do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 61, 'IsLetterOrDigit Query should enumerate 61 chars');
end;

procedure TestTQueryChar.TestIsLower;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsLower do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 25, 'IsLower Query should enumerate 25 chars');
end;

procedure TestTQueryChar.TestIsNumber;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsNumber do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 10, 'IsNumber Query should enumerate 10 chars');
end;

procedure TestTQueryChar.TestIsPunctuation;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsPunctuation do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 8, 'IsPunctuation Query should enumerate 8 chars');
end;

procedure TestTQueryChar.TestIsSymbol;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsSymbol do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 2, 'IsSymbol Query should enumerate 2 chars');
end;

procedure TestTQueryChar.TestIsUpper;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).IsUpper do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 26, 'IsUpper Query should enumerate 26 chars');
end;

procedure TestTQueryChar.TestIsUpperSkipTake;
var
  LChar : Char;
  LResultString : String;
begin
  for LChar in CharQuery
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
  for LChar in CharQuery.From(FStringVal).IsWhiteSpace do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 3, 'IsWhitespace Query should enumerate 3 chars');
end;

procedure TestTQueryChar.TestMatchesCaseInsensitive;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).Matches('Y') do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 2, 'Case Insensitive Matches Query should enumerate two chars');
end;

procedure TestTQueryChar.TestMatchesCaseSensitive;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).Matches('y', False) do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 1, 'Case Sensitive Matches Query should enumerate one char');
end;

procedure TestTQueryChar.TestNoMatchesCaseSensitive;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).Matches('z', False) do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = 0, 'Case Sensitive Matches Query with no matches should enumerate zero chars');
end;

procedure TestTQueryChar.TestWhereNotIsNumber;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).WhereNot(CharQuery.IsNumber) do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = FStringVal.Length - 10, 'Not(IsNumber) Query should enumerate all but 10 chars');
end;

procedure TestTQueryChar.TestPassthrough;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal) do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = FStringVal.Length, 'Passthrough Query should enumerate all items');
end;


procedure TestTQueryChar.TestSkipWhileQueryIsLetter;
var
  LPassCount : Integer;
  LChar : Char;
begin
  LPassCount := 0;
  for LChar in CharQuery.From(FStringVal).SkipWhile(CharQuery.IsLetter) do
  begin
    Inc(LPassCount);
    DummyChar := LChar; // suppress warning about LChar being unused
  end;
  Check(LPassCount = FStringVal.Length - 25, 'Skipwhile(IsLetter) Query should enumerate all items except the first 25');
end;

function TestFluentCharPredicate.AcceptableCount(
  CharPredicate: TPredicate<Char>): Integer;
var
  CharList : TList<Char>;
  Value : Char;
  PassCount : Integer;
begin
  CharList := TList<Char>.Create;
  try
    CharList.Add('a');
    CharList.Add('B');
    CharList.Add('/');
    CharList.Add('c');
    CharList.Add('C');
    CharList.Add('*');
    CharList.Add('1');
    CharList.Add('2');

    PassCount := 0;

    for Value in CharQuery.From(CharList).Where(CharPredicate) do
    begin
      Inc(PassCount);
      DummyChar := Value; // suppress warning about LChar being unused
    end;

    Result := PassCount;
  finally
    CharList.Free;
  end;
end;

procedure TestFluentCharPredicate.TestCharPredicate;
var
  LCount : Integer;
begin
  LCount := AcceptableCount(CharQuery
                              .IsUpper
                              .Predicate);
  Check(LCount = 2, 'Predicate from IsUpper should match 2 items');
end;


initialization
  // Register any test cases with the test runner
  RegisterTest('Chars', TestTQueryChar.Suite);
  RegisterTest('Chars', TestFluentCharPredicate.Suite);
end.

