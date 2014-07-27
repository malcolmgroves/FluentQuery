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
        function IsA(AClass : TClass) : TReturnType;
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
  FluentQuery.GenericObjects.MethodFactories, FluentQuery.GenericObjects;

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
{$ENDIF}

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.IsA(
  AClass: TClass): TReturnType;
begin
  Result := Where(TGenericObjectMethodFactory<T>.IsA(AClass));
{$IFDEF DEBUG}
  Result.OperationName := 'IsA';
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.Map(
  Transformer: TProc<T>): TReturnType;
begin
  Result := TComponentQueryEnumerator<T>.Create(
              TIsomorphicTransformEnumerationStrategy<T>.Create(
                TGenericObjectMethodFactory<T>.InPlaceTransformer(Transformer)),
              IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;

function TComponentQueryEnumerator<T>.TComponentQueryEnumeratorImpl<TReturnType>.Predicate: TPredicate<T>;
begin
  Result := TGenericObjectMethodFactory<T>.QuerySingleValue(FQuery);
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

{ ComponentQuery<T> }

class function ComponentQuery<T>.Select: IUnboundComponentQueryEnumerator<T>;
begin
  Result := TComponentQueryEnumerator<T>.Create(TEnumerationStrategy<T>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'ComponentQuery.Select<T>';
{$ENDIF}
end;

end.
