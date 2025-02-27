unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,Unit2, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids,About, Vcl.ImgList,Data.Win.ADODB,
  Vcl.ToolWin, Vcl.DBCtrls,ComObj,ExcelXP, Data.DB, Bde.DBTables;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label2: TLabel;
    ImageList1: TImageList;
    Label3: TLabel;
    ComboBox3: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    TabSheet2: TTabSheet;
    DBGrid2: TDBGrid;
    Memo1: TMemo;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    TabSheet3: TTabSheet;
    DBGrid3: TDBGrid;
    SD: TSaveDialog;
    procedure N4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses unit3;

Function ExportToExcel(oDataSet:TDataSet; sFile : String): Boolean;
var
iCol,iRow : Integer;

oExcel : TExcelApplication;
oWorkbook : TExcelWorkbook;
oSheet : TExcelWorksheet;

begin
iCol := 0;
iRow := 0;
result := True;
oDataSet.First;
oExcel := TExcelApplication.Create(Application);
oWorkbook := TExcelWorkbook.Create(Application);
oSheet := TExcelWorksheet.Create(Application);

try
oExcel.Visible[0] := True;
oExcel.Connect;
except
result := False;
MessageDlg('Excel may not be installed', mtError, [mbOk], 0);
exit;
end;

oExcel.Visible[0] := False;
oExcel.Caption := 'Report';
oExcel.Workbooks.Add(Null,0);

oWorkbook.ConnectTo(oExcel.Workbooks[1]);
oSheet.ConnectTo(oWorkbook.Worksheets[1] as _Worksheet);

// iRow := 1;


for iCol:=1 to oDataSet.FieldCount do
begin

//oSheet.Cells.Item[iRow,iCol] := oDataSet.FieldDefs.Items[iCol].Name;
oSheet.Cells.Item[1,iCol] := oDataSet.Fields[iCol-1].DisplayLabel;
end;

iRow := 1;

oDataSet.Open;
while NOT oDataSet.Eof do begin
Inc(iRow);

for iCol:=1 to oDataSet.FieldCount do begin
oSheet.Cells.Item[iRow,iCol] := oDataSet.Fields[iCol-1].AsString;
end;

oDataSet.Next;
end;

//Change the wprksheet name.
oSheet.Name := 'Report';

//Change the font properties of all columns.
oSheet.Columns.Font.Color := clPurple;
oSheet.Columns.Font.FontStyle := fsBold;
oSheet.Columns.Font.Size := 10;
oSheet.Columns.AutoFit;


DeleteFile(sFile);

oSheet.Range['A1','A1'].EntireRow.Font.Color := clNavy;
oSheet.Range['A1','A1'].EntireRow.Font.Size := 10;
oSheet.Range['A1','A1'].EntireRow.Font.FontStyle := fsBold;
oSheet.Range['A1','A1'].EntireRow.Font.Name := 'Arabic Transparent';

oSheet.SaveAs(sFile);
oSheet.Disconnect;
oSheet.Free;

oWorkbook.Disconnect;
oWorkbook.Free;

oExcel.Quit;
oExcel.Disconnect;
oExcel.Free;
sleep (2000);
ShowMessage ('������� �������� '+sFile);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
PageControl1.TabIndex:=0;
with DataModule2 do
begin
ADOTable1.Active:=False;
ADOTable1.TableName:=ComboBox1.Items.Strings[Combobox1.ItemIndex];
ADOTable1.Active:=True;
end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
var
S:string;
begin
PageControl1.TabIndex:=1;
with DataModule2 do
begin
case Combobox2.ItemIndex of
0:
begin
memo1.Clear;
memo1.Lines.Text:='SELECT'+#13+
'ID_FROM_ZAKAZ,'+#13+
'SUM([Hasenova].[dbo].[SERVICE].PRICE) AS SUMSOFUSLUG'+#13+
'FROM [Hasenova].[dbo].[SZAKAZ] INNER JOIN [Hasenova].[dbo].[SERVICE]'+#13+
'ON [Hasenova].[dbo].[SZAKAZ].ID_ZAKAZ=[Hasenova].[dbo].[SERVICE].[ID_SERV]'+#13+
'GROUP BY ID_FROM_ZAKAZ';
ToolButton1.Click;
end;
1:
begin
memo1.Clear;
memo1.Lines.Text:='SELECT [Hasenova].[dbo].[ZAKAZ].[ID_ZAKAZ]'+#13+
'       ,[Hasenova].[dbo].TS_TYPE.TS_NAME'+#13+
'      ,[Hasenova].[dbo].[CUST].LASTNAME'+#13+
'      ,[Hasenova].[dbo].[CUST].NAME'+#13+
'      ,[Hasenova].[dbo].[CUST].SECNAME'+#13+
'      ,[Hasenova].[dbo].[ZAKAZ].[DATA]'+#13+
'      ,[Hasenova].[dbo].TS_MARK.TS_NAME'+#13+
'      ,[Hasenova].[dbo].[ZAKAZ].[TSINFO]'+#13+
'      ,[Hasenova].[dbo].[ZAKAZ].[EDATA]'+#13+
'  FROM [Hasenova].[dbo].[ZAKAZ],[Hasenova].[dbo].[CUST],[Hasenova].[dbo].TS_MARK,[Hasenova].[dbo].TS_TYPE'+#13+
'  where'+#13+
'  (DATEPART(d,[Hasenova].[dbo].[ZAKAZ].[DATA])=1)'+#13+
'  and'+#13+
'  ([Hasenova].[dbo].[ZAKAZ].[ID_CUST]=[Hasenova].[dbo].[CUST].IIN)'+#13+
'  and'+#13+
'  ([Hasenova].[dbo].TS_MARK.ID_TTS=[Hasenova].[dbo].[ZAKAZ].ID_TSMARK)'+#13+
'  and'+#13+
'  ([Hasenova].[dbo].TS_TYPE.ID_TTS=[Hasenova].[dbo].[ZAKAZ].[ID_TS])';
ToolButton1.Click;
end;
2:
begin
memo1.Clear;
memo1.Lines.Text:='SELECT  DISTINCT '+#13+
'       [Hasenova].[dbo].[TS_WORKER].[LASNAME]'+#13+
'      ,[Hasenova].[dbo].[TS_WORKER].[NAME]'+#13+
'      ,[Hasenova].[dbo].[TS_WORKER].[SECNAME]'+#13+
'      ,[Hasenova].[dbo].[TS_WORKER].STATUS'+#13+
'  FROM [Hasenova].[dbo].[ZAKAZ],[Hasenova].[dbo].[SZAKAZ],[Hasenova].[dbo].TS_WORKER'+#13+
'  where'+#13+
'  (DATEPART(YEAR,[Hasenova].[dbo].[ZAKAZ].[DATA])=DATEPART(YEAR,SYSDATETIME()))'+#13+
'  and ([Hasenova].[dbo].[ZAKAZ].[ID_ZAKAZ]=[Hasenova].[dbo].[SZAKAZ].[ID_FROM_ZAKAZ])'+#13+
'  and ([Hasenova].[dbo].[SZAKAZ].[ID_WORKER]=[Hasenova].[dbo].[TS_WORKER].[ID_WORKER])';
ToolButton1.Click;
end;
3:
begin
memo1.Clear;
memo1.Lines.Text:='SELECT SUM([PRICE]*[COUNT]) AS TOTAL_SUMM'+#13+
'FROM [Hasenova].[dbo].[SCLAD]';
ToolButton1.Click;
end;
4:
begin
repeat
    s := InputBox('STO_DBCLI', '����������, ������� �����', '��.�������');
  until s <> '' ;
memo1.Clear;
memo1.Lines.Text:='SELECT [IIN] '+#13+
'      ,[NAME]'+#13+
'      ,[SECNAME]'+#13+
'      ,[LASTNAME]'+#13+
'      ,[COUNTRY]'+#13+
'      ,[CITY]'+#13+
'      ,[STREET]'+#13+
'      ,[HOME]'+#13+
'      ,[PHONE]'+#13+
'  FROM [Hasenova].[dbo].[CUST]'+#13+
'  where STREET='+''''+s+'''';
ToolButton1.Click;
end;
end;

end;
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
var
par:Variant;
begin
PageControl1.TabIndex:=2;
with DataModule2 do
begin
case Combobox3.ItemIndex of
0:
begin
repeat
    par := InputBox('STO_DBCLI', '����������, ������� ����� �������������', '1');
  until par <> '' ;
ADODataSet1.Close;
ADODataSet1.CommandText := 'Worker_SUB';
ADODataSet1.Parameters.Refresh;
ADODataSet1.Parameters.ParamByName( '@SUBWORK' ).Value := par;
ADODataSet1.Open;
end;
1:
begin
ADODataSet1.Close;
ADODataSet1.CommandText := 'Get_SUMM_SCLAD1';
ADODataSet1.Parameters.Refresh;
ADODataSet1.Open;
end;
2:
begin
par:='';
repeat
    par := InputBox('STO_DBCLI', '����������, ������� �������� �������������', '�������');
until par <> '' ;
ADODataSet1.Close;
ADODataSet1.CommandType := cmdStoredProc;
ADODataSet1.CommandText := 'Insert_To_SUB';
ADODataSet1.Parameters.Refresh;
ADODataSet1.Parameters.ParamByName( '@SUB_NAME' ).Value := par;
ADODataSet1.Open;
end;
3:
begin
par:='';
repeat
    par := InputBox('STO_DBCLI', '����������, ������� ��� �������', '416385247912');
until par <> '' ;
ADODataSet1.Close;
ADODataSet1.CommandText := 'Cust_Inn';
ADODataSet1.Parameters.Refresh;
ADODataSet1.Parameters.ParamByName( '@CUSTIIN' ).Value := par;
ADODataSet1.Open;
end;

end;

end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
Form3.Close;
end;

procedure TForm1.N3Click(Sender: TObject);

begin
if SD.Execute then
begin
case PageControl1.TabIndex of
0:ExportToExcel(DBGrid1.DataSource.DataSet,SD.FileName);
1:ExportToExcel(DBGrid2.DataSource.DataSet,SD.FileName);
2:ExportToExcel(DBGrid3.DataSource.DataSet,SD.FileName);
end;

end;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
OKRightDlg.Show;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
if memo1.Lines.Text<>'' then
with DataModule2 do
begin
if ADOConnection1.Connected=True then
ADOQuery1.Active:=False;
ADOQuery1.SQL.Text:=memo1.Lines.Text;
ADOQuery1.Active:=True;
end;
end;

end.
