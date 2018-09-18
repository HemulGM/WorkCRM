unit Work.Table.Tasks;

interface
 uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections, Vcl.Grids,
  TableDraw, SQLLang, SQLiteTable3, Work.DB;

 type

  TTableTasks = class;

  TTaskState = (tsDraft, tsInTheWork, tsWaitReport, tsDone);
  TTaskPriority = (tpLow, tpLowNormal, tpNormal, tpNormalHigh, tpHigh);
  TTaskStates = set of TTaskState;

  TTaskStateHelper = record helper for TTaskState
   function ToString:string;
  end;

  TTaskPriorityHelper = record helper for TTaskPriority
   function ToString:string;
  end;

  TItemTask = class
   private
    FModifed:Boolean;
    FOwner:TTableTasks;
    FEmpty:Boolean;
    function CreateTaskWorkDir(Path:string):string;
   public
    ID:Integer;
    Name:string;
    Customer:Integer;
    Priority:TTaskPriority;
    Date:TDateTime;
    Data:string;
    DateCreate:TDateTime;
    State:TTaskState;
    JiraLink:string;
    WorkPath:string;

    CustomerStr:string;
    property Modifed:Boolean read FModifed write FModifed;
    property Empty:Boolean read FEmpty write FEmpty;
    function CreateWorkDir(Path, WorkDirName:string):Boolean;
    procedure Update;
    procedure GetBack;
    constructor Create(AOwner:TTableTasks);
  end;

  TTableTasks = class(TTableData<TItemTask>)
    const TableName = 'Tasks';
    const fnID = 'tkID';
    const fnName = 'tkName';
    const fnCustomer = 'tkCustomer';
    const fnPriority = 'tkPriority';
    const fnDate = 'tkDate';
    const fnData = 'tkData';
    const fnState = 'tkState';
    const fnDateCreate = 'tkDateCreate';
    const fnJiraLink = 'tkJiraLink';
    const fnWorkPath = 'tkWorkPath';
   private
    FDB:TDatabaseCore;
    FFilter:TTaskStates;
    FUseFilter:Boolean;
    FOrderBy: string;
    FOrderByDESC:Boolean;
   public
    procedure Load(CustomerID:Integer = -1);
    procedure Save;
    procedure GetBack(Index:Integer); overload;
    procedure GetBack(Item:TItemTask); overload;
    procedure Update(Index:Integer); overload;
    procedure Update(Item:TItemTask); overload;
    procedure Delete(Item:TItemTask); overload;
    procedure Delete(Index:Integer); overload;
    procedure Clear; override;
    property Filter:TTaskStates read FFilter write FFilter;
    property UseFilter:Boolean read FUseFilter write FUseFilter;
    property LoadTaskBy:string read FOrderBy write FOrderBy;
    property LoadTaskByDESC:Boolean read FOrderByDESC write FOrderByDESC;
    constructor Create(ADB:TDatabaseCore); overload;
    property DatabaseCore:TDatabaseCore read FDB write FDB;
  end;

const
  HG_ActualBat = 'actual_hg.bat';
  HG_Projects = 'projects.txt';


implementation
 uses Work.Table.Customers;

{ TTableTasks }

procedure TTableTasks.Clear;
var i:Integer;
begin
 for i:= 0 to Count-1 do Items[i].Free;
 inherited;
end;

constructor TTableTasks.Create(ADB:TDatabaseCore);
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
    AddField(fnCustomer, ftInteger);
    AddField(fnPriority, ftInteger);
    AddField(fnDate, ftDateTime);
    AddField(fnData, ftString);
    AddField(fnState, ftInteger);
    AddField(fnDateCreate, ftDateTime);
    AddField(fnJiraLink, ftString);
    AddField(fnWorkPath, ftString);
    FDB.SQL.ExecSQL(GetSQL);
    EndCreate;
   end;
end;

procedure TTableTasks.Delete(Item: TItemTask);
begin
 with SQL.Delete(TableName) do
  begin
   WhereFieldEqual(fnID, Item.ID);
   FDB.SQL.ExecSQL(GetSQL);
   EndCreate;
  end;
end;

procedure TTableTasks.Delete(Index: Integer);
begin
 Delete(Items[Index]);
 inherited;
end;

procedure TTableTasks.GetBack(Item: TItemTask);
var RTable:TSQLiteTable;
begin
 with SQL.Select(TableName) do
  begin
   AddField(fnName);
   AddField(fnCustomer);
   AddField(fnPriority);
   AddField(fnDate);
   AddField(fnData);
   AddField(fnState);
   AddField(fnDateCreate);
   AddField(fnJiraLink);
   AddField(fnWorkPath);
   WhereFieldEqual(fnID, Item.ID);
   RTable:=FDB.SQL.GetTable(GetSQL);
   if RTable.Count > 0 then
    begin
     Item.Name:=RTable.FieldAsString(0);
     Item.Customer:=RTable.FieldAsInteger(1);
     Item.Priority:=TTaskPriority(RTable.FieldAsInteger(2));
     Item.Date:=RTable.FieldAsDateTime(3);
     Item.Data:=RTable.FieldAsString(4);
     Item.State:=TTaskState(RTable.FieldAsInteger(5));
     Item.DateCreate:=RTable.FieldAsDateTime(6);
     Item.JiraLink:=RTable.FieldAsString(7);
     Item.WorkPath:=RTable.FieldAsString(8);
     Item.Modifed:=False;
     Item.Empty:=False;
    end;
   RTable.Free;
   EndCreate;
  end;
end;

function SetOfTaskStatesToStrArray(Value:TTaskStates):TArray<string>;
var State:TTaskState;
begin
 for State in Value do
  begin
   if State in Value then
    begin
     SetLength(Result, Length(Result)+1);
     Result[Length(Result)-1]:=IntToStr(Ord(State));
    end;
  end;
end;

procedure TTableTasks.Load;
var RTable, CTable:TSQLiteTable;
    Item:TItemTask;
begin
 BeginUpdate;
 Clear;
 try
  with SQL.Select(TableName) do
   begin
    AddField(fnName);
    AddField(fnCustomer);
    AddField(fnPriority);
    AddField(fnDate);
    AddField(fnData);
    AddField(fnState);
    AddField(fnDateCreate);
    AddField(fnID);
    AddField(fnJiraLink);
    AddField(fnWorkPath);
    if UseFilter then WhereFieldIN(fnState, SetOfTaskStatesToStrArray(FFilter));
    if CustomerID >= 0 then WhereFieldEqual(fnCustomer, CustomerID);

    OrderBy(FOrderBy, FOrderByDESC);
    RTable:=FDB.SQL.GetTable(GetSQL);
    while not RTable.EOF do
     begin
      Item:=TItemTask.Create(Self);
      Item.Name:=RTable.FieldAsString(0);
      Item.Customer:=RTable.FieldAsInteger(1);
      Item.Priority:=TTaskPriority(RTable.FieldAsInteger(2));
      Item.Date:=RTable.FieldAsDateTime(3);
      Item.Data:=RTable.FieldAsString(4);
      Item.State:=TTaskState(RTable.FieldAsInteger(5));
      Item.DateCreate:=RTable.FieldAsDateTime(6);
      Item.ID:=RTable.FieldAsInteger(7);
      Item.JiraLink:=RTable.FieldAsString(8);
      Item.WorkPath:=RTable.FieldAsString(9);
      Item.CustomerStr:='';
      with SQL.Select(TTableCustomers.TableName) do
       begin
        AddField(TTableCustomers.fnF);
        AddField(TTableCustomers.fnI);
        AddField(TTableCustomers.fnO);
        WhereFieldEqual(TTableCustomers.fnID, Item.Customer);
        try
         CTable:=FDB.SQL.GetTable(GetSQL);
         if CTable.Count > 0 then
          begin
           Item.CustomerStr:=CreateFIO(CTable.FieldAsString(0), CTable.FieldAsString(1), CTable.FieldAsString(2));
          end
         else Item.CustomerStr:='';
        finally
         if Assigned(CTable) then CTable.Free;
        end;
        EndCreate;
       end;
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

procedure TTableTasks.GetBack(Index: Integer);
begin
 GetBack(Items[Index]);
end;

procedure TTableTasks.Save;
var i:Integer;
begin
 for i:= 0 to Count-1 do if Items[i].Modifed then Update(i);
end;

procedure TTableTasks.Update(Item: TItemTask);
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
     AddValue(fnCustomer, Item.Customer);
     AddValue(fnPriority, Ord(Item.Priority));
     AddValue(fnDate, Item.Date);
     AddValueAsParam(fnData, '?', True);
     AddValue(fnState, Ord(Item.State));
     AddValue(fnDateCreate, Now);
     AddValue(fnJiraLink, Item.JiraLink);
     AddValue(fnWorkPath, Item.WorkPath);

     FDB.SQL.ExecSQL(GetSQL, [PAnsiChar(AnsiString(Item.Data))]);
     Item.ID:=FDB.SQL.GetLastInsertRowID;
     EndCreate;
    end;
  end
 else
  begin
   with SQL.Update(TableName) do
    begin
     AddValue(fnName, Item.Name);
     AddValue(fnCustomer, Item.Customer);
     AddValue(fnPriority, Ord(Item.Priority));
     AddValue(fnDate, Item.Date);
     AddValueAsParam(fnData, '?', True);
     AddValue(fnState, Ord(Item.State));
     AddValue(fnJiraLink, Item.JiraLink);
     AddValue(fnWorkPath, Item.WorkPath);

     WhereFieldEqual(fnID, Item.ID);

     FDB.SQL.ExecSQL(GetSQL, [PAnsiChar(AnsiString(Item.Data))]);
     EndCreate;
    end;
  end;
 Item.Modifed:=False;
 Item.Empty:=False;
end;

procedure TTableTasks.Update(Index: Integer);
begin
 Update(Items[Index]);
end;

{ TItemTask }

function TItemTask.CreateTaskWorkDir(Path:string): string;
var PName:string;
  i: Integer;
begin
 Result:='';
 if JiraLink <> '' then
  begin
   PName:=JiraLink;
   if PName[Length(PName)] = '/' then Delete(PName, Length(PName), 1);
   for i:= Length(PName) downto 1 do
    if PName[i] = '/' then
     begin
      PName:=Copy(PName, i, 255);
      Break;
     end;
   if PName = '' then PName:=Name;
  end
 else PName:=Name;
 if CreateDir(Path+PName) then Result:=Path+PName+'\';
end;

constructor TItemTask.Create(AOwner:TTableTasks);
begin
 inherited Create;
 FModifed:=True;
 FEmpty:=True;
 FOwner:=AOwner;
end;

function TItemTask.CreateWorkDir(Path, WorkDirName:string): Boolean;
begin
 Result:=False;
 WorkPath:=CreateTaskWorkDir(Path);
 if DirectoryExists(WorkPath) then
  begin
   Result:=CreateDir(WorkPath+'\'+WorkDirName);
   CopyFile(PChar(Path+HG_ActualBat), PChar(WorkPath+HG_ActualBat), False);
   CopyFile(PChar(Path+HG_Projects), PChar(WorkPath+HG_Projects), False);
  end;
end;

procedure TItemTask.GetBack;
begin
 FOwner.GetBack(Self);
end;

procedure TItemTask.Update;
begin
 FOwner.Update(Self);
end;

{ TTaskStateHelper }

function TTaskStateHelper.ToString: string;
begin
 case Self of
  tsDraft:Exit('Черновик');
  tsInTheWork:Exit('В работе');
  tsWaitReport:Exit('Отчёт');
  tsDone:Exit('Готово');
 end;
end;

{ TTaskPriorityHelper }

function TTaskPriorityHelper.ToString: string;
begin
 case Self of
  tpLow:Exit('Низший');
  tpLowNormal:Exit('Низкий');
  tpNormal:Exit('Средний');
  tpNormalHigh:Exit('Высокий');
  tpHigh:Exit('Высший');
 end;
end;

end.
