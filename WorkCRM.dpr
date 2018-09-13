program WorkCRM;

uses
  Vcl.Forms, SysUtils,
  Work.Main in 'Work.Main.pas' {FormMain},
  SQLite3 in '..\..\SQLite\SQLite3.pas',
  SQLiteTable3 in '..\..\SQLite\SQLiteTable3.pas',
  SQLLang in '..\..\SQLite\SQLLang.pas',
  Work.DB in 'Work.DB.pas',
  Work.Table.Customers in 'Work.Table.Customers.pas',
  Work.Table.Tasks in 'Work.Table.Tasks.pas',
  HGM.Common.Notify in '..\..\Components\HGM.Common.Notify.pas',
  Work.Table.History in 'Work.Table.History.pas',
  uCEFApplication;

{$R *.res}

begin
  GlobalCEFApp:= TCefApplication.Create;
  GlobalCEFApp.FlashEnabled               :=False;
  GlobalCEFApp.WindowlessRenderingEnabled :=True;
  GlobalCEFApp.EnableHighDPISupport       :=True;
  GlobalCEFApp.FrameworkDirPath     :='cef';
  GlobalCEFApp.ResourcesDirPath     :='cef';
  GlobalCEFApp.LocalesDirPath       :='cef\locales';
  GlobalCEFApp.EnableGPU            :=True;
  GlobalCEFApp.Cache                :='cef\cache';
  GlobalCEFApp.Cookies              :='cef\cookies';
  GlobalCEFApp.UserDataPath         :='cef\User Data';
  GlobalCEFApp.SingleProcess        :=True;
  GlobalCEFApp.StartMainProcess;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Work CRM';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

  //GlobalCEFApp.Free;
  GlobalCEFApp:=nil;
end.
