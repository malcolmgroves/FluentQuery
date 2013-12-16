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
    ///	  Use Skip when you want to ignore a specified number of items, before
    ///	  enumerating the remainign items.
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
    ///	  Use Take when you want to limit the number of items that will be
    ///	  enumerated.
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
    ///	  Filter the items enumerated to only those that evaluate true when
    ///	  passed into the Predicate
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
    class function From(Collection : TEnumerable<T>) : TQueryEnumerator<T> ;
  end;


implementation
uses
  Generics.Collections.Enumerators;

{ Query<T> }

class function Query<T>.From(Collection: TEnumerable<T>): TQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(Collection.GetEnumerator);
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

function TQueryEnumerator<T>.Take(Count: Integer): TQueryEnumerator<T>;
begin
  Result := TTakeEnumerator<T>.Create(self, Count);
end;

function TQueryEnumerator<T>.Where(
  Predicate: TPredicate<T>): TQueryEnumerator<T>;
begin
  Result := TWhereEnumerator<T>.Create(self, Predicate);
end;


end.
