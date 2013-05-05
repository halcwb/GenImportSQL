using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace TestProject
{
    public class SqlBulkImport : IDisposable
    {
        private readonly SqlConnection _sqlConnection;
        
        public SqlBulkImport(string connectionString)
        {
            _sqlConnection = new SqlConnection(connectionString);
            _sqlConnection.Open();   
        }

        public void ImportTable(DataTable dt, string tableName)
        {
            try
            {
                TryImport(dt);

            }
            catch (Exception e)
            {

                throw new Exception("Could not import table: " + tableName + "into database: " + dt, e);
            }
        }

        private void TryImport(DataTable dt)
        {
            using (var destinationConnection = new SqlConnection(_sqlConnection.ConnectionString))
            {
                destinationConnection.Open();
                using (var bulkCopy = new SqlBulkCopy(destinationConnection.ConnectionString))
                {
                    bulkCopy.BatchSize = 10000;
                    bulkCopy.DestinationTableName = dt.TableName;
                    bulkCopy.WriteToServer(dt);
                }
            }
        }

        public DataTable CreateTable(string name)
        {
            var ds = new DataSet();
            ds.Tables.Add(name);
            var dcid = new DataColumn("id") {DataType = typeof (int)};
            ds.Tables[name].Columns.Add(dcid);

            var createtable = new SqlCommand("CREATE TABLE " + name + " (id int)", _sqlConnection);
            createtable.ExecuteNonQuery();
            return ds.Tables[name];
        }

        public void CreateColumns(DataTable dt, List<FlatFileColumnInfo> columnInfos)
        {
            foreach (var columnInfo in columnInfos)
            {
                var dc = new DataColumn(columnInfo.ColName) {DataType = typeof (string)};
                dt.Columns.Add(dc);

                var addcolumn = new SqlCommand("ALTER TABLE " + dt.TableName + " ADD " + columnInfo.ColName + " varchar(" + (columnInfo.Length > 0 ? columnInfo.Length : 1) + ")", _sqlConnection);
                addcolumn.ExecuteNonQuery();
            }   
        }

        public void Dispose()
        {
            _sqlConnection.Close();
        }
    }
}
