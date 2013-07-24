#pragma once


#define WM_FM_START WM_USER+1004
#define WM_FM_UPDATESTATUS WM_USER+1005
#define WM_FM_CANCEL WM_USER+1006

#define BYTES_PER_READ 1024

// CFileMergeThread

class CFileMergeThread : public CWinThread
{
	DECLARE_DYNCREATE(CFileMergeThread)

protected:
	CFileMergeThread();           // protected constructor used by dynamic creation
	virtual ~CFileMergeThread();

public:
	virtual BOOL InitInstance();
	virtual int ExitInstance();
	afx_msg void OnMergeStart(WPARAM wParam,LPARAM lParam);

protected:
	DECLARE_MESSAGE_MAP()

public:
	CStringArray m_InFiles;
	CString		 m_OutFile;
protected:
	CFile *pInFile, *pOutFile;
	char		pBuf[BYTES_PER_READ];
	double m_dStatus;

public:
	bool CreateJoinFile(CStringArray& inFiles, CString outFile);
	double GetStatus();
	void UpdateStatus(double dPerc);
};


