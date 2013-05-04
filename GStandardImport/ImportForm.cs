using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;

namespace TestProject
{
    public partial class ImportForm : Form
    {
        public ImportForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                this.folderLocationLabel.Text = folderBrowserDialog.SelectedPath;
            }

            string tempPath = folderBrowserDialog.SelectedPath;

            foreach (string fileName in FlatFileReader.GetAllFileNames(tempPath))
            {
                var gStandardReader = new GStandardSchemaReader(tempPath, fileName);
                var name = gStandardReader.GetName();
                var columnInfos = gStandardReader.GetFlatFileColumnInfo();
                using (var sqlBulkImport = new SqlBulkImport("Server=localhost;Database=testdb2;Trusted_Connection=True;"))
                {
                    var dt = sqlBulkImport.CreateTable(name);
                    sqlBulkImport.CreateColumns(dt, columnInfos);
                    FlatFileReader.ReadFlatFileInToDataset(Path.Combine(tempPath, fileName), dt, name, columnInfos);
                    sqlBulkImport.ImportTable(dt, name);
                }
            }
        }
    }
}
