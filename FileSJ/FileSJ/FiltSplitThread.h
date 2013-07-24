#pragma once
#include "afxwin.h"

class CFiltSplitThread :
	public CWinThread
{
public:
	CFiltSplitThread(void);
	~CFiltSplitThread(void);
};
