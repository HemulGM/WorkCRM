unit Work.Table.Customers;

interface
 uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections, Vcl.Grids,
  TableDraw, SQLLang, SQLiteTable3, Work.DB;

 type
  TTableCustomers = class;

  TItemCustomer = class
   private
    FModifed:Boolean;
    FOwner:TTableCustomers;
    FEmpty:Boolean;
    function GetFullFIO: string;
    function GetShortFIO: string;
   public
    ID:Integer;
    F,
    I,
    O:string;
    Phone,
    Telegram:string;
    DateCreate:TDateTime;
    property FullFIO:string read GetFullFIO;
    property ShortFIO:string read GetShortFIO;
    property Modifed:Boolean read FModifed write FModifed;
    property Empty:Boolean read FEmpty write FEmpty;
    procedure OpenTelegramChat;
    procedure Update;
    procedure Delete;
    procedure GetBack;
    constructor Create(AOwner:TTableCustomers);
  end;

  TTableCustomers = class(TTableData<TItemCustomer>)
    const TableName = 'Customers';
    const fnID = 'cuID';
    const fnF = 'cuF';
    const fnI = 'cuI';
    const fnO = 'cuO';
    const fnPhone = 'cuPhone';
    const fnTelegram = 'cuTelegram';
    const fnDateCreate = 'cuDateCreate';
   private
    FDB:TDatabaseCore;
   public
    function Find(ID:Integer):Integer;
    procedure Load;
    procedure Save;
    procedure GetBack(Index:Integer); overload;
    procedure GetBack(Item:TItemCustomer); overload;
    procedure Update(Index:Integer); overload;
    procedure Update(Item:TItemCustomer); overload;
    procedure Delete(Item:TItemCustomer); overload;
    procedure Delete(Index:Integer); overload;
    procedure FillList(List:TStrings; var SelID:Integer);
    procedure Clear; override;
    constructor Create(ADB:TDatabaseCore); overload;
    property DatabaseCore:TDatabaseCore read FDB write FDB;
  end;


implementation
 uses ShellAPI;

{ TTableCustomers }

procedure TTableCustomers.Clear;
var i:Integer;
begin
 for i:= 0 to Count-1 do Items[i].Free;
 inherited;
end;

constructor TTableCustomers.Create(ADB:TDatabaseCore);
begin
 inherited Create;
 FDB:=ADB;
 if not FDB.SQL.TableExists(TableName) then
  with SQL.CreateTable(TableName) do
   begin
    AddField(fnID, ftInteger, True, True);
    AddField(fnF, ftString);
    AddField(fnI, ftString);
    AddField(fnO, ftString);
    AddField(fnPhone, ftString);
    AddField(fnTelegram, ftString);
    AddField(fnDateCreate, ftDateTime);
    FDB.SQL.ExecSQL(GetSQL);
    EndCreate;
   end;
end;

procedure TTableCustomers.Delete(Item: TItemCustomer);
begin
 with SQL.Delete(TableName) do
  begin
   WhereFieldEqual(fnID, Item.ID);
   FDB.SQL.ExecSQL(GetSQL);
   EndCreate;
  end;
end;

procedure TTableCustomers.Delete(Index: Integer);
begin
 Delete(Items[Index]);
 inherited;
end;

procedure TTableCustomers.FillList(List:TStrings; var SelID:Integer);
var i, s:Integer;
begin
 s:=-1;
 List.BeginUpdate;
 List.Clear;
 try
  for i:= 0 to Count-1 do
   begin
    List.Add(Items[i].FullFIO);
    if Items[i].ID = SelID then s:=i;
   end;
 finally
  List.EndUpdate;
 end;
 SelID:=s;
end;

function TTableCustomers.Find(ID: Integer): Integer;
var i:Integer;
begin
 Result:=-1;
 for i:= 0 to Count-1 do if Items[i].ID = ID then Exit(i);
end;

procedure TTableCustomers.GetBack(Item: TItemCustomer);
var RTable:TSQLiteTable;
begin
 with SQL.Select(TableName) do
  begin
   AddField(fnF);
   AddField(fnI);
   AddField(fnO);
   AddField(fnPhone);
   AddField(fnTelegram);
   AddField(fnDateCreate);
   WhereFieldEqual(fnID, Item.ID);
   RTable:=FDB.SQL.GetTable(GetSQL);
   if RTable.Count > 0 then
    begin
     Item.F:=RTable.FieldAsString(0);
     Item.I:=RTable.FieldAsString(1);
     Item.O:=RTable.FieldAsString(2);
     Item.Phone:=RTable.FieldAsString(3);
     Item.Telegram:=RTable.FieldAsString(4);
     Item.DateCreate:=RTable.FieldAsDateTime(5);
     Item.Modifed:=False;
     Item.Empty:=False;
    end;
   RTable.Free;
   EndCreate;
  end;
end;

procedure TTableCustomers.Load;
var RTable:TSQLiteTable;
    Item:TItemCustomer;
begin
 BeginUpdate;
 Clear;
 try
  with SQL.Select(TableName) do
   begin
    AddField(fnID);
    AddField(fnF);
    AddField(fnI);
    AddField(fnO);
    AddField(fnPhone);
    AddField(fnTelegram);
    AddField(fnDateCreate);
    RTable:=FDB.SQL.GetTable(GetSQL);
    while not RTable.EOF do
     begin
      Item:=TItemCustomer.Create(Self);
      Item.ID:=RTable.FieldAsInteger(0);
      Item.F:=RTable.FieldAsString(1);
      Item.I:=RTable.FieldAsString(2);
      Item.O:=RTable.FieldAsString(3);
      Item.Phone:=RTable.FieldAsString(4);
      Item.Telegram:=RTable.FieldAsString(5);
      Item.DateCreate:=RTable.FieldAsDateTime(6);

      Item.Modifed:=False;
      Item.Empty:=False;
      Add(Item);
      RTable.Next;
     end;
    RTable.Free;
    EndCreate;
   end;
 finally
  EndUpdate;
 end;
end;

procedure TTableCustomers.GetBack(Index: Integer);
begin
 GetBack(Items[Index]);
end;

procedure TTableCustomers.Save;
var i:Integer;
begin
 for i:= 0 to Count-1 do if Items[i].Modifed then Update(i);
end;

procedure TTableCustomers.Update(Item: TItemCustomer);
var Res:Integer;
begin
 with SQL.Select(TableName) do
  begin
   AddField(fnID);
   WhereFieldEqual(fnID, Item.ID);
   Res:=FDB.SQL.GetTableValue(GetSQL);
   EndCreate;
  end;
 if Res < 0 then
  begin
   with SQL.InsertInto(TableName) do
    begin
     AddValue(fnF, Item.F);
     AddValue(fnI, Item.I);
     AddValue(fnO, Item.O);
     AddValue(fnPhone, Item.Phone);
     AddValue(fnTelegram, Item.Telegram);
     AddValue(fnDateCreate, Now);
     FDB.SQL.ExecSQL(GetSQL);
     Item.ID:=FDB.SQL.GetLastInsertRowID;
     EndCreate;
    end;
  end
 else
  begin
   with SQL.Update(TableName) do
    begin
     AddValue(fnF, Item.F);
     AddValue(fnI, Item.I);
     AddValue(fnO, Item.O);
     AddValue(fnPhone, Item.Phone);
     AddValue(fnTelegram, Item.Telegram);
     WhereFieldEqual(fnID, Item.ID);
     FDB.SQL.ExecSQL(GetSQL);
     EndCreate;
    end;
  end;
 Item.Modifed:=False;
 Item.Empty:=False;
end;

procedure TTableCustomers.Update(Index: Integer);
begin
 Update(Items[Index]);
end;

{ TItemCustomer }

constructor TItemCustomer.Create(AOwner:TTableCustomers);
begin
 inherited Create;
 FModifed:=True;
 FEmpty:=True;
 FOwner:=AOwner;
end;

procedure TItemCustomer.Delete;
begin
 FOwner.Delete(Self);
end;

procedure TItemCustomer.GetBack;
begin
 FOwner.GetBack(Self);
end;

function TItemCustomer.GetFullFIO: string;
begin
 Result:=CreateFullFIO(F, I, O);
end;

function TItemCustomer.GetShortFIO: string;
begin
 Result:=CreateFIO(F, I, O);
end;

procedure TItemCustomer.OpenTelegramChat;
begin
 ShellExecute(Application.Handle, 'open', PChar('tg://resolve?domain='+Telegram), nil, nil, SW_NORMAL);
end;

procedure TItemCustomer.Update;
begin
 FOwner.Update(Self);
end;

end.
