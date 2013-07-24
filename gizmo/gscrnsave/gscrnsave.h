#ifndef g_scrnsave_h
#define g_scrnsave_h

#define DLG_SCRNSAVECONFIGURE 2003
#define ID_APP        100
#define IDS_DESCRIPTION    1

LRESULT WINAPI ScreenSaverProc (HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);

LRESULT WINAPI DefScreenSaverProc (HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);

BOOL WINAPI ScreenSaverConfigureDialog (HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam);

BOOL WINAPI RegisterDialogClasses (HANDLE hInst);

#endif