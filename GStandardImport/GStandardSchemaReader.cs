using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace TestProject
{
    public class GStandardSchemaReader
    {
        private const string CachedFiles = "cached_files";
        private string contents;

        public GStandardSchemaReader(string tempPath, string fileName)
        {
            if (!File.Exists(Path.Combine(tempPath, CachedFiles)))
                Directory.CreateDirectory(Path.Combine(tempPath, CachedFiles));

            using (var client = new WebClient())
            {
                var cachedFile = Path.Combine(tempPath, CachedFiles, fileName + ".html");
                if (!File.Exists(cachedFile))
                {
                    string s = client.DownloadString(@"http://www.z-index.nl/g-standaard/beschrijvingen/technisch/Bestanden/bestand?bestandsnaam="+fileName);
                    File.WriteAllText(cachedFile, s);
                }
                contents = File.ReadAllText(cachedFile);
            }
        }

        public string GetName()
        {
            var match = Regex.Match(contents, @"Bestand\s\d\d\d(.*?)\<", RegexOptions.IgnoreCase);

            var name = match.Groups[1].ToString().Trim();
            name = name.Replace(' ', '_');
            name = name.Replace('-', '_');
            name = Regex.Replace(name, "[^A-Za-z0-9 _]", "");
            return name;
        }

        public List<FlatFileColumnInfo> GetFlatFileColumnInfo()
        {

            var matches = Regex.Matches(contents, @"\<tr\sclass=""(odd|even)"".*?\>(.*?)<\/tr\>", RegexOptions.Singleline);
            var dataInfoList = new List<FlatFileColumnInfo>();
            for (int i = 0; i < matches.Count; i++)
            {
                var row = matches[i].Groups[2].ToString();
                var colname = Regex.Match(row, @"\<th\>\<.*?\>(.*?)\<", RegexOptions.IgnoreCase).Groups[1].ToString();

                var metaDataMatches = Regex.Matches(row, @"\<td.*?\>(.*?)\<", RegexOptions.IgnoreCase);
                var length = int.Parse(Regex.Replace(metaDataMatches[2].Groups[1].ToString(), @"\(.*?\)", ""));
                var description = metaDataMatches[0].Groups[1].ToString();
                description = description.Replace(' ', '_');
                description = description.Replace('-', '_');
                colname = Regex.Replace(description, "[^A-Za-z0-9 _]", "") + "_" + colname;
                
                if (colname == "Leeg_veld_")
                {
                    colname = Regex.Replace(Guid.NewGuid().ToString(), "^[0-9]*", "").Replace('-','_');
                }
                var positions = metaDataMatches[4].Groups[1].ToString();
                var posstart = int.Parse(positions.Split('-')[0]);
                var posend = int.Parse(positions.Split('-')[1]);
                dataInfoList.Add(new FlatFileColumnInfo() { ColName = colname, Length = length, PosStart = posstart, PosEnd = posend});                
            }
            return dataInfoList;
        }
    }
}
