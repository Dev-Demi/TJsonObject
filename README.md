# TJsonObject
Serialize, deserialize json object. Delphi

Save DATA

procedure TForm1.Button1Click(Sender: TObject);
var
 i:integer;
 SObj:TJsonObject<TMyTest>;
 c:TJsonObject<TMyTest>;
 MyNodeTest:TMyTest;
begin
 SObj:=TJsonObject<TMyTest>.Create;
 // Create data object   // Создаем объект, который хотим сохранить
  MyNodeTest:=TMyTest.Create;
  MyNodeTest.MyStr:='Test JSON serialize, тест';
  MyNodeTest.MyInt:=100;
 // Connect data object to Storage Object // Указываем ссылку на него
 SObj.Node:=MyNodeTest;
 // Create SubObject    // Создаем подобъекты (древовидная структура)
 for i:=1 to 10 do
  begin
    c:=TJsonObject<TMyTest>.Create;
     MyNodeTest:=TMyTest.Create;
     MyNodeTest.MyStr:='Str'+inttostr(i);
     MyNodeTest.MyInt:=i;
    c.Node:=MyNodeTest;
    SObj.Storage.Add(c);
  end;

 Memo1.Lines.Text:= SObj.SaveToText;
 SObj.Free;
end;

LoadData

procedure TForm1.Button2Click(Sender: TObject);
var
 SObj,item:TJsonObject<TMyTest>;
begin
 SObj:=TJsonObject<TMyTest>.Create;
 SObj.LoadFromText(Memo1.Lines.Text);
 Memo1.Lines.Add(SObj.Node.MyStr);

 // Classic method
 // for i:=0 to SObj.Storage.Count-1 do
  // Memo1.Lines.Add(SObj.Storage[i].Node.MyStr);

 // ForIn method
 for item in SObj.ForInStorage do
  Memo1.Lines.Add(item.Node.MyStr);

 SObj.Free;
end;
