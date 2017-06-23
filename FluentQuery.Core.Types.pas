{****************************************************}
{                                                    }
{  FluentQuery                                       }
{                                                    }
{  Copyright (C) 2013 Malcolm Groves                 }
{                                                    }
{  http://www.malcolmgroves.com                      }
{                                                    }
{****************************************************}
{                                                    }
{  This Source Code Form is subject to the terms of  }
{  the Mozilla Public License, v. 2.0. If a copy of  }
{  the MPL was not distributed with this file, You   }
{  can obtain one at                                 }
{                                                    }
{  http://mozilla.org/MPL/2.0/                       }
{                                                    }
{****************************************************}

unit FluentQuery.Core.Types;

interface
uses
  System.SysUtils;

type
  IMinimalEnumerator<T> = interface
    function MoveNext: Boolean;
    function GetCurrent: T;
    property Current: T read GetCurrent;
  end;

  IBaseQuery<T> = interface(IMinimalEnumerator<T>)
{$IFDEF DEBUG}
    function GetOperationName : String;
    procedure SetOperationName(const OperationName : string);
    function GetOperationPath : String;
    property OperationName : string read GetOperationName write SetOperationName;
    property OperationPath : string read GetOperationPath;
{$ENDIF}
    procedure SetUpstreamQuery(UpstreamQuery : IBaseQuery<T>);
    procedure SetSourceData(SourceData : IMinimalEnumerator<T>);
  end;

  IBaseBoundQuery<T> = interface(IBaseQuery<T>)
    procedure Execute;
    function Count : Integer;
    function First : T;
  end;

  IBaseUnboundQuery<T> = interface(IBaseQuery<T>)
    function Predicate : TPredicate<T>;
  end;

  EFluentQueryException = class(Exception);
    ENilEnumeratorException = class(EFluentQueryException);
    EEmptyResultSetException = class(EFluentQueryException);
    ENilSourceException = class(EFLuentQueryException);
implementation

end.
