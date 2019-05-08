/*
IF EXISTS ( SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[audit].[AuditDatabaseSchema]') AND type in (N'U') )
DROP TABLE [audit].[AuditDatabaseSchema]
GO
*/

CREATE TABLE [audit].[AuditDatabaseSchema]
(
    [AuditId]         UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [AuditStatus]     TINYINT          NOT NULL
  , [AuditAppUser]    INT              NOT NULL
  , [AuditSqlUser]    VARCHAR(256)     NOT NULL
  , [AuditDate]       DATETIMEOFFSET   NOT NULL
  , [AuditBatchId]    UNIQUEIDENTIFIER NOT NULL
  , [AuditOperation]  VARCHAR(255)     NOT NULL
  , [DatabaseSchema]  NVARCHAR(128)    NOT NULL
  , [RowStatus]       TINYINT          NOT NULL
  , [CreatedBy]       INT              NOT NULL
  , [ModifiedBy]      INT              NOT NULL
  , [CreatedDate]     DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]    DATETIMEOFFSET   NOT NULL
  , [RowGuid]            UNIQUEIDENTIFIER NOT NULL
);
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [PK__AuditDatabaseSchema] PRIMARY KEY CLUSTERED
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

/* Column(s) [AuditDatabaseSchema].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [FK__AuditDatabaseSchema__AuditStatus] FOREIGN KEY( [AuditStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [audit].[AuditDatabaseSchema] CHECK CONSTRAINT [FK__AuditDatabaseSchema__AuditStatus]
GO

/* Column(s) [AuditDatabaseSchema].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [FK__AuditDatabaseSchema__AuditAppUser] FOREIGN KEY ( [AuditAppUser] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
);
GO

ALTER TABLE [audit].[AuditDatabaseSchema] CHECK CONSTRAINT [FK__AuditDatabaseSchema__AuditAppUser];
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [DF__AuditDatabaseSchema__AuditId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditId];
GO

ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [DF__AuditDatabaseSchema__AuditStatus] DEFAULT ( (1) ) FOR [AuditStatus];
GO

ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [DF__AuditDatabaseSchema__AuditAppUser] DEFAULT ( '1' ) FOR [AuditAppUser];
GO

ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [DF__AuditDatabaseSchema__AuditSqlUser] DEFAULT ( SUSER_SNAME() ) FOR [AuditSqlUser];
GO

ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [DF__AuditDatabaseSchema__AuditDate] DEFAULT ( GETUTCDATE() ) FOR [AuditDate];
GO

ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [DF__AuditDatabaseSchema__AuditBatchId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditBatchId];
GO

ALTER TABLE [audit].[AuditDatabaseSchema] ADD CONSTRAINT [DF__AuditDatabaseSchema__AuditOperation] DEFAULT ( 'Adhoc operation' ) FOR [AuditOperation];
GO

/* -------------------------------------------------------------------------- */
/* Extended Properties - Table Description */
EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Transactional auditing table for the parent table [DatabaseSchema].',
  @level0type = N'SCHEMA',
  @level0name = N'audit',
  @level1type = N'TABLE',
  @level1name = N'AuditDatabaseSchema';
GO