#include <windows.h>

#include <gscrnsave.h>
#include "minisvr.h"

#define false FALSE
#define true TRUE
#define REG_KEY "software\\Pleasure\\minisvr"
#define SHAPE_REG_KEY "shape"
#define MAXSHAPECOUNT_REG_KEY "MaxShapeCount"

#pragma resource "minisvr.res"


static enum {shCircle,shRectangle} g_shape=shRectangle;
static int g_MaxShapeCount=50;
static int g_ShapeWidth=20;
static int g_ShapeHeight=20;
static void ReadCfg();
static void WriteCfg();

LRESULT WINAPI ScreenSaverProc (HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	HDC hdc;
	static UINT timeID;
	int PosX,PosY;
	HBRUSH hBrush;
	HGDIOBJ hOldBrush;
	int rndShape=1;
	RECT rect;
	static int ShapeCount;
	
	switch(message)
	{
		case WM_CREATE:
			timeID=SetTimer(hWnd,1,50,NULL);
			ShapeCount=0;
			return 0;
			//break;
			
		case WM_TIMER:
			hdc=GetDC(hWnd);
			GetClientRect(hWnd,&rect);
			
			hBrush=CreateSolidBrush(RGB( rand() % 255, rand() % 255,rand()% 255 ));
			hOldBrush=SelectObject(hdc,(HGDIOBJ)hBrush);
			
			PosX=rand() % rect.right;
			PosY=rand() %rect.bottom;
			
			rndShape = rand() %2;
			if(rndShape==1)
				Rectangle(hdc,PosX,PosY,PosX+g_ShapeWidth,PosY+g_ShapeHeight);
			else
				Ellipse(hdc,PosX,PosY,PosX+g_ShapeWidth,PosY+g_ShapeHeight);
			
			ShapeCount++;
			
			if(ShapeCount == g_MaxShapeCount)
				{
					InvalidateRect(hWnd,NULL,true);
					ShapeCount=0;
				}
			SelectObject(hdc,hOldBrush);
			DeleteObject(hBrush);
						
			ReleaseDC(hWnd,hdc);
			return 0;
			//break;		
			
		case WM_DESTROY:
			KillTimer(hWnd,timeID);
			PostQuitMessage(0);
			return 0;
			//break;	
	}
		
	return DefScreenSaverProc (hWnd,message,wParam,lParam);
}

BOOL WINAPI ScreenSaverConfigureDialog (HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	char szBuf[256];
	
	switch(message)
	{
		case WM_INITDIALOG:
			ReadCfg();
			
			SendDlgItemMessage(hDlg,(g_shape==shRectangle)?IDR_CIRCLES:IDR_RECTANGLES,BM_SETCHECK,1,0);
			wsprintf(szBuf,"%d",g_MaxShapeCount);
			SetWindowText(GetDlgItem(hDlg,IDE_MDS),szBuf);
			break;
		case WM_COMMAND:
			if(wParam == IDOK)
				{
					if(SendDlgItemMessage(hDlg,IDR_CIRCLES,BM_GETCHECK,0,0))
						g_shape = shCircle;
					else
						g_shape = shRectangle;
						
					GetWindowText(GetDlgItem(hDlg,IDE_MDS),szBuf,256);
					g_MaxShapeCount=atoi(szBuf);
						
					WriteCfg();
				}
				
			if(wParam==IDOK || wParam==IDCANCEL)
				{
					EndDialog(hDlg,0);
					return true;
				}
			
	}
	return false;
}

BOOL WINAPI RegisterDialogClasses (HANDLE hInst)
{
	return true;
}

static void ReadCfg()
{
	long res;
	HKEY hKey;
	DWORD val,valSize,valType;
	
	res = RegOpenKeyEx(HKEY_CURRENT_USER,REG_KEY,0,KEY_ALL_ACCESS,&hKey);
	
	if(res == ERROR_SUCCESS)
		{
			valSize = sizeof(val);
			res = RegQueryValueEx(hKey,SHAPE_REG_KEY,0,&valType,(LPBYTE)&val,&valSize);
			
			if(res == ERROR_SUCCESS)
				g_shape=val;
				
			valSize = sizeof(val);
			res = RegQueryValueEx(hKey,MAXSHAPECOUNT_REG_KEY,0,&valType,(LPBYTE)&val,&valSize);
			
			if(res == ERROR_SUCCESS)
				g_MaxShapeCount=val;
			RegCloseKey(hKey);
		}
}

static void WriteCfg()
{
	LONG res;
  HKEY skey;
  DWORD disp, val;

  // Create the specified key if it does not exist or open the key if it does
  // exist.

  res = RegCreateKeyEx (HKEY_CURRENT_USER, REG_KEY, 0,
             NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL,
             &skey, &disp);

  if (res == ERROR_SUCCESS)
  {
    // Store shape value in the Shape field of the open key.

    val = g_shape;
    RegSetValueEx (skey, SHAPE_REG_KEY, 0, REG_DWORD, (CONST BYTE *) &val,
           sizeof(val));

    // Store maximum number of drawn shapes value in the MDS field of the
    // open key.

    val = g_MaxShapeCount;
    RegSetValueEx (skey, MAXSHAPECOUNT_REG_KEY, 0, REG_DWORD, (CONST BYTE *) &val,
           sizeof(val));

    // Close the open key.

    RegCloseKey (skey);
  }	
}