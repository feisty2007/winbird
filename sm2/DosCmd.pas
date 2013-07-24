unit DosCmd;

interface
type
    DosCmd=interface(TInterfacedObject,IExeInterface)
    public
      function GetDescription:string;
      function GetParam:string;
      procedure Execute(folder:string);
    end;

implementation

end.
 