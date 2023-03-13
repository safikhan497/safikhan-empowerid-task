using System;
using Azure.Identity;
using Microsoft.Rest;
using System.Data.SqlClient;
using Microsoft.Azure.Search;
using Microsoft.Azure.Search.Models;
using Azure.Security.KeyVault.Secrets;
using Microsoft.Rest.Azure.Authentication;
using Microsoft.Azure.Management.DataFactory;
using Microsoft.Azure.Management.DataFactory.Models;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace EmpowerIDTask
{
    class EID_ConsoleApplication
    {
        private string? srcDBConnectionString;
        private string? destDBConnectionString;
        private string? kvSubscriptionId;
        private string? kvTenantId;
        private string? kvClientId;
        private string? kvClientSecret;
        private bool isKeyVaultConnStrDataRetrieved = false;
        private bool isKeyVaultIDDetailsRetrieved = false;

        /// <summary>
        /// This is the main function which has menu options to select the action the user wants to perform.
        /// </summary>
        public static void Main()
        {
            try
            {
                //Welcome Note for Application
                Console.ForegroundColor = ConsoleColor.Magenta;
                Console.WriteLine("\n\n\n\t\t\t **********************************************************");
                Console.WriteLine      ("\t\t\t ************ Welcome to Console Application **************");
                Console.WriteLine      ("\t\t\t **********************************************************");


                //Creating class object for accessing members and methods for each task
                EID_ConsoleApplication taskApp = new EID_ConsoleApplication();


                //Main menu options in different color which will be shown frequently after every task is completd
            MainMenu:
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("\n\n\tEnter the action you want to perform by selecting the key: ");
                Console.WriteLine("\t----------------------------------------------------------\n");
                Console.WriteLine("\t1. Connect to the 'SOURCE' Azure SQL Database for querying.");
                Console.WriteLine("\t2. Connect to the 'DESTINATION' Azure SQL Database for querying.");
                Console.WriteLine("\t3. Initate and monitor a pipeline in Azure Data Factory for syncing data between source and destination.");
                Console.WriteLine("\t4. Perform Search on destination tables using Azure Cognitive Search.");
                Console.WriteLine("\t5. Exit the program.");
                Console.Write("\n\tPlease select a key: ");
                Console.ResetColor();


                //Taking key value from user to check if entered key is valid or not
                string? inputKey = Console.ReadLine();
                int selectedKey = 0;

                if (inputKey != null && inputKey != "")
                    selectedKey = Convert.ToInt32(inputKey);

                while (!(selectedKey >= 1 && selectedKey <= 5))
                {
                    Console.Write("\tPlease select a valid key: ");
                    inputKey = Console.ReadLine();
                    if (inputKey != null && inputKey != "")
                        selectedKey = Convert.ToInt32(inputKey);
                }

                //Performing different actions based on input key given by the user
                if (selectedKey == 1)
                {
                    taskApp.Connect_SourceSQLDatabase();
                    Thread.Sleep(1000);
                    goto MainMenu;
                }
                else if (selectedKey == 2)
                {
                    taskApp.Connect_DestinationSQLDatabase();
                    Thread.Sleep(1000);
                    goto MainMenu;
                }
                else if (selectedKey == 3)
                {
                    taskApp.Initiate_Monitor_ADFPipeline();
                    Thread.Sleep(1000);
                    goto MainMenu;
                }
                else if (selectedKey == 4)
                {
                    taskApp.CognitiveSearch_Products();
                    Thread.Sleep(1000);
                    goto MainMenu;
                }
                else if (selectedKey == 5)
                {
                    Console.Write("\tPress any key to confirm exit: ");
                    Console.ReadLine();
                }
            }

            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                Console.ResetColor();
                Console.ReadLine();
                Environment.Exit(0);
            }
        }



        /// <summary>
        /// This method connects to Source database for querying. It fetches the connection strings from the Key Vault securely.
        /// User can type SELECT, INSERT, UPDATE and DELETE queries and check the data in the source database.
        /// </summary>
        public void Connect_SourceSQLDatabase()
        {
            try
            {
                //Checking if connection string has been retrieved from Key Vault
                if (isKeyVaultConnStrDataRetrieved == false)
                    KeyVault(1);
                else
                {
                    Console.WriteLine("\n\n===========================================================\n");
                    Console.WriteLine("\tConnection String already retrived securely and is available..");
                    Thread.Sleep(500);
                }

                string? connStr = srcDBConnectionString;

                //Connecting to Database
                using (SqlConnection connection = new SqlConnection(connStr))
                {
                    Console.WriteLine("\tEstablishing connection to source database..");
                    Thread.Sleep(500);
                    connection.Open();
                    Console.WriteLine("\tSuccessfully connected to source database..");
                    Thread.Sleep(500);

                Query:
                    Console.Write("\n\tEnter the SQL Query: \n\t");
                    string? sqlQuery = Console.ReadLine();

                    if (sqlQuery == null || sqlQuery == "")
                        goto Query;

                    SqlCommand command = new SqlCommand(sqlQuery, connection);

                    Console.ForegroundColor = ConsoleColor.Cyan;

                    //Printing data on the console
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        Console.WriteLine();
                        int colCount = reader.FieldCount;
                        if (colCount == 0)
                            goto skipSelect;
                        Console.WriteLine("\n\t--------------------------------------------------------------------------------------------------");
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            Console.Write("\t || {0}", reader.GetName(j));
                        }
                        Console.WriteLine("\n\t--------------------------------------------------------------------------------------------------");
                        while (reader.Read())
                        {
                            for (int i = 0; i < colCount; i++)
                            {
                                Console.Write("\t || {0}", reader[i].ToString());
                            }
                            Console.WriteLine();
                        }
                    skipSelect:
                        Console.WriteLine();
                    }
                    Console.ResetColor();

                    Logging_Application_Events("Query Execution at source database", "Success", sqlQuery, "The query was executed successfully", "---");

                    Thread.Sleep(500);
                    Console.Write("\n\tDo you want to stay connected to Source Database? [(Y/y) or (N/n)] \n\tY - Stay Connected \n\tN - Go to Main Menu \n\t");
                    string? inp = Console.ReadLine();

                    if (inp == "Y" || inp == "y")
                    {
                        goto Query;
                    }
                    else
                    {
                        Console.WriteLine("\n\tClosing connection to source database..");
                        Thread.Sleep(1000);
                        connection.Close();
                        Console.WriteLine("\tClosed connection to source database..");
                        Thread.Sleep(1000);
                        Console.WriteLine("\tGoing back to Main Menu...");
                        Thread.Sleep(1000);
                        Console.WriteLine("\n\n\n***********************************************************************************");
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("\n\n\t" + e.ToString());
                Logging_Application_Events("Query Execution at source database", "Failed", "---", "The query was failed execution", e.ToString());
                Console.ResetColor();
                Console.WriteLine("\n\tGoing back to Main Menu...");
                Console.WriteLine("\n\n\n***********************************************************************************");
            }
        }



        /// <summary>
        /// This method connects to Source database for querying. It fetches the connection strings from the Key Vault securely.
        /// User can type SELECT, INSERT, UPDATE and DELETE queries and check the data in the source database.
        /// </summary>
        public void Connect_DestinationSQLDatabase()
        {
            try
            {
                //Checking if connection string has been retrieved from Key Vault
                if (isKeyVaultConnStrDataRetrieved == false)
                    KeyVault(2);
                else
                {
                    Console.WriteLine("\n\n===========================================================\n");
                    Console.WriteLine("\tConnection String already retrived securely and is available..");
                    Thread.Sleep(500);
                }

                string? connStr = destDBConnectionString;

                //Connecting to Database
                using (SqlConnection connection = new SqlConnection(connStr))
                {
                    Console.WriteLine("\tEstablishing connection to destination database..");
                    Thread.Sleep(500);
                    connection.Open();
                    Console.WriteLine("\tSuccessfully connected to destination database..");
                    Thread.Sleep(500);

                Query:
                    Console.Write("\n\tEnter the SQL Query: \n\t");
                    string? sqlQuery = Console.ReadLine();

                    if (sqlQuery == null || sqlQuery == "")
                        goto Query;

                    SqlCommand command = new SqlCommand(sqlQuery, connection);

                    Console.ForegroundColor = ConsoleColor.Cyan;

                    //Printing data on the console
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        Console.WriteLine();
                        int colCount = reader.FieldCount;
                        if (colCount == 0)
                            goto skipSelect;
                        Console.WriteLine("\n\t--------------------------------------------------------------------------------------------------");
                        for (int j = 0; j < reader.FieldCount; j++)
                        {
                            Console.Write("\t || {0}", reader.GetName(j));
                        }
                        Console.WriteLine("\n\t--------------------------------------------------------------------------------------------------");
                        while (reader.Read())
                        {
                            for (int i = 0; i < colCount; i++)
                            {
                                Console.Write("\t || {0}", reader[i].ToString());
                            }
                            Console.WriteLine();
                        }
                    skipSelect:
                        Console.WriteLine();
                    }
                    Console.ResetColor();

                    Logging_Application_Events("Query Execution at destination database", "Success", sqlQuery, "The query was executed successfully", "---");

                    Thread.Sleep(500);
                    Console.Write("\n\tDo you want to stay connected to Destination Database? [(Y/y) or (N/n)] \n\tY - Stay Connected \n\tN - Go to Main Menu \n\t");
                    string? inp = Console.ReadLine();

                    if (inp == "Y" || inp == "y")
                    {
                        goto Query;
                    }
                    else
                    {
                        Console.WriteLine("\n\tClosing connection to destination database..");
                        Thread.Sleep(1000);
                        connection.Close();
                        Console.WriteLine("\tClosed connection to destination database..");
                        Thread.Sleep(1000);
                        Console.WriteLine("\tGoing back to Main Menu...");
                        Thread.Sleep(1000);
                        Console.WriteLine("\n\n\n***********************************************************************************");
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("\n\n\t" + e.ToString());
                Logging_Application_Events("Query Execution at destination database", "Failed", "---", "The query was failed execution", e.ToString());
                Console.ResetColor();
                Console.WriteLine("\n\tGoing back to Main Menu...");
                Console.WriteLine("\n\n\n***********************************************************************************");
            }
        }



        /// <summary>
        /// This method connects to Azure Data Factory and triggers the pipeline. The pipeline syncs the data between source and destination tables.
        /// It does fresh full load as well as syncs Inserts, Updates and Deletes (CDC) changes when ever pipeline is executed.
        /// This method's events are logged directly from Azure Data Factory Pipeline into [dbo].[Application_Events_Log] table of source database
        /// </summary>
        public void Initiate_Monitor_ADFPipeline()
        {
            try
            {
                //Checking if ID details has been retrieved from Key Vault
                if (isKeyVaultIDDetailsRetrieved == false)
                    KeyVault(3);
                else
                {
                    Console.WriteLine("\n\n===========================================================\n");
                    Console.WriteLine("\tID Details already retrived securely and are available..");
                }

                string? tenantId = kvTenantId;
                string? clientId = kvClientId;
                string? clientSecret = kvClientSecret;
                string? subscriptionId = kvSubscriptionId;
                string resourceGroupName = "rg-eid-safikhan-app";
                string dataFactoryName = "adf-safikhan-eid-application";
                string pipelineName = "CDC Pipeline";

                Console.WriteLine("\n\tTask Description: This pipeline will sync the 4 source and destination tables.\n\t\t\t  This handles both first fresh load and CDC changes..");
                Thread.Sleep(2000);
                Console.WriteLine("\n\tConnecting to Azure Data Factory to start Pipeline run..");

                var serviceSettings = ActiveDirectoryServiceSettings.Azure;
                var creds = new ClientCredential(clientId, clientSecret);
                var authContext = new AuthenticationContext(serviceSettings.AuthenticationEndpoint + tenantId);
                var token = authContext.AcquireTokenAsync(serviceSettings.TokenAudience.ToString(), creds).Result.AccessToken;

                var credentials = new TokenCredentials(token);
                var client = new DataFactoryManagementClient(credentials) { SubscriptionId = subscriptionId };


                //client.Pipelines.CreateRunWithHttpMessagesAsync(resourceGroupName, dataFactoryName, pipelineName).Wait();
                CreateRunResponse runResponse = client.Pipelines.CreateRunWithHttpMessagesAsync(resourceGroupName, dataFactoryName, pipelineName).Result.Body;
                Console.WriteLine("\tPipeline Triggered Successfully..");
                Thread.Sleep(1000);
                Console.WriteLine("\tIt takes around 5 minutes to complete. User can monitor the status here OR in ADF Portal OR in Logging table in source database");
                Thread.Sleep(1000);
                
                // Monitor the pipeline run
                Console.WriteLine("\tChecking pipeline run status....");
                Thread.Sleep(1000);
                PipelineRun pipelineRun;
                while (true)
                {
                    pipelineRun = client.PipelineRuns.Get(resourceGroupName, dataFactoryName, runResponse.RunId);
                    Console.WriteLine("\t\tStatus: {0}", pipelineRun.Status);
                    if (pipelineRun.Status == "InProgress" || pipelineRun.Status == "Queued")
                        Thread.Sleep(7000);
                    else
                        break;
                }

                Thread.Sleep(1000);
                Console.WriteLine("\tChecking copy activity run details...");

                RunFilterParameters filterParams = new RunFilterParameters(DateTime.UtcNow.AddMinutes(-10), DateTime.UtcNow.AddMinutes(10));
                ActivityRunsQueryResponse queryResponse = client.ActivityRuns.QueryByPipelineRun(resourceGroupName, dataFactoryName, runResponse.RunId, filterParams);
                Console.Write("\n\tDo you want to view the success output? ((Y/y) or (N/n)) - ");
                string? outputView = Console.ReadLine();
                if (pipelineRun.Status == "Succeeded" && (outputView == "Y" || outputView == "y"))
                {
                    Console.WriteLine(queryResponse.Value.First().Output);
                }
                if (pipelineRun.Status != "Succeeded")
                {
                    Console.WriteLine(queryResponse.Value.First().Error);
                }
            }

            catch (Exception e)
            {
                Console.WriteLine("\n\n\t" + e.ToString());
                Console.ResetColor();
                Console.WriteLine("\n\tGoing back to Main Menu...");
                Console.WriteLine("\n\n\n***********************************************************************************");
            }
        }



        /// <summary>
        /// This method connects to Azure Search Service which helps the user to perform search on data available in destination database for 'Products' table
        /// </summary>
        public void CognitiveSearch_Products()
        {
            try
            {
                if (isKeyVaultConnStrDataRetrieved == false)
                    KeyVault(4);

                string searchServiceName = "acg-eid-data-search";
                string searchServiceAPIKeys = "25dSNVNZT7neR694jadXhfkcGFYup8jTRBUPwPXSiRAzSeAQEzzo";
                string searchServiceIndexName = "index-tbl-products";

                Console.WriteLine("\n\n===========================================================\n\n");
                Console.WriteLine("\tTask Description: Searching for data in 'Products' table in destination database..");

            Query:
                Console.Write("\n\tEnter the text to search (enter '*' to retrieve all records): ");
                string? searchString = Console.ReadLine();

                SearchServiceClient serviceClient = new SearchServiceClient(searchServiceName, new SearchCredentials(searchServiceAPIKeys));
                ISearchIndexClient indexClient = serviceClient.Indexes.GetClient(searchServiceIndexName);
                SearchParameters searchParams = new SearchParameters();
                var result = indexClient.Documents.SearchAsync(searchString, searchParams).Result;

                Console.ForegroundColor = ConsoleColor.Cyan;
                foreach (var data in result.Results)
                {
                    Console.WriteLine();
                    foreach (var a in data.Document)
                    {
                        Console.WriteLine("\t\"{0}\" : \"{1}\"", a.Key, a.Value);
                    }
                    Console.WriteLine();
                }
                Console.ResetColor();

                Logging_Application_Events("Searching data using Azure Cognitive Search", "Success", searchString, "Search was completed successfully", "---");

                Thread.Sleep(1000);
                Console.Write("\n\tDo you want to stay connected to Azure Cognitive Search? [(Y/y) or (N/n)] \n\tY - Stay Connected \n\tN - Go to Main Menu \n\t");
                string? inp = Console.ReadLine();

                if (inp == "Y" || inp == "y")
                {
                    goto Query;
                }
                else
                {
                    Console.WriteLine("\tGoing back to Main Menu...");
                    Thread.Sleep(1000);
                    Console.WriteLine("\n\n\n***********************************************************************************");
                }
            }

            catch (Exception e)
            {
                Console.WriteLine("\n\n\t" + e.ToString());
                Logging_Application_Events("Searching data using Azure Cognitive Search", "Failed", "---", "Search Failed", e.ToString());
                Console.ResetColor();
                Console.WriteLine("\n\tGoing back to Main Menu...");
                Console.WriteLine("\n\n\n***********************************************************************************");
            }
        }



        /// <summary>
        /// This method connects to Azure using the Key Vault and Secret details to fetch the connection strings for the source and destination databases.
        /// The connection strings will be used to connect to the source and destination databases for querying.
        /// </summary>
        public void KeyVault(int inputKey)
        {
            Console.WriteLine("\n\n===========================================================\n");

            try
            {
                //Creating connection to Azure Key Vault for retrieving secrets
                string keyVaultName = "kv-eid-app";
                string keyVaultURL = "https://" + keyVaultName + ".vault.azure.net/";
                var client = new SecretClient(new Uri(keyVaultURL), new DefaultAzureCredential());


                if ((inputKey == 1) || (inputKey == 2))
                {
                    Console.WriteLine("\tConnecting to Azure Key Vault for retrieving the connection strings securely.. Please wait for 10 to 15 seconds..");
                    string srcDBConnStrSecretName = "kv-sqlserver-source-connection-string";
                    KeyVaultSecret secret1 = client.GetSecret(srcDBConnStrSecretName);

                    string destDBConnStrSecretName = "kv-sqlserver-destination-connection-string";
                    KeyVaultSecret secret2 = client.GetSecret(destDBConnStrSecretName);

                    //Setting the password to class members
                    srcDBConnectionString = secret1.Value;
                    destDBConnectionString = secret2.Value;
                    isKeyVaultConnStrDataRetrieved = true;

                    Console.WriteLine("\tConnection Strings retrieved securely and successfully..");
                    Logging_Application_Events("Retrieving Connection Strings from Key Vault", "Success", "---", "Connection Strings were successfully retrieved from Key Vault", "---");
                }

                else if (inputKey == 3)
                {
                    Console.WriteLine("\tConnecting to Azure Key Vault for retrieving the ID details securely.. Please wait for  10 to 15 seconds..");
                    string subscriptionID = "kv-secret-subscrpitionid";
                    KeyVaultSecret secretSID = client.GetSecret(subscriptionID);

                    string tenandID = "kv-secret-tenantid";
                    KeyVaultSecret secretTID = client.GetSecret(tenandID);

                    string clientID = "kv-secret-clientid";
                    KeyVaultSecret secretCID = client.GetSecret(clientID);

                    string clientSecret = "kv-secret-clientsecret";
                    KeyVaultSecret secretCS = client.GetSecret(clientSecret);

                    //Setting the password to class members
                    kvSubscriptionId = secretSID.Value;
                    kvTenantId = secretTID.Value;
                    kvClientId = secretCID.Value;
                    kvClientSecret = secretCS.Value;
                    isKeyVaultIDDetailsRetrieved = true;
                    Console.WriteLine("\tClientID, SubscriptionID, Client Secret and TenantID retrieved securely and successfully..");
                }
                else if (inputKey == 4)
                {
                    Console.WriteLine("\tConnecting to Azure Key Vault for retrieving the connection strings securely for event logging.. Please wait for  10 to 15 seconds..");
                    string srcDBConnStrSecretName = "kv-sqlserver-source-connection-string";
                    KeyVaultSecret secret1 = client.GetSecret(srcDBConnStrSecretName);

                    string destDBConnStrSecretName = "kv-sqlserver-destination-connection-string";
                    KeyVaultSecret secret2 = client.GetSecret(destDBConnStrSecretName);

                    //Setting the password to class members
                    srcDBConnectionString = secret1.Value;
                    destDBConnectionString = secret2.Value;
                    isKeyVaultConnStrDataRetrieved = true;

                    Console.WriteLine("\tConnection Strings retrieved securely and successfully for event logging..");
                    Logging_Application_Events("Retrieving Connection Strings from Key Vault", "Success", "---", "Connection Strings were successfully retrieved from Key Vault", "---");
                }
                Thread.Sleep(1000);
            }
            catch (SqlException e)
            {
                Console.WriteLine("\n\n\t" + e.ToString());
            }
        }



        /// <summary>
        /// This method is used to log events in the database table which occurs in this application
        /// The logging table is available in source database with the name [dbo].[Application_Events_Log];
        /// </summary>
        public void Logging_Application_Events(string? eventName, string? eventStatus, string? userQuery, string? eventDescription, string? eventOutput)
        {
            string insertQuery = "INSERT INTO [dbo].[Application_Events_Log]([event_name],[event_status],[user_query],[event_description],[event_output])" +
                "VALUES(@eventName,@eventStatus,@executedQuery,@eventDescription,@eventOutput)";
            try
            {
                string? connStr = srcDBConnectionString;

                SqlConnection connection = new SqlConnection(connStr);
                connection.Open();
                SqlCommand command = new SqlCommand(insertQuery, connection);
                command.Parameters.AddWithValue("@eventName", eventName);
                command.Parameters.AddWithValue("@eventStatus", eventStatus);
                command.Parameters.AddWithValue("@executedQuery", userQuery);
                command.Parameters.AddWithValue("@eventDescription", eventDescription);
                command.Parameters.AddWithValue("@eventOutput", eventOutput);
                command.ExecuteNonQuery();
                connection.Close();
            }
            catch (SqlException e)
            {
                Console.WriteLine("\n\n\t" + e.ToString());
            }
        }
    }
}