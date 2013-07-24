BCC.DIR=C:\Borland\BCC55
INCLUDE=${BCC.DIR}\include
LIB=${BCC.DIR}\lib
PSDK_LIB = ${LIB}\PSDK

APP = usblock

LINKFLAG = -c -x -aa -Gn
OBJ_FILES = usblock.obj c0w32.obj
EXE_FILE = ${APP}.EXE
LIB_FILES = import32.lib cw32.lib winmm.lib advapi32.lib
MAP_FILES =
DEF_FILES =
RES_FILES = ${APP}.res

usblock.exe: usblock.obj usblock.res
	erase usblock.exe
	${BCC.DIR}\bin\ilink32 ${LINKFLAG} ${OBJ_FILES},${EXE_FILE},${MAP_FILES},${LIB_FILES},${DEF_FILES},${RES_FILES}
	
usblock.obj: usblock.c
	${BCC.DIR}\bin\bcc32 -c -tW ${APP}.c

usblock.res: usblock.rc
	${BCC.DIR}\bin\brcc32 ${APP}.rc
	
clean:
	erase usblock.obj
	erase usblock.res