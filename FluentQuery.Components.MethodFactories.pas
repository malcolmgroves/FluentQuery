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
unit FluentQuery.Components.MethodFactories;

interface
uses
  FluentQuery.GenericObjects.MethodFactories, System.SysUtils, System.Classes;

type
  TComponentMethodFactory<T : TComponent> = class(TGenericObjectMethodFactory<T>)
  public
    // predicates
    class function TagEquals(TagValue : NativeInt) : TPredicate<T>;
  end;

implementation

{ TComponentMethodFactory<T> }

class function TComponentMethodFactory<T>.TagEquals(
  TagValue: NativeInt): TPredicate<T>;
begin
  Result := function (Value : T): boolean
            begin
              Result := Value.Tag = TagValue;
            end;
end;

end.
