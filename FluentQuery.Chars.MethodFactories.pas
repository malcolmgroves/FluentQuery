unit FluentQuery.Chars.MethodFactories;

interface

uses FluentQuery.Core.MethodFactories, System.SysUtils;

type
  TCharPredicateFactory = class(TMethodFactory<Char>)
  public
    class function IsControl : TPredicate<Char>;
    class function IsDigit : TPredicate<Char>;
    class function IsHighSurrogate : TPredicate<Char>;
    class function IsInArray(const SomeChars: array of Char) : TPredicate<Char>;
    class function IsLetter : TPredicate<Char>;
    class function IsLetterOrDigit : TPredicate<Char>;
    class function IsLower : TPredicate<Char>;
    class function IsLowSurrogate : TPredicate<Char>;
    class function IsNumber : TPredicate<Char>;
    class function IsPunctuation : TPredicate<Char>;
    class function IsSeparator : TPredicate<Char>;
    class function IsSurrogate : TPredicate<Char>;
    class function IsSymbol : TPredicate<Char>;
    class function IsUpper : TPredicate<Char>;
    class function IsWhiteSpace : TPredicate<Char>;
    class function Matches(const AChar : Char; IgnoreCase : Boolean) : TPredicate<Char>;
  end;


implementation
uses
  System.Character;

{ TCharPredicateFactory }

class function TCharPredicateFactory.IsControl: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsControl;
            end;
end;

class function TCharPredicateFactory.IsDigit: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsDigit;
            end;
end;

class function TCharPredicateFactory.IsHighSurrogate: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsHighSurrogate;
            end;
end;

class function TCharPredicateFactory.IsInArray(
  const SomeChars: array of Char): TPredicate<Char>;
var
  LSomeChars : array of Char;
  I : Integer;
begin
  // was getting an "unable to capture symbol" error when capturing SomeChars directly.
  SetLength(LSomeChars, Length(SomeChars));
  for I := Low(SomeChars) to High(SomeChars) do
    LSomeChars[i] := SomeChars[i];

  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsInArray(LSomeChars);
            end;
end;

class function TCharPredicateFactory.IsLetter: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsLetter;
            end;
end;

class function TCharPredicateFactory.IsLetterOrDigit: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsLetterOrDigit;
            end;
end;

class function TCharPredicateFactory.IsLower: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsLower;
            end;
end;

class function TCharPredicateFactory.IsLowSurrogate: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsLowSurrogate;
            end;
end;

class function TCharPredicateFactory.IsNumber: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsNumber;
            end;
end;

class function TCharPredicateFactory.IsPunctuation: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsPunctuation;
            end;
end;

class function TCharPredicateFactory.IsSeparator: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsSeparator;
            end;
end;

class function TCharPredicateFactory.IsSurrogate: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsSurrogate;
            end;
end;

class function TCharPredicateFactory.IsSymbol: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsSymbol;
            end;
end;

class function TCharPredicateFactory.IsUpper: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsUpper;
            end;
end;

class function TCharPredicateFactory.IsWhiteSpace: TPredicate<Char>;
begin
  Result := function (CurrentValue : Char) : Boolean
            begin
                Result := CurrentValue.IsWhiteSpace;
            end;
end;

class function TCharPredicateFactory.Matches(
  const AChar: Char; IgnoreCase : Boolean): TPredicate<Char>;
begin
  Result := function (Value : Char) : Boolean
            begin
            if IgnoreCase then
              Result := Value.ToUpper = AChar.ToUpper
            else
              Result := Value = AChar;
            end;
end;

end.
