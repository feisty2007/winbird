using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Win32;

namespace com.gm
{
	class OutlookExeAttachment
	{
        public string GetVersionByIndex(int index)
        {
            if (index >= 4)
                return String.Empty;
            else
                return GetOutlookVersion()[index,1];
        }

        private string[,] GetOutlookVersion()
        {
            string[,] OutLookVersion ={
                                          {"Excel 2000","9.0"},
                                          {"Outlook XP","10.0"},
                                          {"Outlook 2003","11.0"},
                                          {"Outlook 2007","12.0"}
                                     };

            return OutLookVersion;
        }

        public string[] GetSupportedOutlook()
        {
            int i;
            string[,] versions = GetOutlookVersion();
            List<string> result = new List<string>();
            for (i = 0; i < versions.GetLength(0); i++)
            {
                result.Add(versions[i, 0]);
            }

            return result.ToArray();
        }

        public bool MakeExeVisible(int version,bool Visible)
        {
            //Registry reg = Registry.CurrentUser;
            string sVersion = GetVersionByIndex(version);

            StringBuilder sb = new StringBuilder();
            sb.Append(@"software\Microsoft\Office\");
            sb.Append(sVersion);
            sb.Append(@"\");
            sb.Append(@"Outlook\Security");

            RegistryKey key = Registry.CurrentUser.OpenSubKey(sb.ToString(), true);

            if (key != null)
            {
                if (Visible)
                {
                    key.SetValue("Level1Remove", ".exe,.com", RegistryValueKind.String);
                }
                else
                {
                    key.DeleteValue("Level1Remove", false);
                }
                key.Close();

                return true;
            }

            return false;           
        }
    }
}
