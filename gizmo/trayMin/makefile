BCC.DIR=C:\Borland\BCC55
INCLUDE=${BCC.DIR}\include
LIB=${BCC.DIR}\lib
PSDK_LIB = ${LIB}\PSDK

APP = TrayMin

LINKFLAG = -c -x -aa -Gn
OBJ_FILES = TrayMin.obj c0w32.obj
EXE_FILE = ${APP}.EXE
LIB_FILES = import32.lib cw32.lib winmm.lib advapi32.lib psapi.lib
MAP_FILES =
DEF_FILES =
RES_FILES = ${APP}.res

TrayMin.exe: TrayMin.obj TrayMin.res
	erase TrayMin.exe
	${BCC.DIR}\bin\ilink32 ${LINKFLAG} ${OBJ_FILES},${EXE_FILE},${MAP_FILES},${LIB_FILES},${DEF_FILES},${RES_FILES}
	
TrayMin.obj: TrayMin.c
	${BCC.DIR}\bin\bcc32 -c -tW ${APP}.c

TrayMin.res: TrayMin.rc
	${BCC.DIR}\bin\brcc32 ${APP}.rc
	
clean:
	erase TrayMin.obj
	erase TrayMin.res