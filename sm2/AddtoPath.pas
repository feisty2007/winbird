unit AddtoPath;

interface
type
  AddToPath=class(TInterfacedObject,IExeInterface)
  public
     function GetDescription:string;
      function GetParam:string;
      procedure Execute(folder:string);
  end;

implementation

{ AddToPath }

procedure AddToPath.Execute(folder: string);
begin
  
end;

function AddToPath.GetDescription: string;
begin

end;

function AddToPath.GetParam: string;
begin

end;

end.
 