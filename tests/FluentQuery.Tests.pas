unit FluentQuery.Tests;

interface

uses
  TestFramework,
  System.Generics.Collections,
  FluentQuery,
  System.Classes;

type
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


implementation
uses
  System.SysUtils;


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


initialization
  // Register any test cases with the test runner
  RegisterTest('Chars', TestTQueryChar.Suite);
end.

