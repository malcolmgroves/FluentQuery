unit FluentQuery.FluentPredicate.Tests;

interface
uses
  TestFramework,
  System.SysUtils;

type
  TestFluentPredicate = class(TTestCase)
  private
    function AcceptableCount(CharPredicate : TPredicate<Char>) : Integer;
  published
    procedure TestCharPredicate;
  end;

implementation
uses
  Generics.Collections, FluentQuery;

{ TestFluentPredicate }

function TestFluentPredicate.AcceptableCount(
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
//    for Value in Query<Char>.From(CharList).Where(CharPredicate) do
//      Inc(PassCount);

    Result := PassCount;
  finally
    CharList.Free;
  end;
end;

procedure TestFluentPredicate.TestCharPredicate;
//var
//  LCount : Integer;
begin
//  LCount := AcceptableCount(Predicate<Char>.From(CharQuery
//                                                   .Deferred
//                                                   .IsUpper));
//  Check(LCount = 2, 'Predicate from IsUpper should match 2 items');
end;


initialization
  RegisterTest('FluentPredicate', TestFluentPredicate.Suite);

end.
