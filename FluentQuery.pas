unit FluentQuery;

interface
uses
  System.Generics.Collections,
  System.Classes,
  FluentQuery.EnumerationDelegates,
  FluentQuery.Types;

type
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
    class function From(Container : TEnumerable<String>) : IStringQueryEnumerator; overload;
    class function From(Strings : TStrings) : IStringQueryEnumerator; overload;
    class function From(StringValue : String) : ICharQueryEnumerator; overload;
  end;

  List<T> = class
    class function From(Enumerator : IQueryEnumerator<T>) : TList<T>;
  end experimental;

  ObjectList<T : class> = class
    class function From(Enumerator : IQueryEnumerator<T>; AOwnsObjects: Boolean = True) : TObjectList<T>;
  end experimental;


implementation
uses
  FluentQuery.Enumerators,
  FluentQuery.Enumerators.Strings,
  FluentQuery.Enumerators.Generic,
  FluentQuery.Enumerators.Char;

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


class function Query<T>.From(
  Container: TEnumerable<String>): IStringQueryEnumerator;
var
  EnumeratorWrapper : IMinimalEnumerator<String>;
begin
  EnumeratorWrapper := TGenericEnumeratorWrapper<String>.Create(Container.GetEnumerator) as IMinimalEnumerator<String>;
  Result := TStringQueryEnumerator.Create(TEnumerationDelegate<String>.Create(EnumeratorWrapper));
end;

class function Query<T>.From(StringValue: String): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationDelegate<Char>.Create(TStringEnumerator.Create(StringValue)));
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

end.
