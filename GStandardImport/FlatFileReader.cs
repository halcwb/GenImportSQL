using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

namespace TestProject
{
    public static class FlatFileReader
    {
        private static readonly IList<string> _includeList = new List<string>{"BST715T","BST004T","BST031T","BST020T","BST051T","BST050T","BST711T","BST750T","BST720T","BST725T","BST902T", "BST500T"};

        public static void ReadFlatFileInToDataset(string path, DataTable dt, string tableName, List<FlatFileColumnInfo> columnInfoList)
        {
            try
            {
                ReadFile(path, dt, columnInfoList);

            }
            catch (Exception e)
            {
                throw new Exception("Could not read file: " + path + dt,e);
            }
        }

        private static void ReadFile(string path, DataTable dt, List<FlatFileColumnInfo> columnInfoList)
        {
            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                using (var sr = new StreamReader(fs))
                {
                    while (!sr.EndOfStream)
                    {
                        var line = sr.ReadLine();
                        if (line != null && line.Length == 1) continue;

                        var dr = dt.NewRow();
                        foreach (var dataInfo in columnInfoList)
                        {
                            if (line == null) continue;
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
            return Directory.GetFiles(path, "*").Select(Path.GetFileName).Where(fileName => _includeList.Any(f => f == fileName)).ToList();
        }
    }
}
