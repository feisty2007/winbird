#include <windows.h>
#include <string.h>
#include <shellapi.h>
#include <mmsystem.h>
#include <objbase.h>
#include <shlobj.h>
#include <objidl.h>
#include "volume.h"
#include "boolvalue.h"
#include "resource.h"

#define ELEMENTS(array) (sizeof(array)/sizeof(array[0]))

#pragma comment(lib,"winmm.lib")
#pragma comment(lib,"advapi32.lib")
#pragma comment(lib,"ole32.lib")

#define OPENCD_CMD "set cdaudio door open wait"
#define CLOSECD_CMD "set cdaudio door closed wait"
#define VOLUME_INCREASE_SIZE 20
static HINSTANCE hInstThis;

void PrintUsage();

void lockstation(int argc,char* argv[]);
void ShutdownComputer(int argc,char* argv[]);
void LoginOut(int argc,char* argv[]);
void RebootComputer(int argc,char* argv[]);

void MonitorOff(int argc,char* argv[]);
void ActivateScrSav(int argc,char* argv[]);

void OpenCDRom(int argc,char* argv[]);
void CloseCDRom(int argc,char* argv[]);

void SoundMute(int argc,char* argv[]);
void VolumeUp(int argc,char* argv[]);
void VolumeDown(int argc,char* argv[]);
void VolumeMax(int argc,char* argv[]);
boolean CreateDesktopLink(LPSTR strPath,LPSTR szArgument,LPSTR strShotcutName);
BOOL CALLBACK DlgProc(HWND hdWnd,UINT msg,WPARAM wParam,LPARAM lParam);

struct {
	wchar_t* funname;
	void (*func)(int argc,char* argv[]);
	int fun_id;
	wchar_t* fun_desp;
	}functions[]={
			{L"lock",lockstation,IDC_LOCK,L"立即锁定工作站"},
			{L"monoff",MonitorOff,IDC_MONOFF,L"立刻关闭LCD显示器"},
			{L"screensav",ActivateScrSav,IDC_ACTIVESCR,L"一键启动屏幕保护"},
			{L"open",OpenCDRom,IDC_OPENCDROM,L"一键弹出光驱"},
			{L"close",CloseCDRom,IDC_CLOSECDROM,L"关闭光驱"},
			{L"mute",SoundMute,IDC_MUTE,L"系统静音"},
			{L"volumeup",VolumeUp,IDC_VOLUMEUP,L"系统音量提高20%"},
			{L"volumedown",VolumeDown,IDC_VOLUMEDOWN,L"系统音量降低20%"},
			{L"volumemax",VolumeMax,IDC_VOLUMEMAX,L"最大系统音量"},
			{L"loginout",LoginOut,IDC_LOGOUT,L"注销当前用户"},
			{L"shutdown",ShutdownComputer,IDC_SHUTDOWN,L"关闭计算机"},
			{L"reboot",RebootComputer,IDC_REBOOT,L"重新启动计算机"},
		};

INT WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, char *lpCmdLine, int cmdShow)
{
    int i;
    int j;

    int argc=0;
    LPWSTR *argv;
    hInstThis = hInstance;
    //MessageBox(0,"Error","Gizmo Usage:\n",MB_OK);
    argv=CommandLineToArgvW(GetCommandLineW(),&argc);
    //printf("argc=%d",argc);
     
    if(argc==1)
			PrintUsage(hInstance);
    else
    {
			for(i=1;i<argc;i++)
			{
				//MessageBoxW(0,argv[i],"Gizmo",MB_OK);
				for(j=0;j<ELEMENTS(functions);j++)
					if(wcscmp(functions[j].funname,argv[i])==0)
					{
						//MessageBox(0,argv[i],L"Gizmo",MB_OK);	
						(*functions[j].func)(0,NULL);
					}
			}
			LocalFree(argv);
			PostQuitMessage(0);					
    }
    


    return 0;
}

void PrintUsage(HINSTANCE hInst)
{
	DialogBox(hInst,(LPCTSTR)IDD_CREATEDESKTOPLINK_DIALOG,NULL,DlgProc);
}

void lockstation(int argc,char* argv[])
{
	LockWorkStation();
}

void MonitorOff(int argc,char* argv[])
{
	SendMessage(HWND_BROADCAST,WM_SYSCOMMAND,SC_MONITORPOWER,2);
}


void ActivateScrSav(int argc,char* argv[])
{
	SendMessage(HWND_BROADCAST,WM_SYSCOMMAND,SC_SCREENSAVE,0);
}

void OpenCDRom(int argc,char* argv[])
{	
	mciSendString(OPENCD_CMD,NULL,0,0);
}

void CloseCDRom(int argc,char* argv[])
{
	mciSendString(CLOSECD_CMD,NULL,0,0);
}

void SoundMute(int argc,char* argv[])
{
	boolean bMute=GetMute(0);
	SetMute(0,!bMute);
}

void VolumeUp(int argc,char* argv[])
{
	unsigned volume=100;
	if(!GetMute(0))
	{
		volume=GetVolume(0);
		SetVolume(0,volume+VOLUME_INCREASE_SIZE>100?100:volume+VOLUME_INCREASE_SIZE);	
	}
}
void VolumeDown(int argc,char* argv[])
{
	unsigned volume=0;
	if(!GetMute(0))
		{
			volume=GetVolume(0);
			SetVolume(0,volume-VOLUME_INCREASE_SIZE<=0?0:volume-VOLUME_INCREASE_SIZE);	
	}
}

void VolumeMax(int argc,char* argv[])
{
	if(!GetMute(0))
		SetVolume(0,100);
}

boolean EnableShutDown()
{
	HANDLE hToken;	
	TOKEN_PRIVILEGES tkp;
	
	if(OpenProcessToken(GetCurrentProcess,TOKEN_QUERY | TOKEN_ADJUST_PRIVILEGES,&hToken))
	{
		if(!LookupPrivilegeValue(NULL,SE_SHUTDOWN_NAME,&tkp.Privileges[0].Luid))
			return 0;
													
		tkp.PrivilegeCount = 1 ;
	  tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
	  
	  if(AdjustTokenPrivileges(hToken,FALSE,&tkp,0,NULL,0))
	  	return 1;
	  else
	  	return 0;
	 }	
	 else
	 	return 0;
}

void ShutdownComputer(int argc,char* argv[])
{
	if(EnableShutDown)
	{
	 		ExitWindows(EWX_SHUTDOWN | EWX_FORCE, 0);
	}
}
void LoginOut(int argc,char* argv[])
{
	ExitWindows(0,0);	
}

void RebootComputer(int argc,char* argv[])
{
	if(EnableShutDown)
	{
	 		ExitWindows(EWX_REBOOT | EWX_FORCE, 0);
	}	
}

boolean CreateDesktopLink(LPSTR szPath,LPSTR szArgument,LPSTR szLink)
{
	HRESULT hres;
   
  IShellLink* psl = NULL;     
  IPersistFile* ppf = NULL;       
  WCHAR wsz[MAX_PATH];  
  char desktopDir[MAX_PATH];
  
  LPMALLOC shMalloc;
  LPITEMIDLIST desktopIDL;
  
  SHGetMalloc(&shMalloc);
  SHGetSpecialFolderLocation(NULL,CSIDL_DESKTOPDIRECTORY,&desktopIDL);
  SHGetPathFromIDList(desktopIDL,desktopDir);
  
  shMalloc->lpVtbl->Free(shMalloc,desktopIDL);
  shMalloc->lpVtbl->Release(shMalloc);

  hres = CoInitialize(NULL);
  if(FAILED(hres))
    return FALSE;    
  hres = CoCreateInstance(&CLSID_ShellLink,NULL,CLSCTX_INPROC_SERVER,&IID_IShellLink,(LPVOID *)&psl);   
  if(FAILED(hres))  
  	goto clean;
  psl->lpVtbl->SetPath(psl,szPath);      
  psl->lpVtbl->SetArguments(psl,szArgument);    
  hres = psl->lpVtbl->QueryInterface(psl,&IID_IPersistFile,(void**)&ppf);
   
  if(FAILED(hres))     
  	goto clean; 
  
  strcat(desktopDir,"\\");
  strcat(desktopDir,szLink);
  strcat(desktopDir,".lnk");	    
  MultiByteToWideChar(CP_ACP,0,desktopDir,-1,wsz,MAX_PATH)   ;  
  hres = ppf->lpVtbl->Save(ppf,wsz,STGM_READWRITE);   
   
clean:
  if(ppf)
  	ppf->lpVtbl->Release(ppf);
   
  if(psl)  	
  	psl->lpVtbl->Release(psl);
   
  //CoUnitialize();
  return TRUE;
}

void CenterWindow(HWND hWnd)
{
	
		HWND hDestop;
		int cenX,cenY,width,height,left,top;
		RECT rectDestop,rectWnd;
		
		hDestop   =   GetDesktopWindow();  
    GetWindowRect(hDestop,&rectDestop);  
    GetWindowRect(hWnd,&rectWnd);  
    cenX=(rectDestop.left+rectDestop.right)/2;  
    cenY=(rectDestop.top+rectDestop.bottom)/2;  
    width=(rectWnd.right-rectWnd.left);  
    height=(rectWnd.bottom-rectWnd.top);  
    left=cenX-width/2;  
    top=cenY-height/2;  
   
    MoveWindow(hWnd,left,top,width,height,TRUE);   
}
//Dialog Proc
BOOL CALLBACK DlgProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam)
{
	int j;
	int iRet;
	char moduleName[MAX_PATH];
	char funname[MAX_PATH];
	char desp[MAX_PATH];
	
	GetModuleFileName(hInstThis,moduleName,MAX_PATH);
	switch(msg){
		case WM_COMMAND:
			switch(LOWORD(wParam)){
				case IDCANCEL:
					EndDialog(hWnd,0);
					return 1;
				case IDOK:
					for(j=0;j<ELEMENTS(functions);j++)
						{
							iRet = SendDlgItemMessage(hWnd,functions[j].fun_id,BM_GETCHECK,0,0);
							
							if(iRet == BST_CHECKED)
								{
									WideCharToMultiByte (CP_OEMCP,NULL,functions[j].funname,-1,funname,MAX_PATH,NULL,FALSE);
									WideCharToMultiByte (CP_OEMCP,NULL,functions[j].fun_desp,-1,desp,MAX_PATH,NULL,FALSE);
									CreateDesktopLink(moduleName,funname,desp);	
								}	
						}
					EndDialog(hWnd,0);
					return 1;
			}
			break;
			
		case WM_INITDIALOG:
			CenterWindow(hWnd);
			//SetIcon(hWnd,LoadResource(MAINICON));
			return 1;
			break;	
			
		case WM_CLOSE:
			EndDialog(hWnd,TRUE);
			return TRUE;
			break;	
	}
	
	return FALSE;
}