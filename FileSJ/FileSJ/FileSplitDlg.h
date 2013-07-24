#pragma once
#include "afxwin.h"
#include "afxcmn.h"
#include "FileSplitThread.h"


// CFileSplitDlg dialog

class CFileSplitDlg : public CDialog
{
	DECLARE_DYNAMIC(CFileSplitDlg)

public:
	CFileSplitDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CFileSplitDlg();

// Dialog Data
	enum { IDD = IDD_SPLITDLG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support


	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedBtnbrowse();
	afx_msg void OnBnClickedButton2();
	CButton m_chkFloopy;
	CSpinButtonCtrl m_SpinSize;
	int m_splitSize;
	afx_msg void OnBnClickedButton4();
	afx_msg LRESULT OnUpdateStatus(WPARAM wParam,LPARAM lParam);
	virtual BOOL OnInitDialog();
private:
	INT64 GetSelectSplitSize();
	BOOL m_isWorking;
	CFileSplitThread* splitThread;
public:
	
	CProgressCtrl m_prgStatus;
};
