// FindShowFolderDlg.cpp : ʵ���ļ�
//

#include "stdafx.h"
#include "FindShowFolder.h"
#include "FindShowFolderDlg.h"
#include <shlobj.h>

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// ����Ӧ�ó��򡰹��ڡ��˵���� CAboutDlg �Ի���

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// �Ի�������
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

// ʵ��
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CFindShowFolderDlg �Ի���




CFindShowFolderDlg::CFindShowFolderDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFindShowFolderDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CFindShowFolderDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CFindShowFolderDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON1, &CFindShowFolderDlg::OnBnClickedButton1)
END_MESSAGE_MAP()


// CFindShowFolderDlg ��Ϣ�������

BOOL CFindShowFolderDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// ��������...���˵�����ӵ�ϵͳ�˵��С�

	// IDM_ABOUTBOX ������ϵͳ���Χ�ڡ�
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// ���ô˶Ի����ͼ�ꡣ��Ӧ�ó��������ڲ��ǶԻ���ʱ����ܽ��Զ�
	//  ִ�д˲���
	SetIcon(m_hIcon, TRUE);			// ���ô�ͼ��
	SetIcon(m_hIcon, FALSE);		// ����Сͼ��

	// TODO: �ڴ���Ӷ���ĳ�ʼ������

	return TRUE;  // ���ǽ��������õ��ؼ������򷵻� TRUE
}

void CFindShowFolderDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// �����Ի��������С����ť������Ҫ����Ĵ���
//  �����Ƹ�ͼ�ꡣ����ʹ���ĵ�/��ͼģ�͵� MFC Ӧ�ó���
//  �⽫�ɿ���Զ���ɡ�

void CFindShowFolderDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // ���ڻ��Ƶ��豸������

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// ʹͼ���ڹ��������о���
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// ����ͼ��
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//���û��϶���С������ʱϵͳ���ô˺���ȡ�ù����ʾ��
//
HCURSOR CFindShowFolderDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CFindShowFolderDlg::OnBnClickedButton1()
{
	// TODO: Add your control notification handler code here
	TCHAR m_QLPath[MAX_PATH];

	BOOL bResult=::SHGetSpecialFolderPath(this->m_hWnd,m_QLPath,CSIDL_APPDATA,FALSE);

	//GetDlgItem(IDC_EDIT1)->SetWindowText(m_QLPath);

	CString m_szPath(m_QLPath);
	m_szPath.Append(_T("\\Microsoft\\Internet Explorer\\Quick Launch\\ShowDesktop.scf"));

	//MessageBox(m_szPath);

	CStdioFile m_File;
	if(m_File.Open(m_szPath,CFile::modeCreate | CFile::modeWrite | CFile::typeText)==FALSE)
	{
		MessageBox(_T("Error Open File!,Fix Failure"));
		return;
	}

	CString lines[5]={_T("[Shell]"),
		_T("Command=2"),
		_T("IconFile=explorer.exe,3"),
		_T("[Taskbar]"),
		_T("Command=ToggleDesktop")
	};
	
	int i;
	for(i=0;i<5;i++)
	{
		//CString m_Write=lines[i];
		//m_Write.Append(_T("\n\r"));
		m_File.WriteString(lines[i]);
		m_File.WriteString(_T("\r\n"));
	}
	m_File.Close();

	AfxMessageBox(_T("Fix Success!"));
}
