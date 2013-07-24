// FileMergeThread.cpp : implementation file
//

#include "stdafx.h"
#include "FileSJ.h"
#include "FileMergeThread.h"


// CFileMergeThread

IMPLEMENT_DYNCREATE(CFileMergeThread, CWinThread)

CFileMergeThread::CFileMergeThread()
{
}

CFileMergeThread::~CFileMergeThread()
{
}

BOOL CFileMergeThread::InitInstance()
{
	// TODO:  perform and per-thread initialization here
	pInFile=NULL;
	pOutFile=NULL;

	return TRUE;
}

int CFileMergeThread::ExitInstance()
{
	// TODO:  perform any per-thread cleanup here
	if(NULL!=pInFile)
	{
		delete pInFile;
		pInFile=NULL;
	}
	if(NULL!=pOutFile)
	{
		delete pOutFile;
		pOutFile=NULL;
	}
	return CWinThread::ExitInstance();
}

BEGIN_MESSAGE_MAP(CFileMergeThread, CWinThread)
	ON_THREAD_MESSAGE(WM_FM_START,OnMergeStart)
END_MESSAGE_MAP()

void CFileMergeThread::OnMergeStart(WPARAM wParam,LPARAM lParam)
{
	CreateJoinFile(m_InFiles, m_OutFile);
	::PostQuitMessage(0);
}

bool CFileMergeThread::CreateJoinFile(CStringArray& inFiles, CString outFile)
{
	try
	{
		//outFile = inFiles[0].Left(m_InFiles[0].ReverseFind('.')+1);
		bool bCancel = false;
		if(NULL!=pInFile)
		{
			delete pInFile;
		}
		if(NULL!=pOutFile)
		{
			delete pOutFile;
		}
		pOutFile = new CStdioFile();
		if(!pOutFile->Open(outFile, CFile::modeCreate  | CFile::typeBinary | CFile::modeWrite))
		{
			if(m_pMainWnd)
				m_pMainWnd->SendMessage(WM_FM_UPDATESTATUS,0,-1);
			return false;
		}


		pInFile  = new CStdioFile();

		for(int i=0;i<inFiles.GetSize();++i)
		{
			if(!pInFile->Open(inFiles[i],CFile::modeRead | CFile::typeBinary))
			{
				if(m_pMainWnd)
					m_pMainWnd->SendMessage(WM_FM_UPDATESTATUS,0,-1);
				return false;
			}
			int nBytesRead = 0;
			do
			{
				nBytesRead = pInFile->Read(pBuf,BYTES_PER_READ);
				pOutFile->Write(pBuf,nBytesRead);
				/*Check For Cancel..*/
				MSG msg;
				if(PeekMessage(&msg,(HWND)-1,WM_FM_CANCEL,WM_FM_CANCEL,PM_NOREMOVE))
				{
					bCancel = true;
					break;
				}

			}
			while(nBytesRead==BYTES_PER_READ);
			UpdateStatus(100*(double)i/(double)inFiles.GetSize());
			pInFile->Close();
			if(bCancel)
				break;

		}
		pOutFile->Close();
		if(m_pMainWnd)
			m_pMainWnd->SendMessage(WM_FM_UPDATESTATUS,100,1);

	}
	catch(CFileException e)
	{
		if(IsWindow(m_pMainWnd->m_hWnd))
			::PostQuitMessage(0);
		return false;
	}
	if(IsWindow(m_pMainWnd->m_hWnd))
		::PostQuitMessage(0);
	return true;
}


void CFileMergeThread::UpdateStatus(double dPerc)
{
	if(IsWindow(m_pMainWnd->m_hWnd))
	{
		m_pMainWnd->SendMessage(WM_FM_UPDATESTATUS,(WPARAM)dPerc,0);
		//::SendMessage(m_pMainWnd->m_hWnd, WM_FM_UPDATESTATUS, (WPARAM)dPerc,0);
	}
}
// CFileMergeThread message handlers
