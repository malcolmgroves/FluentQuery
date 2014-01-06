unit FluentQuery.Enumerators.Strings;

interface
uses
  FluentQuery.Types,
  FluentQuery,
  System.SysUtils,
  FluentQuery.EnumerationStrategies,
  FluentQuery.Enumerators,
  System.Generics.Collections,
  System.Classes;

type
  TStringQueryEnumerator = class;

  TStringQueryEnumeratorImpl<T : IBaseQueryEnumerator<String>> = class
    class function First(Query : TStringQueryEnumerator) : T;
    class function Skip(Query : TStringQueryEnumerator; Count : Integer): T;
    class function SkipWhile(Query : TStringQueryEnumerator; Predicate : TPredicate<String>) : T;
    class function Take(Query : TStringQueryEnumerator; Count : Integer): T;
    class function TakeWhile(Query : TStringQueryEnumerator; Predicate : TPredicate<String>): T;
    class function Where(Query : TStringQueryEnumerator; Predicate : TPredicate<String>) : T;
    class function Matches(Query : TStringQueryEnumerator; const Value : String; IgnoreCase : Boolean = True) : T;
    class function Contains(Query : TStringQueryEnumerator; const Value : String; IgnoreCase : Boolean = True) : T;
    class function StartsWith(Query : TStringQueryEnumerator; const Value : String; IgnoreCase : Boolean = True) : T;
    class function EndsWith(Query : TStringQueryEnumerator; const Value : String; IgnoreCase : Boolean = True) : T;
  end;


  TStringQueryEnumerator = class(TBaseQueryEnumerator<String>,
                                 IStringQueryEnumerator,
                                 IUnboundStringQueryEnumerator,
                                 IBaseQueryEnumerator<String>,
                                 IMinimalEnumerator<String>)
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

    // IUnboundStringQueryEnumerator Impl
    function UnboundGetEnumerator: IUnboundStringQueryEnumerator;
    function UnboundFirst : IUnboundStringQueryEnumerator;
    function UnboundSkip(Count : Integer): IUnboundStringQueryEnumerator;
    function UnboundSkipWhile(Predicate : TPredicate<String>) : IUnboundStringQueryEnumerator;
    function UnboundTake(Count : Integer): IUnboundStringQueryEnumerator;
    function UnboundTakeWhile(Predicate : TPredicate<String>): IUnboundStringQueryEnumerator;
    function UnboundWhere(Predicate : TPredicate<String>) : IUnboundStringQueryEnumerator;
    function UnboundMatches(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function UnboundContains(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function UnboundStartsWith(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function UnboundEndsWith(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function From(Container : TEnumerable<String>) : IStringQueryEnumerator; overload;
    function From(Strings : TStrings) : IStringQueryEnumerator; overload;
    function Predicate : TPredicate<string>;
    function IUnboundStringQueryEnumerator.GetEnumerator = UnboundGetEnumerator;
    function IUnboundStringQueryEnumerator.First = UnboundFirst;
    function IUnboundStringQueryEnumerator.Skip = UnboundSkip;
    function IUnboundStringQueryEnumerator.SkipWhile = UnboundSkipWhile;
    function IUnboundStringQueryEnumerator.Take = UnboundTake;
    function IUnboundStringQueryEnumerator.TakeWhile = UnboundTakeWhile;
    function IUnboundStringQueryEnumerator.Where = UnboundWhere;
    function IUnboundStringQueryEnumerator.Matches = UnboundMatches;
    function IUnboundStringQueryEnumerator.Contains = UnboundContains;
    function IUnboundStringQueryEnumerator.StartsWith = UnboundStartsWith;
    function IUnboundStringQueryEnumerator.EndsWith = UnboundEndsWith;
  end;

implementation

{ TStringQueryEnumerator }

function TStringQueryEnumerator.Contains(const Value: String;
  IgnoreCase: Boolean): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.Contains(self,
                                                                        Value,
                                                                        IgnoreCase);
end;

function TStringQueryEnumerator.EndsWith(const Value: String;
  IgnoreCase: Boolean): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.EndsWith(self,
                                                                        Value,
                                                                        IgnoreCase);
end;

function TStringQueryEnumerator.First: IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.First(self);
end;

function TStringQueryEnumerator.From(
  Container: TEnumerable<String>): IStringQueryEnumerator;
var
  EnumeratorAdapter : IMinimalEnumerator<String>;
begin
  EnumeratorAdapter := TGenericEnumeratorAdapter<String>.Create(Container.GetEnumerator) as IMinimalEnumerator<String>;
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
                                          IBaseQueryEnumerator<String>(self),
                                          EnumeratorAdapter);
end;

function TStringQueryEnumerator.From(Strings: TStrings): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
                                          IBaseQueryEnumerator<String>(self),
                                          TStringsEnumeratorAdapter.Create(Strings.GetEnumerator));
end;

function TStringQueryEnumerator.GetEnumerator: IStringQueryEnumerator;
begin
  Result := self;
end;

function TStringQueryEnumerator.Matches(const Value: String;
  IgnoreCase: Boolean): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.Matches(self,
                                                                       Value,
                                                                       IgnoreCase);
end;

function TStringQueryEnumerator.Predicate: TPredicate<string>;
begin
  Result := function(Value : String) : boolean
            begin
              self.SetSourceData(TSingleValueAdapter<String>.Create(Value));
              Result := MoveNext;
            end;
end;

function TStringQueryEnumerator.Skip(Count: Integer): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.Skip(self, Count);
end;

function TStringQueryEnumerator.SkipWhile(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.SkipWhile(self,
                                                                         Predicate);
end;

function TStringQueryEnumerator.StartsWith(const Value: String;
  IgnoreCase: Boolean): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.StartsWith(self,
                                                                          Value,
                                                                          IgnoreCase);
end;

function TStringQueryEnumerator.Take(Count: Integer): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.Take(self, Count);
end;

function TStringQueryEnumerator.TakeWhile(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.TakeWhile(self,
                                                                         Predicate);
end;

function TStringQueryEnumerator.UnboundContains(const Value: String;
  IgnoreCase: Boolean): IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.Contains(self,
                                                                        Value,
                                                                        IgnoreCase);
end;

function TStringQueryEnumerator.UnboundEndsWith(const Value: String;
  IgnoreCase: Boolean): IUnboundStringQueryEnumerator;
//var
//  LEndsWithPredicate : TPredicate<String>;
begin
//  LEndsWithPredicate := function (CurrentValue : String) : Boolean
//                        begin
//                          if IgnoreCase then
//                          begin
//                            Result := UpperCase(CurrentValue).EndsWith(UpperCase(Value));
//                          end
//                          else
//                            Result := CurrentValue.EndsWith(Value);
//                        end;
//
//  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LEndsWithPredicate),
//                                          IBaseQueryEnumerator<String>(self));

  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.EndsWith(self,
                                                                        Value,
                                                                        IgnoreCase);
end;

function TStringQueryEnumerator.UnboundFirst: IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.First(self);
end;

function TStringQueryEnumerator.UnboundGetEnumerator: IUnboundStringQueryEnumerator;
begin
  Result := IUnboundStringQueryEnumerator(GetEnumerator);
end;

function TStringQueryEnumerator.UnboundMatches(const Value: String;
  IgnoreCase: Boolean): IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.Matches(self,
                                                                       Value,
                                                                       IgnoreCase);
end;

function TStringQueryEnumerator.UnboundSkip(
  Count: Integer): IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.Skip(self, Count);
end;

function TStringQueryEnumerator.UnboundSkipWhile(
  Predicate: TPredicate<String>): IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.SkipWhile(self,
                                                                         Predicate);
end;

function TStringQueryEnumerator.UnboundStartsWith(const Value: String;
  IgnoreCase: Boolean): IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.StartsWith(self,
                                                                          Value,
                                                                          IgnoreCase);
end;

function TStringQueryEnumerator.UnboundTake(
  Count: Integer): IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.Take(self, Count);
end;

function TStringQueryEnumerator.UnboundTakeWhile(
  Predicate: TPredicate<String>): IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.TakeWhile(self,
                                                                         Predicate);
end;

function TStringQueryEnumerator.UnboundWhere(
  Predicate: TPredicate<String>): IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.Where(self,
                                                                      Predicate);
end;

function TStringQueryEnumerator.Where(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumeratorImpl<IStringQueryEnumerator>.Where(self,
                                                                      Predicate);
end;


{ TStringQueryEnumeratorImpl<T> }

class function TStringQueryEnumeratorImpl<T>.Contains(
  Query: TStringQueryEnumerator; const Value: String; IgnoreCase: Boolean): T;
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

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LContainsPredicate),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.EndsWith(Query: TStringQueryEnumerator;
  const Value: String; IgnoreCase: Boolean): T;
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

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LEndsWithPredicate),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.First(
  Query: TStringQueryEnumerator): T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(1)),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.Matches(
  Query: TStringQueryEnumerator; const Value: String; IgnoreCase: Boolean): T;
var
  LMatchesPredicate : TPredicate<String>;
begin
  LMatchesPredicate := function (CurrentValue : String) : Boolean
                       begin
                         Result := CurrentValue.Compare(CurrentValue, Value, IgnoreCase) = 0;
                       end;

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LMatchesPredicate),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.Skip(Query: TStringQueryEnumerator;
  Count: Integer): T;
begin
  Result := TStringQueryEnumerator.Create(TSkipWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(Count)),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.SkipWhile(
  Query: TStringQueryEnumerator; Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TSkipWhileEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.StartsWith(
  Query: TStringQueryEnumerator; const Value: String; IgnoreCase: Boolean): T;
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

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LStartsWithPredicate),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.Take(Query: TStringQueryEnumerator;
  Count: Integer): T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(Count)),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.TakeWhile(
  Query: TStringQueryEnumerator; Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(Query));
end;

class function TStringQueryEnumeratorImpl<T>.Where(
  Query: TStringQueryEnumerator; Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(Query));
end;

end.
