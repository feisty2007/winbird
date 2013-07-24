BCC.DIR=C:\Borland\BCC55

minisvr.scr: minisvr.c minisvr.res
	${BCC.DIR}\bin\bcc32 -tW minisvr.c gscrnsave.lib
	copy minisvr.exe minisvr.scr
	
minisvr.res: minisvr.rc
	${BCC.DIR}\bin\brc32 -r -32 -i${BCC.DIR}\include;${BCC.DIR}\bin\gscrnsave minisvr.rc
clean:
	erase *.scr
	del *.obj
	