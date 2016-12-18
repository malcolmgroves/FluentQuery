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
    procedure TestCharPredicate;
  end;


implementation

{ TestTQueryChar }

procedure TestTQueryChar.NotEquals;
begin
  CheckEquals(FStringVal.Length - 1, CharQuery.From(FStringVal).NotEquals('y').Count);
end;

procedure TestTQueryChar.SetUp;
begin
  inherited;
  //NB: no lowercase z
  FStringVal := 'abcdefghijklmnopqrstuvwxy 1234567890 !@#$%^&*() ABCDEFGHIJKLMNOPQRSTUVWXYZ';
end;


procedure TestTQueryChar.TestTakeWhileQueryIsLetter;
begin
  CheckEquals(25, CharQuery.From(FStringVal).TakeWhile(CharQuery.IsLetter).Count);
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
                     .AsString;

  Check(LResultString.Length = 4, 'Take(4) should enumerate 4 chars');
  Check(LResultString = 'FGHI', 'IsUpper.Skip(5).Take(4) should enumerate F, G, H and then I');
end;

procedure TestTQueryChar.TestEquals;
begin
  Check(CharQuery.From(FStringVal).Equals('y').Count = 1, 'Equals Query should enumerate one char');
end;

procedure TestTQueryChar.TestIsDigit;
begin
  Check(CharQuery.From(FStringVal).IsDigit.Count = 10, 'IsDigit Query should enumerate 10 chars');
end;

procedure TestTQueryChar.TestIsInArray;
begin
  Check(CharQuery.From(FStringVal).IsInArray(['1', '2', ')', '+', 'a']).Count = 4, 'IsInArray Query should enumerate 4 chars');
end;

procedure TestTQueryChar.TestIsLetter;
begin
  Check(CharQuery.From(FStringVal).IsLetter.Count = 51, 'IsLetter Query should enumerate 51 chars');
end;

procedure TestTQueryChar.TestIsLetterOrDigit;
begin
  Check(CharQuery.From(FStringVal).IsLetterOrDigit.Count = 61, 'IsLetterOrDigit Query should enumerate 61 chars');
end;

procedure TestTQueryChar.TestIsLower;
begin
  Check(CharQuery.From(FStringVal).IsLower.Count = 25, 'IsLower Query should enumerate 25 chars');
end;

procedure TestTQueryChar.TestIsNumber;
begin
  Check(CharQuery.From(FStringVal).IsNumber.Count = 10, 'IsNumber Query should enumerate 10 chars');
end;

procedure TestTQueryChar.TestIsPunctuation;
begin
  Check(CharQuery.From(FStringVal).IsPunctuation.Count = 8, 'IsPunctuation Query should enumerate 8 chars');
end;

procedure TestTQueryChar.TestIsSymbol;
begin
  Check(CharQuery.From(FStringVal).IsSymbol.Count = 2, 'IsSymbol Query should enumerate 2 chars');
end;

procedure TestTQueryChar.TestIsUpper;
begin
  Check(CharQuery.From(FStringVal).IsUpper.Count = 26, 'IsUpper Query should enumerate 26 chars');
end;

procedure TestTQueryChar.TestIsUpperSkipTake;
var
  LResultString : String;
begin
  LResultString := CharQuery
                     .From(FStringVal)
                     .IsUpper
                     .Skip(5)
                     .Take(4)
                     .AsString;
  Check(LResultString.Length = 4, 'Take(4) should enumerate 4 chars');
  Check(LResultString = 'FGHI', 'IsUpper.Skip(5).Take(4) should enumerate F, G, H and then I');
end;

procedure TestTQueryChar.TestIsWhiteSpace;
begin
  Check(CharQuery.From(FStringVal).IsWhiteSpace.Count = 3, 'IsWhitespace Query should enumerate 3 chars');
end;

procedure TestTQueryChar.TestMatchesCaseInsensitive;
begin
  Check(CharQuery.From(FStringVal).Matches('Y').Count = 2, 'Case Insensitive Matches Query should enumerate two chars');
end;

procedure TestTQueryChar.TestMatchesCaseSensitive;
begin
  Check(CharQuery.From(FStringVal).Matches('y', False).Count = 1, 'Case Sensitive Matches Query should enumerate one char');
end;

procedure TestTQueryChar.TestNoMatchesCaseSensitive;
begin
  Check(CharQuery.From(FStringVal).Matches('z', False).Count = 0, 'Case Sensitive Matches Query with no matches should enumerate zero chars');
end;

procedure TestTQueryChar.TestWhereNotIsNumber;
begin
  Check(CharQuery.From(FStringVal).WhereNot(CharQuery.IsNumber).Count = FStringVal.Length - 10, 'Not(IsNumber) Query should enumerate all but 10 chars');
end;

procedure TestTQueryChar.TestPassthrough;
begin
  Check(CharQuery.From(FStringVal).Count = FStringVal.Length, 'Passthrough Query should enumerate all items');
end;


procedure TestTQueryChar.TestSkipWhileQueryIsLetter;
begin
  Check(CharQuery.From(FStringVal).SkipWhile(CharQuery.IsLetter).Count = FStringVal.Length - 25, 'Skipwhile(IsLetter) Query should enumerate all items except the first 25');
end;


procedure TestTQueryChar.TestCharPredicate;
var
  LCount : Integer;
  function AcceptableCount(CharPredicate: TPredicate<Char>): Integer;
  var
    CharList : TList<Char>;
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

      Result := CharQuery.From(CharList).Where(CharPredicate).Count;
    finally
      CharList.Free;
    end;
  end;
begin
  LCount := AcceptableCount(CharQuery
                              .IsUpper
                              .Predicate);
  Check(LCount = 2, 'Predicate from IsUpper should match 2 items');
end;


initialization
  // Register any test cases with the test runner
  RegisterTest('Chars', TestTQueryChar.Suite);
end.

