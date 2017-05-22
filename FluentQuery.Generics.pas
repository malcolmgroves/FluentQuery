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

unit FluentQuery.Generics;

interface
uses
  FluentQuery.Core.Types,
  System.SysUtils,
  System.Generics.Collections,
  FluentQuery.Core.EnumerationStrategies,
  FluentQuery.Core.Enumerators;

type
  IUnboundQuery<T> = interface;

  IBoundQuery<T> = interface(IBaseBoundQuery<T>)
    function GetEnumerator: IBoundQuery<T>;
    // query operations
    function Map(Transformer : TFunc<T, T>) : IBoundQuery<T>;
    function Skip(Count : Integer): IBoundQuery<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IBoundQuery<T>; overload;
    function SkipWhile(UnboundQuery : IUnboundQuery<T>) : IBoundQuery<T>; overload;
    function Take(Count : Integer): IBoundQuery<T>;
    function TakeWhile(Predicate : TPredicate<T>): IBoundQuery<T>; overload;
    function TakeWhile(UnboundQuery : IUnboundQuery<T>): IBoundQuery<T>; overload;
    function Where(Predicate : TPredicate<T>) : IBoundQuery<T>;
    function WhereNot(UnboundQuery : IUnboundQuery<T>) : IBoundQuery<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IBoundQuery<T>; overload;
    // terminating operations
    function AsTList : TList<T>;
  end;

  IUnboundQuery<T> = interface(IBaseUnboundQuery<T>)
    function GetEnumerator: IUnboundQuery<T>;
    function From(Container : TEnumerable<T>) : IBoundQuery<T>;
    // query operations
    function Map(Transformer : TFunc<T, T>) : IUnboundQuery<T>;
    function Skip(Count : Integer): IUnboundQuery<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IUnboundQuery<T>; overload;
    function SkipWhile(UnboundQuery : IUnboundQuery<T>) : IUnboundQuery<T>; overload;
    function Take(Count : Integer): IUnboundQuery<T>;
    function TakeWhile(Predicate : TPredicate<T>): IUnboundQuery<T>; overload;
    function TakeWhile(UnboundQuery : IUnboundQuery<T>): IUnboundQuery<T>; overload;
    function Where(Predicate : TPredicate<T>) : IUnboundQuery<T>;
    function WhereNot(UnboundQuery : IUnboundQuery<T>) : IUnboundQuery<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IUnboundQuery<T>; overload;
  end;

  TQuery<T> = class(TBaseQuery<T>,
                              IBoundQuery<T>,
                              IUnboundQuery<T>)
  protected
    type
      TQueryImpl<TReturnType : IBaseQuery<T>> = class
      private
        FQuery : TQuery<T>;
      public
        constructor Create(Query : TQuery<T>); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function From(Container : TEnumerable<T>) : IBoundQuery<T>;
        // Primitive Operations
        function Map(Transformer : TFunc<T, T>) : TReturnType;
        function SkipWhile(Predicate : TPredicate<T>) : TReturnType; overload;
        function TakeWhile(Predicate : TPredicate<T>): TReturnType; overload;
        function Where(Predicate : TPredicate<T>) : TReturnType;
        // Derivative Operations
        function Skip(Count : Integer): TReturnType;
        function SkipWhile(UnboundQuery : IUnboundQuery<T>) : TReturnType; overload;
        function Take(Count : Integer): TReturnType;
        function TakeWhile(UnboundQuery : IUnboundQuery<T>): TReturnType; overload;
        function WhereNot(UnboundQuery : IUnboundQuery<T>) : TReturnType; overload;
        function WhereNot(Predicate : TPredicate<T>) : TReturnType; overload;
        // Terminating Operations
        function Predicate : TPredicate<T>;
        function AsTList : TList<T>;
        function First : T;
        function Count : Integer;
      end;
  protected
    FBoundQuery : TQueryImpl<IBoundQuery<T>>;
    FUnboundQuery : TQueryImpl<IUnboundQuery<T>>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<T>;
                       UpstreamQuery : IBaseQuery<T> = nil;
                       SourceData : IMinimalEnumerator<T> = nil); override;
    destructor Destroy; override;
    property BoundQuery : TQueryImpl<IBoundQuery<T>>
                                       read FBoundQuery implements IBoundQuery<T>;
    property UnboundQuery : TQueryImpl<IUnboundQuery<T>>
                                       read FUnboundQuery implements IUnboundQuery<T>;
  end;


  GenericQuery<T> = class
  public
    class function Select : IUnboundQuery<T>;
  end;

implementation

uses FluentQuery.Core.MethodFactories, FluentQuery.Core.Reduce;

class function GenericQuery<T>.Select: IUnboundQuery<T>;
begin
  Result := TQuery<T>.Create(TEnumerationStrategy<T>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'GenericQuery<T>.Select';
{$ENDIF}
end;



{ TQueryEnumerator<T> }

function TQuery<T>.TQueryImpl<TReturnType>.Count: Integer;
begin
  Result := TReducer<T,Integer>.Reduce(FQuery,
                                       0,
                                       function(Accumulator : Integer; NextValue : T): Integer
                                       begin
                                         Result := Accumulator + 1;
                                       end);
end;

constructor TQuery<T>.TQueryImpl<TReturnType>.Create(
  Query: TQuery<T>);
begin
  FQuery := Query;
end;

function TQuery<T>.TQueryImpl<TReturnType>.First: T;
begin
  if FQuery.MoveNext then
    Result := FQuery.GetCurrent
  else
    raise EEmptyResultSetException.Create('Can''t call First on an empty Result Set');
end;

function TQuery<T>.TQueryImpl<TReturnType>.From(
  Container: TEnumerable<T>): IBoundQuery<T>;
var
  EnumeratorWrapper : IMinimalEnumerator<T>;
begin
  EnumeratorWrapper := TGenericEnumeratorAdapter<T>.Create(Container.GetEnumerator) as IMinimalEnumerator<T>;
  Result := TQuery<T>.Create(TEnumerationStrategy<T>.Create,
                                       IBaseQuery<T>(FQuery),
                                       EnumeratorWrapper);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TQuery<T>.TQueryImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TQuery<T>.TQueryImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TQuery<T>.TQueryImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TQuery<T>.TQueryImpl<TReturnType>.Map(
  Transformer: TFunc<T, T>): TReturnType;
begin
  Result := TQuery<T>.Create(TIsomorphicTransformEnumerationStrategy<T>.Create(Transformer),
                                          IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Map(Transformer)';
{$ENDIF}
end;


function TQuery<T>.TQueryImpl<TReturnType>.Predicate: TPredicate<T>;
begin
  Result := TMethodFactory<T>.QuerySingleValue(FQuery);
end;

function TQuery<T>.TQueryImpl<TReturnType>.Skip(Count: Integer): TReturnType;
begin
  Result := SkipWhile(TMethodFactory<T>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TQuery<T>.TQueryImpl<TReturnType>.SkipWhile(
  UnboundQuery: IUnboundQuery<T>): TReturnType;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TQuery<T>.TQueryImpl<TReturnType>.SkipWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TQuery<T>.Create(TSkipWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TQuery<T>.TQueryImpl<TReturnType>.Take(Count: Integer): TReturnType;
begin
  Result := TakeWhile(TMethodFactory<T>.UpToNumberOfTimes(Count));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TQuery<T>.TQueryImpl<TReturnType>.TakeWhile(
  UnboundQuery: IUnboundQuery<T>): TReturnType;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TQuery<T>.TQueryImpl<TReturnType>.TakeWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TQuery<T>.Create(TTakeWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TQuery<T>.TQueryImpl<TReturnType>.AsTList: TList<T>;
begin
  Result := TReducer<T,TList<T>>.Reduce(FQuery,
                                        TList<T>.Create,
                                        function(Accumulator : TList<T>; NextValue : T): TList<T>
                                        begin
                                          Accumulator.Add(NextValue);
                                          Result := Accumulator;
                                        end);
end;

function TQuery<T>.TQueryImpl<TReturnType>.Where(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TQuery<T>.Create(TWhereEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQuery<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;


function TQuery<T>.TQueryImpl<TReturnType>.WhereNot(
  UnboundQuery: IUnboundQuery<T>): TReturnType;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TQuery<T>.TQueryImpl<TReturnType>.WhereNot(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := Where(TMethodFactory<T>.Not(Predicate));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ TQueryEnumerator<T> }

constructor TQuery<T>.Create(
  EnumerationStrategy: TEnumerationStrategy<T>;
  UpstreamQuery: IBaseQuery<T>; SourceData: IMinimalEnumerator<T>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQuery := TQueryImpl<IBoundQuery<T>>.Create(self);
  FUnboundQuery := TQueryImpl<IUnboundQuery<T>>.Create(self);
end;

destructor TQuery<T>.Destroy;
begin
  FBoundQuery.Free;
  FUnboundQuery.Free;
  inherited;
end;


end.
