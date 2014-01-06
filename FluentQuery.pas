unit FluentQuery;

interface
uses
  System.Generics.Collections,
  System.Classes,
  System.SysUtils,
  FluentQuery.EnumerationStrategies,
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
    class function From(Container : TEnumerable<Pointer>) : IPointerQueryEnumerator; overload;
    class function From(List : TList) : IPointerQueryEnumerator; overload;
    class function From(Strings : TStrings) : IStringQueryEnumerator; overload;
    class function From(StringValue : String) : ICharQueryEnumerator; overload;
    class function Deferred : IStringQueryEnumerator; overload;
//    class function Deferred : ICharQueryEnumerator; overload;
  end;

//  FromString = class
//    class function Query(Container : TEnumerable<String>) : IStringQueryEnumerator; overload;
//    class function Query(Strings : TStrings) : IStringQueryEnumerator; overload;
//    class function Query : IUnboundStringQueryEnumerator; overload;
//  end;


  CharQuery = class
    class function From(StringValue : String) : ICharQueryEnumerator; overload;
    class function Deferred : ICharQueryEnumerator; overload;
  end;

  CreateTList<T> = class
    class function From(Query : IMinimalEnumerator<T>) : TList<T>;
  end;

  CreateTObjectList<T : class> = class
    class function From(Query : IMinimalEnumerator<T>; AOwnsObjects: Boolean = True) : TObjectList<T>;
  end;

  CreateTStrings = class
    class function From(Query : IMinimalEnumerator<String>) : TStrings;
  end;

  CreateString = class
    class function From(Query : IMinimalEnumerator<Char>) : String;
  end;

//  Predicate<T> = class
//    class function From(Query : IStringQueryEnumerator) : TPredicate<String>; overload;
//    class function From(Query : ICharQueryEnumerator) : TPredicate<Char>; overload;
//  end experimental;

  function StringQuery : IUnboundStringQueryEnumerator;


implementation
uses
  FluentQuery.Enumerators,
  FluentQuery.Enumerators.Strings,
  FluentQuery.Enumerators.Generic,
  FluentQuery.Enumerators.Char,
  FluentQuery.Enumerators.Pointer;


function StringQuery : IUnboundStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create);
end;

{ Query<T> }

class function Query<T>.From(Container: TEnumerable<T>): IQueryEnumerator<T>;
var
  EnumeratorWrapper : IMinimalEnumerator<T>;
begin
  EnumeratorWrapper := TGenericEnumeratorAdapter<T>.Create(Container.GetEnumerator) as IMinimalEnumerator<T>;
  Result := TQueryEnumerator<T>.Create(TEnumerationStrategy<T>.Create,
                                       nil,
                                       EnumeratorWrapper);
end;

class function Query<T>.From(Strings: TStrings): IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
                                          nil,
                                          TStringsEnumeratorAdapter.Create(Strings.GetEnumerator));
end;


class function Query<T>.From(
  Container: TEnumerable<String>): IStringQueryEnumerator;
var
  EnumeratorWrapper : IMinimalEnumerator<String>;
begin
  EnumeratorWrapper := TGenericEnumeratorAdapter<String>.Create(Container.GetEnumerator) as IMinimalEnumerator<String>;
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
                                          nil,
                                          EnumeratorWrapper);
end;

class function Query<T>.Deferred: IStringQueryEnumerator;
begin
  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create);
end;

//class function Query<T>.Deferred: ICharQueryEnumerator;
//begin
//  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create);
//end;

class function Query<T>.From(StringValue: String): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        nil,
                                        TStringEnumeratorAdapter.Create(StringValue));
end;

class function Query<T>.From(
  Container: TEnumerable<Pointer>): IPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TEnumerationStrategy<Pointer>.Create,
                                           nil,
                                           TGenericEnumeratorAdapter<Pointer>.Create(Container.GetEnumerator));
end;

class function Query<T>.From(List: TList): IPointerQueryEnumerator;
begin
  Result := TPointerQueryEnumerator.Create(TEnumerationStrategy<Pointer>.Create,
                                           nil,
                                           TListEnumeratorAdapter.Create(List.GetEnumerator));
end;

{ List<T> }

class function CreateTList<T>.From(Query: IMinimalEnumerator<T>): TList<T>;
var
  LList : TList<T>;
  Item : T;
begin
  LList := TList<T>.Create;

  while Query.MoveNext do
    LList.Add(Query.Current);

  Result := LList;
end;

{ ObjectList<T> }

class function CreateTObjectList<T>.From(Query: IMinimalEnumerator<T>; AOwnsObjects: Boolean = True): TObjectList<T>;
var
  LObjectList : TObjectList<T>;
  Item : T;
begin
  LObjectList := TObjectList<T>.Create(AOwnsObjects);

  while Query.MoveNext do
    LObjectList.Add(Query.Current);

  Result := LObjectList;
end;

{ Strings }

class function CreateTStrings.From(Query: IMinimalEnumerator<String>): TStrings;
var
  LStrings : TStrings;
begin
  LStrings := TStringList.Create;

  while Query.MoveNext do
    LStrings.Add(Query.Current);

  Result := LStrings;
end;


{ GetString }

class function CreateString.From(Query: IMinimalEnumerator<Char>): String;
var
  LString : String;
begin
  LString := '';

  while Query.MoveNext do
    LString := LString + Query.Current;

  Result := LString;
end;


{ Predicate<T> }

//class function Predicate<T>.From(
//  Query: IStringQueryEnumerator): TPredicate<String>;
//begin
//  Result := function(Value : String) : boolean
//            begin
//              Query.SetSourceData(TSingleValueAdapter<String>.Create(Value));
//              Result := Query.MoveNext;
//            end;
//end;

//class function Predicate<T>.From(Query: ICharQueryEnumerator): TPredicate<Char>;
//begin
//  Result := function(Value : Char) : boolean
//            begin
//              Query.SetSourceData(TSingleValueAdapter<Char>.Create(Value));
//              Result := Query.MoveNext;
//            end;
//end;

{ FromString }

//class function FromString.Query: IUnboundStringQueryEnumerator;
//begin
//  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create);
//end;
//
//class function FromString.Query(
//  Container: TEnumerable<String>): IStringQueryEnumerator;
//var
//  EnumeratorWrapper : IMinimalEnumerator<String>;
//begin
//  EnumeratorWrapper := TGenericEnumeratorAdapter<String>.Create(Container.GetEnumerator) as IMinimalEnumerator<String>;
//  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
//                                          EnumeratorWrapper);
//end;
//
//class function FromString.Query(Strings: TStrings): IStringQueryEnumerator;
//begin
//  Result := TStringQueryEnumerator.Create(TEnumerationStrategy<String>.Create,
//                                          TStringsEnumeratorAdapter.Create(Strings.GetEnumerator));
//end;

{ CharQuery }

class function CharQuery.Deferred: ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create);
end;

class function CharQuery.From(StringValue: String): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        nil,
                                        TStringEnumeratorAdapter.Create(StringValue));
end;

end.
