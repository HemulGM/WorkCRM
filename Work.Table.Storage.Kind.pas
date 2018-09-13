unit Work.Table.Storage.Kind;

interface
 uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections, Vcl.Grids,
  TableDraw, SQLLang, SQLiteTable3, Work.DB;

 type
  TTableProductKind = class;

  TItemProdKind = class
   private
    FModifed:Boolean;
    FOwner:TTableProductKind;
    FEmpty:Boolean;
   public
    ID:Integer;
    Name:string;
    Comment:string;
    property Modifed:Boolean read FModifed write FModifed;
    property Empty:Boolean read FEmpty write FEmpty;
    procedure Update;
    procedure GetBack;
    constructor Create(AOwner:TTableProductKind);
  end;

  TTableProductKind = class(TTableData<TItemProdKind>)
    const TableName = 'ProductKind';
    const fnID = 'pkID';
    const fnName = 'pkName';
    const fnComment = 'pkComment';
   private
    FDB:TDatabaseCore;
    FOrderBy: string;
    FOrderByDESC:Boolean;
   public
    procedure Load;
    procedure Save;
    procedure GetBack(Index:Integer); overload;
    procedure GetBack(Item:TItemProdKind); overload;
    procedure Update(Index:Integer); overload;
    procedure Update(Item:TItemProdKind); overload;
    procedure Delete(Item:TItemProdKind); overload;
    procedure Delete(Index:Integer); overload;
    function GetNextOrderNumber:Integer;
    procedure Clear; override;
    property LoadOrderBy:string read FOrderBy write FOrderBy;
    property LoadOrderByDESC:Boolean read FOrderByDESC write FOrderByDESC;
    constructor Create(ADB:TDatabaseCore); overload;
    property DatabaseCore:TDatabaseCore read FDB write FDB;
  end;


implementation

{ TTableProductKind }

procedure TTableProductKind.Clear;
var i:Integer;
begin
 for i:= 0 to Count-1 do Items[i].Free;
 inherited;
end;

constructor TTableProductKind.Create(ADB:TDatabaseCore);
begin
 inherited Create;
 FOrderBy:=fnName;
 FOrderByDESC:=False;
 FDB:=ADB;
 if not FDB.SQL.TableExists(TableName) then
  with SQL.CreateTable(TableName) do
   begin
    AddField(fnID, ftInteger, True, True);
    AddField(fnName, ftString);
    AddField(fnComment, ftString);
    FDB.SQL.ExecSQL(GetSQL);
    EndCreate;
   end;
end;

procedure TTableProductKind.Delete(Item: TItemProdKind);
begin
 with SQL.Delete(TableName) do
  begin
   WhereFieldEqual(fnID, Item.ID);
   FDB.SQL.ExecSQL(GetSQL);
   EndCreate;
  end;
end;

procedure TTableProductKind.Delete(Index: Integer);
begin
 Delete(Items[Index]);
 inherited;
end;

procedure TTableProductKind.GetBack(Item: TItemProdKind);
var RTable:TSQLiteTable;
begin
 with SQL.Select(TableName) do
  begin
   AddField(fnName);
   AddField(fnComment);
   WhereFieldEqual(fnID, Item.ID);
   RTable:=FDB.SQL.GetTable(GetSQL);
   if RTable.Count > 0 then
    begin
     Item.Name:=RTable.FieldAsString(0);
     Item.Comment:=RTable.FieldAsString(1);
     Item.Modifed:=False;
     Item.Empty:=False;
    end;
   RTable.Free;
   EndCreate;
  end;
end;

function TTableProductKind.GetNextOrderNumber: Integer;
begin
 Result:=FDB.GetNextVal('ORDERS');
end;

procedure TTableProductKind.Load;
var RTable:TSQLiteTable;
    Item:TItemProdKind;
begin
 BeginUpdate;
 Clear;
 try
  with SQL.Select(TableName) do
   begin
    AddField(fnID);
    AddField(fnName);
    AddField(fnComment);
    OrderBy(FOrderBy, FOrderByDESC);
    RTable:=FDB.SQL.GetTable(GetSQL);
    while not RTable.EOF do
     begin
      Item:=TItemProdKind.Create(Self);
      Item.ID:=RTable.FieldAsInteger(0);
      Item.Name:=RTable.FieldAsString(1);
      Item.Comment:=RTable.FieldAsString(2);
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

procedure TTableProductKind.GetBack(Index: Integer);
begin
 GetBack(Items[Index]);
end;

procedure TTableProductKind.Save;
var i:Integer;
begin
 for i:= 0 to Count-1 do if Items[i].Modifed then Update(i);
end;

procedure TTableProductKind.Update(Item: TItemProdKind);
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
     AddValue(fnName, Item.Name);
     AddValue(fnComment, Item.Comment);
     FDB.SQL.ExecSQL(GetSQL);
     Item.ID:=FDB.SQL.GetLastInsertRowID;
     EndCreate;
    end;
  end
 else
  begin
   with SQL.Update(TableName) do
    begin
     AddValue(fnName, Item.Name);
     AddValue(fnComment, Item.Comment);
     WhereFieldEqual(fnID, Item.ID);
     FDB.SQL.ExecSQL(GetSQL);
     EndCreate;
    end;
  end;
 Item.Modifed:=False;
 Item.Empty:=False;
end;

procedure TTableProductKind.Update(Index: Integer);
begin
 Update(Items[Index]);
end;

{ TItemProdKind }

constructor TItemProdKind.Create(AOwner:TTableProductKind);
begin
 inherited Create;
 FModifed:=True;
 FEmpty:=True;
 FOwner:=AOwner;
end;

procedure TItemProdKind.GetBack;
begin
 FOwner.GetBack(Self);
end;

procedure TItemProdKind.Update;
begin
 FOwner.Update(Self);
end;

end.
