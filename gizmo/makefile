BCC.DIR=C:\Borland\BCC55
INCLUDE=${BCC.DIR}\include
LIB=${BCC.DIR}\lib
PSDK_LIB = ${LIB}\PSDK

APP = gizmo

LINKFLAG = -c -x -aa -Gn
OBJ_FILES = gizmo.obj c0w32.obj
EXE_FILE = ${APP}.EXE
LIB_FILES = import32.lib cw32.lib winmm.lib advapi32.lib
MAP_FILES =
DEF_FILES =
RES_FILES = ${APP}.res

gizmo.exe: gizmo.obj gizmo.res
	${BCC.DIR}\bin\ilink32 ${LINKFLAG} ${OBJ_FILES},${EXE_FILE},${MAP_FILES},${LIB_FILES},${DEF_FILES},${RES_FILES}
	
gizmo.obj: gizmo.c
	${BCC.DIR}\bin\bcc32 -c -tW ${APP}.c

gizmo.res: gizmo.rc
	${BCC.DIR}\bin\brc32 ${APP}.rc
	
clean:
	del *.obj