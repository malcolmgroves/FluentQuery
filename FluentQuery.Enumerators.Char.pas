unit FluentQuery.Enumerators.Char;

interface
uses
  FluentQuery.Types,
  System.SysUtils,
  FluentQuery.EnumerationStrategies,
  FluentQuery.Enumerators,
  System.Generics.Collections;

type
  IBoundCharQueryEnumerator = interface(IBaseQueryEnumerator<Char>)
    function GetEnumerator: IBoundCharQueryEnumerator;
    function First : IBoundCharQueryEnumerator;
    function Skip(Count : Integer): IBoundCharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : IBoundCharQueryEnumerator;
    function Take(Count : Integer): IBoundCharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): IBoundCharQueryEnumerator;
    function Where(Predicate : TPredicate<Char>) : IBoundCharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : IBoundCharQueryEnumerator;
    function IsControl: IBoundCharQueryEnumerator;
    function IsDigit: IBoundCharQueryEnumerator;
    function IsHighSurrogate: IBoundCharQueryEnumerator;
    function IsInArray(const SomeChars: array of Char): IBoundCharQueryEnumerator;
    function IsLetter: IBoundCharQueryEnumerator;
    function IsLetterOrDigit: IBoundCharQueryEnumerator;
    function IsLower: IBoundCharQueryEnumerator;
    function IsLowSurrogate: IBoundCharQueryEnumerator;
    function IsNumber: IBoundCharQueryEnumerator;
    function IsPunctuation: IBoundCharQueryEnumerator;
    function IsSeparator: IBoundCharQueryEnumerator;
    function IsSurrogate: IBoundCharQueryEnumerator;
    function IsSymbol: IBoundCharQueryEnumerator;
    function IsUpper: IBoundCharQueryEnumerator;
    function IsWhiteSpace: IBoundCharQueryEnumerator;
    function ToAString : String;
  end;

  IUnboundCharQueryEnumerator = interface(IBaseQueryEnumerator<Char>)
    function GetEnumerator: IUnboundCharQueryEnumerator;
    function First : IUnboundCharQueryEnumerator;
    function From(StringValue : String) : IBoundCharQueryEnumerator; overload;
    function From(Container : TEnumerable<Char>) : IBoundCharQueryEnumerator; overload;
    function Skip(Count : Integer): IUnboundCharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : IUnboundCharQueryEnumerator;
    function Take(Count : Integer): IUnboundCharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): IUnboundCharQueryEnumerator;
    function Where(Predicate : TPredicate<Char>) : IUnboundCharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : IUnboundCharQueryEnumerator;
    function IsControl: IUnboundCharQueryEnumerator;
    function IsDigit: IUnboundCharQueryEnumerator;
    function IsHighSurrogate: IUnboundCharQueryEnumerator;
    function IsInArray(const SomeChars: array of Char): IUnboundCharQueryEnumerator;
    function IsLetter: IUnboundCharQueryEnumerator;
    function IsLetterOrDigit: IUnboundCharQueryEnumerator;
    function IsLower: IUnboundCharQueryEnumerator;
    function IsLowSurrogate: IUnboundCharQueryEnumerator;
    function IsNumber: IUnboundCharQueryEnumerator;
    function IsPunctuation: IUnboundCharQueryEnumerator;
    function IsSeparator: IUnboundCharQueryEnumerator;
    function IsSurrogate: IUnboundCharQueryEnumerator;
    function IsSymbol: IUnboundCharQueryEnumerator;
    function IsUpper: IUnboundCharQueryEnumerator;
    function IsWhiteSpace: IUnboundCharQueryEnumerator;
    function Predicate : TPredicate<Char>;
  end;

  function Query : IUnboundCharQueryEnumerator;




implementation
uses
  System.Character;

type
  TCharQueryEnumerator = class(TBaseQueryEnumerator<Char>,
                               IBoundCharQueryEnumerator,
                               IUnboundCharQueryEnumerator,
                               IBaseQueryEnumerator<Char>,
                               IMinimalEnumerator<Char>)
  protected
    type
      TCharQueryEnumeratorImpl<T : IBaseQueryEnumerator<Char>> = class
      private
        FQuery : TCharQueryEnumerator;
      public
        constructor Create(Query : TCharQueryEnumerator); virtual;
        function GetEnumerator: T;
        function First : T;
        function From(StringValue : String) : IBoundCharQueryEnumerator; overload;
        function From(Collection : TEnumerable<Char>) : IBoundCharQueryEnumerator; overload;
        function Skip(Count : Integer): T;
        function SkipWhile(Predicate : TPredicate<Char>) : T;
        function Take(Count : Integer): T;
        function TakeWhile(Predicate : TPredicate<Char>): T;
        function Where(Predicate : TPredicate<Char>) : T;
        function Matches(const Value : Char; IgnoreCase : Boolean = True) : T;
        function IsControl: T;
        function IsDigit: T;
        function IsHighSurrogate: T;
        function IsInArray(const SomeChars: array of Char): T;
        function IsLetter: T;
        function IsLetterOrDigit: T;
        function IsLower: T;
        function IsLowSurrogate: T;
        function IsNumber: T;
        function IsPunctuation: T;
        function IsSeparator: T;
        function IsSurrogate: T;
        function IsSymbol: T;
        function IsUpper: T;
        function IsWhiteSpace: T;
        function Predicate : TPredicate<Char>;
        function ToAString : String;
      end;
  protected
    FBoundCharQueryEnumerator : TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>;
    FUnboundCharQueryEnumerator : TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Char>;
                       UpstreamQuery : IBaseQueryEnumerator<Char> = nil;
                       SourceData : IMinimalEnumerator<Char> = nil); override;
    destructor Destroy; override;
    property BoundCharQueryEnumerator : TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>
                                       read FBoundCharQueryEnumerator implements IBoundCharQueryEnumerator;
    property UnboundCharQueryEnumerator : TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>
                                       read FUnboundCharQueryEnumerator implements IUnboundCharQueryEnumerator;

  end;


function Query : IUnboundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create);
end;


{ TCharQueryEnumerator }

constructor TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Create(
  Query: TCharQueryEnumerator);
begin
  FQuery := Query;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.First: T;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(1)),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.From(
  Collection: TEnumerable<Char>): IBoundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        IBaseQueryEnumerator<Char>(FQuery),
                                        TGenericEnumeratorAdapter<Char>.Create(Collection.GetEnumerator) as IMinimalEnumerator<Char>);
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.From(
  StringValue: String): IBoundCharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        IBaseQueryEnumerator<Char>(FQuery),
                                        TStringEnumeratorAdapter.Create(StringValue));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsControl: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsControl;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsDigit: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsDigit;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsHighSurrogate: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsHighSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsInArray(const SomeChars: array of Char): T;
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
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsLetter: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLetter;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsLetterOrDigit: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLetterOrDigit;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsLower: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLower;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsLowSurrogate: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsLowSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsNumber: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsNumber;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsPunctuation: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsPunctuation;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsSeparator: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSeparator;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsSurrogate: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSurrogate;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsSymbol: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsSymbol;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsUpper: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsUpper;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.IsWhiteSpace: T;
var
  LMatchesPredicate : TPredicate<Char>;
begin
  LMatchesPredicate := function (CurrentValue : Char) : Boolean
                       begin
                           Result := CurrentValue.IsWhiteSpace;
                       end;

  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(LMatchesPredicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Matches(const Value: Char;
  IgnoreCase: Boolean): T;
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
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Predicate: TPredicate<Char>;
begin
  Result := function(Value : Char) : boolean
            begin
              FQuery.SetSourceData(TSingleValueAdapter<Char>.Create(Value));
              Result := FQuery.MoveNext;
            end;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Skip(Count: Integer): T;
begin
  Result := TCharQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(Count)),
                                       IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.SkipWhile(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Take(Count: Integer): T;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(TPredicateFactory<Char>.LessThanOrEqualTo(Count)),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.TakeWhile(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.ToAString: String;
var
  LString : String;
begin
  LString := '';

  while FQuery.MoveNext do
    LString := LString + FQuery.GetCurrent;

  Result := LString;
end;

function TCharQueryEnumerator.TCharQueryEnumeratorImpl<T>.Where(
  Predicate: TPredicate<Char>): T;
begin
  Result := TCharQueryEnumerator.Create(TWhereEnumerationStrategy<Char>.Create(Predicate),
                                        IBaseQueryEnumerator<Char>(FQuery));
end;

{ TCharQueryEnumerator }

constructor TCharQueryEnumerator.Create(
  EnumerationStrategy: TEnumerationStrategy<Char>;
  UpstreamQuery: IBaseQueryEnumerator<Char>;
  SourceData: IMinimalEnumerator<Char>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundCharQueryEnumerator := TCharQueryEnumeratorImpl<IBoundCharQueryEnumerator>.Create(self);
  FUnboundCharQueryEnumerator := TCharQueryEnumeratorImpl<IUnboundCharQueryEnumerator>.Create(self);
end;

destructor TCharQueryEnumerator.Destroy;
begin
  FBoundCharQueryEnumerator.Free;
  FUnboundCharQueryEnumerator.Free;
  inherited;
end;

end.
