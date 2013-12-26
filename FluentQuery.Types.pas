unit FluentQuery.Types;

interface
uses
  System.SysUtils;

type
  IMinimalEnumerator<T> = interface
    function MoveNext: Boolean;
    function GetCurrent: T;
    property Current: T read GetCurrent;
  end;

  IQueryEnumerator<T> = interface(IMinimalEnumerator<T>)
    function First : IQueryEnumerator<T>;
    function Skip(Count : Integer): IQueryEnumerator<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IQueryEnumerator<T>;
    function Take(Count : Integer): IQueryEnumerator<T>;
    function TakeWhile(Predicate : TPredicate<T>): IQueryEnumerator<T>;
    function Where(Predicate : TPredicate<T>) : IQueryEnumerator<T>;
    function GetEnumerator: IQueryEnumerator<T>;
  end;

  IStringQueryEnumerator = interface(IMinimalEnumerator<String>)
    function First : IStringQueryEnumerator;
    function Skip(Count : Integer): IStringQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<String>) : IStringQueryEnumerator;
    function Take(Count : Integer): IStringQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<String>): IStringQueryEnumerator;
    function Where(Predicate : TPredicate<String>) : IStringQueryEnumerator;
    function GetEnumerator: IStringQueryEnumerator;
    function Matches(const Value : String; IgnoreCase : Boolean = True) : IStringQueryEnumerator;
    function Contains(const Value : String; IgnoreCase : Boolean = True) : IStringQueryEnumerator;
    function StartsWith(const Value : String; IgnoreCase : Boolean = True) : IStringQueryEnumerator;
    function EndsWith(const Value : String; IgnoreCase : Boolean = True) : IStringQueryEnumerator;
  end;

  ICharQueryEnumerator = interface(IMinimalEnumerator<Char>)
    function First : ICharQueryEnumerator;
    function Skip(Count : Integer): ICharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : ICharQueryEnumerator;
    function Take(Count : Integer): ICharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): ICharQueryEnumerator;
    function Where(Predicate : TPredicate<Char>) : ICharQueryEnumerator;
    function GetEnumerator: ICharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : ICharQueryEnumerator;
  end;

implementation

end.
