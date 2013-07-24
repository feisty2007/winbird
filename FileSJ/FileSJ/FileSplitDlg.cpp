// FileSplitDlg.cpp : implementation file
//

#include "stdafx.h"
#include "FileSJ.h"
#include "FileSplitDlg.h"
#include "FileSplitThread.h"
#include <ShellAPI.h>


// CFileSplitDlg dialog

IMPLEMENT_DYNAMIC(CFileSplitDlg, CDialog)

CFileSplitDlg::CFileSplitDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFileSplitDlg::IDD, pParent)
	, m_splitSize(0)
	, m_isWorking(FALSE)
{

}

CFileSplitDlg::~CFileSplitDlg()
{
}

void CFileSplitDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_BTNBROWSE, m_chkFloopy);
	DDX_Control(pDX, IDC_SPIN1, m_SpinSize);
	DDX_Control(pDX, IDC_PROGRESS1, m_prgStatus);
}


BEGIN_MESSAGE_MAP(CFileSplitDlg, CDialog)
	ON_BN_CLICKED(IDC_BTNBROWSE, &CFileSplitDlg::OnBnClickedBtnbrowse)
	ON_BN_CLICKED(IDC_BUTTON2, &CFileSplitDlg::OnBnClickedButton2)
	ON_BN_CLICKED(IDC_BUTTON4, &CFileSplitDlg::OnBnClickedButton4)
	//ON_BN_CLICKED(IDC_RADHUND, &CFileSplitDlg::OnBnClickedRadio2)
	//ON_EN_CHANGE(IDC_EDTOTHERSIZE, &CFileSplitDlg::OnEnChangeEdtothersize)
	ON_MESSAGE(WM_FS_UPDATESTATUS,OnUpdateStatus)
END_MESSAGE_MAP()


// CFileSplitDlg message handlers

LRESULT CFileSplitDlg::OnUpdateStatus(WPARAM wParam,LPARAM lParam)
{
	if(lParam==0)
	{
		m_prgStatus.SetPos((int)wParam);
	}

	if(lParam==1)
	{
		m_prgStatus.SetPos(100);
		GetDlgItem(IDC_BTN_STARTSPLIT)->SetWindowText(_T("Start"));
		m_isWorking=false;
	}

	if(lParam==-1)
	{
		m_prgStatus.SetPos(0);
		MessageBox(_T("Error splitting file, please check filenames"), _T("Error"),MB_ICONERROR);

		//EnableAllControls(TRUE);
		GetDlgItem(IDC_BTN_STARTSPLIT)->SetWindowText(_T("Start"));
		//GetDlgItem(IDC_SP_STATIC)->SetWindowText("Done");
		m_isWorking = false;

	}
	return 1;
}

BOOL CFileSplitDlg::OnInitDialog()
{

	CDialog::OnInitDialog();

	m_SpinSize.SetBuddy(GetDlgItem(IDC_EDTOTHERSIZE));
	m_SpinSize.SetRange(1,4700);

	((CButton*)GetDlgItem(IDC_RADONEMB))->SetCheck(1);
	SetDlgItemText(IDC_EDTOTHERSIZE,_T("1"));

	m_prgStatus.SetRange(0,99);
	m_prgStatus.SetPos(0);
	m_prgStatus.SetStep(1);
	return TRUE;
}

void CFileSplitDlg::OnBnClickedBtnbrowse()
{
	CFileDialog m_openDlg(TRUE,_T("*.*"));

	if(m_openDlg.DoModal()==IDOK)
	{
		CString m_fullPathName=m_openDlg.GetPathName();
		SetDlgItemText(IDC_EDTFILE,m_fullPathName);

		int nPos=m_fullPathName.ReverseFind(_T('\\'));
		if(-1!=nPos)
		{
			CString m_Path=m_fullPathName.Left(nPos);
			GetDlgItem(IDC_EDTDIR)->SetWindowText(m_Path);
		}
		
	}
}

void CFileSplitDlg::OnBnClickedButton2()
{
	CString m_fullPath;

	TCHAR buf[MAX_PATH];
	BROWSEINFO bi;
	ZeroMemory(&bi,sizeof(BROWSEINFO));
	bi.hwndOwner=m_hWnd;
	bi.lpszTitle=_T("Select Directory:");
	bi.ulFlags=BIF_RETURNONLYFSDIRS;

	ITEMIDLIST* pIDRet=::SHBrowseForFolder(&bi);
	::SHGetPathFromIDList(pIDRet,buf);

	SetDlgItemText(IDC_EDTDIR,buf);

}

void CFileSplitDlg::OnBnClickedButton4()
{
	// TODO: Add your control notification handler code here

	if(!m_isWorking)
	{
		if(!UpdateData(TRUE))
			return;

		CString m_srcFile;
		GetDlgItemText(IDC_EDTFILE,m_srcFile);

		if(m_srcFile.IsEmpty())
		{
			AfxMessageBox(_T("Please Select File to Split"));
			return;
		}

		CString m_destDir;
		GetDlgItemText(IDC_EDTDIR,m_destDir);

		if(m_destDir.IsEmpty())
		{
			AfxMessageBox(_T("Pleae Select Directory"));
			return;
		}

		CFile f(m_srcFile,CFile::modeRead);
		ULONGLONG fileSize=f.GetLength();
		f.Close();

		///*CString msg;
		//msg.Format(_T("File Size: %I64d"),fileSize);
		//AfxMessageBox(msg);*/

		ULONGLONG splitSize=GetSelectSplitSize();
		if(splitSize>fileSize)
		{
			AfxMessageBox(_T("Split Size Bigger than File Size,ReSelect it!"));
			return;
		}

		GetDlgItem(IDC_BUTTON4)->SetWindowText(_T("Cancel..."));
		splitThread=(CFileSplitThread*)AfxBeginThread(RUNTIME_CLASS(CFileSplitThread));
		splitThread->m_pMainWnd=this;
		splitThread->m_srcSplitFile=m_srcFile;
		splitThread->m_destDir=m_destDir;
		splitThread->m_FileSize=fileSize;
		splitThread->m_splitSize=splitSize;

		splitThread->PostThreadMessage(WM_FS_START,0,0);
	}
	else
	{
		splitThread->PostThreadMessage(WM_FS_CANCEL,0,0);
	}
	
}

INT64 CFileSplitDlg::GetSelectSplitSize()
{
	CButton* m_chkFlp=(CButton*)GetDlgItem(IDC_RADONEMB);

	if(m_chkFlp->GetCheck())
	{
		return (1 << 10) * 1424;
	}

	CButton* m_Hund=(CButton*)GetDlgItem(IDC_RADHUND);
	if (m_Hund->GetCheck())
	{
		return (1 << 20) * 100;
	}

	CButton* m_OneG=(CButton*)GetDlgItem(IDC_RADONEG);
	if (m_OneG->GetCheck())
	{
		return 1 << 30;
	}

	CButton* m_Other=(CButton*)GetDlgItem(IDC_RADOTHERSIZE);
	CEdit* edt_OtherSize=(CEdit*)GetDlgItem(IDC_EDTOTHERSIZE);
	if (m_Other->GetCheck())
	{
		CString strSelSize;
		edt_OtherSize->GetWindowText(strSelSize);
		INT64 iSelectsize=atoi((const char*)strSelSize.GetString());

		return (1 << 20 ) * iSelectsize;
	}

	return 0;
}

