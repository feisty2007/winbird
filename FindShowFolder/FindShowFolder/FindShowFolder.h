// FindShowFolder.h : PROJECT_NAME Ӧ�ó������ͷ�ļ�
//

#pragma once

#ifndef __AFXWIN_H__
	#error "�ڰ������ļ�֮ǰ������stdafx.h�������� PCH �ļ�"
#endif

#include "resource.h"		// ������


// CFindShowFolderApp:
// �йش����ʵ�֣������ FindShowFolder.cpp
//

class CFindShowFolderApp : public CWinApp
{
public:
	CFindShowFolderApp();

// ��д
	public:
	virtual BOOL InitInstance();

// ʵ��

	DECLARE_MESSAGE_MAP()
};

extern CFindShowFolderApp theApp;