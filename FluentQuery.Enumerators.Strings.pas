unit FluentQuery.Enumerators.Strings;

interface
uses
  FluentQuery.Types,
  FluentQuery,
  System.SysUtils,
  FluentQuery.EnumerationStrategies,
  FluentQuery.Enumerators;

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
    function Contains(const Value : String; IgnoreCase : Boolean = True) : IStringQueryEnumerator;
    function StartsWith(const Value : String; IgnoreCase : Boolean = True) : IStringQueryEnumerator;
    function EndsWith(const Value : String; IgnoreCase : Boolean = True) : IStringQueryEnumerator;
  end;


implementation

{ TStringQueryEnumerator }

function TStringQueryEnumerator.Contains(const Value: String;
  IgnoreCase: Boolean): IStringQueryEnumerator;
var
  LContainsPredicate : TPredicate<String>;
begin
  LContainsPredicate := function (CurrentValue : String) : Boolean
                        begin
                          if IgnoreCase then
                          begin
                            Result := UpperCase(CurrentValue).Contains(UpperCase(Value));
                          end
                          else
                            Result := CurrentValue.Contains(Value);
                        end;

  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TWhereEnumerationStrategy<String>.Create(LContainsPredicate));
end;

function TStringQueryEnumerator.EndsWith(const Value: String;
  IgnoreCase: Boolean): IStringQueryEnumerator;
var
  LEndsWithPredicate : TPredicate<String>;
begin
  LEndsWithPredicate := function (CurrentValue : String) : Boolean
                        begin
                          if IgnoreCase then
                          begin
                            Result := UpperCase(CurrentValue).EndsWith(UpperCase(Value));
                          end
                          else
                            Result := CurrentValue.EndsWith(Value);
                        end;

  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TWhereEnumerationStrategy<String>.Create(LEndsWithPredicate));
end;

function TStringQueryEnumerator.First: IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TTakeEnumerationStrategy<String>.Create(1));
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

  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TWhereEnumerationStrategy<String>.Create(LMatchesPredicate));
end;

function TStringQueryEnumerator.Skip(Count: Integer): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TSkipEnumerationStrategy<String>.Create(Count));
end;

function TStringQueryEnumerator.SkipWhile(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TSkipWhileEnumerationStrategy<String>.Create(Predicate));
end;

function TStringQueryEnumerator.StartsWith(const Value: String;
  IgnoreCase: Boolean): IStringQueryEnumerator;
var
  LStartsWithPredicate : TPredicate<String>;
begin
  LStartsWithPredicate := function (CurrentValue : String) : Boolean
                          begin
                            if IgnoreCase then
                            begin
                              Result := UpperCase(CurrentValue).StartsWith(UpperCase(Value));
                            end
                            else
                              Result := CurrentValue.StartsWith(Value);
                          end;

  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TWhereEnumerationStrategy<String>.Create(LStartsWithPredicate));
end;

function TStringQueryEnumerator.Take(Count: Integer): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TTakeEnumerationStrategy<String>.Create(Count));
end;

function TStringQueryEnumerator.TakeWhile(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TTakeWhileEnumerationStrategy<String>.Create(Predicate));
end;

function TStringQueryEnumerator.Where(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(IMinimalEnumerator<String>(self),
                                          TWhereEnumerationStrategy<String>.Create(Predicate));
end;


end.
