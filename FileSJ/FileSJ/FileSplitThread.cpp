// FileSplitThread.cpp : implementation file
//

#include "stdafx.h"
#include "FileSJ.h"
#include "FileSplitThread.h"


// CFileSplitThread

IMPLEMENT_DYNCREATE(CFileSplitThread, CWinThread)

CFileSplitThread::CFileSplitThread()
{
}

CFileSplitThread::~CFileSplitThread()
{
}

BOOL CFileSplitThread::InitInstance()
{
	// TODO:  perform and per-thread initialization here
	return TRUE;
}

int CFileSplitThread::ExitInstance()
{
	// TODO:  perform any per-thread cleanup here
	return CWinThread::ExitInstance();
}

BEGIN_MESSAGE_MAP(CFileSplitThread, CWinThread)
	ON_THREAD_MESSAGE(WM_FS_START,OnSplitStart)
END_MESSAGE_MAP()


// CFileSplitThread message handlers

void CFileSplitThread::OnSplitStart(WPARAM wParam,LPARAM lParam)
{
	CreateSplitFiles(m_srcSplitFile,m_destDir,m_FileSize,m_splitSize);
	::PostQuitMessage(0);
	//return 1;
}

void CFileSplitThread::UpdateStatus(double Prec)
{
	if(m_pMainWnd && IsWindow(m_pMainWnd->m_hWnd))
	{
		m_pMainWnd->PostMessage(WM_FS_UPDATESTATUS,(WPARAM)Prec,0);
	}
}

bool CFileSplitThread::CreateSplitFiles(CString srcFile, CString outDir, INT64 FileSize, INT64 SplitSize)
{
	try
	{
		CFile f(srcFile,CFile::modeRead | CFile::typeBinary);
		INT64 iCount=FileSize/SplitSize;

		TCHAR buf[1024];

		f.SeekToBegin();
		INT64 allReadCount=0;

		for(int i=0;i<=iCount;i++)
		{
			int readCount=0;

			CString m_destFileName;
			m_destFileName.Format(_T("%s\\%s.%d"),outDir,f.GetFileName(),i+1);

			CFile m_destFile(m_destFileName,CFile::modeWrite | CFile::modeCreate | CFile::typeBinary);

			while(readCount<SplitSize && f.GetPosition() <= FileSize)
			{
				UINT iCount=f.Read(buf,1024);
				m_destFile.Write(buf,iCount);

				readCount+=1024;			
				allReadCount+=iCount;
				UpdateStatus(100*((double)allReadCount/(double)FileSize));

				MSG msg;
				if(PeekMessage(&msg,(HWND)-1,WM_FS_CANCEL,WM_FS_CANCEL,PM_NOREMOVE))
				{				
					break;
				}
			}

			m_destFile.Flush();
			m_destFile.Close();
		}
		f.Close();
		m_pMainWnd->SendMessage(WM_FS_UPDATESTATUS,100,1);
	}
	catch (CMemoryException* e)
	{
		return false;
	}
	catch (CFileException* e)
	{
		return false;
	}
	catch (CException* e)
	{
		return false;
	}
	
	return true;
}
