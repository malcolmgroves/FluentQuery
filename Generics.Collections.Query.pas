unit Generics.Collections.Query;

interface
uses
  System.Generics.Collections, System.SysUtils;

type
  TQueryEnumerator<T> = class(TEnumerator<T>)
  protected
    FUpstreamEnumerator : TEnumerator<T>;
    function DoGetCurrent: T; override;
    function DoMoveNext: Boolean; override;
  public
    constructor Create(Enumerator : TEnumerator<T>); virtual;
    destructor Destroy; override;
    function GetEnumerator: TQueryEnumerator<T>;
    ///	<summary>
    ///	  Skip will bypass the specified number of items from the start of the
    ///	  enumeration, after which it will enumerate the remaining items as
    ///	  normal.
    ///	</summary>
    ///	<param name="Count">
    ///	  The number of items to skip over.
    ///	</param>
    ///	<returns>
    ///	  Returns another TQueryEnumerator, so you can call other operators,
    ///	  such as Where and Take, to further filter the items enumerated.
    ///	</returns>
    function Skip(Count : Integer): TQueryEnumerator<T>;
    ///	<summary>
    ///	  SkipWhile will bypass items at the start of the enumeration while the
    ///	  supplied Predicate evaluates True. Once the Predicate evaluates
    ///	  false, all remaining items will be enumerated as normal.
    ///	</summary>
    ///	<param name="Predicate">
    ///	  The Predicate that will be evaluated against each item, until it
    ///	  returns False.
    ///	</param>
    ///	<returns>
    ///	  Returns another TQueryEnumerator, so you can call other operators,
    ///	  such as Where and Take, to further filter the items enumerated.
    ///	</returns>
    function SkipWhile(Predicate : TPredicate<T>) : TQueryEnumerator<T>;
    ///	<summary>
    ///	  Take will enumerate up to the specified number of items and then stop.
    ///	</summary>
    ///	<param name="Count">
    ///	  The maximum number of items to enumerate.
    ///	</param>
    ///	<returns>
    ///	  Returns another TQueryEnumerator, so you can call other operators,
    ///	  such as Where and Skip, to further filter the items enumerated.
    ///	</returns>
    ///	<remarks>
    ///	  Note, it is possible to return less than Count items, if there are
    ///	  fewer items in the collection, or fewer items left after earlier
    ///	  operators (such as Where)
    ///	</remarks>
    function Take(Count : Integer): TQueryEnumerator<T>;
    ///	<summary>
    ///	  TakeWhile will continue enumerating items while the supplied
    ///	  Predicate evaluates True, after which it will ignore the remaining
    ///	  items.
    ///	</summary>
    ///	<param name="Predicate">
    ///	  The Predicate that will be evaluated against each item, until it
    ///	  returns False.
    ///	</param>
    ///	<returns>
    ///	  Returns another TQueryEnumerator, so you can call other operators,
    ///	  such as Where and Take, to further filter the items enumerated.
    ///	</returns>
    function TakeWhile(Predicate : TPredicate<T>): TQueryEnumerator<T>;
    ///	<summary>
    ///	  Filter the items enumerated to only those that evaluate true when
    ///	  passed into the supplied Predicate
    ///	</summary>
    ///	<param name="Predicate">
    ///	  An anonymous method that will be executed in turn against each item.
    ///	  It should return True to include the item in the result, False to
    ///	  exclude it.  
    ///	</param>
    ///	<returns>
    ///	  Returns another TQueryEnumerator, so you can call other operators,
    ///	  such as Take or even another Where operator to further filter the
    ///	  items. 
    ///	</returns>
    function Where(Predicate : TPredicate<T>) : TQueryEnumerator<T>;
    property Current: T read DoGetCurrent;
  end;


  ///	<summary>
  ///	  Starting point of your query.
  ///	</summary>
  ///	<typeparam name="T">
  ///	  The type of the individual items in the collection you are enumerating.
  ///	  ie. If your From method (which comes next) specifies a
  ///	  TList&lt;TPerson&gt;, T here will be a TPerson
  ///	</typeparam>
  Query<T> = class
    ///	<summary>
    ///	  The second part of your query, specifying the source data from which
    ///	  you wish to query.
    ///	</summary>
    class function From(Container : TEnumerable<T>) : TQueryEnumerator<T>;
  end;

  List<T> = class
    class function From(Enumerator : TEnumerator<T>) : TList<T>;
  end experimental;

  ObjectList<T : class> = class
    class function From(Enumerator : TEnumerator<T>; AOwnsObjects: Boolean = True) : TObjectList<T>;
  end experimental;


implementation
uses
  Generics.Collections.Enumerators;

{ Query<T> }

class function Query<T>.From(Container: TEnumerable<T>): TQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(Container.GetEnumerator);
end;

{ TQueryEnumerator<T> }

constructor TQueryEnumerator<T>.Create(Enumerator: TEnumerator<T>);
begin
  FUpstreamEnumerator := Enumerator;
end;

destructor TQueryEnumerator<T>.Destroy;
begin
  FUpstreamEnumerator.Free;
  inherited;
end;

function TQueryEnumerator<T>.DoGetCurrent: T;
begin
  Result := FUpstreamEnumerator.Current;
end;

function TQueryEnumerator<T>.DoMoveNext: Boolean;
begin
  Result := FUpstreamEnumerator.MoveNext;
end;

function TQueryEnumerator<T>.GetEnumerator: TQueryEnumerator<T>;
begin
  Result := self;
end;

function TQueryEnumerator<T>.Skip(Count: Integer): TQueryEnumerator<T>;
begin
  Result := TSkipEnumerator<T>.Create(self, Count);
end;

function TQueryEnumerator<T>.SkipWhile(
  Predicate: TPredicate<T>): TQueryEnumerator<T>;
begin
  Result := TSkipWhileEnumerator<T>.Create(self, Predicate);
end;

function TQueryEnumerator<T>.Take(Count: Integer): TQueryEnumerator<T>;
begin
  Result := TTakeEnumerator<T>.Create(self, Count);
end;

function TQueryEnumerator<T>.TakeWhile(
  Predicate: TPredicate<T>): TQueryEnumerator<T>;
begin
  Result := TTakeWhileEnumerator<T>.Create(self, Predicate);
end;

function TQueryEnumerator<T>.Where(
  Predicate: TPredicate<T>): TQueryEnumerator<T>;
begin
  Result := TWhereEnumerator<T>.Create(self, Predicate);
end;


{ List<T> }

class function List<T>.From(Enumerator: TEnumerator<T>): TList<T>;
var
  LList : TList<T>;
  Item : T;
begin
  try
    LList := TList<T>.Create;

    while Enumerator.MoveNext do
      LList.Add(Enumerator.Current);

    Result := LList;
  finally
    Enumerator.Free;
  end;
end;

{ ObjectList<T> }

class function ObjectList<T>.From(Enumerator: TEnumerator<T>; AOwnsObjects: Boolean = True): TObjectList<T>;
var
  LObjectList : TObjectList<T>;
  Item : T;
begin
  try
    LObjectList := TObjectList<T>.Create(AOwnsObjects);

    while Enumerator.MoveNext do
      LObjectList.Add(Enumerator.Current);

    Result := LObjectList;
  finally
    Enumerator.Free;
  end;
end;

end.
