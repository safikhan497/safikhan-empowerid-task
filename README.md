# C# Console Application - by Safi Khan

  <br>
  
-------
  
  <br>

## Welcome to the console application which was developed to complete the Task based on the requirements.

In this repository there are totally 5 files which are:
1. SQL Script for Source Database (.sql file)
2. SQL Script for Destination Database (.sql file)
3. C# code for console application (.cs file)
4. ZIP file of the Visual Studio Solution folder
5. README.md file

  <br>
  <br>
  
-------
  
  <br>
  <br>

# List of Azure Services created under the Resource Group <br> ('rg-eid-safikhan-app')
> ## __Azure Services__
- [x] SQL Server
- [x] Azure SQL Database (for source)
- [x] Azure SQL Database (for destination)
- [x] Key Vault
- [x] Azure Data Factory (ADF)
- [x] Azure Cognitive Search

  <br>
  <br>
  
-------
  
  <br>
  <br>

# List of components created under Azure Data Factory Service <br> ('adf-safikhan-eid-application')
> ## __ADF Pipeline__
 + CDC Pipeline

> ## __ADF Data Flow__
 + Sync Categories Table
 + Sync Products Table
 + Sync Orders Table
 + Sync OrdersProducts Table

> ## __2 Linked Services (1 for source and 1 for destination)__

> ## __8 Datasets (4 in source and 4 in destination)__

  <br>
  <br>
  
-------
  
  <br>
  <br>

# SQL Server Setup
- [x] Connect to SOURCE server and execute the full SQL script named <<SQL Scripts - Source Database.sql>> ---> (completed and data is available in the database)
- [x] Connect to DESTINATION server and execute the full SQL script named <<SQL Scripts - Destination Database.sql>> ---> (completed and data is available in the database)

  <br>
  <br>
  
-------
  
  <br>
  <br>

# C# Console Application Setup
1. Open Visual Studio and Create a C# Console Application project
2. Open the class file and paste the code available in <<C# Console Application Code.cs>>. This file is uploaded here in GitHub repository.
3. Click on File -> Open -> File and open the .csproj file. Once it is opened, paste the below text anywhere between <Project> start and end tags
  ```
     <ItemGroup>
		  <PackageReference Include="Azure.Security.KeyVault.Secrets" Version="4.4.0" />
		  <PackageReference Include="Azure.Identity" Version="1.9.0-beta.2" />
		  <PackageReference Include="Microsoft.Azure.Management.DataFactory" Version="9.2.0" />
		  <PackageReference Include="Microsoft.Rest.ClientRuntime.Azure.Authentication" Version="2.4.1" />
		  <PackageReference Include="System.Data.SqlClient" Version="4.8.5" />
		  <PackageReference Include="Microsoft.Azure.Search" Version="10.1.0" />
		  <PackageReference Include="Azure.Search.Documents" Version="11.4.0" />
	  </ItemGroup>
  ```
  4. Execute the console application (make sure Visual Studio is signed in using the company account)

  <br>
  <br>
  
-------
  
  <br>
  <br>
