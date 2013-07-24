using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using com.gm;


namespace DelphiLaser
{
    public partial class Form1 : Form
    {
        private OutlookExeAttachment oea = null;
        public Form1()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                tb_Dir.Text = folderBrowserDialog1.SelectedPath;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (!Directory.Exists(tb_Dir.Text))
            {
                MessageBox.Show(this, "Directory is not Exists!", "Notice", MessageBoxButtons.OK,
                    MessageBoxIcon.Error);

                return;
            }
	        Cursor CurPrev = Cursor.Current;
            try
            {		
	            DeleteLaserFile(tb_Dir.Text);
	        }
            finally
            {
                Cursor = CurPrev;                
            }

            MessageBox.Show("Find Finish!");

        }

        private void DeleteLaserFile(string DirName)
        {
           
                this.Cursor = Cursors.WaitCursor;
                string[] files = Directory.GetFiles(DirName);

                foreach (string f in files)
                {
                    if (isFileCanDel(f))
                    {
                        FileInfo fi = new FileInfo(f);
                        DateTime mt = fi.LastWriteTime;
                        FileAttributes fas= fi.Attributes;

                        ListViewItem item = new ListViewItem();
                        item.Text = Path.GetFileName(f);
                        item.SubItems.Add(Path.GetDirectoryName(f));
                        item.SubItems.Add(mt.ToString());
                        item.SubItems.Add(fi.Length.ToString());
                        item.SubItems.Add(GetFileAttr(fi.Attributes));
                        listView1.Items.Add(item);
                        item.Checked = true;
                    }

                        //File.Delete(f);
                }

                string[] dirs = Directory.GetDirectories(DirName);

                foreach (string d in dirs)
                    DeleteLaserFile(d);
           
            
        }

        private string GetFileAttr(FileAttributes attribs)
        {
            StringBuilder sb = new StringBuilder();

            if ((FileAttributes.Archive & attribs) !=0)
                sb.Append("A");

            if ((FileAttributes.Hidden & attribs) != 0)
                sb.Append("H");

            if ((FileAttributes.System & attribs) != 0)
                sb.Append("S");

            return sb.ToString();
        }


        private bool isFileCanDel(string fileName)
        {
            FileInfo fi = new FileInfo(fileName);

            string ext = fi.Extension;

            if (ext == String.Empty)
                return false;

            foreach (string s in listBox1.Items)
            {
                if (ext.Substring(1) == s)
                {
                    return true;
                }
            }

            return false;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            tb_Dir.Text = Application.StartupPath;
            oea = new OutlookExeAttachment();
            cbb_Outlook.Items.AddRange(oea.GetSupportedOutlook());
            cbb_Outlook.SelectedIndex = 0;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem item in listView1.Items)
            {
                if(item.Checked)
                {
                    string fullName = item.SubItems[1].Text + @"\" + item.Text;

                    try
                    {
                        File.Delete(fullName);
                        listView1.Items.Remove(item);
                    }
                    catch (System.Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }
                    finally
                    {
                    }
                }
            }

            MessageBox.Show("Clear Finished!");
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (oea.MakeExeVisible(cbb_Outlook.SelectedIndex, true))
            {
                MessageBox.Show("Restart Outlook,You Will See the Exe Attachment!", "Congulations", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show("Modify Error!,OutLook Version is Corrent?", "Notice", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            if (oea.MakeExeVisible(cbb_Outlook.SelectedIndex, false))
            {
                MessageBox.Show("Restart Outlook,You now can't see the Exe Attachment!", "Congulations", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show("Modify Error!,OutLook Version is Corrent?", "Notice", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}