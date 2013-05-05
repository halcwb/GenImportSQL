using System;
using System.IO;
using System.Windows.Forms;

namespace TestProject
{
    public partial class ImportForm : Form
    {
        public ImportForm()
        {
            InitializeComponent();
        }

        void FilePathButtonClick(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                folderLocationLabel.Text = folderBrowserDialog.SelectedPath;
            }

            var tempPath = folderBrowserDialog.SelectedPath;

            foreach (var fileName in FlatFileReader.GetAllFileNames(tempPath))
            {
                var gStandardReader = new GStandardSchemaReader(tempPath, fileName);
                var name = fileName + "_" + gStandardReader.GetName();
                var columnInfos = gStandardReader.GetFlatFileColumnInfo();
                using (var sqlBulkImport = new SqlBulkImport("Server=localhost;Database=GStandDb;Trusted_Connection=True;"))
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
