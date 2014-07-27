unit FluentQuery.Components;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Classes,
  System.TypInfo;

type
  IUnboundComponentQueryEnumerator<T : TComponent> = interface;

  IBoundComponentQueryEnumerator<T : TComponent> = interface(IBaseQueryEnumerator<T>)
    function GetEnumerator: IBoundComponentQueryEnumerator<T>;
    // query operations
    function IsA(AClass : TClass) : IBoundComponentQueryEnumerator<T>;
    function Map(Transformer : TProc<T>) : IBoundComponentQueryEnumerator<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IBoundComponentQueryEnumerator<T>; overload;
    function TakeWhile(Predicate : TPredicate<T>): IBoundComponentQueryEnumerator<T>; overload;
    function Where(Predicate : TPredicate<T>) : IBoundComponentQueryEnumerator<T>;
    function HasProperty(const Name : string; PropertyType : TTypeKind) : IBoundComponentQueryEnumerator<T>;
    function Skip(Count : Integer): IBoundComponentQueryEnumerator<T>;
    function SkipWhile(UnboundQuery : IUnboundComponentQueryEnumerator<T>) : IBoundComponentQueryEnumerator<T>; overload;
    function TagEquals(const TagValue : NativeInt) : IBoundComponentQueryEnumerator<T>;
    function Take(Count : Integer): IBoundComponentQueryEnumerator<T>;
    function TakeWhile(UnboundQuery : IUnboundComponentQueryEnumerator<T>): IBoundComponentQueryEnumerator<T>; overload;
    function WhereNot(UnboundQuery : IUnboundComponentQueryEnumerator<T>) : IBoundComponentQueryEnumerator<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IBoundComponentQueryEnumerator<T>; overload;
    // terminating operations
    function First : T;
  end;

  IUnboundComponentQueryEnumerator<T : TComponent> = interface(IBaseQueryEnumerator<T>)
    function GetEnumerator: IUnboundComponentQueryEnumerator<T>;
    function From(Owner : TComponent) : IBoundComponentQueryEnumerator<T>;
    // query operations
    function IsA(AClass : TClass) : IUnboundComponentQueryEnumerator<T>;
    function Map(Transformer : TProc<T>) : IUnboundComponentQueryEnumerator<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IUnboundComponentQueryEnumerator<T>; overload;
    function TakeWhile(Predicate : TPredicate<T>): IUnboundComponentQueryEnumerator<T>; overload;
    function Where(Predicate : TPredicate<T>) : IUnboundComponentQueryEnumerator<T>;
    function HasProperty(const Name : string; PropertyType : TTypeKind) : IUnboundComponentQueryEnumerator<T>;
    function Skip(Count : Integer): IUnboundComponentQueryEnumerator<T>;
    function SkipWhile(UnboundQuery : IUnboundComponentQueryEnumerator<T>) : IUnboundComponentQueryEnumerator<T>; overload;
    function TagEquals(const TagValue : NativeInt) : IUnboundComponentQueryEnumerator<T>;
    function Take(Count : Integer): IUnboundComponentQueryEnumerator<T>;
    function TakeWhile(UnboundQuery : IUnboundComponentQueryEnumerator<T>): IUnboundComponentQueryEnumerator<T>; overload;
    function WhereNot(UnboundQuery : IUnboundComponentQueryEnumerator<T>) : IUnboundComponentQueryEnumerator<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IUnboundComponentQueryEnumerator<T>; overload;
    // terminating operations
    function Predicate : TPredicate<T>;
  end;

  TComponentQueryEnumerator<T : TComponent> = class(TBaseQueryEnumerator<T>,
                              IBoundComponentQueryEnumerator<T>,
                              IUnboundComponentQueryEnumerator<T>)
  protected
    type
      TComponentQueryEnumeratorImpl<TReturnType : IBaseQueryEnumerator<T>> = class
      private
        FQuery : TComponentQueryEnumerator<T>;
      public
        constructor Create(Query : TComponentQueryEnumerator<T>); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(Owner : TComponent) : IBoundComponentQueryEnumerator<T>;
        // Primitive Operations
        function Map(Transformer : TProc<T>) : TReturnType;
        function SkipWhile(Predicate : TPredicate<T>) : TReturnType; overload;
        function TakeWhile(Predicate : TPredicate<T>): TReturnType; overload;
        function Where(Predicate : TPredicate<T>) : TReturnType;
        // Derivative Operations
        function HasProperty(const Name : string; PropertyType : TTypeKind) : TReturnType;
        function IsA(AClass : TClass) : TReturnType;
        function Skip(Count : Integer): TReturnType;
        function SkipWhile(UnboundQuery : IUnboundComponentQueryEnumerator<T>) : TReturnType; overload;
        function TagEquals(const TagValue : NativeInt) : TReturnType;
        function Take(Count : Integer): TReturnType;
        function TakeWhile(UnboundQuery : IUnboundComponentQueryEnumerator<T>): TReturnType; overload;
        function WhereNot(UnboundQuery : IUnboundComponentQueryEnumerator<T>) : TReturnType; overload;
        function WhereNot(Predicate : TPredicate<T>) : TReturnType; overload;
        // Terminating Operations
        function Predicate : TPredicate<T>;
        function First : T;
      end;
  protected
    FBoundQueryEnumerator : TComponentQueryEnumeratorImpl<IBoundComponentQueryEnumerator<T>>;
    FUnboundQueryEnumerator : TComponentQueryEnumeratorImpl<IUnboundComponentQueryEnumerator<T>>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<T>;
                       UpstreamQuery : IBaseQueryEnumerator<T> = nil;
                       SourceData : IMinimalEnumerator<T> = nil); override;
    destructor Destroy; override;
    property BoundQueryEnumerator : TComponentQueryEnumeratorImpl<IBoundComponentQueryEnumerator<T>>
                                       read FBoundQueryEnumerator implements IBoundComponentQueryEnumerator<T>;
    property UnboundQueryEnumerator : TComponentQueryEnumeratorImpl<IUnboundComponentQueryEnumerator<T>>
                                       read FUnboundQueryEnumerator implements IUnboundComponentQueryEnumerator<T>;
  end;

  ComponentQuery<T : TComponent> = class
  public
    class function Select : IUnboundComponentQueryEnumerator<T>;
  end;




implementation
uses
  FluentQuery.Components.MethodFactories, FluentQuery.GenericObjects;

{ TComponentQueryEnumerator<T> }

constructor TComponentQueryEnumerator<T>.Create(
  EnumerationStrategy: TEnumerationStrategy<T>;
  UpstreamQuery: IBaseQueryEnumerator<T>; SourceData: IMinimalEnumerator<T>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQueryEnumerator := TComponentQueryEnumeratorImpl<IBoundComponentQueryEnumerator<T>>.Create(self);
  FUnboundQueryEnumerator := TComponentQueryEnumeratorImpl<IUnboundComponentQueryEnumerator<T>>.Create(self);
end;

destructor TComponentQueryEnumerator<T>.Destroy;
begin
  FBoundQueryEnumerator.Free;
  FUnboundQueryEnumerator.Free;
  inherited;
end;

{ TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType> }

constructor TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.Create(
  Query: TComponentQueryEnumerator<T>);
begin
  FQuery := Query;
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.First: T;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.From(
  Owner: TComponent): IBoundComponentQueryEnumerator<T>;
var
  LEnumeratorWrapper : IMinimalEnumerator<TComponent>;
  LSuperTypeAdapter : TSuperTypeEnumeratorAdapter<TComponent, T>;
begin
  LEnumeratorWrapper := TComponentEnumeratorAdapter.Create(Owner.GetEnumerator) as IMinimalEnumerator<TComponent>;
  LSuperTypeAdapter := TSuperTypeEnumeratorAdapter<TComponent, T>.Create(
                         ObjectQuery<TComponent>.Select.From(LEnumeratorWrapper).IsA(T));
  Result := TComponentQueryEnumerator<T>.Create(TEnumerationStrategy<T>.Create,
                                       IBaseQueryEnumerator<T>(FQuery),
                                       LSuperTypeAdapter);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Owner.Name]);
{$ENDIF}

end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.HasProperty(
  const Name: string; PropertyType: TTypeKind): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.PropertyNamedOfType(Name, PropertyType));
{$IFDEF DEBUG}
  Result.OperationName := 'HasProperty(Name, PropertyType)';
{$ENDIF}
end;

{$ENDIF}

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.IsA(
  AClass: TClass): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.IsA(AClass));
{$IFDEF DEBUG}
  Result.OperationName := 'IsA';
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.Map(
  Transformer: TProc<T>): TReturnType;
begin
  Result := TComponentQueryEnumerator<T>.Create(
              TIsomorphicTransformEnumerationStrategy<T>.Create(
                TComponentMethodFactory<T>.InPlaceTransformer(Transformer)),
              IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.Predicate: TPredicate<T>;
begin
  Result := TComponentMethodFactory<T>.QuerySingleValue(FQuery);
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.SkipWhile(
  UnboundQuery: IUnboundComponentQueryEnumerator<T>): TReturnType;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.SkipWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TComponentQueryEnumerator<T>.Create(TSkipWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.TakeWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TComponentQueryEnumerator<T>.Create(TTakeWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.Where(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TComponentQueryEnumerator<T>.Create(TWhereEnumerationStrategy<T>.Create(Predicate),
                                             IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.Skip(
  Count: Integer): TReturnType;
begin
  Result := SkipWhile(TComponentMethodFactory<T>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.TagEquals(
  const TagValue: NativeInt): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.TagEquals(TagValue));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [TagValue]);
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.Take(
  Count: Integer): TReturnType;
begin
  Result := TakeWhile(TComponentMethodFactory<T>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.TakeWhile(
  UnboundQuery: IUnboundComponentQueryEnumerator<T>): TReturnType;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.WhereNot(
  UnboundQuery: IUnboundComponentQueryEnumerator<T>): TReturnType;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.WhereNot(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := Where(TComponentMethodFactory<T>.InvertPredicate(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ ComponentQuery<T> }

class function ComponentQuery<T>.Select: IUnboundComponentQueryEnumerator<T>;
begin
  Result := TComponentQueryEnumerator<T>.Create(TEnumerationStrategy<T>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'ComponentQuery.Select<T>';
{$ENDIF}
end;

end.
