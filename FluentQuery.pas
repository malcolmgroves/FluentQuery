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
    class function From(StringValue : String) : ICharQueryEnumerator; overload;
  end;

  CharQuery = class
    class function From(StringValue : String) : ICharQueryEnumerator; overload;
    class function Deferred : ICharQueryEnumerator; overload;
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
  FluentQuery.Enumerators.Char;



{ Query<T> }


class function Query<T>.From(StringValue: String): ICharQueryEnumerator;
begin
  Result := TCharQueryEnumerator.Create(TEnumerationStrategy<Char>.Create,
                                        nil,
                                        TStringEnumeratorAdapter.Create(StringValue));
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
