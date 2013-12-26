unit FluentQuery.Enumerators.Char;

interface
uses
  FluentQuery.Types,
  FluentQuery,
  System.SysUtils,
  FluentQuery.EnumerationDelegates,
  FluentQuery.Enumerators;

type

  TCharQueryEnumerator = class(TMinimalEnumerator<Char>, ICharQueryEnumerator, IMinimalEnumerator<Char>)
  public
    function GetEnumerator: ICharQueryEnumerator;
    function First : ICharQueryEnumerator;
    function Skip(Count : Integer): ICharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : ICharQueryEnumerator;
    function Take(Count : Integer): ICharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): ICharQueryEnumerator;
    function Where(Predicate : TPredicate<Char>) : ICharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : ICharQueryEnumerator;
  end;


implementation
uses
  System.Character;

{ TCharQueryEnumerator }

function TCharQueryEnumerator.First: ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TTakeEnumerationDelegate<Char>.Create(IMinimalEnumerator<Char>(self), 1));
end;

function TCharQueryEnumerator.GetEnumerator: ICharQueryEnumerator;
begin
  Result := Self;
end;

function TCharQueryEnumerator.Matches(const Value: Char;
  IgnoreCase: Boolean): ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                         if IgnoreCase then
                           Result := CurrentValue.ToUpper = Value.ToUpper
                         else
                           Result := CurrentValue = Value;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationDelegate<Char>.Create(IMinimalEnumerator<Char>(self), LMatchesPredicate));
end;

function TCharQueryEnumerator.Skip(Count: Integer): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TSkipEnumerationDelegate<Char>.Create(IMinimalEnumerator<Char>(self), Count));
end;

function TCharQueryEnumerator.SkipWhile(
  Predicate: TPredicate<Char>): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TSkipWhileEnumerationDelegate<Char>.Create(IMinimalEnumerator<Char>(self), Predicate));
end;

function TCharQueryEnumerator.Take(Count: Integer): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TTakeEnumerationDelegate<Char>.Create(IMinimalEnumerator<Char>(self), Count));
end;

function TCharQueryEnumerator.TakeWhile(
  Predicate: TPredicate<Char>): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationDelegate<Char>.Create(IMinimalEnumerator<Char>(self), Predicate));
end;

function TCharQueryEnumerator.Where(
  Predicate: TPredicate<Char>): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TWhereEnumerationDelegate<Char>.Create(IMinimalEnumerator<Char>(self), Predicate));
end;

end.
