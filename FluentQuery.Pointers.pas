unit FluentQuery.Pointers;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Classes,
  System.Generics.Collections;

type
  IBoundPointerQueryEnumerator = interface(IBaseQueryEnumerator<Pointer>)
    function GetEnumerator: IBoundPointerQueryEnumerator;
    function IsAssigned : IBoundPointerQueryEnumerator;
  end;

  IUnboundPointerQueryEnumerator = interface(IBaseQueryEnumerator<Pointer>)
    function GetEnumerator: IUnboundPointerQueryEnumerator;
    function IsAssigned : IUnboundPointerQueryEnumerator;
    function From(List : TList) : IBoundPointerQueryEnumerator; overload;
    function From(Container : TEnumerable<Pointer>) : IBoundPointerQueryEnumerator; overload;
  end;

  function Query : IUnboundPointerQueryEnumerator;



implementation

type
  TPointerQueryEnumerator = class(TBaseQueryEnumerator<Pointer>,
                                  IBoundPointerQueryEnumerator,
                                  IUnboundPointerQueryEnumerator,
                                  IBaseQueryEnumerator<Pointer>,
                                  IMinimalEnumerator<Pointer>)
  protected
    type
      TPointerQueryEnumeratorImpl<T : IBaseQueryEnumerator<Pointer>> = class
      private
        FQuery : TPointerQueryEnumerator;
      public
        constructor Create(Query : TPointerQueryEnumerator); virtual;
        function GetEnumerator: T;
        function First : T;
        function From(List : TList) : IBoundPointerQueryEnumerator; overload;
        function From(Container : TEnumerable<Pointer>) : IBoundPointerQueryEnumerator; overload;
        function Skip(Count : Integer): T;
        function SkipWhile(Predicate : TPredicate<Pointer>) : T;
        function Take(Count : Integer): T;
        function TakeWhile(Predicate : TPredicate<Pointer>): T;
        function Where(Predicate : TPredicate<Pointer>) : T;
        function IsAssigned : T;
      end;
  protected
    FBoundPointerQueryEnumerator : TPointerQueryEnumeratorImpl<IBoundPointerQueryEnumerator>;
    FUnboundPointerQueryEnumerator : TPointerQueryEnumeratorImpl<IUnboundPointerQueryEnumerator>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Pointer>;
                       UpstreamQuery : IBaseQueryEnumerator<Pointer> = nil;
                       SourceData : IMinimalEnumerator<Pointer> = nil); override;
    destructor Destroy; override;
    property BoundStringQueryEnumerator : TPointerQueryEnumeratorImpl<IBoundPointerQueryEnumerator>
                                       read FBoundPointerQueryEnumerator implements IBoundPointerQueryEnumerator;
    property UnboundStringQueryEnumerator : TPointerQueryEnumeratorImpl<IUnboundPointerQueryEnumerator>
                                       read FUnboundPointerQueryEnumerator implements IUnboundPointerQueryEnumerator;
  end;


function Query : IUnboundPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TEnumerationStrategy<Pointer>.Create);
end;



{ TPointerQueryEnumerator }

constructor TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Create(
  Query: TPointerQueryEnumerator);
begin
  FQuery := Query;
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.First: T;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(1)),
                                           IBaseQueryEnumerator<Pointer>(FQuery));

end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.From(
  List: TList): IBoundPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TEnumerationStrategy<Pointer>.Create,
                                           IBaseQueryEnumerator<Pointer>(FQuery),
                                           TListEnumeratorAdapter.Create(List.GetEnumerator));
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.From(
  Container: TEnumerable<Pointer>): IBoundPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TEnumerationStrategy<Pointer>.Create,
                                           IBaseQueryEnumerator<Pointer>(FQuery),
                                           TGenericEnumeratorAdapter<Pointer>.Create(Container.GetEnumerator));
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.IsAssigned: T;
var
  LIsAssigned : TPredicate<Pointer>;
begin
  LIsAssigned := function (Value : Pointer): boolean
                 begin
                   Result := Assigned(Value);
                 end;

  Result := TPointerQueryEnumerator.Create(TWhereEnumerationStrategy<Pointer>.Create(LIsAssigned),
                                          IBaseQueryEnumerator<Pointer>(FQuery));
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Skip(Count: Integer): T;
begin
  Result := TPointerQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(Count)),
                                           IBaseQueryEnumerator<Pointer>(FQuery));
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.SkipWhile(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Pointer>.Create(Predicate),
                                           IBaseQueryEnumerator<Pointer>(FQuery));
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Take(Count: Integer): T;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(Count)),
                                           IBaseQueryEnumerator<Pointer>(FQuery));
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.TakeWhile(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(Predicate),
                                           IBaseQueryEnumerator<Pointer>(FQuery));
end;

function TPointerQueryEnumerator.TPointerQueryEnumeratorImpl<T>.Where(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQueryEnumerator.Create(TWhereEnumerationStrategy<Pointer>.Create(Predicate),
                                          IBaseQueryEnumerator<Pointer>(FQuery));
end;

{ TPointerQueryEnumerator }

constructor TPointerQueryEnumerator.Create(
  EnumerationStrategy: TEnumerationStrategy<Pointer>;
  UpstreamQuery: IBaseQueryEnumerator<Pointer>;
  SourceData: IMinimalEnumerator<Pointer>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundPointerQueryEnumerator := TPointerQueryEnumeratorImpl<IBoundPointerQueryEnumerator>.Create(self);
  FUnboundPointerQueryEnumerator := TPointerQueryEnumeratorImpl<IUnboundPointerQueryEnumerator>.Create(self);
end;

destructor TPointerQueryEnumerator.Destroy;
begin
  FBoundPointerQueryEnumerator.Free;
  FUnboundPointerQueryEnumerator.Free;
  inherited;
end;

end.
