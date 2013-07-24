#include <windows.h>
#include <stdio.h>
#include <shellapi.h>
#include <psapi.h>

#include "boolvalue.h"
#include "resource.h"


LPCTSTR szWinName = "TrayMinWnd";
LRESULT CALLBACK WndProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam);

#define WM_TRAYMIN (WM_USER+1001)
UINT wmNotifyMsg=0;
NOTIFYICONDATA niData;
bool InitTrayIcon(HWND hWnd);
bool RemoveTrayIcon(HWND hWnd);

bool InitWindow();
static HWND hWndTask;
HINSTANCE hInstThis;

///////////////////////Store Active Windows Information/////////////////////////
#define MAX_WIN_COUNT 256
typedef struct stru_Window
{
	HWND hWnd;
	char title[MAX_PATH];
}GWINDOW;

typedef struct stru_Windows
{
	int count;
	GWINDOW windows[MAX_WIN_COUNT];
}GWINDOWS;

GWINDOWS g_Windows;

void InitGWindows()
{
	g_Windows.count =0;
}

void AddGWindows(GWINDOW win)
{
	if(g_Windows.count<MAX_WIN_COUNT-1)
		{
			memset(&(g_Windows.windows[g_Windows.count]),0,sizeof(GWINDOW));
			g_Windows.windows[g_Windows.count].hWnd=win.hWnd;
			strcpy(g_Windows.windows[g_Windows.count].title,win.title);
			
			g_Windows.count++;
		}
}

HICON getIconFromHWnd(HWND hWnd)
{
	DWORD ProcessId;
	HANDLE hProcess;
	const unsigned max_file_path=1024;
	char Path[1024];
	SHFILEINFO shInfo;
	DWORD sysImageList;
	
	
	GetWindowThreadProcessId(hWnd,&ProcessId);	
	hProcess = OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_INFORMATION,
												 false,
												 ProcessId);
												 
  GetModuleFileNameEx(hProcess, 0, Path, 1024);
  
  CloseHandle(hProcess);
  
  memset(&shInfo,0,sizeof(SHFILEINFO));
  sysImageList = SHGetFileInfo(Path,
  							0,
  							&shInfo,
  							sizeof(SHFILEINFO),
  							SHGFI_ICON | SHGFI_SMALLICON);
  							
  							
  return shInfo.hIcon;
}

void HideWndToTray(HWND hWnd,GWINDOW vWnd,UINT id)
{
	
	NOTIFYICONDATA v_niData;
	HICON hIcon;
	//memset(&v_niData,0,sizeof(NOTIFYICONDATA));
	
	v_niData.cbSize = sizeof(NOTIFYICONDATA);
	v_niData.hWnd = hWnd;
	
	v_niData.uID = vWnd.hWnd;
	v_niData.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
	
	v_niData.uCallbackMessage = WM_TRAYMIN+256;
	hIcon = getIconFromHWnd(vWnd.hWnd);
	
	if(hIcon)
		v_niData.hIcon = hIcon;
	else
		v_niData.hIcon = LoadIcon(hInstThis,MAKEINTRESOURCE(ID_EXEICON));
	
	strcpy(v_niData.szTip,vWnd.title);
	
	Shell_NotifyIcon(NIM_ADD,&v_niData);
	
	ShowWindow(vWnd.hWnd,SW_HIDE);
	
	//if(hIcon)
		//CloseHandle(hIcon);
		
	return true;	
}


///////////////////////////////////////////////////////////////////////////////

typedef struct HideWin
{
	UINT windows[MAX_WIN_COUNT];
}HIDEWIN;

HIDEWIN g_HideWindows;

void InitGlobalHideWindows()
{
	int i;
	
	for(i=0;i<MAX_WIN_COUNT;i++)
		g_HideWindows.windows[i] = -1;
}

void AddHideWindow(HWND hWnd)
{
	int i=0;
	
	while(g_HideWindows.windows[i] != -1 && i<MAX_WIN_COUNT) i++;
	
	if(i<MAX_WIN_COUNT)
		g_HideWindows.windows[i]=hWnd;
}

void DeleteHideWindow(HWND hWnd)
{
	int i=0;
	while(g_HideWindows.windows[i]!=hWnd && i<MAX_WIN_COUNT) i++;
	
	if(i<MAX_WIN_COUNT)
		g_HideWindows.windows[i]=-1;
}

void ShowAllHideWindow(HWND hWnd)
{
	int i=0;
	NOTIFYICONDATA ni_Data;
	for(;i<MAX_WIN_COUNT;i++)
	{
		if(g_HideWindows.windows[i]!=-1) 
			{
				if(IsWindow((HWND)g_HideWindows.windows[i])) 
					{
						memset(&niData,0,sizeof(NOTIFYICONDATA));
	
						niData.cbSize = sizeof(NOTIFYICONDATA);
						niData.uID = (HWND)g_HideWindows.windows[i];
						niData.hWnd = hWnd;
	
						Shell_NotifyIcon(NIM_DELETE,&niData);
						ShowWindow((HWND)(g_HideWindows.windows[i]),SW_SHOW);
					}
			}
	}
	
	InitGlobalHideWindows();
}

///////////////////////////////////////////////////////////////////////////////


bool __stdcall EnumWindowsProc(HWND hWnd,LPARAM lParam)
{
	char title[MAX_PATH];
	
	if( IsWindowVisible(hWnd) && hWnd != hWndTask)
		{
		int ret=GetWindowText(hWnd,title,MAX_PATH);
	
		if( ret != 0 && strcmp(title,"Program Manager")!=0)
			{
				GWINDOW vWin;
				memset(&vWin,0,sizeof(GWINDOW));
				vWin.hWnd=hWnd;
				strcpy(vWin.title,title);
				
				AddGWindows(vWin);
			}
			//MessageBox(0,title,"Windows",MB_OK);
		}
	return true;
}

////////////////////////////////////////////////////////////////////////////////
INT WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, char *lpCmdLine, int cmdShow)
{
	HWND hWnd;
	MSG uMsg;
	WNDCLASS wndClass;
	
	//hWndTask=FindWindow("Shell_TrayWnd","");
	//MessageBox(0,"Hello","Message",MB_OK);
	
	//EnumWindows(EnumWindowsProc,0);
	
	
	wndClass.style = 0;
	wndClass.lpfnWndProc = WndProc;
	wndClass.cbClsExtra = 0;
	wndClass.cbWndExtra =0 ;
	
	wndClass.hInstance = hInstance;
	wndClass.hIcon = LoadIcon(hInstance,MAKEINTRESOURCE(ID_APP));
	wndClass.hCursor = NULL;
	wndClass.hbrBackground = GetStockObject(WHITE_BRUSH);
	
	wndClass.lpszMenuName = NULL;
	wndClass.lpszClassName = szWinName;
	
	RegisterClass(&wndClass);
	hInstThis = hInstance;
	
	hWnd = CreateWindow(szWinName,"TrayMin",
											WS_OVERLAPPEDWINDOW,
											CW_USEDEFAULT,
											CW_USEDEFAULT,
											450,
											450,
											NULL,
											NULL,
											hInstance,
											NULL);
	
	ShowWindow(hWnd,cmdShow);
	
	UpdateWindow(hWnd);
	
	ShowWindow(hWnd,SW_HIDE);
	
	while(GetMessage(&uMsg,NULL,0,0))
	{
		TranslateMessage(&uMsg);
		DispatchMessage(&uMsg);
	}
	
	return uMsg.wParam;
	//return 1;
}

bool InitWindow(HINSTANCE hInstance)
{
}
LRESULT CALLBACK WndProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam)
{
	HMENU hPopMenu,hFirstMenu;
	POINT pt;
	long ret;
	int i;
	HWND hClickWnd;
	NOTIFYICONDATA niData;
	
	if(msg == wmNotifyMsg)
		{
			switch(lParam)
			{
			    case WM_LBUTTONDBLCLK:
			    	ShowAllHideWindow(hWnd);
						RemoveTrayIcon(hWnd);
						PostQuitMessage(0);	
						break;
						
					case WM_RBUTTONDOWN:
						//MessageBox(hWnd,"Right Button Clicked!","msg",MB_OK);
						hPopMenu=LoadMenu(NULL,"PopupMenu");
						hFirstMenu=GetSubMenu(hPopMenu,0);
						
						InitGWindows();
						EnumWindows(EnumWindowsProc,0);
						
						InsertMenu(hFirstMenu,0,MF_BYPOSITION | MF_SEPARATOR,0,"-");
						for(i=0;i<g_Windows.count;i++)
							InsertMenu(hFirstMenu,0,MF_BYPOSITION | MF_STRING,WM_TRAYMIN+i,g_Windows.windows[i].title);
							
						GetCursorPos(&pt);
						
						ret=TrackPopupMenu(hFirstMenu,TPM_RIGHTALIGN | TPM_RETURNCMD,pt.x,pt.y,0,hWnd,0);
						
						if(ret == IDM_APP_QUIT)
							{
								ShowAllHideWindow(hWnd);
								RemoveTrayIcon(hWnd);
								PostQuitMessage(0);		
							}
						else if(ret > WM_TRAYMIN && ret < WM_TRAYMIN+g_Windows.count)
							{
								HideWndToTray(hWnd,g_Windows.windows[ret-WM_TRAYMIN],ret-WM_TRAYMIN+1);
								AddHideWindow(g_Windows.windows[ret-WM_TRAYMIN].hWnd);
							}else if(ret == IDM_SHOWALLHIDE)
								{
									ShowAllHideWindow(hWnd);
								}else if(ret == IDM_HIDEALL)
									{
										InitGWindows();
										EnumWindows(EnumWindowsProc,0);
										
										i=0;
										for(;i<g_Windows.count;i++)
										{
											HideWndToTray(hWnd,g_Windows.windows[i],i+1);
											AddHideWindow(g_Windows.windows[i].hWnd);	
										}	
									}
						break;
			}
			return 0;
		}
	else
		{	
			if(msg == WM_TRAYMIN+256)
				{
					
					if(lParam==WM_LBUTTONDOWN)
						{
							//MessageBox(hWnd,"Clicked","msg",MB_OK);
							hClickWnd=(HWND)wParam;
							if(IsWindow(hClickWnd))
								{							
									ShowWindow(hClickWnd,SW_SHOW);
									
									memset(&niData,0,sizeof(NOTIFYICONDATA));
	
									niData.cbSize = sizeof(NOTIFYICONDATA);
									niData.uID = hClickWnd;								
									niData.hWnd = hWnd;
	
									Shell_NotifyIcon(NIM_DELETE,&niData);
									DeleteHideWindow(hClickWnd);
								}
						}
						
					return 0;
				}
			else
				{
					switch(msg)
					{
						case WM_CREATE:
							wmNotifyMsg = RegisterWindowMessage(szWinName);
							InitTrayIcon(hWnd);
							InitGlobalHideWindows();
							break;
							
						case WM_DESTROY:
							ShowAllHideWindow(hWnd);
							RemoveTrayIcon(hWnd);
							PostQuitMessage(0);
							break;		
													
						default:
							return DefWindowProc(hWnd,msg,wParam,lParam);
					}
				}
		}
	
	return 0;
}

bool InitTrayIcon(HWND hWnd)
{
	memset(&niData,0,sizeof(NOTIFYICONDATA));
	
	niData.cbSize = sizeof(NOTIFYICONDATA);
	niData.hWnd = hWnd;
	
	niData.uID = 1;
	niData.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
	
	niData.uCallbackMessage = wmNotifyMsg;
	niData.hIcon = LoadIcon(hInstThis,MAKEINTRESOURCE(ID_APP));
	
	strcpy(niData.szTip,"Tray Minimize");
	//strcpy(niData.szInfo,"Now You Can Minize to System Tray");
	
	Shell_NotifyIcon(NIM_ADD,&niData);
	
	return true;
}
bool RemoveTrayIcon(HWND hWnd)
{
	memset(&niData,0,sizeof(NOTIFYICONDATA));
	
	niData.cbSize = sizeof(NOTIFYICONDATA);
	niData.uID = 1;
	niData.hWnd = hWnd;
	
	Shell_NotifyIcon(NIM_DELETE,&niData);
	return true;
}