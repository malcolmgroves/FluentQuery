unit FluentQuery.Enumerators.Char;

interface
uses
  FluentQuery.Types,
  FluentQuery,
  System.SysUtils,
  FluentQuery.EnumerationStrategies,
  FluentQuery.Enumerators;

type

  TCharQueryEnumerator = class(TBaseQueryEnumerator<Char>,
                               ICharQueryEnumerator,
                               IBaseQueryEnumerator<Char>,
                               IMinimalEnumerator<Char>)
  public
    function GetEnumerator: ICharQueryEnumerator;
    function First : ICharQueryEnumerator;
    function Skip(Count : Integer): ICharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : ICharQueryEnumerator;
    function Take(Count : Integer): ICharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): ICharQueryEnumerator;
    function Where(Predicate : TPredicate<Char>) : ICharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : ICharQueryEnumerator;
    function IsControl: ICharQueryEnumerator;
    function IsDigit: ICharQueryEnumerator;
    function IsHighSurrogate: ICharQueryEnumerator;
    function IsInArray(const SomeChars: array of Char): ICharQueryEnumerator;
    function IsLetter: ICharQueryEnumerator;
    function IsLetterOrDigit: ICharQueryEnumerator;
    function IsLower: ICharQueryEnumerator;
    function IsLowSurrogate: ICharQueryEnumerator;
    function IsNumber: ICharQueryEnumerator;
    function IsPunctuation: ICharQueryEnumerator;
    function IsSeparator: ICharQueryEnumerator;
    function IsSurrogate: ICharQueryEnumerator;
    function IsSymbol: ICharQueryEnumerator;
    function IsUpper: ICharQueryEnumerator;
    function IsWhiteSpace: ICharQueryEnumerator;
  end;


implementation
uses
  System.Character;

{ TCharQueryEnumerator }

function TCharQueryEnumerator.First: ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(1)),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.GetEnumerator: ICharQueryEnumerator;
begin
  Result := Self;
end;

function TCharQueryEnumerator.IsControl: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsControl;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsDigit: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsDigit;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsHighSurrogate: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsHighSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsInArray(const SomeChars: array of Char): ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
  LSomeChars : array of Char;
  I : Integer;
begin
  // was getting an "unable to capture symbol" error when capturing SomeChars directly.
  SetLength(LSomeChars, Length(SomeChars));
  for I := Low(SomeChars) to High(SomeChars) do
    LSomeChars[i] := SomeChars[i];

  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsInArray(LSomeChars);
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsLetter: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLetter;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsLetterOrDigit: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLetterOrDigit;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsLower: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLower;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsLowSurrogate: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLowSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsNumber: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsNumber;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsPunctuation: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsPunctuation;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsSeparator: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSeparator;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsSurrogate: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsSymbol: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSymbol;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsUpper: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsUpper;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.IsWhiteSpace: ICharQueryEnumerator;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsWhiteSpace;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
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

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.Skip(Count: Integer): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(Count)),
                                       IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.SkipWhile(
  Predicate: TPredicate<Char>): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.Take(Count: Integer): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(Count)),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.TakeWhile(
  Predicate: TPredicate<Char>): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

function TCharQueryEnumerator.Where(
  Predicate: TPredicate<Char>): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(self));
end;

end.
