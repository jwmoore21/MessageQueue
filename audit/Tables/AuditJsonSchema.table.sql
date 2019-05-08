/*
IF EXISTS ( SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[audit].[AuditJsonSchema]') AND type in (N'U') )
DROP TABLE [audit].[AuditJsonSchema]
GO
*/

CREATE TABLE [audit].[AuditJsonSchema]
(
    [AuditId]           UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [AuditStatus]       TINYINT          NOT NULL
  , [AuditAppUser]      INT              NOT NULL
  , [AuditSqlUser]      VARCHAR(256)     NOT NULL
  , [AuditDate]         DATETIMEOFFSET   NOT NULL
  , [AuditBatchId]      UNIQUEIDENTIFIER NOT NULL
  , [AuditOperation]    VARCHAR(255)     NOT NULL
  , [JsonSchemaName]    VARCHAR(64)      NULL
  , [RowStatus]         TINYINT          NULL
  , [CreatedDate]       DATETIMEOFFSET   NULL
  , [ModifiedDate]      DATETIMEOFFSET   NULL
  , [CreatedBy]         INT              NULL
  , [ModifiedBy]        INT              NULL
  , [RowGuid]           UNIQUEIDENTIFIER NULL
  , [SchemaDescription] VARCHAR(255)     NULL
  , [JsonSchema]        NVARCHAR(4000)   NULL
);
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [PK__AuditJsonSchema] PRIMARY KEY CLUSTERED
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

/* Column(s) [AuditJsonSchema].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [FK__AuditJsonSchema__AuditStatus] FOREIGN KEY( [AuditStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [audit].[AuditJsonSchema] CHECK CONSTRAINT [FK__AuditJsonSchema__AuditStatus]
GO

/* Column(s) [AuditJsonSchema].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [FK__AuditJsonSchema__AuditAppUser] FOREIGN KEY ( [AuditAppUser] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
);
GO

ALTER TABLE [audit].[AuditJsonSchema] CHECK CONSTRAINT [FK__AuditJsonSchema__AuditAppUser];
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [DF__AuditJsonSchema__AuditId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditId];
GO

ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [DF__AuditJsonSchema__AuditStatus] DEFAULT ( (1) ) FOR [AuditStatus];
GO

ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [DF__AuditJsonSchema__AuditAppUser] DEFAULT ( '1' ) FOR [AuditAppUser];
GO

ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [DF__AuditJsonSchema__AuditSqlUser] DEFAULT ( SUSER_SNAME() ) FOR [AuditSqlUser];
GO

ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [DF__AuditJsonSchema__AuditDate] DEFAULT ( GETUTCDATE() ) FOR [AuditDate];
GO

ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [DF__AuditJsonSchema__AuditBatchId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditBatchId];
GO

ALTER TABLE [audit].[AuditJsonSchema] ADD CONSTRAINT [DF__AuditJsonSchema__AuditOperation] DEFAULT ( 'Adhoc operation' ) FOR [AuditOperation];
GO

/* -------------------------------------------------------------------------- */
/* Extended Properties - Table Description */
EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Transactional auditing table for the parent table [HostName].',
  @level0type = N'SCHEMA',
  @level0name = N'audit',
  @level1type = N'TABLE',
  @level1name = N'AuditJsonSchema';
GO