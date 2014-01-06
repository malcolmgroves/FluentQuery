unit FluentQuery.Enumerators.Pointer;

interface
uses
  FluentQuery,
  FluentQuery.Types,
  System.SysUtils,
  FluentQuery.EnumerationStrategies,
  FluentQuery.Enumerators;

type
  TPointerQueryEnumerator = class(TBaseQueryEnumerator<Pointer>,
                                  IPointerQueryEnumerator,
                                  IBaseQueryEnumerator<Pointer>,
                                  IMinimalEnumerator<Pointer>)
    function GetEnumerator: IPointerQueryEnumerator;
    function First : IPointerQueryEnumerator;
    function Skip(Count : Integer): IPointerQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Pointer>) : IPointerQueryEnumerator;
    function Take(Count : Integer): IPointerQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Pointer>): IPointerQueryEnumerator;
    function Where(Predicate : TPredicate<Pointer>) : IPointerQueryEnumerator;
    function IsAssigned : IPointerQueryEnumerator;
  end;

implementation
uses
  RTTI;

{ TPointerQueryEnumerator }

function TPointerQueryEnumerator.First: IPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(1)),
                                           IBaseQueryEnumerator<Pointer>(self));
end;

function TPointerQueryEnumerator.GetEnumerator: IPointerQueryEnumerator;
begin
  Result := self;
end;

function TPointerQueryEnumerator.IsAssigned: IPointerQueryEnumerator;
var
  LIsAssigned : TPredicate<Pointer>;
begin
  LIsAssigned := function (Value : Pointer): boolean
                 begin
                   Result := Assigned(Value);
                 end;

  Result := TPointerQueryEnumerator.Create(TWhereEnumerationStrategy<Pointer>.Create(LIsAssigned),
                                          IBaseQueryEnumerator<Pointer>(self));
end;

function TPointerQueryEnumerator.Skip(Count: Integer): IPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(Count)),
                                           IBaseQueryEnumerator<Pointer>(self));
end;

function TPointerQueryEnumerator.SkipWhile(
  Predicate: TPredicate<Pointer>): IPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TSkipWhileEnumerationStrategy<Pointer>.Create(Predicate),
                                           IBaseQueryEnumerator<Pointer>(self));
end;

function TPointerQueryEnumerator.Take(Count: Integer): IPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(TPredicateFactory<Pointer>.LessThanOrEqualTo(Count)),
                                           IBaseQueryEnumerator<Pointer>(self));
end;

function TPointerQueryEnumerator.TakeWhile(
  Predicate: TPredicate<Pointer>): IPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(Predicate),
                                           IBaseQueryEnumerator<Pointer>(self));
end;

function TPointerQueryEnumerator.Where(
  Predicate: TPredicate<Pointer>): IPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TWhereEnumerationStrategy<Pointer>.Create(Predicate),
                                          IBaseQueryEnumerator<Pointer>(self));
end;

end.
