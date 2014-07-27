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
    class function LessThanOrEqualTo(Count : Integer) : TPredicate<T>;
    class function QuerySingleValue(UnboundQuery : IBaseQueryEnumerator<T>) : TPredicate<T>;
    class function InvertPredicate(Predicate : TPredicate<T>) : TPredicate<T>;
    class function InPlaceTransformer(TransformProc : TProc<T>) : TFunc<T, T>;
  end;

implementation
uses FluentQuery.Core.Enumerators;


{ TPredicateFactory<T> }

class function TMethodFactory<T>.InPlaceTransformer(
  TransformProc: TProc<T>): TFunc<T, T>;
begin
  Result := function (Value : T) : T
                      begin
                        TransformProc(Value);
                        Result := Value;
                      end;
end;

class function TMethodFactory<T>.InvertPredicate(
  Predicate: TPredicate<T>): TPredicate<T>;
begin
  Result := function (CurrentValue : T) : Boolean
            begin
              Result := not Predicate(CurrentValue);
            end;
end;

class function TMethodFactory<T>.LessThanOrEqualTo(
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
  UnboundQuery: IBaseQueryEnumerator<T>): TPredicate<T>;
begin
  Result := function (CurrentValue : T) : Boolean
            begin
              UnboundQuery.SetSourceData(TSingleValueAdapter<T>.Create(CurrentValue));
              Result := UnboundQuery.MoveNext;
            end;
end;

end.
