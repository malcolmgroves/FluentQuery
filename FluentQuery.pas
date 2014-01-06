unit FluentQuery;

interface
uses
  System.Generics.Collections,
  System.Classes,
  System.SysUtils,
  FluentQuery.EnumerationStrategies,
  FluentQuery.Types;

type
  Query<T> = class
    class function From(Container : TEnumerable<T>) : IQueryEnumerator<T>; overload;
    class function From(Container : TEnumerable<Pointer>) : IPointerQueryEnumerator; overload;
    class function From(List : TList) : IPointerQueryEnumerator; overload;
    class function From(StringValue : String) : ICharQueryEnumerator; overload;
  end;

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

  CreateString = class
    class function From(Query : IMinimalEnumerator<Char>) : String;
  end;

//  Predicate<T> = class
//    class function From(Query : ICharQueryEnumerator) : TPredicate<Char>; overload;
//  end experimental;



implementation
uses
  FluentQuery.Enumerators,
  FluentQuery.Enumerators.Generic,
  FluentQuery.Enumerators.Char,
  FluentQuery.Enumerators.Pointer;



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


//class function Predicate<T>.From(Query: ICharQueryEnumerator): TPredicate<Char>;
//begin
//  Result := function(Value : Char) : boolean
//            begin
//              Query.SetSourceData(TSingleValueAdapter<Char>.Create(Value));
//              Result := Query.MoveNext;
//            end;
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
