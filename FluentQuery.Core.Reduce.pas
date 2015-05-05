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
unit FluentQuery.Core.Reduce;

interface
uses
  FluentQuery.Core.Enumerators;

type
  TCombiningFunction<T, TAccumulator> = reference to function(Accumulator : TAccumulator; NextValue : T): TAccumulator;

  TReducer<T, TAccumulator> = class
  public
    class function Reduce(Query : TBaseQuery<T>; InitialAccumulatorValue : TAccumulator; CombiningFunction : TCombiningFunction<T, TAccumulator>) : TAccumulator;
  end;

implementation

{ TReducer<T, TAccumulator> }

class function TReducer<T, TAccumulator>.Reduce(Query : TBaseQuery<T>;
                                                InitialAccumulatorValue: TAccumulator;
                                                CombiningFunction: TCombiningFunction<T, TAccumulator>): TAccumulator;
var
  LValue : TAccumulator;
begin
  LValue := InitialAccumulatorValue;

  while Query.MoveNext do
    LValue := CombiningFunction(LValue, Query.GetCurrent);

  Result := LValue;
end;



end.
