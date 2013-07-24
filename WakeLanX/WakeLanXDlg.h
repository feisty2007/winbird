// WakeLanXDlg.h : header file
//

#if !defined(AFX_WAKELANXDLG_H__1BB0FC5E_0DF0_4B54_96B3_E49D3D02BA96__INCLUDED_)
#define AFX_WAKELANXDLG_H__1BB0FC5E_0DF0_4B54_96B3_E49D3D02BA96__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CWakeLanXDlg dialog

class CWakeLanXDlg : public CDialog
{
// Construction
public:
	CWakeLanXDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CWakeLanXDlg)
	enum { IDD = IDD_WAKELANX_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CWakeLanXDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CWakeLanXDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnWakeOnLan();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_WAKELANXDLG_H__1BB0FC5E_0DF0_4B54_96B3_E49D3D02BA96__INCLUDED_)
