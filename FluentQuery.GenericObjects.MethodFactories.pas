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

unit FluentQuery.GenericObjects.MethodFactories;

interface
uses
  FluentQuery.Core.MethodFactories, System.SysUtils, System.TypInfo, System.Rtti;

type
  TGenericObjectMethodFactory<T : class> = class(TMethodFactory<T>)
  public
    // predicates
    class function IsA(AClass : TClass): TPredicate<T>;
    class function IsAssigned: TPredicate<T>;
    class function PropertyNamedOfType(const Name: string; PropertyType: TTypeKind): TPredicate<T>;
  end;


implementation

{ TGenericObjectPredicateFactory<T> }

class function TGenericObjectMethodFactory<T>.IsA(
  AClass: TClass): TPredicate<T>;
begin
  Result := function (Value : T): boolean
            begin
              Result := Value is AClass;
            end;
end;

class function TGenericObjectMethodFactory<T>.IsAssigned: TPredicate<T>;
begin
  Result := function (Value : T): boolean
            begin
              Result := Assigned(Value);
            end;
end;

class function TGenericObjectMethodFactory<T>.PropertyNamedOfType(
  const Name: string; PropertyType: TTypeKind): TPredicate<T>;
begin
  Result :=  function (Value : T) : boolean
             var
               LRTTIContext : TRTTIContext;
               LClassType : TRTTIType;
               LProperty : TRTTIProperty;
             begin
               Result := False;
               LRTTIContext := TRttiContext.Create;
               LClassType := LRTTIContext.GetType(Value.ClassInfo);
               LProperty := LClassType.GetProperty(Name);
               if Assigned(LProperty) then
                 Result := LProperty.PropertyType.TypeKind = PropertyType;
             end;
end;

end.
