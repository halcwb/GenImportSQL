using System.Configuration;

namespace TestProject
{
    public class GStandardImportConfigurationSection : ConfigurationSection
    {
        private const string Folder = "folder";
        private const string FileList = "filelist";

        [ConfigurationProperty(Folder, IsRequired = true)]
        public string GStandardFolder
        {
            get { return (string)this[Folder]; }
            set { this[Folder] = value; }
        }

        [ConfigurationProperty(FileList, IsRequired = true)]
        public GStandardFileListConfigurationElement GStandardFileList
        {
            get { return (GStandardFileListConfigurationElement)this[FileList]; }
            set { this[FileList] = value; }
        }



    }
}