unit FluidQuery.Enumerators.Generic;

interface
uses
  FluidQuery, FluidQuery.Types, System.SysUtils,
  FluidQuery.EnumerationDelegates, FluidQuery.Enumerators;

type
  TQueryEnumerator<T> = class(TMinimalEnumerator<T>, IQueryEnumerator<T>, IMinimalEnumerator<T>)
  public
    function GetEnumerator: IQueryEnumerator<T>;
    function First : IQueryEnumerator<T>;
    ///	<summary>
    ///	  Skip will bypass the specified number of items from the start of the
    ///	  enumeration, after which it will enumerate the remaining items as
    ///	  normal.
    ///	</summary>
    ///	<param name="Count">
    ///	  The number of items to skip over.
    ///	</param>
    ///	<returns>
    ///	  Returns another IQueryEnumerator, so you can call other operators,
    ///	  such as Where and Take, to further filter the items enumerated.
    ///	</returns>
    function Skip(Count : Integer): IQueryEnumerator<T>;
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
    ///	  Returns another IQueryEnumerator, so you can call other operators,
    ///	  such as Where and Take, to further filter the items enumerated.
    ///	</returns>
    function SkipWhile(Predicate : TPredicate<T>) : IQueryEnumerator<T>;
    ///	<summary>
    ///	  Take will enumerate up to the specified number of items and then stop.
    ///	</summary>
    ///	<param name="Count">
    ///	  The maximum number of items to enumerate.
    ///	</param>
    ///	<returns>
    ///	  Returns another IQueryEnumerator, so you can call other operators,
    ///	  such as Where and Skip, to further filter the items enumerated.
    ///	</returns>
    ///	<remarks>
    ///	  Note, it is possible to return less than Count items, if there are
    ///	  fewer items in the collection, or fewer items left after earlier
    ///	  operators (such as Where)
    ///	</remarks>
    function Take(Count : Integer): IQueryEnumerator<T>;
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
    ///	  Returns another IQueryEnumerator, so you can call other operators,
    ///	  such as Where and Take, to further filter the items enumerated.
    ///	</returns>
    function TakeWhile(Predicate : TPredicate<T>): IQueryEnumerator<T>;
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
    ///	  Returns another IQueryEnumerator, so you can call other operators,
    ///	  such as Take or even another Where operator to further filter the
    ///	  items. 
    ///	</returns>
    function Where(Predicate : TPredicate<T>) : IQueryEnumerator<T>;
  end;


implementation

{ TQueryEnumerator<T> }

function TQueryEnumerator<T>.First: IQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(TTakeEnumerationDelegate<T>.Create(IMinimalEnumerator<T>(self), 1));
end;

function TQueryEnumerator<T>.GetEnumerator: IQueryEnumerator<T>;
begin
  Result := self;
end;

function TQueryEnumerator<T>.Skip(Count: Integer): IQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(TSkipEnumerationDelegate<T>.Create(IMinimalEnumerator<T>(self), Count));
end;

function TQueryEnumerator<T>.SkipWhile(
  Predicate: TPredicate<T>): IQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(TSkipWhileEnumerationDelegate<T>.Create(IMinimalEnumerator<T>(self), Predicate));
end;

function TQueryEnumerator<T>.Take(Count: Integer): IQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(TTakeEnumerationDelegate<T>.Create(IMinimalEnumerator<T>(self), Count));
end;

function TQueryEnumerator<T>.TakeWhile(
  Predicate: TPredicate<T>): IQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(TTakeWhileEnumerationDelegate<T>.Create(IMinimalEnumerator<T>(self), Predicate));
end;

function TQueryEnumerator<T>.Where(
  Predicate: TPredicate<T>): IQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(TWhereEnumerationDelegate<T>.Create(IMinimalEnumerator<T>(self), Predicate));
end;


end.
