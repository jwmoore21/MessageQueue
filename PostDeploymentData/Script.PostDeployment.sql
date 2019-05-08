/*
Post-Deployment Script Template
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.
 Use SQLCMD syntax to include a file in the post-deployment script.
 Example:      :r .\myfile.sql
 Use SQLCMD syntax to reference a variable in the post-deployment script.
 Example:      :setvar TableName MyTable
               SELECT * FROM [$(TableName)]
--------------------------------------------------------------------------------------
*/


:setvar DatabaseName "MessageQueue"

:setvar FolderLocation ".\PostDeploymentData\"

GO

USE [$(DatabaseName)]
GO

:r $(FolderLocation)000_MasterList.Status.sql
:r $(FolderLocation)010_WebUser.users.sql


:r $(FolderLocation)001_DatabaseCatalogNames.data.sql
:r $(FolderLocation)002_DatabaseSchemaNames.data.sql
:r $(FolderLocation)003_DatabaseTableNames.data.sql


:r $(FolderLocation)303_MasterList.CountryTld.sql

:r $(FolderLocation)358_MasterList.SecondLevelDomain.sql

:r $(FolderLocation)360_MasterList.TopLevelDomain.sql

:r $(FolderLocation)361_MasterList.DomainName.sql

:r $(FolderLocation)362_MasterList.SubHostName.sql
:r $(FolderLocation)363_MasterList.HostName.sql
:r $(FolderLocation)364_MasterList.FQDN.sql

:r $(FolderLocation)375_MasterList.HttpVerb.sql
:r $(FolderLocation)555_MsqQueue.JsonSchema.sql


