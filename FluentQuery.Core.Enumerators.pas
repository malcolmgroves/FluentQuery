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

unit FluentQuery.Core.Enumerators;

interface
uses
  System.Generics.Collections,
  System.Classes,
  FluentQuery.Core.Types,
  FluentQuery.Core.EnumerationStrategies;

type
  TBaseQuery<T> = class(TInterfacedObject, IBaseQuery<T>)
  protected
    FUpstreamQuery : IBaseQuery<T>;
    FEnumerationStrategy : TEnumerationStrategy<T>;
    FSourceData : IMinimalEnumerator<T>;
    FValues : TStrings;
{$IFDEF DEBUG}
    FOperationName : String;
{$ENDIF}
    procedure SetSourceData(SourceData : IMinimalEnumerator<T>); virtual;
    function GetCurrent: T; virtual;
    function MoveNext: Boolean; virtual;
  public
    constructor Create(EnumerationStrategy : TEnumerationStrategy<T>;
                       UpstreamQuery : IBaseQuery<T> = nil;
                       SourceData : IMinimalEnumerator<T> = nil); virtual;
    destructor Destroy; override;
    procedure SetUpstreamQuery(UpstreamQuery : IBaseQuery<T>);
{$IFDEF DEBUG}
    function GetOperationName : String; virtual;
    procedure SetOperationName(const Name : String); virtual;
    function GetOperationPath : String; virtual;
    property OperationName : string read GetOperationName write SetOperationName;
    property OperationPath : string read GetOperationPath;
{$ENDIF}
  end;

  TStringsEnumeratorAdapter = class(TInterfacedObject, IMinimalEnumerator<String>)
  protected
    FStringsEnumerator : TStringsEnumerator;
    function GetCurrent: String;
    function MoveNext: Boolean;
  public
    constructor Create(StringsEnumerator : TStringsEnumerator); virtual;
    destructor Destroy; override;
    property Current: String read GetCurrent;
  end;

  TGenericEnumeratorAdapter<T> = class(TInterfacedObject, IMinimalEnumerator<T>)
  protected
    FEnumerator : TEnumerator<T>;
    function GetCurrent: T;
  public
    constructor Create(Enumerator : TEnumerator<T>); virtual;
    destructor Destroy; override;
    function MoveNext: Boolean;
    property Current: T read GetCurrent;
  end;

  TSuperTypeEnumeratorAdapter<TSuperType : class; TSubType : class> = class(TInterfacedObject, IMinimalEnumerator<TSubType>)
  protected
    FEnumerator : IMinimalEnumerator<TSuperType>;
    function GetCurrent: TSubType;
  public
    constructor Create(Enumerator : IMinimalEnumerator<TSuperType>); virtual;
    function MoveNext: Boolean;
    property Current: TSubType read GetCurrent;
  end;


  TStringEnumeratorAdapter = class(TInterfacedObject, IMinimalEnumerator<Char>)
  protected
    FStringValue : String;
    FIndex : Integer;
    function GetCurrent: Char;
    function MoveNext: Boolean;
  public
    constructor Create(StringValue : String); virtual;
    property Current: Char read GetCurrent;
  end;

  TSingleValueAdapter<T> = class(TInterfacedObject, IMinimalEnumerator<T>)
  private
    FMoveCount: Integer;
    FValue : T;
  public
    function GetCurrent: T;
    function MoveNext: Boolean;
    constructor Create(Value : T);
  end;

  TListEnumeratorAdapter = class(TinterfacedObject, IMinimalEnumerator<Pointer>)
    FListEnumerator : TListEnumerator;
    function GetCurrent: Pointer;
    function MoveNext: Boolean;
  public
    constructor Create(ListEnumerator : TListEnumerator); virtual;
    destructor Destroy; override;
    property Current: Pointer read GetCurrent;
  end;

  TComponentEnumeratorAdapter = class(TinterfacedObject, IMinimalEnumerator<TComponent>)
    FEnumerator : TComponentEnumerator;
    function GetCurrent: TComponent;
    function MoveNext: Boolean;
  public
    constructor Create(Enumerator : TComponentEnumerator); virtual;
    destructor Destroy; override;
    property Current: TComponent read GetCurrent;
  end;


  TIntegerRangeEnumerator = class(TInterfacedObject, IMinimalEnumerator<Integer>)
  private
    FFinish : Integer;
    FCurrent : Integer;
  protected
    function MoveNext: Boolean;
    function GetCurrent: Integer;
  public
    constructor Create(Start : Integer = 0; Finish : Integer = MaxInt);
  end;

  TIntegerRangeReverseEnumerator = class(TInterfacedObject, IMinimalEnumerator<Integer>)
  private
    FFinish : Integer;
    FCurrent : Integer;
  protected
    function MoveNext: Boolean;
    function GetCurrent: Integer;
  public
    constructor Create(Start : Integer = 0; Finish : Integer = MaxInt);
  end;


implementation

{ TStringsEnumeratorWrapper }

constructor TStringsEnumeratorAdapter.Create(StringsEnumerator : TStringsEnumerator);
begin
  FStringsEnumerator := StringsEnumerator;
end;

destructor TStringsEnumeratorAdapter.Destroy;
begin
  FStringsEnumerator.Free;
  inherited;
end;

function TStringsEnumeratorAdapter.GetCurrent: String;
begin
  Result := FStringsEnumerator.Current;
end;

function TStringsEnumeratorAdapter.MoveNext: Boolean;
begin
  Result := FStringsEnumerator.MoveNext;;
end;


{ TGenericEnumeratorWrapper<T> }

constructor TGenericEnumeratorAdapter<T>.Create(Enumerator: TEnumerator<T>);
begin
  FEnumerator := Enumerator;
end;

destructor TGenericEnumeratorAdapter<T>.Destroy;
begin
  FEnumerator.Free;
  inherited;
end;

function TGenericEnumeratorAdapter<T>.GetCurrent: T;
begin
  Result := FEnumerator.Current;
end;

function TGenericEnumeratorAdapter<T>.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

{ TStringEnumeratorWrapper }

constructor TStringEnumeratorAdapter.Create(StringValue: String);
begin
  FStringValue := StringValue;
  FIndex := Low(StringValue) - 1;
end;

function TStringEnumeratorAdapter.GetCurrent: Char;
begin
  Result := FStringValue[FIndex];
end;

function TStringEnumeratorAdapter.MoveNext: Boolean;
begin
  Inc(FIndex);

  Result := FIndex <= High(FStringValue);
end;

{ TSingleValueAdapter<T> }

constructor TSingleValueAdapter<T>.Create(Value: T);
begin
  FValue := Value;
end;

function TSingleValueAdapter<T>.GetCurrent: T;
begin
  Result := FValue;
end;

function TSingleValueAdapter<T>.MoveNext: Boolean;
begin
  Inc(FMoveCount);
  Result := FMoveCount = 1;
end;

{ TListEnumeratorAdapter }

constructor TListEnumeratorAdapter.Create(ListEnumerator: TListEnumerator);
begin
  FListEnumerator := ListEnumerator;
end;

destructor TListEnumeratorAdapter.Destroy;
begin
  FListEnumerator.Free;
  inherited;
end;

function TListEnumeratorAdapter.GetCurrent: Pointer;
begin
  Result := FListEnumerator.Current;
end;

function TListEnumeratorAdapter.MoveNext: Boolean;
begin
  Result := FListEnumerator.MoveNext;
end;


{ TBaseQueryEnumerator<T> }


constructor TBaseQuery<T>.Create(
  EnumerationStrategy: TEnumerationStrategy<T>;
  UpstreamQuery: IBaseQuery<T>;
  SourceData: IMinimalEnumerator<T>);
begin
  SetUpstreamQuery(UpstreamQuery);
  SetSourceData(SourceData);
  FEnumerationStrategy := EnumerationStrategy;
end;

destructor TBaseQuery<T>.Destroy;
begin
  FEnumerationStrategy.Free;
  FValues.Free;
  inherited;
end;

function TBaseQuery<T>.GetCurrent: T;
begin
  if Assigned(FUpstreamQuery) then
    Result := FEnumerationStrategy.GetCurrent(FUpstreamQuery)
  else
    Result := FEnumerationStrategy.GetCurrent(FSourceData);;
end;

{$IFDEF DEBUG}
function TBaseQuery<T>.GetOperationName: String;
begin
  Result := FOperationName;
end;

procedure TBaseQuery<T>.SetOperationName(const Name: String);
begin
  FOperationName := Name;
end;

function TBaseQuery<T>.GetOperationPath: String;
begin
  if Assigned(FUpstreamQuery) then
    Result := FUpstreamQuery.GetOperationPath + '.' + GetOperationName
  else
    Result := GetOperationName;
end;
{$ENDIF}

function TBaseQuery<T>.MoveNext: Boolean;
begin
  if Assigned(FUpstreamQuery) then
    Result := FEnumerationStrategy.MoveNext(FUpstreamQuery)
  else
    Result := FEnumerationStrategy.MoveNext(FSourceData);
end;

procedure TBaseQuery<T>.SetSourceData(
  SourceData: IMinimalEnumerator<T>);
begin
  if Assigned(SourceData) then
  begin
    if Assigned(FUpstreamQuery) then
      FUpstreamQuery.SetSourceData(SourceData)
    else
      FSourceData := SourceData;
  end;
end;

procedure TBaseQuery<T>.SetUpstreamQuery(
  UpstreamQuery: IBaseQuery<T>);
begin
  FUpstreamQuery := UpstreamQuery;
end;

{ TIntegerRangeEnumerator }

constructor TIntegerRangeEnumerator.Create(Start, Finish: Integer);
begin
  FFinish := Finish;
  FCurrent := Start - 1;
end;

function TIntegerRangeEnumerator.GetCurrent: Integer;
begin
  Result := FCurrent;
end;

function TIntegerRangeEnumerator.MoveNext: Boolean;
begin
  if FCurrent = MaxInt then
    Exit(False); //avoid wraparound

  Inc(FCurrent);
  Result := FCurrent <= FFinish;
end;

{ TIntegerRangeReverseEnumerator }

constructor TIntegerRangeReverseEnumerator.Create(Start, Finish: Integer);
begin
  FFinish := Finish;
  FCurrent := Start + 1;
end;

function TIntegerRangeReverseEnumerator.GetCurrent: Integer;
begin
  Result := FCurrent;
end;

function TIntegerRangeReverseEnumerator.MoveNext: Boolean;
begin
  if FCurrent = -MaxInt then
    Exit(False); //avoid wraparound

  Dec(FCurrent);
  Result := FCurrent >= FFinish;
end;


{ TSuperTypeEnumeratorAdapter<TSuperType, TSubType> }

constructor TSuperTypeEnumeratorAdapter<TSuperType, TSubType>.Create(
  Enumerator: IMinimalEnumerator<TSuperType>);
begin
  FEnumerator := Enumerator;
end;


function TSuperTypeEnumeratorAdapter<TSuperType, TSubType>.GetCurrent: TSubType;
begin
  Result := FEnumerator.Current as TSubType;
end;

function TSuperTypeEnumeratorAdapter<TSuperType, TSubType>.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

{ TComponentEnumeratorAdapter }

constructor TComponentEnumeratorAdapter.Create(
  Enumerator: TComponentEnumerator);
begin
  FEnumerator := Enumerator;
end;

destructor TComponentEnumeratorAdapter.Destroy;
begin
  FEnumerator.Free;
  inherited;
end;

function TComponentEnumeratorAdapter.GetCurrent: TComponent;
begin
  Result := FEnumerator.Current;
end;

function TComponentEnumeratorAdapter.MoveNext: Boolean;
begin
  Result := FEnumerator.MoveNext;
end;

end.
