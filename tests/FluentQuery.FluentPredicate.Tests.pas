unit FluentQuery.FluentPredicate.Tests;

interface
uses
  TestFramework,
  FluentQuery,
  System.SysUtils;

type
  TestFluentPredicate = class(TTestCase)
  private
    function AcceptableCount(CharPredicate : TPredicate<Char>) : Integer;
  published
    procedure TestListboxFilterPredicate;
    procedure TestCharPredicate;
  end;

implementation
uses
  FMX.Listbox, Generics.Collections;

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
    for Value in Query<Char>.From(CharList).Where(CharPredicate) do
      Inc(PassCount);

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

procedure TestFluentPredicate.TestListboxFilterPredicate;
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

    Listbox.FilterPredicate := StringQuery
                                 .EndsWith('e')
                                 .Predicate;

    Check(Listbox.Count = 3, 'Filter on items ending in ''e'' should result in 3 items');

    Listbox.FilterPredicate := StringQuery
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
  RegisterTest('FluentPredicate', TestFluentPredicate.Suite);

end.
