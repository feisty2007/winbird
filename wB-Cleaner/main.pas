unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,CommCtrl;

type
  TForm2 = class(TForm)
    tv_foot: TTreeView;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
    procedure tv_footMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    tvFoot_NodeChecked:boolean;
    procedure PopulateFootNode(Node:TTreeNode);

  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Winrar, TreeNodeUtil, UrlHistory, OfficeClearn, ClearRecentDoc;

{$R *.dfm}

procedure TForm2.btn1Click(Sender: TObject);
var
  Node: TTreeNode;
  //Nodes:TTreeNodes;
begin
  Node := tv_foot.Items.GetFirstNode;
  while Node <> nil do
  begin
    PopulateFootNode(Node);
    Node := Node.GetNext;
  end;
end;

procedure TForm2.PopulateFootNode(Node: TTreeNode);
var
  tempNode: TTreeNode;
  nodeText: string;
  cleaner: IClear;
  ieCleaner: TIEClear;
  hisCleaner: TUrlHistory;

  office2007Cleaner: TOffice2007Cleaner;
  wps2005Cleaner: TWpsOffice2005Cleaner;

  winAppltet: TWindowsApplets;
  winZip: TWinzip;
begin
  //if Node=nil then exit;

  if node.HasChildren then
  begin
    tempNode := Node.getFirstChild;

    while tempNode <> nil do
    begin
      nodeText := tempNode.Text;
      //lst1.Items.Add(nodeText);

      if (nodeText = 'Winrar') and (tvU_GetNodeChecked(tempNode)) then
      begin
        cleaner := TWinrar.Create;
        cleaner.Clear;
      end;

      if (nodeText = 'Internet Access') and (tvU_GetNodeChecked(tempNode)) then
      begin
        hisCleaner := TUrlHistory.Create(self);
        hisCleaner.ClearHistory;
        hisCleaner.Free;
      end;

      if (nodeText = 'IE AddressBar') and (tvU_GetNodeChecked(tempNode)) then
      begin
        cleaner := TIEAddressBarCleaner.Create;
        cleaner.Clear;
      end;

      if (nodeText = 'RealPlayer 10') and (tvU_GetNodeChecked(tempNode)) then
      begin
        cleaner := TRealPlayerTenHistoryCleaner.Create;
        cleaner.Clear;
      end;

      if (nodeText = 'Recent Document') and (tvU_GetNodeChecked(tempNode)) then
      begin
        cleaner := TCurrentDocClearner.Create;
        cleaner.Clear;
      end;

      if (nodeText = 'Run') and (tvU_GetNodeChecked(tempNode)) then
      begin
        cleaner := TRunProgramClearner.Create;
        cleaner.Clear;
      end;

      if (nodeText = 'Windows Media Player') and (tvU_GetNodeChecked(tempNode)) then
      begin
        cleaner := TMediaPlayerClearner.Create;
        cleaner.Clear;
      end;

      if (nodeText = 'Cookies') and (tvU_GetNodeChecked(tempNode)) then
      begin
        iecleaner := TIEClear.Create;
        iecleaner.ClearCookies;
        ieCleaner.Free;
      end;

      if (nodeText = 'IntelliForms') and (tvU_GetNodeChecked(tempNode)) then
      begin
        iecleaner := TIEClear.Create;
        iecleaner.ClearIntelliForms;
        ieCleaner.Free;
      end;

      if (nodeText = 'Favorites') and (tvU_GetNodeChecked(tempNode)) then
      begin
        iecleaner := TIEClear.Create;
        iecleaner.Clear;
        ieCleaner.Free;
      end;

      if (nodeText = 'Word 2007') and (tvU_GetNodeChecked(tempNode)) then
      begin
        office2007Cleaner := TOffice2007Cleaner.Create;

        office2007Cleaner.ClearWord;
        office2007Cleaner.Free;
      end;

      if (nodeText = 'Excel 2007') and (tvU_GetNodeChecked(tempNode)) then
      begin
        office2007Cleaner := TOffice2007Cleaner.Create;

        office2007Cleaner.ClearExcel;
        office2007Cleaner.Free;
      end;

      if (nodeText = 'PowerPoint 2007') and (tvU_GetNodeChecked(tempNode)) then
      begin
        office2007Cleaner := TOffice2007Cleaner.Create;

        office2007Cleaner.ClearPowerPoint;
        office2007Cleaner.Free;
      end;

      if (nodeText = 'WPSOffice 2005') and (tvU_GetNodeChecked(tempNode)) then
      begin
        wps2005Cleaner := TWpsOffice2005Cleaner.Create;

        wps2005Cleaner.CleanHistory(0);
        wps2005Cleaner.Free;
      end;

      if (((nodeText = 'Paint') or (nodeText = 'Wordpad')) and (tvU_GetNodeChecked(tempNode))) then
      begin
        winAppltet := TWindowsApplets.Create;

        winAppltet.ClearByName(nodeText);

        winAppltet.Free;
      end;

      if (nodeText = 'Winzip') and (tvU_GetNodeChecked(tempNode)) then
      begin
        winZip := TWinzip.Create;

        winZip.Clear;
        winZip.Free;
      end;
      tempNode := Node.GetNextChild(tempNode);
    end;
  end;
end;

procedure TForm2.tv_footMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
  isChecked: Boolean;
begin
  Node := tv_foot.GetNodeAt(X, Y);

  if Node <> nil then
  begin
    isChecked := tvU_GetNodeChecked(node);

    isChecked := not isChecked;
    tvU_SetNodesCheck(node, isChecked);
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
   SetWindowLong(tv_foot.Handle,
    GWL_STYLE,
    GetWindowLong(tv_foot.Handle, GWL_STYLE) or TVS_CHECKBOXES);

  tv_foot.FullExpand;
  tvFoot_NodeChecked := false;
end;

end.
