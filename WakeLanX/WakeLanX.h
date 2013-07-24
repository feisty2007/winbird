// WakeLanX.h : main header file for the WAKELANX application
//

#if !defined(AFX_WAKELANX_H__541E936E_E559_4850_B1D4_F5FCAB0C6186__INCLUDED_)
#define AFX_WAKELANX_H__541E936E_E559_4850_B1D4_F5FCAB0C6186__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

#include <winsock.h>

#pragma comment(lib,"WSOCK32.LIB")

/////////////////////////////////////////////////////////////////////////////
// CWakeLanXApp:
// See WakeLanX.cpp for the implementation of this class
//

class CWakeLanXApp : public CWinApp
{
public:
	CWakeLanXApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CWakeLanXApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CWakeLanXApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_WAKELANX_H__541E936E_E559_4850_B1D4_F5FCAB0C6186__INCLUDED_)
