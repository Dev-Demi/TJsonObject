unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,UJsonObject;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    MultiLineMemo: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
{$M+}
  TMyTest = class(TObject)
  private
    fInt:Integer;
    fString:String;
  public
   Constructor Create;
   Destructor Free;
  published
    property MyStr: string read fString write fString;
    property MyInt: Integer read fInt write fInt;
  end;
{$M-}
var
  Form1: TForm1;

implementation

{$R *.dfm}

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
  MyNodeTest.MyStr:=MultiLineMemo.Text; //multiline test // тест многострочного текста
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

procedure TForm1.FormCreate(Sender: TObject);
begin
 ReportMemoryLeaksOnShutdown := True;
end;

{ TMyTest }

constructor TMyTest.Create;
begin

end;

destructor TMyTest.Free;
begin

end;

end.
