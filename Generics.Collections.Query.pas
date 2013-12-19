unit Generics.Collections.Query;

interface
uses
  System.Generics.Collections, System.SysUtils, System.Classes,
  Generics.Collections.EnumerationDelegates, Generics.Collections.Query.Interfaces;

type
  TMinimalEnumerator<T> = class(TinterfacedObject, IMinimalEnumerator<T>)
  protected
    FEnumerationDelegate : TEnumerationDelegate<T>;
    function GetCurrent: T; overload;
    function MoveNext: Boolean;
  public
    constructor Create(EnumerationDelegate : TEnumerationDelegate<T>); virtual;
    destructor Destroy; override;
    property Current: T read GetCurrent;
  end;

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

  TStringQueryEnumerator = class(TMinimalEnumerator<String>, IStringQueryEnumerator, IMinimalEnumerator<String>)
  public
    function GetEnumerator: IStringQueryEnumerator;
    function First : IStringQueryEnumerator;
    function Foo : IStringQueryEnumerator;
    function Skip(Count : Integer): IStringQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<String>) : IStringQueryEnumerator;
    function Take(Count : Integer): IStringQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<String>): IStringQueryEnumerator;
    function Where(Predicate : TPredicate<String>) : IStringQueryEnumerator;
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
    class function From(Container : TEnumerable<T>) : IQueryEnumerator<T>; overload;
    class function From(Strings : TStrings) : IStringQueryEnumerator; overload;
  end;

  List<T> = class
    class function From(Enumerator : IQueryEnumerator<T>) : TList<T>;
  end experimental;

  ObjectList<T : class> = class
    class function From(Enumerator : IQueryEnumerator<T>; AOwnsObjects: Boolean = True) : TObjectList<T>;
  end experimental;


implementation
uses
  Generics.Collections.Enumerators;

{ Query<T> }

class function Query<T>.From(Container: TEnumerable<T>): IQueryEnumerator<T>;
var
  EnumeratorWrapper : IMinimalEnumerator<T>;
begin
  EnumeratorWrapper := TGenericEnumeratorWrapper<T>.Create(Container.GetEnumerator) as IMinimalEnumerator<T>;
  Result := TQueryEnumerator<T>.Create(TEnumerationDelegate<T>.Create(EnumeratorWrapper));
end;

class function Query<T>.From(Strings: TStrings): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationDelegate<String>.Create(TStringsEnumeratorWrapper.Create(Strings)));
end;

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


{ List<T> }

class function List<T>.From(Enumerator: IQueryEnumerator<T>): TList<T>;
var
  LList : TList<T>;
  Item : T;
begin
  LList := TList<T>.Create;

  while Enumerator.MoveNext do
    LList.Add(Enumerator.Current);

  Result := LList;
end;

{ ObjectList<T> }

class function ObjectList<T>.From(Enumerator: IQueryEnumerator<T>; AOwnsObjects: Boolean = True): TObjectList<T>;
var
  LObjectList : TObjectList<T>;
  Item : T;
begin
  LObjectList := TObjectList<T>.Create(AOwnsObjects);

  while Enumerator.MoveNext do
    LObjectList.Add(Enumerator.Current);

  Result := LObjectList;
end;

{ TStringQueryEnumerator }

function TStringQueryEnumerator.First: IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TTakeEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), 1));
end;

function TStringQueryEnumerator.Foo: IStringQueryEnumerator;
begin

end;

function TStringQueryEnumerator.GetEnumerator: IStringQueryEnumerator;
begin
  Result := self;
end;

function TStringQueryEnumerator.Skip(Count: Integer): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TSkipEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Count));
end;

function TStringQueryEnumerator.SkipWhile(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TSkipWhileEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Predicate));
end;

function TStringQueryEnumerator.Take(Count: Integer): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TTakeEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Count));
end;

function TStringQueryEnumerator.TakeWhile(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TTakeWhileEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Predicate));
end;

function TStringQueryEnumerator.Where(
  Predicate: TPredicate<String>): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TWhereEnumerationDelegate<String>.Create(IMinimalEnumerator<String>(self), Predicate));
end;

{ TMinimalEnumerator<T> }

constructor TMinimalEnumerator<T>.Create(
  EnumerationDelegate: TEnumerationDelegate<T>);
begin
  FEnumerationDelegate := EnumerationDelegate;
end;

destructor TMinimalEnumerator<T>.Destroy;
begin
  FEnumerationDelegate.Free;
  inherited;
end;

function TMinimalEnumerator<T>.GetCurrent: T;
begin
  Result := FEnumerationDelegate.GetCurrent;
end;

function TMinimalEnumerator<T>.MoveNext: Boolean;
begin
  Result := FEnumerationDelegate.MoveNext;
end;

end.
