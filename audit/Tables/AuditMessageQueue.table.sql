/*
IF EXISTS ( SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[audit].[AuditMessageQueue]') AND type in (N'U') )
DROP TABLE [audit].[AuditMessageQueue]
GO
*/

CREATE TABLE [audit].[AuditMessageQueue]
(
    [AuditId]               UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [AuditStatus]           TINYINT          NOT NULL
  , [AuditAppUser]          INT              NOT NULL
  , [AuditSqlUser]          VARCHAR(256)     NOT NULL
  , [AuditDate]             DATETIMEOFFSET   NOT NULL
  , [AuditBatchId]          UNIQUEIDENTIFIER NOT NULL
  , [AuditOperation]        VARCHAR(255)     NOT NULL
  , [MessageQueueId]        INT              NULL 
  , [JsonSchemaName]        VARCHAR(64)      NULL
  , [RowStatus]             TINYINT          NULL
  , [CreatedDate]           DATETIMEOFFSET   NULL
  , [ModifiedDate]          DATETIMEOFFSET   NULL
  , [CreatedByApplication]  VARCHAR(32)      NULL
  , [ModifiedByApplication] VARCHAR(32)      NULL
  , [CreatedBy]             INT              NULL
  , [ModifiedBy]            INT              NULL
  , [RowGuid]               UNIQUEIDENTIFIER NULL 
  , [RunAgainstPort]        INT              NULL
  , [HttpVerb]              VARCHAR(8)       NULL
  , [ccTLD]                 CHAR(3)          NULL
  , [SecondLevelDomain]     VARCHAR(16)      NULL
  , [TopLevelDomain]        VARCHAR(24)      NULL
  , [DomainName]            VARCHAR(188)     NULL
  , [SubHostName]           VARCHAR(63)      NULL
  , [HostName]              VARCHAR(63)      NULL
  , [ScriptName]            VARCHAR(128)     NULL
  , [Datasource]            VARCHAR(255)     NULL
  , [DatabaseName]          NVARCHAR(128)    NULL
  , [DatabaseSchema]        NVARCHAR(128)    NULL
  , [DatabaseTable]         NVARCHAR(128)    NULL
  , [JsonDocument]          NVARCHAR(4000)   NULL
);
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [PK__AuditMessageQueue] PRIMARY KEY CLUSTERED
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

/* Column(s) [AuditMessageQueue].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [FK__AuditMessageQueue__AuditStatus] FOREIGN KEY( [AuditStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [audit].[AuditMessageQueue] CHECK CONSTRAINT [FK__AuditMessageQueue__AuditStatus]
GO

/* Column(s) [AuditMessageQueue].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [FK__AuditMessageQueue__AuditAppUser] FOREIGN KEY ( [AuditAppUser] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
);
GO

ALTER TABLE [audit].[AuditMessageQueue] CHECK CONSTRAINT [FK__AuditMessageQueue__AuditAppUser];
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [DF__AuditMessageQueue__AuditId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditId];
GO

ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [DF__AuditMessageQueue__AuditStatus] DEFAULT ( (1) ) FOR [AuditStatus];
GO

ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [DF__AuditMessageQueue__AuditAppUser] DEFAULT ( '1' ) FOR [AuditAppUser];
GO

ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [DF__AuditMessageQueue__AuditSqlUser] DEFAULT ( SUSER_SNAME() ) FOR [AuditSqlUser];
GO

ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [DF__AuditMessageQueue__AuditDate] DEFAULT ( GETUTCDATE() ) FOR [AuditDate];
GO

ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [DF__AuditMessageQueue__AuditBatchId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditBatchId];
GO

ALTER TABLE [audit].[AuditMessageQueue] ADD CONSTRAINT [DF__AuditMessageQueue__AuditOperation] DEFAULT ( 'Adhoc operation' ) FOR [AuditOperation];
GO

/* -------------------------------------------------------------------------- */
/* Extended Properties - Table Description */
EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Transactional auditing table for the parent table [HostName].',
  @level0type = N'SCHEMA',
  @level0name = N'audit',
  @level1type = N'TABLE',
  @level1name = N'AuditMessageQueue';
GO