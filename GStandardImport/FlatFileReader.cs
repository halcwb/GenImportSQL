using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestProject
{
    public static class FlatFileReader
    {
        private static IList<string> _includeList = new List<string>{"BST715T","BST004T","BST031T","BST020T","BST051T","BST050T","BST711T","BST750T","BST720T","BST725T","BST902T",};

        public static void ReadFlatFileInToDataset(string path, DataTable dt, string tableName, List<FlatFileColumnInfo> columnInfoList)
        {
            using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                using (StreamReader sr = new StreamReader(fs))
                {
                    while (!sr.EndOfStream)
                    {
                        var line = sr.ReadLine();
                        if (line.Length == 1) continue;

                        var dr = dt.NewRow();
                        foreach (FlatFileColumnInfo dataInfo in columnInfoList)
                        {
                            var data = line.Substring(dataInfo.PosStart - 1, dataInfo.PosEnd - (dataInfo.PosStart - 1));
                            dr[dataInfo.ColName] = data;
                        }
                        dt.Rows.Add(dr);
                    }
                }
            }
        }

        public static List<string> GetAllFileNames(string path)
        {
            List<string> fileNames = new List<string>();
            foreach (string fileName in Directory.GetFiles(path, "*").Select(Path.GetFileName))
            {
                if (_includeList.Any(f => f == fileName)) fileNames.Add(fileName);
            }
            return fileNames;
        }
    }
}
