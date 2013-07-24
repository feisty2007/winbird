// FileSJDlg.h : header file
//

#pragma once
#include "afxcmn.h"
#include "FileSplitDlg.h"
#include "FileJoinDlg.h"


// CFileSJDlg dialog
class CFileSJDlg : public CDialog
{
// Construction
public:
	CFileSJDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_FILESJ_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnTcnSelchangeTab1(NMHDR *pNMHDR, LRESULT *pResult);
	CTabCtrl m_MainTab;
	CFileSplitDlg m_splitWnd;
	CFileJoinDlg m_joinWnd;
};
