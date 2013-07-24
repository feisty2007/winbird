unit TreeNodeUtil;

interface
uses
  Windows, Forms, CommCtrl, ComCtrls;
function tvU_GetNodeChecked(node: TTreeNode): Boolean;
procedure tvU_SetNodeCheck(node: TTreeNode; checked: Boolean);
procedure tvU_SetNodesCheck(node: TTreeNode; checked: Boolean);
implementation

function tvU_GetNodeChecked(node: TTreeNode): Boolean;
var
  item: TV_ITEM;
begin
  item.mask := TVIF_HANDLE or TVIF_STATE;
  item.hItem := node.itemId;

  item.stateMask := TVIS_STATEIMAGEMASK;

  TreeView_GetItem(node.TreeView.Handle, item);

  result := (item.State and IndexToStateImageMask(2)) > 0
end;

procedure tvU_SetNodeCheck(node: TTreeNode; checked: Boolean);
var
  item: TV_ITEM;
begin
  item.mask := TVIF_HANDLE or TVIF_STATE;
  item.hItem := node.itemId;

  item.stateMask := TVIS_STATEIMAGEMASK;
  if checked then
    item.state := IndexToStateImageMask(2)
  else
    item.state := IndexToStateImageMask(1);

  TreeView_SetItem(node.TreeView.Handle, item);

      //result:=(item.State shl 12 -1) >0 ;
end;

procedure tvU_SetNodesCheck(node: TTreeNode; checked: Boolean);
var
  count: Integer;
  i: integer;
begin
  count := node.Count;

  tvU_SetNodeCheck(node, checked);
  if count > 0 then
  begin
    for i := 0 to count - 1 do
    begin
      tvU_SetNodeCheck(node.Item[i], checked);
    end;
  end;
end;
end.
