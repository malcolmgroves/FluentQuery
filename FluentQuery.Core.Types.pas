unit FluentQuery.Core.Types;

interface

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

implementation

end.
