// FileJoinDlg.cpp : implementation file
//

#include "stdafx.h"
#include "FileSJ.h"
#include "FileJoinDlg.h"


// CFileJoinDlg dialog

IMPLEMENT_DYNAMIC(CFileJoinDlg, CDialog)

/*
Sort Function For List Control
*/
int CALLBACK CompareFunc(LPARAM lParam1, LPARAM lParam2, 
						 LPARAM lParamSort)
{
	if(lParam1<lParam2)
		return -1;
	if(lParam1>lParam2)
		return 1;
	return 0;
}

char* CALLBACK GetFileNo(char* fileExt)
{
	CString str(fileExt);

	int Pos=str.ReverseFind('0');

	if(-1!=Pos)
	{
		return (char*)(LPCTSTR)str.Right(str.GetLength()-Pos);
	}
	else
		return fileExt;	
}

CFileJoinDlg::CFileJoinDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFileJoinDlg::IDD, pParent)
	, m_OutFile(_T(""))
	, m_OutFileName(_T(""))
{
	m_bIsWorking=false;
}

CFileJoinDlg::~CFileJoinDlg()
{
}

void CFileJoinDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST1, m_FileList);
	DDX_Text(pDX,IDC_EDIT1,m_OutFile);
	DDX_Control(pDX, IDC_PROGRESS1, m_Progress);
}


BEGIN_MESSAGE_MAP(CFileJoinDlg, CDialog)
	ON_EN_CHANGE(IDC_EDIT1, &CFileJoinDlg::OnEnChangeEdit1)
	ON_BN_CLICKED(IDC_BUTTON1, &CFileJoinDlg::OnBnClickedButton1)
	ON_NOTIFY(LVN_ITEMCHANGED, IDC_LIST1, &CFileJoinDlg::OnLvnItemchangedList1)
	ON_BN_CLICKED(IDC_BUTTON2, &CFileJoinDlg::OnBnClickedButton2)
	//ON_BN_CLICKED(IDC_BUTTON3, &CFileJoinDlg::OnBnClickedButton3)

	ON_MESSAGE(WM_FM_UPDATESTATUS,OnUpdateStatus)
	//ON_BN_CLICKED(IDC_BUTTON4, &CFileJoinDlg::OnBnClickedButton4)
	ON_BN_CLICKED(IDC_BTN_STARTMERGE, &CFileJoinDlg::OnBnClickedBtnStartmerge)
	ON_BN_CLICKED(IDC_BTN_FILEUP, &CFileJoinDlg::OnBnClickedBtnFileup)
	ON_BN_CLICKED(IDC_BTN_FILEDOWN, &CFileJoinDlg::OnBnClickedBtnFiledown)
	ON_BN_CLICKED(IDC_BTN_DELETE, &CFileJoinDlg::OnBnClickedBtnDelete)
END_MESSAGE_MAP()


// CFileJoinDlg message handlers

void CFileJoinDlg::OnEnChangeEdit1()
{
	// TODO:  If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialog::OnInitDialog()
	// function and call CRichEditCtrl().SetEventMask()
	// with the ENM_CHANGE flag ORed into the mask.

	// TODO:  Add your control notification handler code here
}

void CFileJoinDlg::OnBnClickedButton1()
{
	// TODO: Add your control notification handler code here
	CFileDialog dlg(TRUE, NULL, NULL, OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_ALLOWMULTISELECT, NULL, this);
	dlg.m_ofn.lpstrFile = new TCHAR[4097];
	*dlg.m_ofn.lpstrFile = 0;

	dlg.m_ofn.nMaxFile = 4096;
	if(dlg.DoModal()==IDOK)
	{
		POSITION pos = dlg.GetStartPosition();
		m_FileList.DeleteAllItems();
		CString strFileName;
		while(pos)
		{
			strFileName = dlg.GetNextPathName(pos);
			CString strExt = strFileName.Mid(strFileName.ReverseFind('.')+1);
			m_FileList.InsertItem(0,strFileName);
			int nExtNo = atoi((char*)(strExt.GetString()));
			m_FileList.SetItemData(0,nExtNo);

		}
		m_FileList.SetColumnWidth(0,LVSCW_AUTOSIZE);
		m_FileList.SortItems(CompareFunc,0);
		if(m_OutFile.IsEmpty())
			m_OutFile =  strFileName.Left(strFileName.ReverseFind('.'));
		UpdateData(FALSE);
	}
	delete []dlg.m_ofn.lpstrFile;
}

void CFileJoinDlg::OnLvnItemchangedList1(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	// TODO: Add your control notification handler code here
	*pResult = 0;
}

BOOL CFileJoinDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_FileList.InsertColumn(0,_T("Files"));
	return TRUE;
}

void CFileJoinDlg::OnBnClickedButton2()
{
	// TODO: Add your control notification handler code here
	LPMALLOC pMalloc;
	/* Gets the Shell's default allocator */
	if (::SHGetMalloc(&pMalloc) == NOERROR)
	{
		UpdateData(TRUE);
		BROWSEINFO bi;
		TCHAR *pszBuffer=new TCHAR[MAX_PATH];
		LPITEMIDLIST pidl;
		// Get help on BROWSEINFO struct - it's got all the bit settings.
		bi.hwndOwner = GetSafeHwnd();
		bi.pidlRoot = NULL;
		bi.pszDisplayName = pszBuffer;
		bi.lpszTitle = _T("Select Path For Output Files");
		bi.ulFlags = BIF_RETURNFSANCESTORS | BIF_RETURNONLYFSDIRS;
		bi.lpfn = NULL;
		bi.lParam = 0;
		// This next call issues the dialog box.
		if ((pidl = ::SHBrowseForFolder(&bi)) != NULL)
		{
			if (::SHGetPathFromIDList(pidl, pszBuffer))
			{ 
				// At this point pszBuffer contains the selected path */.
				m_OutDirName = pszBuffer;
				m_OutFileName=m_OutFile.Mid(m_OutFile.ReverseFind('\\'));
				m_OutFile = m_OutDirName+m_OutFileName;
				UpdateData(FALSE);
			}
			// Free the PIDL allocated by SHBrowseForFolder.
			pMalloc->Free(pidl);
		}
		// Release the shell's allocator.
		pMalloc->Release();

		delete[] bi.pszDisplayName;
	}
}

void CFileJoinDlg::OnBnClickedButton3()
{
	// TODO: Add your control notification handler code here
	if(!m_bIsWorking)
	{
		if(UpdateData(TRUE))
		{
			int nCount = m_FileList.GetItemCount();
			if(nCount==0)
				return;
			if(m_OutFile.IsEmpty())
				return;
			GetDlgItem(IDC_BTN_STARTMERGE)->SetWindowText(_T("Cancel"));

			//EnableAllControls(false);

			CStringArray arr;
			for(int i=0;i<nCount;++i)
			{
				arr.Add(m_FileList.GetItemText(i,0));
			}
			m_pFM = (CFileMergeThread*)AfxBeginThread(RUNTIME_CLASS(CFileMergeThread));
			m_pFM->m_pMainWnd=this;
			m_pFM->m_InFiles.Copy(arr);
			m_pFM->m_OutFile = m_OutFile;
			m_pFM->PostThreadMessage(WM_FM_START,0,0);
			m_bIsWorking = true;

		}
	}
	else
	{
		m_pFM->PostThreadMessage(WM_FM_CANCEL,0,0);
	}
}

LRESULT CFileJoinDlg::OnUpdateStatus(WPARAM wP, LPARAM lP)
{
	if(lP==0)
		m_Progress.SetPos((int)wP);
	if(lP==-1)
	{
		m_Progress.SetPos(0);
		MessageBox(_T("Error merging files, please check filenames"), _T("Error"),MB_ICONERROR);
		//EnableAllControls(TRUE);
		GetDlgItem(IDC_BTN_STARTMERGE)->SetWindowText(_T("Start"));
		//GetDlgItem(IDC_ME_STATIC)->SetWindowText("Done");
		m_bIsWorking = false;

	}
	if(lP==1)
	{
		m_Progress.SetPos(100);
		//EnableAllControls(TRUE);
		GetDlgItem(IDC_BTN_STARTMERGE)->SetWindowText(_T("Start"));
		//GetDlgItem(IDC_ME_STATIC)->SetWindowText("Done");
		m_bIsWorking = false;
	}

	return 1;
}

void CFileJoinDlg::OnBnClickedButton4()
{
	// TODO: Add your control notification handler code here
}

void CFileJoinDlg::OnBnClickedBtnStartmerge()
{
	// TODO: Add your control notification handler code here
	OnBnClickedButton3();

	::AfxMessageBox(_T("Merge Success!"));
}

void CFileJoinDlg::OnBnClickedBtnFileup()
{
	// TODO: Add your control notification handler code here
	POSITION pos=m_FileList.GetFirstSelectedItemPosition();

	while(pos)
	{
		int nSel=m_FileList.GetNextSelectedItem(pos);

		if(nSel>0)
		{
			m_FileList.SetItemData(nSel-1,m_FileList.GetItemData(nSel-1)+1);
			m_FileList.SetItemData(nSel,m_FileList.GetItemData(nSel)-1);
		}

		m_FileList.SortItems(CompareFunc,0);
	}

	m_FileList.SortItems(CompareFunc,0);
}

void CFileJoinDlg::OnBnClickedBtnFiledown()
{
	// TODO: Add your control notification handler code here
	POSITION pos = m_FileList.GetFirstSelectedItemPosition();
	int nSel;
	int nDec = 1;
	while(pos)
	{
		nSel = m_FileList.GetNextSelectedItem(pos);
		if(nSel<m_FileList.GetItemCount()-1)
		{
			/*if(!( LVIS_SELECTED == m_FileList.GetItemState(nSel+1,LVIS_SELECTED) ))
			{
				m_FileList.SetItemData(nSel+1, m_FileList.GetItemData(nSel+1) - nDec);
				nDec=1;
			}
			else
				nDec++;

			m_FileList.SetItemData(nSel, m_FileList.GetItemData(nSel)+1);*/
			m_FileList.SetItemData(nSel+1,m_FileList.GetItemData(nSel+1)-1);
			m_FileList.SetItemData(nSel,m_FileList.GetItemData(nSel)+1);
		}
		m_FileList.SortItems(CompareFunc,0);
	}
	
	m_FileList.SortItems(CompareFunc,0);
}

void CFileJoinDlg::OnBnClickedBtnDelete()
{
	// TODO: Add your control notification handler code here
	POSITION pos = m_FileList.GetFirstSelectedItemPosition();
	int nDeleted = 0;
	CUIntArray arr;

	while(pos)
	{
		int nSel = m_FileList.GetNextSelectedItem(pos);
		//m_FileList.DeleteItem(nSel-nDeleted);
		arr.Add(nSel);


	}
	for(int i=0;i<arr.GetSize();++i)
	{
		m_FileList.DeleteItem(arr.GetAt(i)-nDeleted);
		nDeleted++;
	}

	m_FileList.SortItems(CompareFunc,0);
}
