using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestProject
{
    public class SqlBulkImport : IDisposable
    {
        private SqlConnection sqlConnection;
        
        public SqlBulkImport(string connectionString)
        {
            sqlConnection = new SqlConnection(connectionString);
            sqlConnection.Open();   
        }

        public void ImportTable(DataTable dt, string tableName)
        {
            using (SqlConnection destinationConnection = new SqlConnection(sqlConnection.ConnectionString))
            {
                destinationConnection.Open();
                using (SqlBulkCopy bulkCopy = new SqlBulkCopy(destinationConnection.ConnectionString))
                {
                    bulkCopy.BatchSize = 10000;
                    //bulkCopy.NotifyAfter = 1000;
                    //bulkCopy.SqlRowsCopied += new SqlRowsCopiedEventHandler(bulkCopy_SqlRowsCopied);
                    bulkCopy.DestinationTableName = dt.TableName;
                    bulkCopy.WriteToServer(dt);
                }
            }
        }

        public DataTable CreateTable(string name)
        {
            var ds = new DataSet();
            ds.Tables.Add(name);
            var dcid = new DataColumn("id");
            dcid.DataType = typeof(int);
            ds.Tables[name].Columns.Add(dcid);

            var createtable = new SqlCommand("CREATE TABLE " + name + " (id int)", sqlConnection);
            createtable.ExecuteNonQuery();
            return ds.Tables[name];
        }

        public void CreateColumns(DataTable dt, List<FlatFileColumnInfo> columnInfos)
        {
            foreach (FlatFileColumnInfo columnInfo in columnInfos)
            {
                var dc = new DataColumn(columnInfo.ColName);
                dc.DataType = typeof(string);
                dt.Columns.Add(dc);

                SqlCommand addcolumn = new SqlCommand("ALTER TABLE " + dt.TableName + " ADD " + columnInfo.ColName + " varchar(" + (columnInfo.Length > 0 ? columnInfo.Length : 1) + ")", sqlConnection);
                addcolumn.ExecuteNonQuery();
            }   
        }

        public void Dispose()
        {
            sqlConnection.Close();
        }
    }
}
