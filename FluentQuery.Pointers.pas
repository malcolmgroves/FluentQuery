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

unit FluentQuery.Pointers;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators,
  System.Classes,
  System.Generics.Collections;

type
  IUnboundPointerQuery = interface;

  IBoundPointerQuery = interface(IBaseBoundQuery<Pointer>)
    function GetEnumerator: IBoundPointerQuery;
    // common operations
    function Map(Transformer : TFunc<Pointer, Pointer>) : IBoundPointerQuery;
    function Skip(Count : Integer): IBoundPointerQuery;
    function SkipWhile(Predicate : TPredicate<Pointer>) : IBoundPointerQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundPointerQuery) : IBoundPointerQuery; overload;
    function Take(Count : Integer): IBoundPointerQuery;
    function TakeWhile(Predicate : TPredicate<Pointer>): IBoundPointerQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundPointerQuery): IBoundPointerQuery; overload;
    function Where(Predicate : TPredicate<Pointer>) : IBoundPointerQuery;
    function WhereNot(UnboundQuery : IUnboundPointerQuery) : IBoundPointerQuery; overload;
    function WhereNot(Predicate : TPredicate<Pointer>) : IBoundPointerQuery; overload;
    // type-specific operations
    function IsAssigned : IBoundPointerQuery;
  end;

  IUnboundPointerQuery = interface(IBaseUnboundQuery<Pointer>)
    function GetEnumerator: IUnboundPointerQuery;
    // common operations
    function From(List : TList) : IBoundPointerQuery; overload;
    function From(Container : TEnumerable<Pointer>) : IBoundPointerQuery; overload;
    function Map(Transformer : TFunc<Pointer, Pointer>) : IUnboundPointerQuery;
    function Skip(Count : Integer): IUnboundPointerQuery;
    function SkipWhile(Predicate : TPredicate<Pointer>) : IUnboundPointerQuery; overload;
    function SkipWhile(UnboundQuery : IUnboundPointerQuery) : IUnboundPointerQuery; overload;
    function Take(Count : Integer): IUnboundPointerQuery;
    function TakeWhile(Predicate : TPredicate<Pointer>): IUnboundPointerQuery; overload;
    function TakeWhile(UnboundQuery : IUnboundPointerQuery): IUnboundPointerQuery; overload;
    function Where(Predicate : TPredicate<Pointer>) : IUnboundPointerQuery;
    function WhereNot(UnboundQuery : IUnboundPointerQuery) : IUnboundPointerQuery; overload;
    function WhereNot(Predicate : TPredicate<Pointer>) : IUnboundPointerQuery; overload;
    // type-specific operations
    function IsAssigned : IUnboundPointerQuery;
    // terminating operations
  end;

  function PointerQuery : IUnboundPointerQuery;



implementation

uses FluentQuery.Core.MethodFactories, FluentQuery.Core.Reduce;

type
  TPointerQuery = class(TBaseQuery<Pointer>,
                                  IBoundPointerQuery,
                                  IUnboundPointerQuery)
  protected
    type
      TPointerQueryImpl<T : IBaseQuery<Pointer>> = class
      private
        FQuery : TPointerQuery;
      public
        constructor Create(Query : TPointerQuery); virtual;
        function GetEnumerator: T;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(List : TList) : IBoundPointerQuery; overload;
        function From(Container : TEnumerable<Pointer>) : IBoundPointerQuery; overload;
        // Primitive Operations
        function Map(Transformer : TFunc<Pointer, Pointer>) : T;
        function SkipWhile(Predicate : TPredicate<Pointer>) : T; overload;
        function TakeWhile(Predicate : TPredicate<Pointer>): T; overload;
        function Where(Predicate : TPredicate<Pointer>) : T;
        // Derivative Operations
        function Skip(Count : Integer): T;
        function SkipWhile(UnboundQuery : IUnboundPointerQuery) : T; overload;
        function Take(Count : Integer): T;
        function TakeWhile(UnboundQuery : IUnboundPointerQuery): T; overload;
        function WhereNot(UnboundQuery : IUnboundPointerQuery) : T; overload;
        function WhereNot(Predicate : TPredicate<Pointer>) : T; overload;
        function IsAssigned : T;
        // Terminating Operations
        function Predicate : TPredicate<Pointer>;
        function First : Pointer;
        function Count : Integer;
      end;
  protected
    FBoundQuery : TPointerQueryImpl<IBoundPointerQuery>;
    FUnboundQuery : TPointerQueryImpl<IUnboundPointerQuery>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<Pointer>;
                       UpstreamQuery : IBaseQuery<Pointer> = nil;
                       SourceData : IMinimalEnumerator<Pointer> = nil); override;
    destructor Destroy; override;
    property BoundQuery : TPointerQueryImpl<IBoundPointerQuery>
                                       read FBoundQuery implements IBoundPointerQuery;
    property UnboundQuery : TPointerQueryImpl<IUnboundPointerQuery>
                                       read FUnboundQuery implements IUnboundPointerQuery;
  end;


function PointerQuery : IUnboundPointerQuery;
begin
  Result := TPointerQuery.Create(TEnumerationStrategy<Pointer>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'PointerQuery';
{$ENDIF}
end;


{ TPointerQueryEnumerator }

function TPointerQuery.TPointerQueryImpl<T>.Count: Integer;
begin
  Result := TReducer<Pointer,Integer>.Reduce(FQuery,
                                             0,
                                             function(Accumulator : Integer; NextValue : Pointer): Integer
                                             begin
                                               Result := Accumulator + 1;
                                             end);
end;

constructor TPointerQuery.TPointerQueryImpl<T>.Create(
  Query: TPointerQuery);
begin
  FQuery := Query;
end;

function TPointerQuery.TPointerQueryImpl<T>.First: Pointer;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TPointerQuery.TPointerQueryImpl<T>.From(
  List: TList): IBoundPointerQuery;
begin
  Result := TPointerQuery.Create(TEnumerationStrategy<Pointer>.Create,
                                           IBaseQuery<Pointer>(FQuery),
                                           TListEnumeratorAdapter.Create(List.GetEnumerator));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [List.ToString]);
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.From(
  Container: TEnumerable<Pointer>): IBoundPointerQuery;
begin
  Result := TPointerQuery.Create(TEnumerationStrategy<Pointer>.Create,
                                           IBaseQuery<Pointer>(FQuery),
                                           TGenericEnumeratorAdapter<Pointer>.Create(Container.GetEnumerator));
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.GetEnumerator: T;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TPointerQuery.TPointerQueryImpl<T>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TPointerQuery.TPointerQueryImpl<T>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TPointerQuery.TPointerQueryImpl<T>.IsAssigned: T;
var
  LPredicate : TPredicate<Pointer>;
begin
  LPredicate := function (Value : Pointer): boolean
                begin
                  Result := Assigned(Value);
                end;

  Result := Where(LPredicate);
{$IFDEF DEBUG}
  Result.OperationName := 'IsAssigned';
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.Map(
  Transformer: TFunc<Pointer, Pointer>): T;
begin
  Result := TPointerQuery.Create(TIsomorphicTransformEnumerationStrategy<Pointer>.Create(Transformer),
                                          IBaseQuery<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TPointerQuery.TPointerQueryImpl<T>.Predicate: TPredicate<Pointer>;
begin
  Result := TMethodFactory<Pointer>.QuerySingleValue(FQuery);
end;

function TPointerQuery.TPointerQueryImpl<T>.Skip(Count: Integer): T;
begin
  Result := SkipWhile(TMethodFactory<Pointer>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.SkipWhile(
  UnboundQuery: IUnboundPointerQuery): T;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.SkipWhile(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQuery.Create(TSkipWhileEnumerationStrategy<Pointer>.Create(Predicate),
                                           IBaseQuery<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.Take(Count: Integer): T;
begin
  Result := TakeWhile(TMethodFactory<Pointer>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.TakeWhile(
  UnboundQuery: IUnboundPointerQuery): T;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.TakeWhile(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQuery.Create(TTakeWhileEnumerationStrategy<Pointer>.Create(Predicate),
                                           IBaseQuery<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.Where(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := TPointerQuery.Create(TWhereEnumerationStrategy<Pointer>.Create(Predicate),
                                          IBaseQuery<Pointer>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.WhereNot(
  UnboundQuery: IUnboundPointerQuery): T;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TPointerQuery.TPointerQueryImpl<T>.WhereNot(
  Predicate: TPredicate<Pointer>): T;
begin
  Result := Where(TMethodFactory<Pointer>.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ TPointerQueryEnumerator }

constructor TPointerQuery.Create(
  EnumerationStrategy: TEnumerationStrategy<Pointer>;
  UpstreamQuery: IBaseQuery<Pointer>;
  SourceData: IMinimalEnumerator<Pointer>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TPointerQueryImpl<IBoundPointerQuery>.Create(self);
  FUnboundQuery := TPointerQueryImpl<IUnboundPointerQuery>.Create(self);
end;

destructor TPointerQuery.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;

end.
