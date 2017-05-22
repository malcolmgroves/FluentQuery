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

unit FluentQuery.Core.MethodFactories;

interface
uses
  System.SysUtils, FluentQuery.Core.Types;

type
  TMethodFactory<T> = class
  public
    class function UpToNumberOfTimes(Count : Integer) : TPredicate<T>;
    class function QuerySingleValue(UnboundQuery : IBaseQuery<T>) : TPredicate<T>;
    class function &Not(Predicate : TPredicate<T>) : TPredicate<T>;
    class function InPlaceTransformer(TransformProc : TProc<T>) : TFunc<T, T>;
    class function &Or(PredicateA, PredicateB : TPredicate<T>) : TPredicate<T>;
    class function &And(PredicateA, PredicateB : TPredicate<T>) : TPredicate<T>;
  end;

implementation
uses FluentQuery.Core.Enumerators;


{ TPredicateFactory<T> }

class function TMethodFactory<T>.&Or(PredicateA,
  PredicateB: TPredicate<T>): TPredicate<T>;
begin
  Result := function (CurrentValue : T) : Boolean
            begin
              Result := PredicateA(CurrentValue) or PredicateB(CurrentValue);
            end;
end;

class function TMethodFactory<T>.&And(PredicateA,
  PredicateB: TPredicate<T>): TPredicate<T>;
begin
  Result := function (CurrentValue : T) : Boolean
            begin
              Result := PredicateA(CurrentValue) and PredicateB(CurrentValue);
            end;
end;

class function TMethodFactory<T>.InPlaceTransformer(
  TransformProc: TProc<T>): TFunc<T, T>;
begin
  Result := function (Value : T) : T
                      begin
                        TransformProc(Value);
                        Result := Value;
                      end;
end;

class function TMethodFactory<T>.&Not(
  Predicate: TPredicate<T>): TPredicate<T>;
begin
  Result := function (CurrentValue : T) : Boolean
            begin
              Result := not Predicate(CurrentValue);
            end;
end;

class function TMethodFactory<T>.UpToNumberOfTimes(
  Count: Integer): TPredicate<T>;
var
  LCount : Integer;
begin
  LCOunt := 0;
  Result := function (Value : T) : boolean
            begin
              Inc(LCount);
              Result := LCount <= Count;
            end;
end;

class function TMethodFactory<T>.QuerySingleValue(
  UnboundQuery: IBaseQuery<T>): TPredicate<T>;
begin
  Result := function (CurrentValue : T) : Boolean
            begin
              UnboundQuery.SetSourceData(TSingleValueAdapter<T>.Create(CurrentValue));
              Result := UnboundQuery.MoveNext;
            end;
end;

end.
