unit Generics.Collections.Enumerators.Strings;

interface
uses
  Generics.Collections.Query.Types, Generics.Collections.Query, System.SysUtils,
  Generics.Collections.EnumerationDelegates, Generics.Collections.Enumerators;

type

  TStringQueryEnumerator = class(TMinimalEnumerator<String>, IStringQueryEnumerator, IMinimalEnumerator<String>)
  public
    function GetEnumerator: IStringQueryEnumerator;
    function First : IStringQueryEnumerator;
    function Skip(Count : Integer): IStringQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<String>) : IStringQueryEnumerator;
    function Take(Count : Integer): IStringQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<String>): IStringQueryEnumerator;
    function Where(Predicate : TPredicate<String>) : IStringQueryEnumerator;
    function Matches(const Value : String; IgnoreCase : Boolean = True) : IStringQueryEnumerator;
  end;


implementation

{ TStringQueryEnumerator }

function TStringQueryEnumerator.First: IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TTakeEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), 1));
end;

function TStringQueryEnumerator.GetEnumerator: IStringQueryEnumerator;
begin
  Result := self;
end;

function TStringQueryEnumerator.Matches(const Value: String;
  IgnoreCase: Boolean): IStringQueryEnumerator;
var
  LMatchesPredicate : TPredicate<String>;
begin
  LMatchesPredicate := function (CurrentValue : String) : Boolean
                       begin
                         Result := CurrentValue.Compare(CurrentValue, Value, IgnoreCase) = 0;
                       end;

  Result := TStringQueryEnumerator.Create(TWhereEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), LMatchesPredicate));
end;

function TStringQueryEnumerator.Skip(Count: Integer): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TSkipEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Count));
end;

function TStringQueryEnumerator.SkipWhile(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TSkipWhileEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Predicate));
end;

function TStringQueryEnumerator.Take(Count: Integer): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TTakeEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Count));
end;

function TStringQueryEnumerator.TakeWhile(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Predicate));
end;

function TStringQueryEnumerator.Where(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TWhereEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Predicate));
end;


end.
