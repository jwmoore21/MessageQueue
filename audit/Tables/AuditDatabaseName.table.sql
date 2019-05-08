/*
IF EXISTS ( SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[audit].[AuditDatabaseName]') AND type in (N'U') )
DROP TABLE [audit].[AuditDatabaseName]
GO
*/

CREATE TABLE [audit].[AuditDatabaseName]
(
    [AuditId]         UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [AuditStatus]     TINYINT          NOT NULL
  , [AuditAppUser]    INT              NOT NULL
  , [AuditSqlUser]    VARCHAR(256)     NOT NULL
  , [AuditDate]       DATETIMEOFFSET   NOT NULL
  , [AuditBatchId]    UNIQUEIDENTIFIER NOT NULL
  , [AuditOperation]  VARCHAR(255)     NOT NULL
  , [DatabaseName]    NVARCHAR(128)    NULL
  , [RowStatus]       TINYINT          NULL
  , [CreatedBy]       INT              NULL
  , [ModifiedBy]      INT              NULL
  , [CreatedDate]     DATETIMEOFFSET   NULL
  , [ModifiedDate]    DATETIMEOFFSET   NULL
  , [RowGuid]            UNIQUEIDENTIFIER NULL
);
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [PK__AuditDatabaseName] PRIMARY KEY CLUSTERED
(
  [AuditId] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* Column(s) [AuditDatabaseName].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [FK__AuditDatabaseName__AuditStatus] FOREIGN KEY( [AuditStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [audit].[AuditDatabaseName] CHECK CONSTRAINT [FK__AuditDatabaseName__AuditStatus]
GO

/* Column(s) [AuditDatabaseName].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [FK__AuditDatabaseName__AuditAppUser] FOREIGN KEY ( [AuditAppUser] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
);
GO

ALTER TABLE [audit].[AuditDatabaseName] CHECK CONSTRAINT [FK__AuditDatabaseName__AuditAppUser];
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [DF__AuditDatabaseName__AuditId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditId];
GO

ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [DF__AuditDatabaseName__AuditStatus] DEFAULT ( (1) ) FOR [AuditStatus];
GO

ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [DF__AuditDatabaseName__AuditAppUser] DEFAULT ( '1' ) FOR [AuditAppUser];
GO

ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [DF__AuditDatabaseName__AuditSqlUser] DEFAULT ( SUSER_SNAME() ) FOR [AuditSqlUser];
GO

ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [DF__AuditDatabaseName__AuditDate] DEFAULT ( GETUTCDATE() ) FOR [AuditDate];
GO

ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [DF__AuditDatabaseName__AuditBatchId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditBatchId];
GO

ALTER TABLE [audit].[AuditDatabaseName] ADD CONSTRAINT [DF__AuditDatabaseName__AuditOperation] DEFAULT ( 'Adhoc operation' ) FOR [AuditOperation];
GO

/* -------------------------------------------------------------------------- */
/* Extended Properties - Table Description */
EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Transactional auditing table for the parent table [DatabaseName].',
  @level0type = N'SCHEMA',
  @level0name = N'audit',
  @level1type = N'TABLE',
  @level1name = N'AuditDatabaseName';
GO