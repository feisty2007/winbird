#pragma once
#include "afxcmn.h"
#include "FileMergeThread.h"


// CFileJoinDlg dialog

class CFileJoinDlg : public CDialog
{
	DECLARE_DYNAMIC(CFileJoinDlg)

public:
	CFileJoinDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CFileJoinDlg();

// Dialog Data
	enum { IDD = IDD_JOINDLG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnEnChangeEdit1();
	afx_msg void OnBnClickedButton1();
	CListCtrl m_FileList;
	CString m_OutFile;
	afx_msg void OnLvnItemchangedList1(NMHDR *pNMHDR, LRESULT *pResult);

public:
	virtual BOOL OnInitDialog();
	CString m_OutFileName;
	afx_msg void OnBnClickedButton2();

private:
	CString m_OutDirName;
	CFileMergeThread* m_pFM;
	bool m_bIsWorking;
public:
	afx_msg void OnBnClickedButton3();
	LRESULT OnUpdateStatus(WPARAM wParam,LPARAM lParam);
	CProgressCtrl m_Progress;
	afx_msg void OnBnClickedButton4();
	afx_msg void OnBnClickedBtnStartmerge();
	afx_msg void OnBnClickedBtnFileup();
	afx_msg void OnBnClickedBtnFiledown();
	afx_msg void OnBnClickedBtnDelete();
};
