// WakeLanXDlg.cpp : implementation file
//

#include "stdafx.h"
#include "WakeLanX.h"
#include "WakeLanXDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CWakeLanXDlg dialog

CWakeLanXDlg::CWakeLanXDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CWakeLanXDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CWakeLanXDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CWakeLanXDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CWakeLanXDlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CWakeLanXDlg, CDialog)
	//{{AFX_MSG_MAP(CWakeLanXDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON1, OnWakeOnLan)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CWakeLanXDlg message handlers

BOOL CWakeLanXDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
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

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CWakeLanXDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CWakeLanXDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CWakeLanXDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CWakeLanXDlg::OnWakeOnLan() 
{
	CString wakIP;
	int iLen = GetDlgItemText(IDC_EDIT1,wakIP);

	char* ip = wakIP.GetBuffer(iLen);
	for (char * a=ip; *a; a++)
	  if (*a!='-' && !isxdigit(*a))
	  {
	   MessageBox("MAC地址格式必须类似于 00-D0-4C-BF-52-BA","错误",MB_OK | MB_ICONWARNING);
	   return ;
	  }

	 int dstaddr[6];
	 int i=sscanf(ip, "%2x-%2x-%2x-%2x-%2x-%2x",
					&dstaddr[0], &dstaddr[1], &dstaddr[2], &dstaddr[3], &dstaddr[4], &dstaddr[5]);
	 if (i!=6)
	 {
	  MessageBox("Mac地址格式不正确","Notice",MB_OK);
	  return;
	 }

	 unsigned char ether_addr[6];
	 for (i=0; i<6; i++)
	  ether_addr[i]=dstaddr[i];

	 //构造Magic Packet
	 char magicpacket[200];
	 memset(magicpacket, 0xff, 6);
	 int packetsize=6;
	 for (i=0; i<16; i++)
	 {
	  memcpy(magicpacket+packetsize, ether_addr, 6);
	  packetsize+=6;
	 }

	 //启动WSA
	 WSADATA WSAData;

	 
	 memset(&WSAData,0,sizeof(WSADATA)); 	
	 if (WSAStartup( MAKEWORD(2, 0), &WSAData)!=0)
	 {
			MessageBox("Winsock初始化错误!","消息",MB_OK | MB_ICONWARNING); 
			return ;
	 }
	 //创建socket
	 SOCKET sock=socket(AF_INET, SOCK_DGRAM, 0);
	 

	 //设置为广播发送
	 BOOL bOptVal=TRUE;
	 int iOptLen=sizeof(BOOL);
	 if (setsockopt(sock, SOL_SOCKET, SO_BROADCAST, (char*)&bOptVal, iOptLen)==SOCKET_ERROR)
	 {
	  //fprintf(stderr, "setsockopt error: %d\n", WSAGetLastError());
      MessageBox("Winsock设置为广播模式出错!","消息",MB_OK | MB_ICONWARNING); 
	  closesocket(sock);
	  WSACleanup();

	  return;
	 }

	 sockaddr_in to;
	 to.sin_family=AF_INET;
	 to.sin_port=htons(0);
	 to.sin_addr.s_addr=htonl(INADDR_BROADCAST);

	 //发送Magic Packet
	 if (sendto(sock, (const char *)magicpacket, packetsize, 0, (const struct sockaddr *)&to, sizeof(to))==SOCKET_ERROR)
	  MessageBox("发送数据包错误","消息",MB_OK | MB_ICONWARNING);
	 else
	  MessageBox("成功发送数据包!远程主机可能已经启动","消息",MB_OK | MB_ICONINFORMATION);

	 closesocket(sock);
	 WSACleanup();	
}
