// slib.c

// Screensavers library.

#include <windows.h>

#include "gscrnsave.h"

// minimum number of pixels that mouse must move (horizontally plus vertically)
// before screensaver will close

#define WAKE_THRESHOLD 4

// type definitions for change password and verify password function prototypes

typedef VOID (WINAPI *PWDCHANGEPASSWORD)
 (LPCSTR lpcRegkeyname, HWND hwnd, UINT uiReserved1, UINT uiReserved2);

typedef BOOL (WINAPI *VERIFYSCREENSAVEPWD)(HWND hwnd);

// enumeration of screensaver modes. g_scrmode holds the mode in which the
// screensaver should be running. the default mode is smNone (0).

enum {smNone, smConfig, smPassword, smPreview, smSaver} g_scrmode;

// checking password flag. this flag is set to TRUE prior to calling the
// VerifyScreenSavePwd() function and reset to FALSE after that function
// returns. if set, we show the arrow pointer mouse cursor. if reset, we hide
// the mouse cursor. after all, we want the user to see the mouse cursor as
// they move it around the screen while the verification dialog box is visible.
// otherwise, they might have trouble moving the mouse into that dialog box, if
// they cannot see the mouse cursor over much of the screen.

static BOOL g_fCheckingPassword = FALSE;

// screensaver must close flag. this flag is set to TRUE if the user enters the
// correct password in the password verification dialog box or if there is no
// VerifyScreenSavePwd() function.

static BOOL g_fClosing = FALSE;

// running under Windows 95/98/ME flag. this flag is set to TRUE if running
// under Windows 95/98/ME. it is used to prevent access to the password
// change/verification dialog boxes under Windows NT and other Win32 operating
// systems. it is also used to prevent disabling/renabling the Alt+Tab,
// Ctrl+Alt+Delete, and Windows keys under NT and other Win32 operating systems.
// these system keys are automatically disabled under NT.

static BOOL g_fOnWin95 = FALSE;

// screensaver class name

static char g_szClassName [] = "WindowsScreenSaverClass";

// password.cpl instance handle

static HINSTANCE g_hinstPwdDLL;

// program instance handle

static HINSTANCE g_hinstance;

// last recorded mouse position. this position is initialized in response to
// DefScreenSaverProc()¡¯s WM_CLOSE and WM_MOUSEMOVE messages. this position is
// also initialized in response to RealScreenSaverProc()¡¯s WM_CREATE message.

static POINT g_ptMouse;

// message ID associated with "QueryCancelAutoPlay" message string

static UINT uShellMessage;

// VerifyScreenSavePwd() entry point address

static VERIFYSCREENSAVEPWD g_verifyScreenSavePwd;

// local function prototypes

void doChangePwd   (HWND hwnd);
void doConfig    (HWND hwnd);
void doSaver     (HWND hwndParent);
void hogMachine   (BOOL fDisable);
void loadPwdDLL   (void);
void unloadPwdDLL  (void);

LRESULT CALLBACK RealScreenSaverProc (HWND hwnd, int iMsg, WPARAM wparam,
                   LPARAM lparam);

// ==========================================================================
// int WINAPI WinMain (HINSTANCE hinstance, HINSTANCE hinstancePrev,
//           LPSTR lpszCmdLine, int iCmdShow)
//
// Program entry point.
//
// Arguments:
//
// hinstance   - program¡¯s instance handle (which uniquely identifies the
//         program when running under Windows)
//
// hinstancePrev - obsolete (leftover from Windows 3.1)
//
// lpszCmdLine  - address of \0-terminated string that contains command-line
//         parameters (not used in this program)
//
// iCmdShow   - number that indicates how the window is to be initially
//         displayed (not used in this program)
//
// Return    - 0
// ==========================================================================

#pragma argsused
int WINAPI WinMain (HINSTANCE hinstance, HINSTANCE hinstancePrev,
          LPSTR lpszCmdLine, int iCmdShow)
{
  char     *pch;
  HWND     hwnd;
  OSVERSIONINFO osvi;

  // Obtain version number and determine if running Windows operating system
  // belongs to the Windows 95/98/ME family. Set the g_fOnWin95 flag to true
  // for Windows 95/98/ME family.
  
  osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
  if (GetVersionEx (&osvi) || osvi.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS)
    g_fOnWin95 = TRUE;

  // If an exception occurs within the body of the following try statement, we
  // must handle that exception in the __except handler. That handler invokes
  // hogMachine() with a FALSE argument to re-enable the Alt+Tab, Windows, and
  // Ctrl+Alt+Delete keys.

  __try
  {
    // Save instance handle for later access in doConfig() and doSaver().

    g_hinstance = hinstance;

    // Obtain the command line.

    pch = GetCommandLine ();

    // Process the command line. Example: "c:\bc45\projects\pscl\pscl.scr" /S
    // In some cases, there may not be double quotes.

    if (*pch == '\"')
    {
      // Skip open double quote.

      pch++;

      // Skip all characters until end of command line or close double
      // quote encountered.

      while (*pch != '\0' && *pch != '\"')
       pch++;
    }
    else
    {
      // Skip all characters until end of command line or space
      // encountered.

      while (*pch != '\0' && *pch != ' ')
       pch++;
    }

    // If *pch is not \0 (end of command line), it is either a double quote
    // or a space. Skip past this character.

    if (*pch != '\0')
      pch++;

    // Consume all intervening spaces.

    while (*pch == ' ')
     pch++;

    // If *pch is \0, no arguments were passed to the screensaver. Establish
    // smConfig as the screensaver mode, with the foreground window as the
    // parent window handle.

    if (*pch == '\0')
    {
      g_scrmode = smConfig;
      hwnd = GetForegroundWindow ();
    }
    else
    {
      // If we found an option, skip over option indicator.

      if (*pch == '-' || *pch == '/')
        pch++;

      // Detect valid option characters.

      if (*pch == 'a' || *pch == 'A')
      {
        // Establish smPassword as the screensaver mode.

        g_scrmode = smPassword;

        // Skip over option character.

        pch++;

        // Skip intervening spaces or colons.

        while (*pch == ' ' || *pch == ':')
         pch++;

        // Save handle argument as the parent window handle.

        hwnd = (HWND) atoi (pch);
      }
      else
      if (*pch == 'c' || *pch == 'C')
      {
        // Establish smConfig as the screensaver mode.

        g_scrmode = smConfig;

        // Skip over option character.

        pch++;

        // Skip intervening spaces or colons.

        while (*pch == ' ' || *pch ==':')
         pch++;

        // If nothing follows the option character (except for spaces and
        // colons), use the foreground window¡¯s handle as the parent
        // window handle. Otherwise, save the handle argument as the
        // parent window handle.

        if (*pch == '\0')
          hwnd = GetForegroundWindow ();
        else
          hwnd = (HWND) atoi (pch);
      }
      else
      if (*pch == 'p' || *pch == 'P' || *pch == 'l' || *pch == 'L')
      {
        // Establish smPreview as the screensaver mode.

        g_scrmode = smPreview;

        // Skip over option character.

        pch++;

        // Skip intervening spaces or colons.

        while (*pch == ' ' || *pch == ':')
         pch++;

        // Save handle argument as the parent window handle.

        hwnd = (HWND) atoi (pch);
      }
      else
      if (*pch == 's' || *pch == 'S')
      {
        // Establish smSaver as the screensaver mode.

        g_scrmode = smSaver;
      }
    }

    // Invoke appropriate screensaver entry point based on screensaver mode.

    if (g_scrmode == smConfig)
      doConfig (hwnd);
    else
    if (g_scrmode == smPassword)
      doChangePwd (hwnd);
    else
    if (g_scrmode == smPreview)
      doSaver (hwnd);
    else
    if (g_scrmode == smSaver)
      doSaver (NULL);
  }
  __except (EXCEPTION_EXECUTE_HANDLER)
  {
    hogMachine (FALSE);
  }

  return 0;
}

// ============================================================================
// LRESULT WINAPI DefScreenSaverProc (HWND hwnd, int iMsg, WPARAM wparam,
//                  LPARAM lparam)
//
// Default screensaver procedure for processing messages.
//
// Arguments:
//
// hwnd  - handle of window associated with this screensaver procedure
//
// iMsg  - message identifier
//
// wparam - 32-bit word parameter with message data (if applicable)
//
// lparam - 32-bit long word parameter with message data (if applicable)
//
// Return:
//
// 0, 1, or -1 if message processed, otherwise DefWindowProc() result
// ============================================================================

LRESULT WINAPI DefScreenSaverProc (HWND hwnd, UINT iMsg, WPARAM wparam,
                  LPARAM lparam)
{
  POINT ptCheck;
  int deltax, deltay;

  // The doSaver() function invokes function RegisterWindowMessage () with the
  // "QueryCancelAutoPlay" string argument. That function attempts to register
  // this message with Windows. If registration succeeds, a nonzero message ID
  // returns. Windows sends that message ID to the foreground window¡¯s window
  // procedure whenever the user inserts a CD into the CD-ROM/DVD-ROM drive,
  // and the CD contains an autorun.inf file identifying a program to run.

  // The message handler returns 1 if it does not want that program to run. It
  // returns 0 otherwise. We don¡¯t want to run a CD-based program while a
  // password-protected screensaver is running. After all, the user should not
  // be able to execute programs prior to entering the correct password. If we
  // permitted these CD-based programs to execute, it is possible that a
  // program would be executed that could violate the security of the password,
  // and then there would be no point in assigning a password to a screensaver.

  // RegisterWindowMessage() returns 0 if it fails to register the message.

  if (iMsg == uShellMessage)
  {
    if (uShellMessage == 0)
      return DefWindowProc (hwnd, iMsg, wparam, lparam);

    PostMessage (hwnd, WM_CLOSE, 0, 0);

    return (g_verifyScreenSavePwd) ? 1 : 0;
  }

  // The following switch statement is only entered if we are not running in a
  // preview window (the screensaver occupies the entire desktop) and we are
  // not closing the screensaver.

  if (g_scrmode != smPreview && !g_fClosing)
    switch (iMsg)
    {
     case WM_ACTIVATEAPP:
        // Close the screensaver window if another window is being
        // activated. For example, suppose the screensaver-specific
        // window procedure launches a copy of Windows Notepad. In
        // preview mode, we can see Notepad¡¯s main window. We cannot see
        // that window when the screensaver occupies the entire desktop.
        // By posting the close message, we shut down the desktop
        // screensaver.

        if (wparam == FALSE)
          PostMessage (hwnd, WM_CLOSE, 0, 0);

        break;

     case WM_CLOSE:
        // If we are not running under the Windows 95/98/ME family, we
        // must forward WM_CLOSE to default window procedure.

        if (!g_fOnWin95)
          break;

        // Prepare to verify the password. If g_verifyScreenSavePwd is
        // NULL, we cannot verify the password, so forward the WM_CLOSE
        // message to DefWindowProc() to cause the screensaver to close.

        if (!g_verifyScreenSavePwd)
        {
          g_fClosing = TRUE;
          break;
        }

        // Verify the password. If the user enters the correct password,
        // forward WM_CLOSE to DefWindowProc(), to cause the screensaver
        // to close.

        g_fCheckingPassword = TRUE;

        g_fClosing = g_verifyScreenSavePwd (hwnd);

        g_fCheckingPassword = FALSE;

        if (g_fClosing)
          break;

        // Get current mouse cursor coordinates. We do this because we
        // are not yet closing the screensaver (which is occupying the
        // entire desktop) and the mouse cursor will have moved while
        // clicking a button in the verification dialog box. These mouse
        // coordinates are compared with mouse coordinates obtained
        // during WM_MOUSEMOVE message processing (see below). If they
        // indicate a combined movement more than WAKE_THRESHOLD pixels,
        // we want to close the screensaver.

        GetCursorPos (&g_ptMouse);

        return 0;

     case WM_KEYDOWN:
     case WM_LBUTTONDOWN:
     case WM_MBUTTONDOWN:
     case WM_POWERBROADCAST:
     case WM_RBUTTONDOWN:
     case WM_SYSKEYDOWN:
        // Close the screensaver.

        PostMessage (hwnd, WM_CLOSE, 0, 0);

        break;

     case WM_MOUSEMOVE:
        // Get current mouse cursor coordinates.

        GetCursorPos (&ptCheck);

        // Compute distance between current horizontal coordinate and
        // last saved horizontal coordinate.

        deltax = ptCheck.x-g_ptMouse.x;
        if (deltax < 0)
          deltax = -deltax;

        // Compute distance between current vertical coordinate and last
        // saved vertical coordinate.

        deltay = ptCheck.y-g_ptMouse.y;
        if (deltay < 0)
          deltay = -deltay;

        // Compute total distance change.

        deltay += deltax;

        // If total distance change exceeds a pixels threshold, save the
        // current mouse cursor coordinates (for next time) and close
        // the screensaver.

        if (deltay > WAKE_THRESHOLD)
        {
          g_ptMouse.x = ptCheck.x;
          g_ptMouse.y = ptCheck.y;
          PostMessage (hwnd, WM_CLOSE, 0, 0);
        }

        break;

     case WM_POWER:
        // If the system is resuming operation after entering suspended
        // mode, close the screensaver.

        if (wparam == PWR_CRITICALRESUME)
          PostMessage (hwnd, WM_CLOSE, 0, 0);

        break;

     case WM_SETCURSOR:
        // Show or hide the cursor.

        SetCursor (g_fCheckingPassword ? LoadCursor (NULL, IDC_ARROW)
                       : NULL);

        return -1;
    }

  return DefWindowProc (hwnd, iMsg, wparam, lparam);
}

// ==========================================================
// void doChangePwd (HWND hwnd)
//
// Screensaver entry point for changing screensaver password.
//
// Arguments:
//
// hwnd - parent window handle
//
// Return:
//
// none
// ==========================================================

static void doChangePwd (HWND hwnd)
{
  HINSTANCE hinstMPRDLL;
  PWDCHANGEPASSWORD pwdChangePassword;

  // Return if not running under Windows 95/98/ME family. This function will
  // most likely never be invoked under Windows NT and above (which handle
  // passwords themselves and do not invoke screensavers with argument /A).
  // Still, it is better to be safe than sorry -- hence "if (!g_fOnWin95)".

  if (!g_fOnWin95)
    return;

  // Load multiple provider router DLL.

  hinstMPRDLL = LoadLibrary ("mpr.dll");
  if (hinstMPRDLL == NULL)
    return;

  // Obtain PwdChangePasswordA() function entry point.

  pwdChangePassword = (PWDCHANGEPASSWORD) GetProcAddress (hinstMPRDLL,
                              "PwdChangePasswordA");

  // Invoke PwdChangePasswordA() function to change screensaver password.

  if (pwdChangePassword != NULL)
    (*pwdChangePassword) ("SCRSAVE", hwnd, 0, 0);

  // Unload multiple provider router DLL.

  FreeLibrary (hinstMPRDLL);
}

// ====================================================
// void doConfig (HWND hwnd)
//
// Screensaver entry point for configuring screensaver.
//
// Arguments:
//
// hwnd - parent window handle
//
// Return:
//
// none
// ====================================================

static void doConfig (HWND hwnd)
{
  // RegisterDialogClasses() lets the screensaver register any child control
  // windows needed by the configuration dialog box. If successful, that
  // function returns TRUE.

  if (RegisterDialogClasses (g_hinstance))
  {
    // Display the configuration dialog box, allowing the user to configure
    // the screensaver.

    DialogBoxParam (g_hinstance, MAKEINTRESOURCE(DLG_SCRNSAVECONFIGURE),
            hwnd, (DLGPROC) ScreenSaverConfigureDialog, 0);
  }
}

// ================================================
// void doSaver (HWND hwndParent)
//
// Screensaver entry point for running screensaver.
//
// Arguments:
//
// hwndParent - parent window handle
//
// Return:
//
// none
// ================================================

static void doSaver (HWND hwndParent)
{
  HDC hdc;
  MSG msg;
  HWND hwnd;
  WNDCLASS cls;
  HANDLE hOther;
  RECT rcParent;
  int nx, ny, cx, cy;
  PSTR pszWindowTitle;
  UINT uExStyle, uStyle;

  // Define screensaver¡¯s window class.

  cls.style = CS_OWNDC | CS_DBLCLKS | CS_VREDRAW | CS_HREDRAW;
  cls.lpfnWndProc = (WNDPROC) RealScreenSaverProc;
  cls.cbClsExtra = 0;
  cls.cbWndExtra = 0;
  cls.hInstance = g_hinstance;
  cls.hIcon = LoadIcon (g_hinstance, MAKEINTRESOURCE(ID_APP));
  cls.hCursor = NULL;
  cls.hbrBackground = (HBRUSH) GetStockObject (BLACK_BRUSH);
  cls.lpszMenuName = NULL;
  cls.lpszClassName = g_szClassName;

  // If hwndParent is not NULL, we are running in preview mode. Otherwise, we
  // are running in saver mode.

  if (hwndParent != NULL)
  {
    // Specify appropriate title for preview mode screensaver window.

    pszWindowTitle = "Preview";

    // Get the parent window rectangle.

    GetClientRect (hwndParent, &rcParent);

    // Compute width and position information for preview window, relative to
    // the parent window.

    cx = rcParent.right;
    cy = rcParent.bottom;
    nx = 0;
    ny = 0;

    // No extended style required for preview window, which is a child of its
    // non-desktop parent window.

    uExStyle = 0;

    // Set the preview window style -- child window, visible, exclude the
    // area occupied by child windows when drawing in parent window.

    uStyle = WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN;
  }
  else
  {
    // Specify appropriate title for saver mode screensaver window.

    pszWindowTitle = "Screen Saver";

    // Search for existing screensaver window.

    hOther = FindWindow (g_szClassName, pszWindowTitle);

    // If this window exists, make it the foreground window and return. We
    // don¡¯t execute more than one screensaver at the same time. What would
    // be the point of doing that?
	  
    if (hOther != NULL && IsWindow ((HWND) hOther))
    {
      SetForegroundWindow (hOther);
      return;
    }

    // Get the desktop window rectangle.

    hdc = GetDC (HWND_DESKTOP);
    GetClipBox (hdc, &rcParent);
    ReleaseDC (HWND_DESKTOP, hdc);

    // Compute width and position information for screensaver window,
    // relative to the desktop window -- the entire screen.

    cx = rcParent.right - rcParent.left;
    cy = rcParent.bottom - rcParent.top;
    nx = rcParent.left;
    ny = rcParent.top;

    // The screensaver window occupies the entire screen and must be the
    // topmost window -- no other window can be located on top of the
    // screensaver window.

    uExStyle = WS_EX_TOPMOST;

    // Set the screensaver window style -- popup, visible, exclude the area
    // occupied by child windows when drawing in parent window, clip child
    // windows relative to each other.

    uStyle = WS_POPUP | WS_VISIBLE | WS_CLIPSIBLINGS | WS_CLIPCHILDREN;
  }

  // Attempt to register the screensaver¡¯s window class.

  if (!RegisterClass (&cls))
    return;

  if (g_fOnWin95)
  {
    // Load the password DLL (found in password.cpl -- a DLL with a .cpl
    // file extension.

    loadPwdDLL ();

    // Register the QueryCancelAutoPlay message with Windows.

    uShellMessage = RegisterWindowMessage ("QueryCancelAutoPlay");
  }

  // Disable the Alt+Tab, Ctrl+Alt+Delete, and Windows keys.

  hogMachine (TRUE);

  // Create either preview mode or saver mode screensaver window.

  hwnd = CreateWindowEx (uExStyle, g_szClassName, pszWindowTitle, uStyle,
             nx, ny, cx, cy, hwndParent, NULL, g_hinstance, NULL);

  // If we were successful ...

  if (hwnd)
  {
    // Either a preview window or a window occupying the entire desktop has
    // been created. In the latter case, make that window the foreground
    // window. Nothing can supersede a window occuping the entire desktop.

    if (g_scrmode != smPreview)
      SetForegroundWindow (hwnd);

    // Enter the screensaver¡¯s message loop. Loop ends when
    // RealScreenSaverProc() responds to the WM_DESTROY message by calling
    // PostQuitMessage (0).

    while (GetMessage (&msg, NULL, 0, 0))
    {
     TranslateMessage (&msg);
     DispatchMessage (&msg);
    }
  }

  // Enable the Alt+Tab, Ctrl+Alt+Delete, and Windows keys.

  hogMachine (FALSE);

  if (g_fOnWin95)
  {
    // Unload the password DLL.

    unloadPwdDLL ();
  }
}

// ==========================================================================
// void hogMachine (BOOL fDisable)
//
// Disable or enable special keys when running under Windows 95/98/ME family.
//
// Arguments:
//
// fDisable - disable/enable flag (true - disable, false - enable)
//
// Return:
//
// none
// ==========================================================================

static void hogMachine (BOOL fDisable)
{
  UINT uOldValue;

  if (!g_fOnWin95)
    return;

  // Disable or enable CTRL-ALT-DELETE, ALT-TAB, and Windows keys when running
  // under the Windows 95/98/ME family.

  SystemParametersInfo (SPI_SCREENSAVERRUNNING, fDisable, &uOldValue, 0);
}

// ======================
// void loadPwdDLL (void)
//
// Load the password DLL.
//
// Arguments:
//
// none
//
// Return:
//
// none
// ======================

static void loadPwdDLL (void)
{
  HKEY hkey;
  DWORD dwSize, dwVal;

  // Open the specified key.

  if (RegOpenKey (HKEY_CURRENT_USER, "Control Panel\\Desktop", &hkey))
    return;

  // Fetch password value from the ScreenSaveUsePassword field of the open
  // key.

  dwSize = sizeof(DWORD);
  if (RegQueryValueEx (hkey, "ScreenSaveUsePassword", NULL, NULL,
    (LPBYTE) &dwVal, &dwSize))
  {
    RegCloseKey (hkey);
    return;
  }

  // Close the open key.

  RegCloseKey (hkey);

  // If a password exists ...

  if (dwVal != 0)
  {
    // Load the password.cpl DLL. This DLL contains the VerifyScreenSavePwd()
    // function.

    g_hinstPwdDLL = LoadLibrary ("password.cpl");
    if (!g_hinstPwdDLL)
      return;

    // Obtain entry point for VerifyScreenSavePwd.

    g_verifyScreenSavePwd =
     (VERIFYSCREENSAVEPWD) GetProcAddress (g_hinstPwdDLL,
                        "VerifyScreenSavePwd");
    if (g_verifyScreenSavePwd != NULL)
      return;

    // Unload password.cpl DLL.

    unloadPwdDLL ();
  }
}

// ========================
// void unloadPwdDLL (void)
//
// Unload the password DLL.
//
// Arguments:
//
// none
//
// Return:
//
// none
// ========================

static void unloadPwdDLL (void)
{
  // Return if password.cpl DLL not loaded.

  if (!g_hinstPwdDLL)
    return;

  // Remove the passworld.cpl DLL from memory.

  FreeLibrary (g_hinstPwdDLL);
  g_hinstPwdDLL = NULL;
  g_verifyScreenSavePwd = NULL;
}

// ===========================================================================
// LRESULT WINAPI RealScreenSaverProc (HWND hwnd, int iMsg, WPARAM wparam,
//                   LPARAM lparam)
//
// Real screensaver procedure for processing messages.
//
// Arguments:
//
// hwnd  - handle of window associated with this real screensaver procedure
//
// iMsg  - message identifier
//
// wparam - 32-bit word parameter with message data (if applicable)
//
// lparam - 32-bit long word parameter with message data (if applicable)
//
// Return:
//
// 0 or 1 if message processed, otherwise DefWindowProc() or ScreenSaverProc()
// result
// ===========================================================================

static LRESULT CALLBACK RealScreenSaverProc (HWND hwnd, int iMsg, WPARAM wparam,
                       LPARAM lparam)
{
  switch (iMsg)
  {
   // If preview window is being displayed, user clicks the right mouse
   // button in preview window, or user clicks ? button beside X button in
   // caption area of Display Properties window followed by right mouse
   // button in preview window, Windows sends a WM_CONTEXTMENU message. But
   // if user clicks ? button followed by left mouse button in preview
   // window, and then moves the mouse pointer out of preview window, Windows
   // sends a WM_HELP message. In either case, message is forwarded to valid
   // parent window.

   case WM_CONTEXTMENU:
   case WM_HELP:
      if (g_scrmode == smPreview)
      {
        HWND hwndParent = GetParent (hwnd);
        if (hwndParent == NULL || !IsWindow (hwndParent))
          return 1;
        PostMessage (hwndParent, iMsg, (WPARAM) hwndParent, lparam);
        return 1;
      }

      break;

   // WM_CREATE message sent in response to CreateWindowEx() function call in
   // the doSaver() function.

   case WM_CREATE:
      // Capture the mouse¡¯s current position. This position is used in
      // DefScreenSaverProc() to determine if the mouse has moved
      // sufficiently to close the screensaver.

      GetCursorPos (&g_ptMouse);

      // If preview window is not being displayed (we are covering the
      // entire desktop with a screensaver), hide the mouse cursor.

      if (g_scrmode != smPreview)
        SetCursor (NULL);

      break;

   // WM_DESTROY message sent in response to window being destroyed, after
   // the window has been removed from the screen.

   case WM_DESTROY:
      // Terminate the screensaver. PostQuitMessage() posts a WM_QUIT
      // message to the thread¡¯s message queue and immediately returns. 

      PostQuitMessage (0);
  }

  return ScreenSaverProc (hwnd, iMsg, wparam, lparam);
}