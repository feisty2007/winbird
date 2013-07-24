#pragma once



#define WM_FS_START WM_USER+1001
#define WM_FS_UPDATESTATUS WM_USER+1002
#define WM_FS_CANCEL WM_USER+1003

// CFileSplitThread

class CFileSplitThread : public CWinThread
{
	DECLARE_DYNCREATE(CFileSplitThread)

protected:
	CFileSplitThread();           // protected constructor used by dynamic creation
	virtual ~CFileSplitThread();

public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();

protected:
	DECLARE_MESSAGE_MAP()

public:
	CString m_srcSplitFile;
	CString m_destDir;
	INT64 m_splitSize;
	INT64 m_FileSize;
private:
	afx_msg void OnSplitStart(WPARAM wParam,LPARAM lParam);
	bool CreateSplitFiles(CString srcFile, CString outDir, INT64 FileSize, INT64 SplitSize);
	void UpdateStatus(double Prec);
};


