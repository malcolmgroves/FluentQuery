unit FluentQuery.Strings;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Generics.Collections,
  System.Classes;

type
  IBoundStringQueryEnumerator = interface(IBaseQueryEnumerator<String>)
    function GetEnumerator: IBoundStringQueryEnumerator;
    function First : IBoundStringQueryEnumerator;
    function Skip(Count : Integer): IBoundStringQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<String>) : IBoundStringQueryEnumerator;
    function Take(Count : Integer): IBoundStringQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<String>): IBoundStringQueryEnumerator;
    function Where(Predicate : TPredicate<String>) : IBoundStringQueryEnumerator;
    function Matches(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQueryEnumerator;
    function Contains(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQueryEnumerator;
    function StartsWith(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQueryEnumerator;
    function EndsWith(const Value : String; IgnoreCase : Boolean = True) : IBoundStringQueryEnumerator;
    function ToTStrings : TStrings;
  end;

  IUnboundStringQueryEnumerator = interface(IBaseQueryEnumerator<String>)
    function GetEnumerator: IUnboundStringQueryEnumerator;
    function From(Container : TEnumerable<String>) : IBoundStringQueryEnumerator; overload;
    function From(Strings : TStrings) : IBoundStringQueryEnumerator; overload;
    function First : IUnboundStringQueryEnumerator;
    function Skip(Count : Integer): IUnboundStringQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<String>) : IUnboundStringQueryEnumerator;
    function Take(Count : Integer): IUnboundStringQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<String>): IUnboundStringQueryEnumerator;
    function Where(Predicate : TPredicate<String>) : IUnboundStringQueryEnumerator;
    function Matches(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function Contains(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function StartsWith(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function EndsWith(const Value : String; IgnoreCase : Boolean = True) : IUnboundStringQueryEnumerator;
    function Predicate : TPredicate<string>;
  end;

  function Query : IUnboundStringQueryEnumerator;

implementation

type
  TStringQueryEnumerator = class(TBaseQueryEnumerator<String>,
                                 IBoundStringQueryEnumerator,
                                 IUnboundStringQueryEnumerator,
                                 IBaseQueryEnumerator<String>,
                                 IMinimalEnumerator<String>)
  protected
    type
      TStringQueryEnumeratorImpl<T : IBaseQueryEnumerator<String>> = class
      private
        FQuery : TStringQueryEnumerator;
      public
        constructor Create(Query : TStringQueryEnumerator); virtual;
        function GetEnumerator: T;
        function First : T;
        function From(Container : TEnumerable<String>) : IBoundStringQueryEnumerator; overload;
        function From(Strings : TStrings) : IBoundStringQueryEnumerator; overload;
        function Predicate : TPredicate<string>;
        function Skip(Count : Integer): T;
        function SkipWhile(Predicate : TPredicate<String>) : T;
        function Take(Count : Integer): T;
        function TakeWhile(Predicate : TPredicate<String>): T;
        function Where(Predicate : TPredicate<String>) : T;
        function Matches(const Value : String; IgnoreCase : Boolean = True) : T;
        function Contains(const Value : String; IgnoreCase : Boolean = True) : T;
        function StartsWith(const Value : String; IgnoreCase : Boolean = True) : T;
        function EndsWith(const Value : String; IgnoreCase : Boolean = True) : T;
        function ToTStrings : TStrings;
      end;
  protected
    FBoundStringQueryEnumerator : TStringQueryEnumeratorImpl<IBoundStringQueryEnumerator>;
    FUnboundStringQueryEnumerator : TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<String>;
                       UpstreamQuery : IBaseQueryEnumerator<String> = nil;
                       SourceData : IMinimalEnumerator<String> = nil); override;
    destructor Destroy; override;
    property BoundStringQueryEnumerator : TStringQueryEnumeratorImpl<IBoundStringQueryEnumerator>
                                       read FBoundStringQueryEnumerator implements IBoundStringQueryEnumerator;
    property UnboundStringQueryEnumerator : TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>
                                       read FUnboundStringQueryEnumerator implements IUnboundStringQueryEnumerator;
  end;


function Query : IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create);
end;

{ TStringQueryEnumerator }

constructor TStringQueryEnumerator.Create(
  EnumerationStrategy: TEnumerationStrategy<String>;
  UpstreamQuery: IBaseQueryEnumerator<String>;
  SourceData: IMinimalEnumerator<String>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundStringQueryEnumerator := TStringQueryEnumeratorImpl<IBoundStringQueryEnumerator>.Create(self);
  FUnboundStringQueryEnumerator := TStringQueryEnumeratorImpl<IUnboundStringQueryEnumerator>.Create(self);
end;


destructor TStringQueryEnumerator.Destroy;
begin
  FBoundStringQueryEnumerator.Free;
  FUnboundStringQueryEnumerator.Free;
  inherited;
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Contains(
  const Value: String; IgnoreCase: Boolean): T;
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
                                          IBaseQueryEnumerator<String>(FQuery));
end;

constructor TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Create(Query: TStringQueryEnumerator);
begin
  FQuery := Query;
end;


function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.EndsWith(const Value: String; IgnoreCase: Boolean): T;
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
                                          IBaseQueryEnumerator<String>(FQuery));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.First: T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(1)),
                                          IBaseQueryEnumerator<String>(FQuery));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.From(Container: TEnumerable<String>): IBoundStringQueryEnumerator;
var
  EnumeratorAdapter : IMinimalEnumerator<String>;
begin
  EnumeratorAdapter := TGenericEnumeratorAdapter<String>.Create(Container.GetEnumerator) as IMinimalEnumerator<String>;
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
                                          IBaseQueryEnumerator<String>(FQuery),
                                          EnumeratorAdapter);
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.From(Strings: TStrings): IBoundStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
                                          IBaseQueryEnumerator<String>(FQuery),
                                          TStringsEnumeratorAdapter.Create(Strings.GetEnumerator));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Matches(
  const Value: String; IgnoreCase: Boolean): T;
var
  LMatchesPredicate : TPredicate<String>;
begin
  LMatchesPredicate := function (CurrentValue : String) : Boolean
                       begin
                         Result := CurrentValue.Compare(CurrentValue, Value, IgnoreCase) = 0;
                       end;

  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(LMatchesPredicate),
                                          IBaseQueryEnumerator<String>(FQuery));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Predicate: TPredicate<string>;
begin
  Result := function(Value : String) : boolean
            begin
              FQuery.SetSourceData(TSingleValueAdapter<String>.Create(Value));
              Result := FQuery.MoveNext;
            end;
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Skip(Count: Integer): T;
begin
  Result := TStringQueryEnumerator.Create(TSkipWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(Count)),
                                          IBaseQueryEnumerator<String>(FQuery));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.SkipWhile(
  Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TSkipWhileEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(FQuery));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.StartsWith(
  const Value: String; IgnoreCase: Boolean): T;
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
                                          IBaseQueryEnumerator<String>(FQuery));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Take(Count: Integer): T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(TPredicateFactory<String>.LessThanOrEqualTo(Count)),
                                          IBaseQueryEnumerator<String>(FQuery));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.TakeWhile(Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(FQuery));
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.ToTStrings: TStrings;
var
  LStrings : TStrings;
begin
  LStrings := TStringList.Create;

  while FQuery.MoveNext do
    LStrings.Add(FQuery.GetCurrent);

  Result := LStrings;
end;

function TStringQueryEnumerator.TStringQueryEnumeratorImpl<T>.Where(
  Predicate: TPredicate<String>): T;
begin
  Result := TStringQueryEnumerator.Create(TWhereEnumerationStrategy<String>.Create(Predicate),
                                          IBaseQueryEnumerator<String>(FQuery));
end;

end.
