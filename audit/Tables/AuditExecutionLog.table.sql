/*
IF EXISTS ( SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[audit].[AuditExecutionLog]') AND type in (N'U') )
DROP TABLE [audit].[AuditExecutionLog]
GO
*/

CREATE TABLE [audit].[AuditExecutionLog]
(
    [AuditId]          UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [AuditStatus]      TINYINT          NOT NULL
  , [AuditAppUser]     INT              NOT NULL
  , [AuditSqlUser]     VARCHAR(256)     NOT NULL
  , [AuditDate]        DATETIMEOFFSET   NOT NULL
  , [AuditBatchId]     UNIQUEIDENTIFIER NOT NULL
  , [AuditOperation]   VARCHAR(255)     NOT NULL
  , [ExecutionLogId]   INT              NULL
  , [RowGuid]          UNIQUEIDENTIFIER NULL
  , [MessageQueueId]   INT              NULL
  , [JsonSchemaName]   VARCHAR(64)      NULL
  , [RowStatus]        TINYINT          NULL
  , [RanByApplication] VARCHAR(32)      NULL
  , [RanByHost]        VARCHAR(32)      NULL
  , [RanOnDate]        DATETIMEOFFSET   NULL
  , [RanByUser]        INT              NULL
  , [Results]          NVARCHAR(4000)   NULL
);
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [PK__AuditExecutionLog] PRIMARY KEY CLUSTERED
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

/* Column(s) [AuditExecutionLog].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [FK__AuditExecutionLog__AuditStatus] FOREIGN KEY( [AuditStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [audit].[AuditExecutionLog] CHECK CONSTRAINT [FK__AuditExecutionLog__AuditStatus]
GO

/* Column(s) [AuditExecutionLog].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [FK__AuditExecutionLog__AuditAppUser] FOREIGN KEY ( [AuditAppUser] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
);
GO

ALTER TABLE [audit].[AuditExecutionLog] CHECK CONSTRAINT [FK__AuditExecutionLog__AuditAppUser];
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [DF__AuditExecutionLog__AuditId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditId];
GO

ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [DF__AuditExecutionLog__AuditStatus] DEFAULT ( (1) ) FOR [AuditStatus];
GO

ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [DF__AuditExecutionLog__AuditAppUser] DEFAULT ( '1' ) FOR [AuditAppUser];
GO

ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [DF__AuditExecutionLog__AuditSqlUser] DEFAULT ( SUSER_SNAME() ) FOR [AuditSqlUser];
GO

ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [DF__AuditExecutionLog__AuditDate] DEFAULT ( GETUTCDATE() ) FOR [AuditDate];
GO

ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [DF__AuditExecutionLog__AuditBatchId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditBatchId];
GO

ALTER TABLE [audit].[AuditExecutionLog] ADD CONSTRAINT [DF__AuditExecutionLog__AuditOperation] DEFAULT ( 'Adhoc operation' ) FOR [AuditOperation];
GO

/* -------------------------------------------------------------------------- */
/* Extended Properties - Table Description */
EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Transactional auditing table for the parent table [HostName].',
  @level0type = N'SCHEMA',
  @level0name = N'audit',
  @level1type = N'TABLE',
  @level1name = N'AuditExecutionLog';
GO