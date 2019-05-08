/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[msgQueue].[ExecutionLog]') AND type in (N'U'))
DROP TABLE [msgQueue].[ExecutionLog]
GO
*/

CREATE TABLE [msgQueue].[ExecutionLog]
(
    [ExecutionLogId]   INT              NOT NULL IDENTITY(1,1)
  , [RowGuid]             UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [MessageQueueId]   INT              NOT NULL
  , [JsonSchemaName]   VARCHAR(64)      NOT NULL
  , [RowStatus]        TINYINT          NOT NULL
  , [RanByApplication] VARCHAR(32)      NOT NULL
  , [RanByHost]        VARCHAR(32)      NOT NULL
  , [RanOnDate]        DATETIMEOFFSET   NOT NULL
  , [RanByUser]        INT              NOT NULL
  , [Results]          NVARCHAR(4000)   NOT NULL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [PK__ExecutionLog] PRIMARY KEY CLUSTERED
(
  [ExecutionLogId] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* Column(s) [ExecutionLog].[JsonSchemaName] IS A FK TO [msgQueue].[JsonSchema].[JsonSchemaName] */
ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [FK__ExecutionLog__JsonSchema] FOREIGN KEY ( [JsonSchemaName] )
REFERENCES [msgQueue].[JsonSchema]
(
  [JsonSchemaName]
)
GO

ALTER TABLE [msgQueue].[ExecutionLog] CHECK CONSTRAINT [FK__ExecutionLog__JsonSchema]
GO

/* Column(s) [ExecutionLog].[MessageQueueId] IS A FK TO [msgQueue].[MessageQueue].[MessageQueueId] */
ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [FK__ExecutionLog__MessageQueueId] FOREIGN KEY ( [MessageQueueId] )
REFERENCES [msgQueue].[MessageQueue]
(
  [MessageQueueId]
)
GO

ALTER TABLE [msgQueue].[ExecutionLog] CHECK CONSTRAINT [FK__ExecutionLog__MessageQueueId]
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [DF__ExecutionLog__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [DF__ExecutionLog__RanByApplication] DEFAULT ( ('CFScheduler') ) FOR [RanByApplication]
GO

ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [DF__ExecutionLog__RanByHost] DEFAULT ( ('127.0.0.1') ) FOR [RanByHost]
GO

ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [DF__ExecutionLog__RanOnDate] DEFAULT ( (getutcdate()) ) FOR [RanOnDate]
GO

ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [DF__ExecutionLog__RanByUser] DEFAULT ( ((1)) ) FOR [RanByUser]
GO


/* -------------------------------------------------------------------------- */
/* Column Check Contraints */
ALTER TABLE [msgQueue].[ExecutionLog] ADD CONSTRAINT [CK__ExecutionLog__IsJson] CHECK ( (isjson([Results])=(1)) )
GO
ALTER TABLE [msgQueue].[ExecutionLog] CHECK CONSTRAINT [CK__ExecutionLog__IsJson]
GO


/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__ExecutionLog__RowGuid__Covering] ON [msgQueue].[ExecutionLog]
(
  [RowGuid] ASC
)
INCLUDE
(
    [ExecutionLogId]
  , [MessageQueueId]
  , [JsonSchemaName]
  , [RowStatus]
  , [RanByApplication]
  , [RanByHost]
  , [RanOnDate]
  , [RanByUser]
  , [Results]
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Column Descriptions */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Unique Row Guid, primary key',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'ExecutionLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Link to the Json message queue record for which these exection logs are related too.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'MessageQueueId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Link to the Json Schema document in which to validate this document by',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Status of the Message, 0 = Not Run, 1 = Currently Active, 2 = Reserved By Task Manager, 3 = Completed, 4 Error',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Name of the application which ultimately ran the message',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Name of the host which ultimately ran the message',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByHost'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Date time of when the message was run',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanOnDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Name of the user which ultimately ran the message',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByUser'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Results and / or messages from the execution of the message',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'Results'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ExecutionLogId',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'ExecutionLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'MessageQueueId',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'MessageQueueId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'JsonSchemaName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RanByApplication',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RanByHost',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByHost'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RanOnDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanOnDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RanByUser',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByUser'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'Results',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'Results'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ExecutionLogId',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'ExecutionLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for MessageQueueId',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'MessageQueueId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for JsonSchemaName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RanByApplication',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RanByHost',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByHost'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RanOnDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanOnDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RanByUser',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'RanByUser'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for Results',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog',
  @level2type=N'COLUMN',
  @level2name=N'Results'
GO

/* -------------------------------------------------------------------------- */
/* Table Description */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Transactional table.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'ExecutionLog'
GO