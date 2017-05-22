unit FluentQuery.Components;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Classes,
  System.TypInfo,
  FluentQuery.Integers,
  FluentQuery.Strings;

type
  IUnboundComponentQuery<T : TComponent> = interface;

  IBoundComponentQuery<T : TComponent> = interface(IBaseQuery<T>)
    function GetEnumerator: IBoundComponentQuery<T>;
    // query operations
    function IsA(AClass : TClass) : IBoundComponentQuery<T>;
    function Map(Transformer : TProc<T>) : IBoundComponentQuery<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IBoundComponentQuery<T>; overload;
    function TakeWhile(Predicate : TPredicate<T>): IBoundComponentQuery<T>; overload;
    function Where(Predicate : TPredicate<T>) : IBoundComponentQuery<T>;
    function HasProperty(const Name : string; PropertyType : TTypeKind) : IBoundComponentQuery<T>;
    function IntegerProperty(const Name : string; const Value : Integer) : IBoundComponentQuery<T>; overload;
    function IntegerProperty(const Name : string; Query : IUnboundIntegerQuery) : IBoundComponentQuery<T>; overload;
    function StringProperty(const Name : string; const Value : String; IgnoreCase : Boolean = True) : IBoundComponentQuery<T>; overload;
    function StringProperty(const Name : string; Query : IUnboundStringQuery) : IBoundComponentQuery<T>; overload;
    function BooleanProperty(const Name : string; const Value : Boolean) : IBoundComponentQuery<T>;
    function Skip(Count : Integer): IBoundComponentQuery<T>;
    function SkipWhile(UnboundQuery : IUnboundComponentQuery<T>) : IBoundComponentQuery<T>; overload;
    function TagEquals(const TagValue : NativeInt) : IBoundComponentQuery<T>;
    function Take(Count : Integer): IBoundComponentQuery<T>;
    function TakeWhile(UnboundQuery : IUnboundComponentQuery<T>): IBoundComponentQuery<T>; overload;
    function WhereNot(UnboundQuery : IUnboundComponentQuery<T>) : IBoundComponentQuery<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IBoundComponentQuery<T>; overload;
    // terminating operations
    function First : T;
    function Count : Integer;
  end;

  IUnboundComponentQuery<T : TComponent> = interface(IBaseQuery<T>)
    function GetEnumerator: IUnboundComponentQuery<T>;
    function From(Owner : TComponent) : IBoundComponentQuery<T>;
    // query operations
    function IsA(AClass : TClass) : IUnboundComponentQuery<T>;
    function Map(Transformer : TProc<T>) : IUnboundComponentQuery<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IUnboundComponentQuery<T>; overload;
    function TakeWhile(Predicate : TPredicate<T>): IUnboundComponentQuery<T>; overload;
    function Where(Predicate : TPredicate<T>) : IUnboundComponentQuery<T>;
    function HasProperty(const Name : string; PropertyType : TTypeKind) : IUnboundComponentQuery<T>;
    function IntegerProperty(const Name : string; const Value : Integer) : IUnboundComponentQuery<T>; overload;
    function IntegerProperty(const Name : string; Query : IUnboundIntegerQuery) : IUnboundComponentQuery<T>; overload;
    function StringProperty(const Name : string; const Value : String; IgnoreCase : Boolean = True) : IUnboundComponentQuery<T>; overload;
    function StringProperty(const Name : string; Query : IUnboundStringQuery) : IUnboundComponentQuery<T>; overload;
    function BooleanProperty(const Name : string; const Value : Boolean) : IUnboundComponentQuery<T>;
    function Skip(Count : Integer): IUnboundComponentQuery<T>;
    function SkipWhile(UnboundQuery : IUnboundComponentQuery<T>) : IUnboundComponentQuery<T>; overload;
    function TagEquals(const TagValue : NativeInt) : IUnboundComponentQuery<T>;
    function Take(Count : Integer): IUnboundComponentQuery<T>;
    function TakeWhile(UnboundQuery : IUnboundComponentQuery<T>): IUnboundComponentQuery<T>; overload;
    function WhereNot(UnboundQuery : IUnboundComponentQuery<T>) : IUnboundComponentQuery<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IUnboundComponentQuery<T>; overload;
    // terminating operations
    function Predicate : TPredicate<T>;
  end;

  TComponentQuery<T : TComponent> = class(TBaseQuery<T>,
                              IBoundComponentQuery<T>,
                              IUnboundComponentQuery<T>)
  protected
    type
      TComponentQueryImpl<TReturnType : IBaseQuery<T>> = class
      private
        FQuery : TComponentQuery<T>;
      public
        constructor Create(Query : TComponentQuery<T>); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(Owner : TComponent) : IBoundComponentQuery<T>;
        // Primitive Operations
        function Map(Transformer : TProc<T>) : TReturnType;
        function SkipWhile(Predicate : TPredicate<T>) : TReturnType; overload;
        function TakeWhile(Predicate : TPredicate<T>): TReturnType; overload;
        function Where(Predicate : TPredicate<T>) : TReturnType;
        // Derivative Operations
        function HasProperty(const Name : string; PropertyType : TTypeKind) : TReturnType;
        function IntegerProperty(const Name : string; const Value : Integer) : TReturnType; overload;
        function IntegerProperty(const Name : string; Query : IUnboundIntegerQuery) : TReturnType; overload;
        function StringProperty(const Name : string; const Value : String; IgnoreCase : Boolean = True) : TReturnType; overload;
        function StringProperty(const Name : string; Query : IUnboundStringQuery) : TReturnType; overload;
        function BooleanProperty(const Name : string; const Value : Boolean) : TReturnType;
        function IsA(AClass : TClass) : TReturnType;
        function Skip(Count : Integer): TReturnType;
        function SkipWhile(UnboundQuery : IUnboundComponentQuery<T>) : TReturnType; overload;
        function TagEquals(const TagValue : NativeInt) : TReturnType;
        function Take(Count : Integer): TReturnType;
        function TakeWhile(UnboundQuery : IUnboundComponentQuery<T>): TReturnType; overload;
        function WhereNot(UnboundQuery : IUnboundComponentQuery<T>) : TReturnType; overload;
        function WhereNot(Predicate : TPredicate<T>) : TReturnType; overload;
        // Terminating Operations
        function Predicate : TPredicate<T>;
        function First : T;
        function Count : Integer;
      end;
  protected
    FBoundQuery : TComponentQueryImpl<IBoundComponentQuery<T>>;
    FUnboundQuery : TComponentQueryImpl<IUnboundComponentQuery<T>>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<T>;
                       UpstreamQuery : IBaseQuery<T> = nil;
                       SourceData : IMinimalEnumerator<T> = nil); override;
    destructor Destroy; override;
    property BoundQuery : TComponentQueryImpl<IBoundComponentQuery<T>>
                                       read FBoundQuery implements IBoundComponentQuery<T>;
    property UnboundQuery : TComponentQueryImpl<IUnboundComponentQuery<T>>
                                       read FUnboundQuery implements IUnboundComponentQuery<T>;
  end;

  ComponentQuery<T : TComponent> = class
  public
    class function Select : IUnboundComponentQuery<T>;
  end;




implementation
uses
  FluentQuery.Components.MethodFactories, FluentQuery.GenericObjects, FluentQuery.Integers.MethodFactories,
  FluentQuery.Strings.MethodFactories, FluentQuery.Core.Reduce;

{ TComponentQueryEnumerator<T> }

constructor TComponentQuery<T>.Create(
  EnumerationStrategy: TEnumerationStrategy<T>;
  UpstreamQuery: IBaseQuery<T>; SourceData: IMinimalEnumerator<T>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TComponentQueryImpl<IBoundComponentQuery<T>>.Create(self);
  FUnboundQuery := TComponentQueryImpl<IUnboundComponentQuery<T>>.Create(self);
end;

destructor TComponentQuery<T>.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;

{ TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType> }

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.BooleanProperty(
  const Name: string; const Value: Boolean): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.BooleanPropertyNamedWithValue(Name, Value));
{$IFDEF DEBUG}
  Result.OperationName := 'BooleanProperty(Name, Value)';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.Count: Integer;
begin
  Result := TReducer<T,Integer>.Reduce(FQuery,
                                       0,
                                       function(Accumulator : Integer; NextValue : T): Integer
                                       begin
                                         Result := Accumulator + 1;
                                       end);
end;

constructor TComponentQuery<T>.TComponentQueryImpl<TReturnType>.Create(
  Query: TComponentQuery<T>);
begin
  FQuery := Query;
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.First: T;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.From(
  Owner: TComponent): IBoundComponentQuery<T>;
var
  LEnumeratorWrapper : IMinimalEnumerator<TComponent>;
  LSuperTypeAdapter : TSuperTypeEnumeratorAdapter<TComponent, T>;
begin
  LEnumeratorWrapper := TComponentEnumeratorAdapter.Create(Owner.GetEnumerator) as IMinimalEnumerator<TComponent>;
  LSuperTypeAdapter := TSuperTypeEnumeratorAdapter<TComponent, T>.Create(
                         ObjectQuery<TComponent>.Select.From(LEnumeratorWrapper).IsA(T));
  Result := TComponentQuery<T>.Create(TEnumerationStrategy<T>.Create,
                                       IBaseQuery<T>(FQuery),
                                       LSuperTypeAdapter);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Owner.Name]);
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.HasProperty(
  const Name: string; PropertyType: TTypeKind): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.PropertyNamedOfType(Name, PropertyType));
{$IFDEF DEBUG}
  Result.OperationName := 'HasProperty(Name, PropertyType)';
{$ENDIF}
end;

{$ENDIF}

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.IntegerProperty(
  const Name: string; const Value: Integer): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.IntegerPropertyNamedWithValue(Name, TIntegerMethodFactory.Equals(Value)));
{$IFDEF DEBUG}
  Result.OperationName := 'IntegerProperty(Name, Value)';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.IntegerProperty(
  const Name: string; Query: IUnboundIntegerQuery): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.IntegerPropertyNamedWithValue(Name, Query.Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'IntegerProperty(Name, ' + Query.OperationPath + ')';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.IsA(
  AClass: TClass): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.IsA(AClass));
{$IFDEF DEBUG}
  Result.OperationName := 'IsA';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.Map(
  Transformer: TProc<T>): TReturnType;
begin
  Result := TComponentQuery<T>.Create(
              TIsomorphicTransformEnumerationStrategy<T>.Create(
                TComponentMethodFactory<T>.InPlaceTransformer(Transformer)),
              IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.Predicate: TPredicate<T>;
begin
  Result := TComponentMethodFactory<T>.QuerySingleValue(FQuery);
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.SkipWhile(
  UnboundQuery: IUnboundComponentQuery<T>): TReturnType;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.StringProperty(
  const Name: string; Query: IUnboundStringQuery): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.StringPropertyNamedWithValue(Name,
                                                                          Query.Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'StringProperty(Name, Value)';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.StringProperty(
  const Name, Value: String; IgnoreCase : Boolean): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.StringPropertyNamedWithValue(Name,
                                                                          TStringMethodFactory.Matches(Value, IgnoreCase)));
{$IFDEF DEBUG}
  Result.OperationName := 'StringProperty(Name, Value)';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.SkipWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TComponentQuery<T>.Create(TSkipWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.TakeWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TComponentQuery<T>.Create(TTakeWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.Where(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TComponentQuery<T>.Create(TWhereEnumerationStrategy<T>.Create(Predicate),
                                             IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.Skip(
  Count: Integer): TReturnType;
begin
  Result := SkipWhile(TComponentMethodFactory<T>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.TagEquals(
  const TagValue: NativeInt): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.TagEquals(TagValue));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [TagValue]);
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.Take(
  Count: Integer): TReturnType;
begin
  Result := TakeWhile(TComponentMethodFactory<T>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.TakeWhile(
  UnboundQuery: IUnboundComponentQuery<T>): TReturnType;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.WhereNot(
  UnboundQuery: IUnboundComponentQuery<T>): TReturnType;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TComponentQuery<T>.TComponentQueryImpl<TReturnType>.WhereNot(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ ComponentQuery<T> }

class function ComponentQuery<T>.Select: IUnboundComponentQuery<T>;
begin
  Result := TComponentQuery<T>.Create(TEnumerationStrategy<T>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'ComponentQuery.Select<T>';
{$ENDIF}
end;

end.
