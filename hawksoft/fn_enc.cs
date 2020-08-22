using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace hawksoft
{
    public class fn_enc
    {
        //Parameterized reader & execute methods to prevent sql injection
        public static SqlDataReader ExecuteReader(String commandText, string[] paramColl)
        {
            var conn = new SqlConnection();
            if (HttpContext.Current.Request.IsLocal)
                conn.ConnectionString = System.Configuration.ConfigurationManager.AppSettings["connstr_dev"];
            else
                conn.ConnectionString = System.Configuration.ConfigurationManager.AppSettings["connstr"];

            using (SqlCommand cmd = new SqlCommand(commandText, conn))
            {
                if (paramColl != null)
                {
                    int i = 1;
                    foreach (var p in paramColl)
                    {
                        cmd.Parameters.Add(new SqlParameter("Param" + i.ToString(), p.ToString()));
                        i++;
                    }
                }

                conn.Open();
                // When using CommandBehavior.CloseConnection, the connection will be closed when the 
                // IDataReader is closed.
                SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                return reader;
            }
        }

        public static void ExecuteNonQuery(string commandText, string[] paramColl)
        {
            var conn = new SqlConnection();
            conn.ConnectionString = System.Configuration.ConfigurationManager.AppSettings["connstr"];

            using (SqlCommand cmd = new SqlCommand(commandText, conn))
            {
                if (paramColl != null)
                {
                    int i = 1;
                    foreach (var p in paramColl)
                    {
                        if (p == null)
                            cmd.Parameters.Add(new SqlParameter("Param" + i.ToString(), DBNull.Value));
                        else if (p.ToString() == "")
                            cmd.Parameters.Add(new SqlParameter("Param" + i.ToString(), DBNull.Value));
                        else
                            cmd.Parameters.Add(new SqlParameter("Param" + i.ToString(), p.ToString()));
                        i++;
                    }
                }

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

        }
    }
}