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
  IUnboundQueryEnumerator<T> = interface;

  IBoundQueryEnumerator<T> = interface(IBaseQueryEnumerator<T>)
    function GetEnumerator: IBoundQueryEnumerator<T>;
    // common operations
    function First : IBoundQueryEnumerator<T>;
    function Skip(Count : Integer): IBoundQueryEnumerator<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IBoundQueryEnumerator<T>; overload;
    function SkipWhile(UnboundQuery : IUnboundQueryEnumerator<T>) : IBoundQueryEnumerator<T>; overload;
    function Take(Count : Integer): IBoundQueryEnumerator<T>;
    function TakeWhile(Predicate : TPredicate<T>): IBoundQueryEnumerator<T>; overload;
    function TakeWhile(UnboundQuery : IUnboundQueryEnumerator<T>): IBoundQueryEnumerator<T>; overload;
    function Where(Predicate : TPredicate<T>) : IBoundQueryEnumerator<T>;
    function WhereNot(UnboundQuery : IUnboundQueryEnumerator<T>) : IBoundQueryEnumerator<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IBoundQueryEnumerator<T>; overload;
    // terminating operations
    function ToTList : TList<T>;
//    function ToTObjectList : TObjectList<T>;
  end;

  IUnboundQueryEnumerator<T> = interface(IBaseQueryEnumerator<T>)
    function GetEnumerator: IUnboundQueryEnumerator<T>;
    // common operations
    function First : IUnboundQueryEnumerator<T>;
    function From(Container : TEnumerable<T>) : IBoundQueryEnumerator<T>;
    function Skip(Count : Integer): IUnboundQueryEnumerator<T>;
    function SkipWhile(Predicate : TPredicate<T>) : IUnboundQueryEnumerator<T>; overload;
    function SkipWhile(UnboundQuery : IUnboundQueryEnumerator<T>) : IUnboundQueryEnumerator<T>; overload;
    function Take(Count : Integer): IUnboundQueryEnumerator<T>;
    function TakeWhile(Predicate : TPredicate<T>): IUnboundQueryEnumerator<T>; overload;
    function TakeWhile(UnboundQuery : IUnboundQueryEnumerator<T>): IUnboundQueryEnumerator<T>; overload;
    function Where(Predicate : TPredicate<T>) : IUnboundQueryEnumerator<T>;
    function WhereNot(UnboundQuery : IUnboundQueryEnumerator<T>) : IUnboundQueryEnumerator<T>; overload;
    function WhereNot(Predicate : TPredicate<T>) : IUnboundQueryEnumerator<T>; overload;
    // terminating operations
    function Predicate : TPredicate<T>;
  end;

  TQueryEnumerator<T> = class(TBaseQueryEnumerator<T>,
                              IBoundQueryEnumerator<T>,
                              IUnboundQueryEnumerator<T>)
  protected
    type
      TQueryEnumeratorImpl<TReturnType : IBaseQueryEnumerator<T>> = class
      private
        FQuery : TQueryEnumerator<T>;
      public
        constructor Create(Query : TQueryEnumerator<T>); virtual;
        function GetEnumerator: TReturnType;
{$IFDEF DEBUG}
        function GetOperationName : String;
        function GetOperationPath : String;
        property OperationName : string read GetOperationName;
        property OperationPath : string read GetOperationPath;
{$ENDIF}
        function First : TReturnType;
        function From(Container : TEnumerable<T>) : IBoundQueryEnumerator<T>;
        function Skip(Count : Integer): TReturnType;
        function SkipWhile(Predicate : TPredicate<T>) : TReturnType; overload;
        function SkipWhile(UnboundQuery : IUnboundQueryEnumerator<T>) : TReturnType; overload;
        function Take(Count : Integer): TReturnType;
        function TakeWhile(Predicate : TPredicate<T>): TReturnType; overload;
        function TakeWhile(UnboundQuery : IUnboundQueryEnumerator<T>): TReturnType; overload;
        function Where(Predicate : TPredicate<T>) : TReturnType;
        function WhereNot(UnboundQuery : IUnboundQueryEnumerator<T>) : TReturnType; overload;
        function WhereNot(Predicate : TPredicate<T>) : TReturnType; overload;
        function Predicate : TPredicate<T>;
        function ToTList : TList<T>;
//        function ToTObjectList(AOwnsObjects: Boolean = True) : TObjectList<T>;
      end;
  protected
    FBoundQueryEnumerator : TQueryEnumeratorImpl<IBoundQueryEnumerator<T>>;
    FUnboundQueryEnumerator : TQueryEnumeratorImpl<IUnboundQueryEnumerator<T>>;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<T>;
                       UpstreamQuery : IBaseQueryEnumerator<T> = nil;
                       SourceData : IMinimalEnumerator<T> = nil); override;
    destructor Destroy; override;
    property BoundQueryEnumerator : TQueryEnumeratorImpl<IBoundQueryEnumerator<T>>
                                       read FBoundQueryEnumerator implements IBoundQueryEnumerator<T>;
    property UnboundQueryEnumerator : TQueryEnumeratorImpl<IUnboundQueryEnumerator<T>>
                                       read FUnboundQueryEnumerator implements IUnboundQueryEnumerator<T>;
  end;


  Query = class
  public
    class function Select<T> : IUnboundQueryEnumerator<T>;
  end;

  GenericQuery = Query;

implementation

{ Query }

class function GenericQuery.Select<T>: IUnboundQueryEnumerator<T>;
begin
  Result := TQueryEnumerator<T>.Create(TEnumerationStrategy<T>.Create);
{$IFDEF DEBUG}
  Result.OperationName := 'Query.Select<T>';
{$ENDIF}
end;



{ TQueryEnumerator<T> }

constructor TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.Create(
  Query: TQueryEnumerator<T>);
begin
  FQuery := Query;
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.First: TReturnType;
begin
  Result := TQueryEnumerator<T>.Create(TTakeWhileEnumerationStrategy<T>.Create(TPredicateFactory<T>.LessThanOrEqualTo(1)),
                                       IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'First';
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.From(
  Container: TEnumerable<T>): IBoundQueryEnumerator<T>;
var
  EnumeratorWrapper : IMinimalEnumerator<T>;
begin
  EnumeratorWrapper := TGenericEnumeratorAdapter<T>.Create(Container.GetEnumerator) as IMinimalEnumerator<T>;
  Result := TQueryEnumerator<T>.Create(TEnumerationStrategy<T>.Create,
                                       IBaseQueryEnumerator<T>(FQuery),
                                       EnumeratorWrapper);
{$IFDEF DEBUG}
  Result.OperationName := Format('From(%s)', [Container.ToString]);
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.GetEnumerator: TReturnType;
begin
  Result := FQuery;
end;

{$IFDEF DEBUG}
function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.GetOperationName: String;
begin
  Result := FQuery.OperationName;
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.GetOperationPath: String;
begin
  Result := FQuery.OperationPath;
end;
{$ENDIF}

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.Predicate: TPredicate<T>;
begin
  Result := TPredicateFactory<T>.QuerySingleValue(FQuery);
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.Skip(Count: Integer): TReturnType;
begin
  Result := TQueryEnumerator<T>.Create(TSkipWhileEnumerationStrategy<T>.Create(TPredicateFactory<T>.LessThanOrEqualTo(Count)),
                                       IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Skip(%d)', [Count]);
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.SkipWhile(
  UnboundQuery: IUnboundQueryEnumerator<T>): TReturnType;
begin
  Result := SkipWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('SkipWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.SkipWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TQueryEnumerator<T>.Create(TSkipWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'SkipWhile(Predicate)';
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.Take(Count: Integer): TReturnType;
begin
  Result := TQueryEnumerator<T>.Create(TTakeWhileEnumerationStrategy<T>.Create(TPredicateFactory<T>.LessThanOrEqualTo(Count)),
                                       IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := Format('Take(%d)', [Count]);
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.TakeWhile(
  UnboundQuery: IUnboundQueryEnumerator<T>): TReturnType;
begin
  Result := TakeWhile(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('TakeWhile', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.TakeWhile(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TQueryEnumerator<T>.Create(TTakeWhileEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'TakeWhile(Predicate)';
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.ToTList: TList<T>;
var
  LList : TList<T>;
  Item : T;
begin
  LList := TList<T>.Create;

  while FQuery.MoveNext do
    LList.Add(FQuery.GetCurrent);

  Result := LList;
end;

//function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.ToTObjectList(AOwnsObjects: Boolean = True): TObjectList<T>;
//var
//  LObjectList : TObjectList<T>;
//  Item : T;
//begin
//  LObjectList := TObjectList<T>.Create(AOwnsObjects);
//
//  while FQuery.MoveNext do
//    LObjectList.Add(FQuery.GetCurrent);
//
//  Result := LObjectList;
//end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.Where(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TQueryEnumerator<T>.Create(TWhereEnumerationStrategy<T>.Create(Predicate),
                                       IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'Where(Predicate)';
{$ENDIF}
end;


function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.WhereNot(
  UnboundQuery: IUnboundQueryEnumerator<T>): TReturnType;
begin
  Result := WhereNot(UnboundQuery.Predicate);
{$IFDEF DEBUG}
  Result.OperationName := Format('WhereNot(%s)', [UnboundQuery.OperationPath]);
{$ENDIF}
end;

function TQueryEnumerator<T>.TQueryEnumeratorImpl<TReturnType>.WhereNot(
  Predicate: TPredicate<T>): TReturnType;
begin
  Result := TQueryEnumerator<T>.Create(TWhereNotEnumerationStrategy<T>.Create(Predicate),
                                          IBaseQueryEnumerator<T>(FQuery));
{$IFDEF DEBUG}
  Result.OperationName := 'WhereNot(Predicate)';
{$ENDIF}
end;

{ TQueryEnumerator<T> }

constructor TQueryEnumerator<T>.Create(
  EnumerationStrategy: TEnumerationStrategy<T>;
  UpstreamQuery: IBaseQueryEnumerator<T>; SourceData: IMinimalEnumerator<T>);
begin
  inherited Create(EnumerationStrategy, UpstreamQuery, SourceData);
  FBoundQueryEnumerator := TQueryEnumeratorImpl<IBoundQueryEnumerator<T>>.Create(self);
  FUnboundQueryEnumerator := TQueryEnumeratorImpl<IUnboundQueryEnumerator<T>>.Create(self);
end;

destructor TQueryEnumerator<T>.Destroy;
begin
  FBoundQueryEnumerator.Free;
  FUnboundQueryEnumerator.Free;
  inherited;
end;


end.
