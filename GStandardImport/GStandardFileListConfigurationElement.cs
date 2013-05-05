using System.Configuration;

namespace TestProject
{
    public class GStandardFileListConfigurationElement : ConfigurationElement
    {
        [ConfigurationProperty("list", IsRequired = true)]
        public string FileList
        {
            get { return (string)this["list"]; }
            set { this["list"] = value; }
        }
    }
}
