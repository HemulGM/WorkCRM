unit Work.Main;

interface

{$I cef.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.Generics.Collections, Vcl.Grids, TableDraw, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ImgList, ShadowWnd,

  LKDU.Button, HGM.Common.Utils, HGM.Common.Notify,

  Work.Table.Customers, Work.Table.Tasks,
  Work.Table.History, Work.DB, System.Rtti, Vcl.Menus, uCEFChromium,
  uCEFWindowParent, uCEFChromiumWindow, uCEFTypes, uCEFInterfaces, uCEFConstants,
  acPNG;

const
  CEF_AFTERCREATED_GKEEP       = WM_APP + $A10;
  CEF_AFTERCREATED_JIRA        = WM_APP + $A11;

type
  TCRMMode = (cmNormal, cmMini);

  TAppState = record
   FModals:Integer;
   // Данные формы заказчика
   CurCustomer:TItemCustomer;
   // Данные формы заказчика
   FCurCustomerTasks:TTableTasks;
   // Данные формы задачи
   CurTask:TItemTask;
   CurTaskState:TTaskState;
   CurTaskPriority:TTaskPriority;
   procedure OpenModal;
   procedure CloseModal;
  end;

  TNotifyKind = (nkInfo, nkWarning, nkError, nkOK, nkFail);
  TNotifyItem = record
   Text:string;
   Kind:TNotifyKind;
   class function Create(AText:string; AKind:TNotifyKind):TNotifyItem; static;
  end;
  TNotifyStorage = TTableData<TNotifyItem>;

  TFormMain = class(TForm)
    PanelHeader: TPanel;
    Shape1: TShape;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    EditSearch: TEdit;
    ButtonFlat1: TButtonFlat;
    ImageList24: TImageList;
    Panel3: TPanel;
    LabelTime: TLabel;
    TimerTime: TTimer;
    PanelLeft: TPanel;
    PanelClient: TPanel;
    Panel4: TPanel;
    ButtonFlatAddOther: TButtonFlat;
    ImageListSmall: TImageList;
    ButtonFlat3: TButtonFlat;
    PanelTableCustomers: TPanel;
    PanelTableCustomerHead: TPanel;
    PanelTableCustomersClient: TPanel;
    Label3: TLabel;
    LabelDate: TLabel;
    ButtonFlatCustomers: TButtonFlat;
    ButtonFlatNewTask: TButtonFlat;
    Shape2: TShape;
    Panel5: TPanel;
    TableExCustomers: TTableEx;
    Panel6: TPanel;
    ButtonFlatCustomersAdd: TButtonFlat;
    ButtonFlatTasks: TButtonFlat;
    ButtonFlatCalendar: TButtonFlat;
    ButtonFlatStatistics: TButtonFlat;
    PanelTableTasks: TPanel;
    Panel8: TPanel;
    Label4: TLabel;
    Panel9: TPanel;
    Panel10: TPanel;
    TableExTasks: TTableEx;
    Panel11: TPanel;
    ButtonFlatTasksAdd: TButtonFlat;
    PanelTask: TPanel;
    Panel12: TPanel;
    LabelSelectTask: TLabel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    ButtonFlatTaskSave: TButtonFlat;
    ButtonFlatTaskClose: TButtonFlat;
    Panel7: TPanel;
    PanelFeed: TPanel;
    Panel17: TPanel;
    Label10: TLabel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    ButtonFlatFeedNewTask: TButtonFlat;
    ButtonFlatFeed: TButtonFlat;
    PanelCustomer: TPanel;
    Panel21: TPanel;
    LabelSelCustomer: TLabel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    ButtonFlatCustomerSave: TButtonFlat;
    ButtonFlatCustomerClose: TButtonFlat;
    Panel25: TPanel;
    Label12: TLabel;
    EditCustomerF: TEdit;
    EditCustomerI: TEdit;
    EditCustomerO: TEdit;
    Label11: TLabel;
    EditCustomerPhone: TEdit;
    Label13: TLabel;
    EditCustomerTelegram: TEdit;
    PanelCurCustomerTasks: TPanel;
    TableExCustomerTasks: TTableEx;
    Label15: TLabel;
    ButtonFlatCustomersEdit: TButtonFlat;
    ButtonFlatCustomersDel: TButtonFlat;
    ButtonFlatTasksDelete: TButtonFlat;
    ButtonFlatTasksEdit: TButtonFlat;
    ButtonFlatFeedNewCustomer: TButtonFlat;
    PanelFeedHotTasks: TPanel;
    TableExHotTasks: TTableEx;
    ButtonFlatCustomersLoad: TButtonFlat;
    ButtonFlatLoadTasks: TButtonFlat;
    Panel26: TPanel;
    ButtonFlatFeedUpdate: TButtonFlat;
    Panel27: TPanel;
    Shape3: TShape;
    Panel28: TPanel;
    Shape4: TShape;
    TableExFeed: TTableEx;
    Panel29: TPanel;
    EditSearchFeed: TEdit;
    ButtonFlatSearchFeed: TButtonFlat;
    ButtonFlat4: TButtonFlat;
    ButtonFlatTODO1: TButtonFlat;
    Label17: TLabel;
    EditClientDateCreate: TEdit;
    PopupMenuAddOther: TPopupMenu;
    MenuItemNewTask: TMenuItem;
    MenuItemN1: TMenuItem;
    MenuItemNewCustomer: TMenuItem;
    ImageListWinC1: TImageList;
    ImageListWinC2: TImageList;
    ButtonFlatGoogleKeep: TButtonFlat;
    PanelGoogleKeep: TPanel;
    PanelJira: TPanel;
    ButtonFlatJira: TButtonFlat;
    Panel16: TPanel;
    ScrollBox1: TScrollBox;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    Label16: TLabel;
    LabelTaskName: TLabel;
    Label14: TLabel;
    ComboBoxSelTaskCustomer: TComboBox;
    MemoSelTaskData: TMemo;
    DateTimePickerSelTaskTime: TDateTimePicker;
    DateTimePickerSelTaskDate: TDateTimePicker;
    ButtonFlatTaskDraft: TButtonFlat;
    ButtonFlatTaskNormal: TButtonFlat;
    ButtonFlatTaskInTheWork: TButtonFlat;
    ButtonFlatTaskDone: TButtonFlat;
    ButtonFlatTaskNewCustomer: TButtonFlat;
    EditTaskName: TEdit;
    ButtonFlatTaskPr0: TButtonFlat;
    ButtonFlatTaskPr1: TButtonFlat;
    ButtonFlatTaskPr2: TButtonFlat;
    ButtonFlatTaskPr3: TButtonFlat;
    ButtonFlatTaskPr4: TButtonFlat;
    EditTaskJira: TEdit;
    ButtonFlatTaskJiraLoad: TButtonFlat;
    PanelTaskAuto: TPanel;
    Label9: TLabel;
    ButtonFlatTaskAutoCProject: TButtonFlat;
    CheckBoxTaskAutoCProject: TCheckBox;
    ButtonFlat2: TButtonFlat;
    CheckBoxTaskAutoHG: TCheckBox;
    TableExNotify: TTableEx;
    ButtonFlat5: TButtonFlat;
    ChromiumJira: TChromium;
    ChromiumGKeep: TChromium;
    ChromiumWindowJira: TCEFWindowParent;
    ChromiumWindowGKeep: TCEFWindowParent;
    ButtonFlat6: TButtonFlat;
    PopupMenuCustomer: TPopupMenu;
    MenuItemCustEdit: TMenuItem;
    MenuItemCustTelegram: TMenuItem;
    MenuItemCustDel: TMenuItem;
    N3: TMenuItem;
    ButtonFlatCustomerTelegram: TButtonFlat;
    ButtonFlatTasksTelegram: TButtonFlat;
    PanelCustomerInfo: TPanel;
    PanelCustInfoHead: TPanel;
    ButtonFlatHideCustomerInfo: TButtonFlat;
    ImageListOver: TImageList;
    Label18: TLabel;
    PanelCustInfoName: TPanel;
    Image1: TImage;
    LabelCustName: TLabel;
    PanelCustInfoActions: TPanel;
    ButtonFlat8: TButtonFlat;
    ButtonFlat9: TButtonFlat;
    PanelCustInfoContact: TPanel;
    ButtonFlat7: TButtonFlat;
    EditCustPhone: TEdit;
    Label19: TLabel;
    EditCustTelegram: TEdit;
    Label20: TLabel;
    ButtonFlatShowCustomerInfo: TButtonFlat;
    Shape5: TShape;
    Shape6: TShape;
    procedure FormCreate(Sender: TObject);
    procedure TableExCostomersGetData(FCol, FRow: Integer; var Value: string);
    procedure TimerTimeTimer(Sender: TObject);
    procedure EditSearchEnter(Sender: TObject);
    procedure EditSearchExit(Sender: TObject);
    procedure ButtonFlatCustomersClick(Sender: TObject);
    procedure ButtonFlatCustomersAddClick(Sender: TObject);
    procedure ButtonFlatTasksClick(Sender: TObject);
    procedure TableExTasksGetData(FCol, FRow: Integer; var Value: string);
    procedure TableExTasksDrawCellData(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ButtonFlatFeedClick(Sender: TObject);
    procedure ButtonFlatCustomerSaveClick(Sender: TObject);
    procedure ButtonFlatCustomerCloseClick(Sender: TObject);
    procedure ButtonFlatCustomersEditClick(Sender: TObject);
    procedure ButtonFlatCustomersDelClick(Sender: TObject);
    procedure ButtonFlatTasksAddClick(Sender: TObject);
    procedure ButtonFlatTasksEditClick(Sender: TObject);
    procedure ButtonFlatTaskCloseClick(Sender: TObject);
    procedure ButtonFlatTasksDeleteClick(Sender: TObject);
    procedure ButtonFlatTaskDraftClick(Sender: TObject);
    procedure ButtonFlatTaskSaveClick(Sender: TObject);
    procedure TableExCustomerTasksGetData(FCol, FRow: Integer; var Value: string);
    procedure ButtonFlatCustomersLoadClick(Sender: TObject);
    procedure ButtonFlatLoadTasksClick(Sender: TObject);
    procedure ButtonFlatTaskNewCustomerClick(Sender: TObject);
    procedure DateTimePickerSelTaskTimeChange(Sender: TObject);
    procedure TableExHotTasksDrawCellData(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ButtonFlatFeedUpdateClick(Sender: TObject);
    procedure TableExHotTasksItemClick(Sender: TObject;
      MouseButton: TMouseButton; const Index: Integer);
    procedure FormResize(Sender: TObject);
    procedure TableExFeedDrawCellData(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ButtonFlatTaskPr0Click(Sender: TObject);
    procedure ButtonFlatAddOtherClick(Sender: TObject);
    procedure Panel16MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonFlatGoogleKeepClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonFlatJiraClick(Sender: TObject);
    procedure ButtonFlatTaskAutoCProjectClick(Sender: TObject);
    procedure ButtonFlat2Click(Sender: TObject);
    procedure EditTaskJiraChange(Sender: TObject);
    procedure TableExNotifyGetData(FCol, FRow: Integer; var Value: string);
    procedure TableExNotifyAfterDrawText(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Label1Click(Sender: TObject);
    procedure ChromiumGKeepBeforePopup(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
      targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; const popupFeatures: TCefPopupFeatures;
      var windowInfo: TCefWindowInfo; var client: ICefClient;
      var settings: TCefBrowserSettings; var noJavascriptAccess,
      Result: Boolean);
    procedure ChromiumJiraAfterCreated(Sender: TObject;
      const browser: ICefBrowser);
    procedure ChromiumGKeepAfterCreated(Sender: TObject;
      const browser: ICefBrowser);
    procedure FormShow(Sender: TObject);
    procedure ButtonFlat6Click(Sender: TObject);
    procedure ButtonFlatCustomerTelegramClick(Sender: TObject);
    procedure ButtonFlatTasksTelegramClick(Sender: TObject);
    procedure ButtonFlat9Click(Sender: TObject);
    procedure TableExCustomersItemClick(Sender: TObject;
      MouseButton: TMouseButton; const Index: Integer);
    procedure ButtonFlatHideCustomerInfoClick(Sender: TObject);
    procedure ButtonFlatShowCustomerInfoClick(Sender: TObject);
    procedure ChromiumGKeepJsdialog(Sender: TObject; const browser: ICefBrowser;
      const originUrl: ustring; dialogType: TCefJsDialogType; const messageText,
      defaultPromptText: ustring; const callback: ICefJsDialogCallback;
      out suppressMessage, Result: Boolean);
   private
    FCWJiraClosed:Boolean;
    FCWGKeepClosed:Boolean;

    FAppState:TAppState;
    FNotify:TNotifyPanel;
    FNotifyStorage:TNotifyStorage;
    //Ядро БД
    FCore:TDatabaseCore;
    //Таблицы
    FCustomers:TTableCustomers;
    FTasks:TTableTasks;
    FHotTasks:TTableTasks;
    FHistory:TTableHistory;
    FMode: TCRMMode;
    FDefWidth:Integer;
    FDefHeight:Integer;

    procedure CreateTables;
    procedure BrowserCreatedMsgGKeep(var aMessage : TMessage); message CEF_AFTERCREATED_GKEEP;
    procedure BrowserCreatedMsgJira(var aMessage : TMessage); message CEF_AFTERCREATED_JIRA;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;
    procedure SetMenuIconColor(Color: TColor);
    procedure ShowPanel(Panel:TPanel);
    procedure SetTaskStateButtons(State:TTaskState);
    procedure SetTaskPriorityButtons(Priority:TTaskPriority);
    procedure OpenPage(Panel: TPanel);
    procedure UpdateFeed;
    procedure InitTables;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure SetMode(const Value: TCRMMode);
  public
    procedure CreateParams(var Params:TCreateParams); override;
    function AddCustomer:Integer;
    function EditCustomer:Integer;
    function DeleteCustomer:Integer;

    function AddTask:Integer;
    function EditTask:Integer; overload;
    function EditTask(Item:TItemTask):Integer; overload;
    function EditTask(Item:Integer):Integer; overload;
    function DeleteTask:Integer;

    function ShowInfoOk(Text:string; OnlyList:Boolean = False):Boolean;
    function ShowWrongInfo(Text:string; OnlyList:Boolean = False):Boolean;

    function CanIDoSmt:Boolean;

    procedure SetCustomerInfo(Item:TItemCustomer);

    procedure UpdateCustomersTable(ItemID:Integer = -1);
    procedure UpdateTasksTable(ItemID:Integer = -1);
    procedure Quit;
    procedure Waiting;

    property Mode:TCRMMode read FMode write SetMode;
  end;

const
  WorkPath = 'C:\Projects\';
  WorkDir  = '#Work';

  urlGKeep = 'https://keep.google.com/#label/Рабочий';
  urlJira = 'http://jira.elt';
  urlBorda = 'https://live.goodline.info/people/';


var
  FormMain: TFormMain;

implementation
 uses Math, uCEFApplication, clipbrd, ShellAPI;

{$R *.dfm}

procedure OpenURL(aURL:string);
begin
 ShellExecute(Application.Handle, 'open', PChar(aURL), nil, nil, SW_NORMAL);
end;

procedure TFormMain.WMEnterMenuLoop(var aMessage: TMessage);
begin
 inherited;
 if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := True;
end;

procedure TFormMain.WMExitMenuLoop(var aMessage: TMessage);
begin
 inherited;
 if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := False;
end;

procedure TFormMain.WMMove(var aMessage : TWMMove);
begin
 inherited;
 //if (ChromiumJira <> nil) then ChromiumJira.NotifyMoveOrResizeStarted;
 //if (ChromiumGKeep <> nil) then ChromiumGKeep.NotifyMoveOrResizeStarted;
end;

procedure TFormMain.WMMoving(var aMessage : TMessage);
begin
 inherited;
 //if (ChromiumJira <> nil) then ChromiumJira.NotifyMoveOrResizeStarted;
 //if (ChromiumGKeep <> nil) then ChromiumGKeep.NotifyMoveOrResizeStarted;
end;

procedure TFormMain.Waiting;
begin
 //
end;

procedure TFormMain.CreateParams(var Params:TCreateParams);
begin
 inherited;
 Params.ExStyle:=Params.ExStyle or WS_EX_COMPOSITED;
end;

procedure TFormMain.SetCustomerInfo(Item: TItemCustomer);
var H:Integer;
begin
 LabelCustName.Caption:=Item.ShortFIO;
 EditCustTelegram.Text:=Item.Telegram;
 EditCustPhone.Text:=Item.Phone;
 H:=110;
 if (EditCustTelegram.Text = '') and (EditCustPhone.Text = '') then PanelCustInfoContact.Hide
 else
  begin
   if EditCustTelegram.Text <> '' then H:=60;
   if EditCustPhone.Text <> '' then H:=110;
   PanelCustInfoContact.Visible:=True;
  end;
 PanelCustInfoContact.Height:=H;


 if EditCustTelegram.Text = '' then EditCustTelegram.Text:='Нет';
 if EditCustPhone.Text = '' then EditCustPhone.Text:='Нет';
 //60 110
end;

procedure TFormMain.SetMenuIconColor(Color:TColor);
var i:Integer;
begin
 for i:= 0 to ImageList24.Count - 1 do ColorImages(ImageList24, i, Color);
 for i:= 0 to ImageListSmall.Count - 1 do
  begin
   ColorImages(ImageListSmall, i, ColorDarker(Color, 60));
   ImageListOver.AddImage(ImageListSmall, i);
   ColorImages(ImageListOver, i, ColorDarker(Color, 80));
  end;

 ColorImages(ImageListSmall, 8, $00005B9C);
 ColorImages(ImageListSmall, 9, $000042F7);
 ColorImages(ImageListSmall, 10, $00E3B030);
 ColorImages(ImageListSmall, 11, $0020C100);

 ColorImages(ImageListSmall, 16, $000FDF8F);
 ColorImages(ImageListSmall, 17, $000FDFDD);
 ColorImages(ImageListSmall, 18, $00D4B811);
 ColorImages(ImageListSmall, 19, $001183D8);
 ColorImages(ImageListSmall, 20, $001449C8);

 for i:= 0 to ImageListWinC1.Count - 1 do ColorImages(ImageListWinC1, i, $00736657);
 for i:= 0 to ImageListWinC2.Count - 1 do ColorImages(ImageListWinC2, i, $00E0E0E0);
 //$00736657
 //$00E0E0E0
end;

procedure TFormMain.SetMode(const Value: TCRMMode);
begin
 FMode := Value;
 case FMode of
  cmNormal:
   begin
    Constraints.MinWidth:=800;
    Constraints.MaxWidth:=0;
    ClientWidth:=FDefWidth;
   end;
  cmMini:
   begin
    Constraints.MinWidth:=0;
    ClientWidth:=225;
    Constraints.MinWidth:=Width;
    Constraints.MaxWidth:=Width;
   end;
 end;
end;

procedure TFormMain.SetTaskPriorityButtons(Priority: TTaskPriority);
begin
 FAppState.CurTaskPriority:=Priority;
 if ButtonFlatTaskPr0.Tag = Ord(Priority) then ButtonFlatTaskPr0.ColorNormal:=$00F7D791 else ButtonFlatTaskPr0.ColorNormal:=$00F7F6F2;
 if ButtonFlatTaskPr1.Tag = Ord(Priority) then ButtonFlatTaskPr1.ColorNormal:=$00F7D791 else ButtonFlatTaskPr1.ColorNormal:=$00F7F6F2;
 if ButtonFlatTaskPr2.Tag = Ord(Priority) then ButtonFlatTaskPr2.ColorNormal:=$00F7D791 else ButtonFlatTaskPr2.ColorNormal:=$00F7F6F2;
 if ButtonFlatTaskPr3.Tag = Ord(Priority) then ButtonFlatTaskPr3.ColorNormal:=$00F7D791 else ButtonFlatTaskPr3.ColorNormal:=$00F7F6F2;
 if ButtonFlatTaskPr4.Tag = Ord(Priority) then ButtonFlatTaskPr4.ColorNormal:=$00F7D791 else ButtonFlatTaskPr4.ColorNormal:=$00F7F6F2;
end;

procedure TFormMain.SetTaskStateButtons(State:TTaskState);
begin
 FAppState.CurTaskState:=State;
 if ButtonFlatTaskDraft.Tag = Ord(State) then ButtonFlatTaskDraft.ColorNormal:=$00F7D791 else ButtonFlatTaskDraft.ColorNormal:=$00F7F6F2;
 if ButtonFlatTaskNormal.Tag = Ord(State) then ButtonFlatTaskNormal.ColorNormal:=$00F7D791 else ButtonFlatTaskNormal.ColorNormal:=$00F7F6F2;
 if ButtonFlatTaskInTheWork.Tag = Ord(State) then ButtonFlatTaskInTheWork.ColorNormal:=$00F7D791 else ButtonFlatTaskInTheWork.ColorNormal:=$00F7F6F2;
 if ButtonFlatTaskDone.Tag = Ord(State) then ButtonFlatTaskDone.ColorNormal:=$00F7D791 else ButtonFlatTaskDone.ColorNormal:=$00F7F6F2;
end;

function TFormMain.ShowInfoOk(Text: string; OnlyList:Boolean = False):Boolean;
var NItem:TNotifyItem;
begin
 Result:=True;
 NItem.Text:=Text;
 NItem.Kind:=nkOK;
 FNotifyStorage.Insert(0, NItem);
 if not OnlyList then FNotify.OK('Готово', Text);
end;

procedure TFormMain.OpenPage(Panel: TPanel);
begin
 if not CanIDoSmt then Exit;
 ShowPanel(Panel);
 if Panel = PanelGoogleKeep then ChromiumGKeep.NotifyMoveOrResizeStarted;
 if Panel = PanelJira then ChromiumJira.NotifyMoveOrResizeStarted;
end;

procedure TFormMain.Panel16MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const SC_DragMove = $F012;
begin
 ReleaseCapture;
 Perform(WM_SYSCOMMAND, SC_DragMove, 0);
end;

procedure TFormMain.Quit;
begin
 Waiting;
 Hide;
 ChromiumGKeep.CloseBrowser(True);
 ChromiumJira.CloseBrowser(True);
 Application.Terminate;
end;

procedure TFormMain.ShowPanel(Panel: TPanel);
begin
 if not Assigned(Panel) then Exit;
 Panel.Show;
 Panel.BringToFront;
end;

function TFormMain.ShowWrongInfo(Text:string; OnlyList:Boolean = False):Boolean;
var NItem:TNotifyItem;
begin
 Result:=True;
 NItem.Text:=Text;
 NItem.Kind:=nkWarning;
 FNotifyStorage.Insert(0, NItem);
 if not OnlyList then FNotify.Warning('Ошибка', Text);
end;

function TFormMain.AddCustomer: Integer;
begin
 EditCustomerF.Clear;
 EditCustomerI.Clear;
 EditCustomerO.Clear;
 EditCustomerPhone.Clear;
 EditCustomerTelegram.Clear;
 EditClientDateCreate.Text:='Сейчас';
 FAppState.CurCustomer:=TItemCustomer.Create(FCustomers);
 PanelCurCustomerTasks.Hide;
 LabelSelCustomer.Caption:='Новый заказчик';

 FAppState.OpenModal;
 ShowPanel(PanelCustomer);
end;

function TFormMain.AddTask:Integer;
var SelIt:Integer;
begin
 FCustomers.FillList(ComboBoxSelTaskCustomer.Items, SelIt);
 ComboBoxSelTaskCustomer.ItemIndex:=-1;
 ComboBoxSelTaskCustomer.Text:='';
 DateTimePickerSelTaskDate.DateTime:=Now;
 DateTimePickerSelTaskTime.DateTime:=Now;
 MemoSelTaskData.Clear;
 EditTaskName.Clear;
 EditTaskJira.Clear;

 FAppState.CurTask:=TItemTask.Create(FTasks);
 SetTaskStateButtons(FAppState.CurTask.State);
 SetTaskPriorityButtons(FAppState.CurTask.Priority);
 PanelTaskAuto.Visible:=True;
 LabelSelectTask.Caption:='Новая задача';

 FAppState.OpenModal;
 ShowPanel(PanelTask);
end;

procedure TFormMain.ButtonFlatTasksEditClick(Sender: TObject);
begin
 EditTask;
end;

procedure TFormMain.ButtonFlatTasksTelegramClick(Sender: TObject);
var CID:Integer;
begin
 if not IndexInList(TableExTasks.ItemIndex, FTasks.Count) then Exit;
 if FTasks[TableExTasks.ItemIndex].Customer < 0 then Exit;
 CID:=FCustomers.Find(FTasks[TableExTasks.ItemIndex].Customer);
 if CID < 0 then Exit;
 FCustomers[CID].OpenTelegramChat;
end;

procedure TFormMain.ButtonFlatTaskNewCustomerClick(Sender: TObject);
begin
 AddCustomer;
end;

procedure TFormMain.ButtonFlatTaskPr0Click(Sender: TObject);
begin
 SetTaskPriorityButtons(TTaskPriority((Sender as TButtonFlat).Tag));
end;

procedure TFormMain.ButtonFlatTaskSaveClick(Sender: TObject);
var ItemHist:TItemHistory;
    SPath:string;
begin
 if not Assigned(FAppState.CurTask) then Exit;
 if EditTaskName.Text = '' then
  if ShowWrongInfo('Необходимо дать краткое описание') then
   begin
    FlashControl(EditTaskName);
    Exit;
   end;

 ItemHist:=TItemHistory.Create(FHistory);
 if FAppState.CurTask.Empty then
  begin
   FTasks.Insert(0, FAppState.CurTask);
   FAppState.CurTask.Update;

   ItemHist.Action:=haAdd;
  end
 else ItemHist.Action:=haChange;

 if not IndexInList(ComboBoxSelTaskCustomer.ItemIndex, FCustomers.Count) then
  begin
   FAppState.CurTask.Customer:=-1;
   FAppState.CurTask.CustomerStr:='';
  end
 else
  begin
   FAppState.CurTask.Customer:=FCustomers[ComboBoxSelTaskCustomer.ItemIndex].ID;
   FAppState.CurTask.CustomerStr:=FCustomers[ComboBoxSelTaskCustomer.ItemIndex].ShortFIO;
  end;
 FAppState.CurTask.Name:=EditTaskName.Text;
 FAppState.CurTask.JiraLink:=EditTaskJira.Text;
 FAppState.CurTask.Date:=DateTimePickerSelTaskDate.DateTime;
 FAppState.CurTask.Data:=MemoSelTaskData.Text;
 FAppState.CurTask.State:=FAppState.CurTaskState;
 FAppState.CurTask.Priority:=FAppState.CurTaskPriority;

 ItemHist.TableName:=TTableTasks.TableName;
 ItemHist.RecordID:=FAppState.CurTask.ID;
 ItemHist.Date:=Now;
 ItemHist.Desc:=
  FAppState.CurTask.Name+#13#10+
  FAppState.CurTask.CustomerStr+#13#10+
  FAppState.CurTask.Data;
 FHistory.Insert(0, ItemHist);
 ItemHist.Update;

 //Auto
 if PanelTaskAuto.Visible then
  begin
   PanelTaskAuto.Hide;
   if CheckBoxTaskAutoCProject.Checked then
    begin
     if FAppState.CurTask.CreateWorkDir(WorkPath, WorkDir)
     then ShowInfoOk('Каталог задачи создан', True)
     else ShowWrongInfo('Не смог создать каталог задачи', True);
    end;
   if CheckBoxTaskAutoHG.Checked then
    begin
     if WinExec(WorkPath+HG_ActualBat, SW_NORMAL) > ERROR_GEN_FAILURE
     then ShowInfoOk('Запущена выгрузка git default', True)
     else ShowWrongInfo('Задача выгрузки не запущена', True);
    end;
  end;
 //

 FAppState.CurTask.Update;
 UpdateTasksTable(FAppState.CurTask.ID);
 ButtonFlatTaskSave.TimedText('Сохранено', 5000);
 ShowInfoOk('Информация о задаче сохранена');
end;

procedure TFormMain.ButtonFlatCustomersAddClick(Sender: TObject);
begin
 if not CanIDoSmt then Exit;
 AddCustomer;
end;

procedure TFormMain.ButtonFlatCustomersDelClick(Sender: TObject);
begin
 DeleteCustomer;
end;

procedure TFormMain.ButtonFlatCustomersEditClick(Sender: TObject);
begin
 EditCustomer;
end;

procedure TFormMain.ButtonFlatCustomerSaveClick(Sender: TObject);
var ItemHist:TItemHistory;
begin
 if not Assigned(FAppState.CurCustomer) then Exit;
 if EditCustomerF.Text = '' then if ShowWrongInfo('Необходимо указать Фамилию заказчика') then Exit;
 if EditCustomerI.Text = '' then if ShowWrongInfo('Необходимо указать Имя заказчика') then Exit;

 ItemHist:=TItemHistory.Create(FHistory);
 if FAppState.CurCustomer.Empty then
  begin
   FCustomers.Insert(0, FAppState.CurCustomer);
   FAppState.CurCustomer.Update;

   ItemHist.Action:=haAdd;
  end
 else ItemHist.Action:=haChange;

 FAppState.CurCustomer.F:=EditCustomerF.Text;
 FAppState.CurCustomer.I:=EditCustomerI.Text;
 FAppState.CurCustomer.O:=EditCustomerO.Text;
 FAppState.CurCustomer.Phone:=EditCustomerPhone.Text;
 FAppState.CurCustomer.Telegram:=EditCustomerTelegram.Text;

 ItemHist.TableName:=TTableCustomers.TableName;
 ItemHist.RecordID:=FAppState.CurCustomer.ID;
 ItemHist.Date:=Now;
 ItemHist.Desc:=FAppState.CurCustomer.FullFIO;
 FHistory.Insert(0, ItemHist);
 ItemHist.Update;

 FAppState.CurCustomer.Update;
 UpdateCustomersTable(FAppState.CurCustomer.ID);
 ButtonFlatCustomerSave.TimedText('Сохранено', 5000);
 ShowInfoOk('Информация о заказчике сохранена');
end;

procedure TFormMain.ButtonFlatCustomersClick(Sender: TObject);
begin
 OpenPage(PanelTableCustomers);
end;

procedure TFormMain.BrowserCreatedMsgGKeep(var aMessage: TMessage);
begin
 ChromiumWindowGKeep.UpdateSize;
 ChromiumGKeep.LoadURL(urlGKeep);
end;

procedure TFormMain.BrowserCreatedMsgJira(var aMessage: TMessage);
begin
 ChromiumWindowJira.UpdateSize;
 ChromiumJira.LoadURL(urlJira);
end;

procedure TFormMain.ButtonFlat2Click(Sender: TObject);
begin
 CheckBoxTaskAutoHG.Checked:=not CheckBoxTaskAutoHG.Checked;
end;

procedure TFormMain.ButtonFlat6Click(Sender: TObject);
begin
 ChromiumJira.Reload;
end;

procedure TFormMain.ButtonFlat9Click(Sender: TObject);
begin
 if not IndexInList(TableExCustomers.ItemIndex, FCustomers.Count) then Exit;
 Clipboard.AsText:=FCustomers[TableExCustomers.ItemIndex].FullFIO;
 OpenURL(urlBorda);
end;

procedure TFormMain.ButtonFlatAddOtherClick(Sender: TObject);
var Pt:TPoint;
begin
 Pt:=ButtonFlatNewTask.ClientToScreen(Point(0, 0));
 Pt.Offset(0, ButtonFlatNewTask.Height+2);
 PopupMenuAddOther.Popup(Pt.X, Pt.Y);
end;

procedure TFormMain.ButtonFlatCustomerCloseClick(Sender: TObject);
begin
 FAppState.CloseModal;
 FAppState.FCurCustomerTasks.UnAssignTables;
 FAppState.FCurCustomerTasks.Clear;
 PanelCustomer.Hide;
end;

procedure TFormMain.ButtonFlatFeedClick(Sender: TObject);
begin
 OpenPage(PanelFeed);
end;

procedure TFormMain.ButtonFlatFeedUpdateClick(Sender: TObject);
begin
 UpdateFeed;
end;

procedure TFormMain.ButtonFlatGoogleKeepClick(Sender: TObject);
begin
 OpenPage(PanelGoogleKeep);
end;

procedure TFormMain.ButtonFlatHideCustomerInfoClick(Sender: TObject);
begin
 PanelCustomerInfo.Hide;
end;

procedure TFormMain.ButtonFlatJiraClick(Sender: TObject);
begin
 OpenPage(PanelJira);
end;

procedure TFormMain.ButtonFlatCustomersLoadClick(Sender: TObject);
begin
 if not CanIDoSmt then Exit;
 FCustomers.Load;
end;

procedure TFormMain.ButtonFlatCustomerTelegramClick(Sender: TObject);
begin
 if not IndexInList(TableExCustomers.ItemIndex, FCustomers.Count) then Exit;
 if FCustomers[TableExCustomers.ItemIndex].Telegram.IsEmpty then Exit;
 FCustomers[TableExCustomers.ItemIndex].OpenTelegramChat;
end;

procedure TFormMain.ButtonFlatLoadTasksClick(Sender: TObject);
begin
 if not CanIDoSmt then Exit;
 FTasks.Load;
end;

procedure TFormMain.ButtonFlatShowCustomerInfoClick(Sender: TObject);
begin
 if not IndexInList(TableExCustomers.ItemIndex, FCustomers.Count) then
  begin
   if FCustomers.Count > 0 then TableExCustomers.ItemIndex:=0;
  end;
 if not IndexInList(TableExCustomers.ItemIndex, FCustomers.Count) then
  begin
   ShowWrongInfo('Выберите контакт');
   Exit;
  end;
 SetCustomerInfo(FCustomers[TableExCustomers.ItemIndex]);
 PanelCustomerInfo.Show;
end;

procedure TFormMain.ButtonFlatTasksAddClick(Sender: TObject);
begin
 if not CanIDoSmt then Exit;
 AddTask;
end;

procedure TFormMain.ButtonFlatTaskAutoCProjectClick(Sender: TObject);
begin
 CheckBoxTaskAutoCProject.Checked:=not CheckBoxTaskAutoCProject.Checked;
end;

procedure TFormMain.ButtonFlatTaskCloseClick(Sender: TObject);
begin
 FAppState.CloseModal;
 PanelTask.Hide;
end;

procedure TFormMain.ButtonFlatTasksDeleteClick(Sender: TObject);
begin
 DeleteTask;
end;

procedure TFormMain.ButtonFlatTaskDraftClick(Sender: TObject);
begin
 SetTaskStateButtons(TTaskState((Sender as TButtonFlat).Tag));
end;

procedure TFormMain.ButtonFlatTasksClick(Sender: TObject);
begin
 OpenPage(PanelTableTasks);
end;

function TFormMain.CanIDoSmt:Boolean;
begin
 Result:=FAppState.FModals <= 0;
 if not Result then
  ShowWrongInfo('Сначала необходимо завершить работу с модальным окном');
end;

procedure TFormMain.ChromiumGKeepAfterCreated(Sender: TObject; const browser: ICefBrowser);
begin
 if ChromiumGKeep.IsSameBrowser(browser) then
  PostMessage(Handle, CEF_AFTERCREATED_GKEEP, 0, 0)
 else
  SendMessage(browser.Host.WindowHandle, WM_SETICON, 1, Application.Icon.Handle);
end;

procedure TFormMain.ChromiumJiraAfterCreated(Sender: TObject; const browser: ICefBrowser);
begin
 if ChromiumJira.IsSameBrowser(browser) then
  PostMessage(Handle, CEF_AFTERCREATED_JIRA, 0, 0)
 else
  SendMessage(browser.Host.WindowHandle, WM_SETICON, 1, Application.Icon.Handle);
end;

procedure TFormMain.ChromiumGKeepBeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
  targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; const popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var noJavascriptAccess, Result: Boolean);
begin
 Result:=(targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TFormMain.ChromiumGKeepJsdialog(Sender: TObject;
  const browser: ICefBrowser; const originUrl: ustring;
  dialogType: TCefJsDialogType; const messageText, defaultPromptText: ustring;
  const callback: ICefJsDialogCallback; out suppressMessage, Result: Boolean);
begin
 Result:=False;
 suppressMessage:=True;
 ShowMessage(messageText+#13#10+defaultPromptText);
end;

procedure TFormMain.CreateTables;
begin
 with TableExCustomers do
  begin
   AddColumn('', 32);
   AddColumn('Полное имя', 400);
   AddColumn('', 10);
  end;

 with TableExTasks do
  begin
   AddColumn('', 32);
   Columns[AddColumn('Задача', 300)].Format:=[tfWordBreak, tfVerticalCenter, tfLeft, tfWordEllipsis];
   Columns[AddColumn('Информация', 450)].Format:=[tfWordBreak, tfVerticalCenter, tfLeft, tfWordEllipsis];
   Columns[AddColumn('Дата', 120)].Format:=[tfWordBreak, tfVerticalCenter, tfCenter, tfLeft, tfWordEllipsis];
   AddColumn('Статус', 100);
   AddColumn('', 32);
  end;

 with TableExCustomerTasks do
  begin
   AddColumn('Задача', 100);
   AddColumn('Информация', 100);
   AddColumn('Дата', 120);
   AddColumn('Добавлена', 100);
   AddColumn('', 10);
  end;

 TableExHotTasks.AddColumn('', 100);

 TableExFeed.AddColumn('', 100);

 TableExNotify.AddColumn('', 100);
end;

procedure TFormMain.DateTimePickerSelTaskTimeChange(Sender: TObject);
begin
 DateTimePickerSelTaskDate.Time:=DateTimePickerSelTaskTime.Time;
end;

function TFormMain.DeleteCustomer:Integer;
begin
 if not IndexInList(TableExCustomers.ItemIndex, FCustomers.Count) then Exit;
 FHistory.Add(haDelete, TTableCustomers.TableName, FCustomers[TableExCustomers.ItemIndex].ID, FCustomers[TableExCustomers.ItemIndex].FullFIO);
 FCustomers.Delete(TableExCustomers.ItemIndex);
 UpdateCustomersTable;
end;

function TFormMain.DeleteTask: Integer;
begin
 if not IndexInList(TableExTasks.ItemIndex, FTasks.Count) then Exit;
 FHistory.Add(haDelete, TTableTasks.TableName, FTasks[TableExTasks.ItemIndex].ID, FTasks[TableExTasks.ItemIndex].Name);
 FTasks.Delete(TableExTasks.ItemIndex);
 UpdateTasksTable;
end;

function TFormMain.EditCustomer: Integer;
begin
 if not IndexInList(TableExCustomers.ItemIndex, FCustomers.Count) then Exit;
 FAppState.CurCustomer:=FCustomers[TableExCustomers.ItemIndex];
 FAppState.FCurCustomerTasks.Load(FAppState.CurCustomer.ID);
 FAppState.FCurCustomerTasks.AddTable(TableExCustomerTasks);
 FAppState.FCurCustomerTasks.UpdateTable;
 EditCustomerF.Text:=FAppState.CurCustomer.F;
 EditCustomerI.Text:=FAppState.CurCustomer.I;
 EditCustomerO.Text:=FAppState.CurCustomer.O;
 EditCustomerPhone.Text:=FAppState.CurCustomer.Phone;
 EditCustomerTelegram.Text:=FAppState.CurCustomer.Telegram;
 EditClientDateCreate.Text:=FormatDateTime('DD.MM.YYYY HH:MM', FAppState.CurCustomer.DateCreate);
 PanelCurCustomerTasks.Show;

 LabelSelCustomer.Caption:=FAppState.CurCustomer.FullFIO;

 FAppState.OpenModal;
 ShowPanel(PanelCustomer);
end;

function TFormMain.EditTask(Item: Integer): Integer;
var i:Integer;
begin
 Result:=-1;
 for i:= 0 to FTasks.Count-1 do
  if FTasks[i].ID = Item then Exit(EditTask(FTasks[i]));
end;

function TFormMain.EditTask(Item: TItemTask): Integer;
var SelIt:Integer;
begin
 if not Assigned(Item) then Exit;
 FAppState.CurTask:=Item;
 SelIt:=FAppState.CurTask.Customer;
 ComboBoxSelTaskCustomer.Text:='';
 FCustomers.FillList(ComboBoxSelTaskCustomer.Items, SelIt);
 ComboBoxSelTaskCustomer.ItemIndex:=SelIt;
 DateTimePickerSelTaskDate.DateTime:=FAppState.CurTask.Date;
 DateTimePickerSelTaskTime.Time:=FAppState.CurTask.Date;
 MemoSelTaskData.Text:=FAppState.CurTask.Data;
 EditTaskName.Text:=FAppState.CurTask.Name;
 EditTaskJira.Text:=FAppState.CurTask.JiraLink;
 SetTaskStateButtons(FAppState.CurTask.State);
 SetTaskPriorityButtons(FAppState.CurTask.Priority);
 LabelSelectTask.Caption:=FAppState.CurTask.Name;
 PanelTaskAuto.Visible:=False;

 FAppState.OpenModal;
 ShowPanel(PanelTask);
end;

procedure TFormMain.UpdateFeed;
begin
 FHotTasks.Load;
 FHotTasks.UpdateTable;

 FHistory.Load;
 FHistory.UpdateTable;
end;

procedure TFormMain.UpdateTasksTable(ItemID: Integer);
begin
 UpdateFeed;
end;

function TFormMain.EditTask: Integer;
begin
 if not IndexInList(TableExTasks.ItemIndex, FTasks.Count) then Exit;
 EditTask(FTasks[TableExTasks.ItemIndex]);
end;

procedure TFormMain.EditTaskJiraChange(Sender: TObject);
begin
 if EditTaskJira.Text <> '' then
  begin
   CheckBoxTaskAutoCProject.Checked:=True;
   CheckBoxTaskAutoHG.Checked:=True;
  end;
end;

procedure TFormMain.EditSearchEnter(Sender: TObject);
begin
 if EditSearch.Text = 'искать задачу, заказчика, прочее...' then EditSearch.Text:='';
end;

procedure TFormMain.EditSearchExit(Sender: TObject);
begin
 if EditSearch.Text = '' then EditSearch.Text:='искать задачу, заказчика, прочее...';
end;

procedure TFormMain.InitTables;
begin
 //Таблица заказчиков
 FCustomers:=TTableCustomers.Create(FCore);
 FCustomers.AddTable(TableExCustomers);
 FCustomers.Load;
 FCustomers.UpdateTable;
 //Таблица задач
 FTasks:=TTableTasks.Create(FCore);
 FTasks.AddTable(TableExTasks);
 FTasks.Load;
 FTasks.UpdateTable;
 //Таблица ближайших задач
 FHotTasks:=TTableTasks.Create(FCore);
 FHotTasks.AddTable(TableExHotTasks);
 FHotTasks.Filter:=[tsDraft, tsInTheWork];
 FHotTasks.UseFilter:=True;
 FHotTasks.LoadTaskBy:=TTableTasks.fnDate;
 FHotTasks.LoadTaskByDESC:=False;
 //История действий (лента)
 FHistory:=TTableHistory.Create(FCore);
 FHistory.AddTable(TableExFeed);
 FHistory.Load;
 FHistory.UpdateTable;
 //Таблицы для редактирования
 FAppState.FCurCustomerTasks:=TTableTasks.Create(FCore);
 FAppState.FCurCustomerTasks.AddTable(TableExCustomerTasks);
end;

procedure TFormMain.Label1Click(Sender: TObject);
begin
 if Mode = cmNormal then Mode:=cmMini else Mode:=cmNormal;
 
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose:=False;
 Quit;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var TM:Cardinal;
begin
 FDefWidth:=ClientWidth;
 Mode:=cmNormal;
 FCWJiraClosed:=True;
 FCWGKeepClosed:=True;
 TM:=GetTickCount;
 //Система уведомлений
 FNotify:=TNotifyPanel.Create(Self);
 FNotify.Bottom:=10;
 FNotify.Right:=10;
 FNotifyStorage:=TNotifyStorage.Create(TableExNotify);
 //FNotifyStorage.Add(TNotifyItem.Create('Нет', nkInfo));
 //Инициализация БД
 FCore:=TDatabaseCore.Create(ExtractFilePath(Application.ExeName)+'data.db');
 if not FCore.Work then Application.Terminate;
 //Создание таблиц для работы
 InitTables;
 //Визуальное наполнение и настройка таблиц
 CreateTables;
 SetMenuIconColor($00D7D2CB);
 TimerTimeTimer(nil);
 //
 UpdateFeed;
 ShowPanel(PanelFeed);
 TM:=GetTickCount - TM;
 //ShowMessage(FloatToStr(TM / 1000));
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
 if Assigned(FNotify) then FNotify.UpdateGlobalSize;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
 if not ChromiumJira.Initialized then
  while not (ChromiumJira.CreateBrowser(ChromiumWindowJira, '')) do Application.ProcessMessages;
 if not ChromiumGKeep.Initialized then
  while not (ChromiumGKeep.CreateBrowser(ChromiumWindowGKeep, '')) do Application.ProcessMessages;
end;

procedure TFormMain.TableExCostomersGetData(FCol, FRow: Integer; var Value: string);
begin
 Value:='';
 if not IndexInList(FRow, FCustomers.Count) then Exit;
 case FCol of
  0:if FCustomers[FRow].Modifed then Value:='*' else Value:='';
  1:Value:=FCustomers[FRow].FullFIO;
 else Value:='';
 end;
end;

procedure TFormMain.TableExCustomersItemClick(Sender: TObject;
  MouseButton: TMouseButton; const Index: Integer);
begin
 if not IndexInList(Index, FCustomers.Count) then Exit;
 SetCustomerInfo(FCustomers[Index]);
end;

procedure TFormMain.TableExCustomerTasksGetData(FCol, FRow: Integer; var Value: string);
begin
 Value:='';
 if not Assigned(FAppState.FCurCustomerTasks) then
  begin
   TableExCustomerTasks.ItemCount:=0;
   Exit;
  end;
 if not IndexInList(FRow, FAppState.FCurCustomerTasks.Count) then Exit;
 case FCol of
  0:Value:=FAppState.FCurCustomerTasks[FRow].Name;
  1:Value:=FAppState.FCurCustomerTasks[FRow].Data;
  2:Value:=FormatDateTime('DD.MM.YYYY HH:MM', FAppState.FCurCustomerTasks[FRow].Date);
  3:Value:=FormatDateTime('DD.MM.YYYY HH:MM', FAppState.FCurCustomerTasks[FRow].DateCreate);
 end;
end;

function HistoryActionToString(Value:THistoryAction):String;
begin
 case Value of
  haAdd: Exit('Добавление');
  haChange: Exit('Изменение');
  haDelete: Exit('Удаление');
 end;
end;

function TableNameToString(Value:string):string;
begin
 if Value = TTableTasks.TableName then Exit('задача');
 //if Value = TTableAddresses.TableName then Exit('адрес');
 if Value = TTableCustomers.TableName then Exit('заказчик');
end;

procedure TFormMain.TableExFeedDrawCellData(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var TxtRect:TRect;
    AW, TW, NH:Integer;
    Str:string;
begin
 if not IndexInList(ARow, FHistory.Count) then Exit;
 if FHistory[ARow].TableName = TTableTasks.TableName then
  begin
   NH:=Max(50, Min(TableExFeed.Canvas.TextHeight(FHistory[ARow].Desc)*(Length(FHistory[ARow].Desc.Split([#13,#10]))+1), 95));
   if TableExFeed.RowHeights[ARow] <> NH then
    begin
     TableExFeed.RowHeights[ARow]:=NH;
     Repaint;
     Exit;
    end;
  end
 else
  begin
   if TableExFeed.RowHeights[ARow] <> 50 then
    begin
     TableExFeed.RowHeights[ARow]:=50;
     Repaint;
     Exit;
    end;
  end;
 with TableExFeed.Canvas do
  begin
   Lock;
   try
    Brush.Color:=clWhite;
    Brush.Style:=bsSolid;
    FillRect(Rect);
    TxtRect:=Rect;
    TxtRect.Inflate(-5, -5);
    if TableExFeed.CordHot.Y = ARow then Brush.Color:=$00FEF8F2;
    Brush.Style:=bsSolid;
    Pen.Style:=psClear;
    RoundRect(TxtRect, 10, 10);
    TxtRect.Inflate(-10, -10);

    Brush.Style:=bsClear;
    //AH:=TxtRect.Height;
    //TxtRect.Height:=30;                               //+' '+TableNameToString(FHistory[ARow].TableName)+' '+FHistory[ARow].Desc;
    Font.Size:=10;
    case FHistory[ARow].Action of
     haAdd: Font.Color:=$00A16C29; //Синий
     haChange: Font.Color:=$00A16C29; //Синий
     haDelete: Font.Color:=$002530AD; //Синий
    end;
    Font.Style:=[fsBold];
    Str:=HistoryActionToString(FHistory[ARow].Action);
    AW:=TextWidth(Str);
    TextOut(TxtRect.Left, TxtRect.Top, Str);

    Font.Color:=$006D6A6C; //Серый
    Font.Style:=[fsBold];
    Font.Size:=15;
    Str:='›';
    Inc(AW, 3);
    TextOut(TxtRect.Left+AW, TxtRect.Top-5, Str);
    Inc(AW, TextWidth(Str));

    Font.Color:=$00318D5E; //Зелёный
    Font.Style:=[fsBold];
    Font.Size:=10;
    Str:=TableNameToString(FHistory[ARow].TableName)+':';
    Inc(AW, 3);
    TextOut(TxtRect.Left+AW, TxtRect.Top, Str);
    Inc(AW, TextWidth(Str));

    Font.Color:=$006D6A6C; //Серый
    Font.Style:=[];
    Font.Size:=10;
    Str:=FormatDateTime('DD.MM.YYYY HH:MM', FHistory[ARow].Date);
    TW:=TextWidth(Str);
    TextOut(TxtRect.Right-TW-5, TxtRect.Top, Str);

    if FHistory[ARow].TableName <> TTableTasks.TableName then
     begin
      Font.Color:=$006D6A6C; //Серый
      Font.Style:=[];
      Font.Size:=10;
      Str:=FHistory[ARow].Desc;
      Inc(AW, 3);
      TextOut(TxtRect.Left+AW, TxtRect.Top, Str);
     end
    else
     begin
      TxtRect.Offset(AW+3, 0);
      TxtRect.Width:=TxtRect.Width-(AW+3);
      Font.Color:=$006D6A6C; //Серый
      Font.Style:=[];
      Font.Size:=10;
      Str:=FHistory[ARow].Desc;
      TextRect(TxtRect, Str, [tfWordBreak]);
     end;

   finally
    Unlock;
   end;
  end;
end;

procedure TFormMain.TableExHotTasksDrawCellData(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var TxtRect:TRect;
    AH:Integer;
    Str:string;
begin
 if not IndexInList(ARow, FHotTasks.Count) then
  begin
   Str:='Нет задач';
   TableExHotTasks.Canvas.TextRect(Rect, Str, [tfCenter, tfVerticalCenter, tfSingleLine]);
   Exit
  end;

 if ACol <> 0 then Exit;
 with TableExHotTasks.Canvas do
  begin
   Brush.Color:=clWhite;
   Brush.Style:=bsSolid;
   FillRect(Rect);
   Font.Color:=$00A46326;
   Font.Style:=[fsUnderline, fsBold];
   TxtRect:=Rect;
   TxtRect.Inflate(-5, -5);
   if TableExHotTasks.CordHot.Y = ARow then Brush.Color:=$00FAE6CE
   else Brush.Color:=$00F7F6F2;
   Brush.Style:=bsSolid;
   Pen.Style:=psClear;
   RoundRect(TxtRect, 10, 10);
   TxtRect.Inflate(-10, -10);

   Brush.Style:=bsClear;
   AH:=TxtRect.Height;
   TxtRect.Height:=30;
   Str:=FHotTasks[ARow].Name;
   TextRect(TxtRect, Str, []);

   TxtRect.Offset(0, 20);
   Font.Color:=$00241DA4;
   Font.Style:=[];
   Str:=FormatDateTime('DD.MM.YYYY HH:MM', FHotTasks[ARow].Date);
   TextRect(TxtRect, Str, []);

   Font.Color:=$00908F91;
   Font.Style:=[];
   Str:=FHotTasks[ARow].CustomerStr;
   TextRect(TxtRect, Str, [tfRight]);

   TxtRect.Offset(0, 20);
   TxtRect.Height:=AH - 40;
   Font.Color:=ColorLighter(clBlack, 20);
   Font.Style:=[];
   Str:=FHotTasks[ARow].Data;
   TextRect(TxtRect, Str, [tfWordBreak]);
  end;
end;

procedure TFormMain.TableExHotTasksItemClick(Sender: TObject; MouseButton: TMouseButton; const Index: Integer);
begin
 if not IndexInList(Index, FHotTasks.Count) then Exit;
 if MouseButton = mbLeft then
  begin
   EditTask(FHotTasks[Index].ID);
  end;
end;

procedure TFormMain.TableExNotifyAfterDrawText(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 if not IndexInList(ARow, FNotifyStorage.Count) then Exit;
 with TableExNotify.Canvas do
  begin
   case FNotifyStorage[ARow].Kind of
    nkWarning: Brush.Color:=$00A2DDFF;
    nkInfo: Brush.Color:=$00FFD0A1;
    nkOK: Brush.Color:=$00D2FFC1;
    nkError,
    nkFail: Brush.Color:=$00B0BCFF;
   end;
   Pen.Color:=Brush.Color;
   Rectangle(Rect);
  end;
end;

procedure TFormMain.TableExNotifyGetData(FCol, FRow: Integer; var Value: string);
begin
 Value:='Нет уведомлений';
 if not IndexInList(FRow, FNotifyStorage.Count) then Exit;
 case FCol of
  0:Value:=FNotifyStorage[FRow].Text;
 else Value:='';
 end;
end;

procedure TFormMain.TableExTasksDrawCellData(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 if not IndexInList(ARow, FTasks.Count) then Exit;
 if ACol <> 4 then Exit;
 with TableExTasks.Canvas do
  begin
   //Brush.Color:=clWhite;
   //Pen.Color:=Brush.Color;
   Brush.Style:=bsClear;

   //RoundRect(System.Classes.Rect(Rect.Left + 3, Rect.Top + 3, Rect.Right - 3, Rect.Top + 5 + 24 + 3), 10, 10);
   ImageListSmall.Draw(TableExTasks.Canvas, Rect.Left + 5, Rect.Top + 5, 8+Ord(FTasks[ARow].State), True);
   TextOut(Rect.Left + 5 + 24 + 5, Rect.Top + 5 + 3, FTasks[ARow].State.ToString);

   //RoundRect(System.Classes.Rect(Rect.Left + 3, Rect.Top + 5 + 24 + 3 + 3, Rect.Right - 3, Rect.Top + 5 + 24 + 5 + 24 + 3), 10, 10);
   ImageListSmall.Draw(TableExTasks.Canvas, Rect.Left + 5, Rect.Top + 5 + 24 + 5, 16+Ord(FTasks[ARow].Priority), True);
   TextOut(Rect.Left + 5 + 24 + 5, Rect.Top + 5 + 24 + 5 + 5, FTasks[ARow].Priority.ToString);
  end;
end;

procedure TFormMain.TableExTasksGetData(FCol, FRow: Integer; var Value: string);
begin
 Value:='';
 if not IndexInList(FRow, FTasks.Count) then Exit;
 case FCol of
  0:if FTasks[FRow].Modifed then Value:='*' else Value:='';
  1:Value:=FTasks[FRow].Name;
  2:Value:=FTasks[FRow].Data;
  3:Value:=FormatDateTime('DD.MM.YYYY'#13#10'HH:MM', FTasks[FRow].Date);
 else Value:='';
 end;
end;

procedure TFormMain.TimerTimeTimer(Sender: TObject);
begin
 LabelTime.Caption:=FormatDateTime('HH:MM', Now);
 LabelDate.Caption:=FormatDateTime('DD.MM.YYYY'#13#10'DDD', Now);
end;

procedure TFormMain.UpdateCustomersTable;
var SelIt:Integer;
begin
 if PanelCustomerInfo.Visible then
  if not IndexInList(TableExCustomers.ItemIndex, FCustomers.Count) then
   begin
    PanelCustomerInfo.Hide;
   end
  else SetCustomerInfo(FCustomers[TableExCustomers.ItemIndex]);

 //Если открыта панель задач, то подставляем туда нашу изменённую запись
 if PanelTask.Visible then
  begin
   SelIt:=ItemID;
   ComboBoxSelTaskCustomer.Text:='';
   FCustomers.FillList(ComboBoxSelTaskCustomer.Items, SelIt);
   ComboBoxSelTaskCustomer.ItemIndex:=SelIt;
  end;
end;

{ TAppState }

procedure TAppState.CloseModal;
begin
 Dec(FModals);
 FModals:=Max(0, FModals);
end;

procedure TAppState.OpenModal;
begin
 Inc(FModals);
end;

{ TNotifyItem }

class function TNotifyItem.Create(AText: string; AKind: TNotifyKind): TNotifyItem;
begin
 Result.Text:=AText;
 Result.Kind:=AKind;
end;

end.
