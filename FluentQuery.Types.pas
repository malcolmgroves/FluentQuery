unit FluentQuery.Types;

interface
uses
  System.SysUtils,
  System.Generics.Collections,
  System.Classes;

type
  IMinimalEnumerator<T> = interface
    function MoveNext: Boolean;
    function GetCurrent: T;
    property Current: T read GetCurrent;
  end;

  IBaseQueryEnumerator<T> = interface(IMinimalEnumerator<T>)
    procedure SetUpstreamQuery(UpstreamQuery : IBaseQueryEnumerator<T>);
    procedure SetSourceData(SourceData : IMinimalEnumerator<T>);
  end;

  IQueryEnumerator<T> = interface(IBaseQueryEnumerator<T>)
    function GetEnumerator: IQueryEnumerator<T>;
    function First : IQueryEnumerator<T>;
    function Skip(Count : Integer): IQueryEnumerator<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IQueryEnumerator<T>;
    function Take(Count : Integer): IQueryEnumerator<T>;
    function TakeWhile(Predicate : TPredicate<T>): IQueryEnumerator<T>;
    function Where(Predicate : TPredicate<T>) : IQueryEnumerator<T>;
  end;


  ICharQueryEnumerator = interface(IBaseQueryEnumerator<Char>)
    function GetEnumerator: ICharQueryEnumerator;
//    procedure SetSourceData(SourceData : IMinimalEnumerator<Char>);
    function First : ICharQueryEnumerator;
    function Skip(Count : Integer): ICharQueryEnumerator;
    function SkipWhile(Predicate : TPredicate<Char>) : ICharQueryEnumerator;
    function Take(Count : Integer): ICharQueryEnumerator;
    function TakeWhile(Predicate : TPredicate<Char>): ICharQueryEnumerator;
    function Where(Predicate : TPredicate<Char>) : ICharQueryEnumerator;
    function Matches(const Value : Char; IgnoreCase : Boolean = True) : ICharQueryEnumerator;
    function IsControl: ICharQueryEnumerator;
    function IsDigit: ICharQueryEnumerator;
    function IsHighSurrogate: ICharQueryEnumerator;
    function IsInArray(const SomeChars: array of Char): ICharQueryEnumerator;
    function IsLetter: ICharQueryEnumerator;
    function IsLetterOrDigit: ICharQueryEnumerator;
    function IsLower: ICharQueryEnumerator;
    function IsLowSurrogate: ICharQueryEnumerator;
    function IsNumber: ICharQueryEnumerator;
    function IsPunctuation: ICharQueryEnumerator;
    function IsSeparator: ICharQueryEnumerator;
    function IsSurrogate: ICharQueryEnumerator;
    function IsSymbol: ICharQueryEnumerator;
    function IsUpper: ICharQueryEnumerator;
    function IsWhiteSpace: ICharQueryEnumerator;
  end;

  IPointerQueryEnumerator = interface(IBaseQueryEnumerator<Pointer>)
    function GetEnumerator: IPointerQueryEnumerator;
//    procedure SetSourceData(SourceData : IMinimalEnumerator<Pointer>);
    function IsAssigned : IPointerQueryEnumerator;
  end;

implementation

end.
