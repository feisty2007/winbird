unit vistaAero;


interface
uses
	Windows,Registry;
	
	type
		TVistaAzero=class
		public 
			procedure Open;
		end;
implementation

procedure TVistaAzero.Open;
const
	regKey='Software\Microsoft\Windows\DWM';
var
	reg:TRegistry;
begin

	reg:=TRegistry.Create;
	try
		if reg.OpenKey(regKey,true) then
		begin
			reg.WriteInteger('ColorizationOpaqueBlend',1);
			reg.WriteInteger('CompositionPolicy',2);
		end;
	finally
		reg.free;
	end;
end;

end.