using System;
using System.Configuration;
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
            var location = SetFolderLocation();
            if (location == "") return;

            foreach (var fileName in FlatFileReader.GetAllFileNames(location))
            {
                var gStandardReader = new GStandardSchemaReader(location, fileName);
                var name = fileName + "_" + gStandardReader.GetName();
                var columnInfos = gStandardReader.GetFlatFileColumnInfo();
                using (var sqlBulkImport = new SqlBulkImport("Server=localhost;Database=GStandDb;Trusted_Connection=True;"))
                {
                    var dt = sqlBulkImport.CreateTable(name);
                    sqlBulkImport.CreateColumns(dt, columnInfos);
                    FlatFileReader.ReadFlatFileInToDataset(Path.Combine(location, fileName), dt, name, columnInfos);
                    sqlBulkImport.ImportTable(dt, name);
                }
            }
            Close();
        }

        private string SetFolderLocation()
        {
            var config = (GStandardImportConfigurationSection)ConfigurationManager.GetSection("Import");

            folderLocationLabel.Text = config.GStandardFolder;
            if (folderLocationLabel.Text == "") FolderPathBrowserDialog();
            var tempPath = folderLocationLabel.Text;
            return tempPath;
        }

        private void FolderPathBrowserDialog()
        {
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                folderLocationLabel.Text = folderBrowserDialog.SelectedPath;
            }
        }
    }
}
