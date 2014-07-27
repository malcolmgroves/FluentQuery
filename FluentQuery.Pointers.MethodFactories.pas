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

unit FluentQuery.Pointers.MethodFactories;

interface
uses
  FluentQuery.Core.MethodFactories, System.SysUtils;

type
  TPointerMethodFactory = class(TMethodFactory<Pointer>)
  public
    // predicates
    class function IsAssigned: TPredicate<Pointer>;
  end;

implementation

{ TPointerMethodFactory }

class function TPointerMethodFactory.IsAssigned: TPredicate<Pointer>;
begin
  Result := function (Value : Pointer): boolean
            begin
              Result := Assigned(Value);
            end;
end;

end.
