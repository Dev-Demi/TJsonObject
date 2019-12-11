unit UJsonObject;

interface
uses
 System.JSON.Serializers,System.JSON.Types,Generics.Collections;
type
 TJsonObjectEnumerator<T> = class;
{$M+}
  TJsonObject<T> = class(TObject)
  private
    fMyObjectList:TList<TJsonObject<T>>;
    fNode:T;
  public
   Constructor Create;
   Destructor Free;
   Function SaveToText:String;
   Procedure LoadFromText(JsonText:string);
   Function ForInStorage:TJsonObjectEnumerator<T>;
  published
    property Node:T read fNode write fNode;
    property Storage:TList<TJsonObject<T>> read fMyObjectList write fMyObjectList;
  end;
{$M-}

 TJsonObjectEnumerator<T>=class
    private
     ForInIndex:integer;
     fEnumItem:TJsonObject<T>;
     function GetCurrentItem:TJsonObject<T>;
    public
    // обслуживание перечислителя, не для внешнего использования!
     property Current:TJsonObject<T> read GetCurrentItem;
     function MoveNext:boolean;
     function GetEnumerator:TJsonObjectEnumerator<T>;{$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
    // генерировать перечень файлов
    Constructor Create(EnumItem:TJsonObject<T>);
    Destructor Destroy;override;
  end;

implementation
 uses SysUtils;

{ TJsonObject<T> }

constructor TJsonObject<T>.Create;
begin
 Storage:=TList<TJsonObject<T>>.Create;
end;

function TJsonObject<T>.ForInStorage: TJsonObjectEnumerator<T>;
begin
 result:= TJsonObjectEnumerator<t>.Create(self);
end;

destructor TJsonObject<T>.Free;
var
 tmp:T;
 tmpJsonObj: TJsonObject<T>;
begin
 tmp:=Node;
 FreeAndNil(tmp);
 while Storage.Count>0 do
 begin
  tmpJsonObj:=storage[0];
  storage.Remove(tmpJsonObj);
  tmpJsonObj.Free;
 end;
 Storage.Free;
end;

procedure TJsonObject<T>.LoadFromText(JsonText: string);
var
 LSerializer : TJsonSerializer;
begin
 LSerializer := TJsonSerializer.Create;
 LSerializer.Formatting := TJsonFormatting.Indented;
 LSerializer.Populate(JsonText,self);
 LSerializer.Free
end;

function TJsonObject<T>.SaveToText: String;
var
 LSerializer : TJsonSerializer;
begin
 LSerializer := TJsonSerializer.Create;
 LSerializer.Formatting := TJsonFormatting.Indented;
 result:= LSerializer.Serialize(self);
 LSerializer.Free;
end;

{ TJsonObjectEnumerator<T> }

constructor TJsonObjectEnumerator<T>.Create(EnumItem: TJsonObject<T>);
begin
 fEnumItem:= EnumItem;
 ForInIndex:=-1;
end;

destructor TJsonObjectEnumerator<T>.Destroy;
begin

  inherited;
end;

function TJsonObjectEnumerator<T>.GetCurrentItem: TJsonObject<T>;
begin
 result:=nil;

 if ForInIndex<0 then exit;
  if fEnumItem.storage.Count>0 then
   if ForInIndex<fEnumItem.storage.Count then
    result:= fEnumItem.Storage[ForInIndex];
end;

function TJsonObjectEnumerator<T>.GetEnumerator: TJsonObjectEnumerator<T>;
begin
 result:=self;
end;

function TJsonObjectEnumerator<T>.MoveNext: boolean;
begin
 result:=true;
 if ForInIndex>=fEnumItem.storage.Count-1 then
  result:=false;

 if result then
  ForInIndex:=ForInIndex+1;
end;

end.
