BCC.DIR=C:\Borland\BCC55

gscrnsave.lib: gscrnsave.c
	erase gscrnsave.lib
	${BCC.DIR}\bin\bcc32 -tW -c gscrnsave.c 
	${BCC.DIR}\bin\tlib gscrnsave.lib +gscrnsave.obj
