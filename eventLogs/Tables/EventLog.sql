/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[eventLogs].[EventLog]') AND type in (N'U'))
DROP TABLE [eventLogs].[EventLog]
GO
*/

CREATE TABLE [eventLogs].[EventLog]
(
    [EventLogId]       INT              NOT NULL IDENTITY(1,1)
  , [ApplicationId]    INT              NOT NULL
  , [ClientId]         INT              NOT NULL
  , [ServerId]         INT              NOT NULL
  , [RowStatus]        TINYINT          NOT NULL
  , [CreatedBy]        INT              NOT NULL
  , [CreatedDate]      DATETIMEOFFSET   NOT NULL
  , [RowGuid]             UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [EventType]        VARCHAR(255)     NOT NULL
  , [EventName]        VARCHAR(255)     NOT NULL
  , [EventDescription] VARCHAR(1000)    NULL
  , [EventDetails]     XML              NULL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [eventLogs].[EventLog] ADD CONSTRAINT [PK__EventLog] PRIMARY KEY CLUSTERED
(
  [EventLogId] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* Column(s) [EventLog].[EventType] IS A FK TO [masterLists].[EventType].[EventType] */
ALTER TABLE [eventLogs].[EventLog] ADD CONSTRAINT [FK__EventLog__EventType] FOREIGN KEY ( [EventType] )
REFERENCES [masterLists].[EventType]
(
  [EventType]
)
GO

ALTER TABLE [eventLogs].[EventLog] CHECK CONSTRAINT [FK__EventLog__EventType]
GO

/* Column(s) [EventLog].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [eventLogs].[EventLog] ADD CONSTRAINT [FK__EventLog__UserCreatedBy] FOREIGN KEY ( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [eventLogs].[EventLog] CHECK CONSTRAINT [FK__EventLog__UserCreatedBy]
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [eventLogs].[EventLog] ADD CONSTRAINT [DF__EventLog__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [eventLogs].[EventLog] ADD CONSTRAINT [DF__EventLog__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [eventLogs].[EventLog] ADD CONSTRAINT [DF__EventLog__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [eventLogs].[EventLog] ADD CONSTRAINT [DF__EventLog__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO


/* -------------------------------------------------------------------------- */
/* Column Check Contraints */

/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__EventLog__RowGuid__Covering] ON [eventLogs].[EventLog]
(
  [RowGuid] ASC
)
INCLUDE
(
    [EventLogId]
  , [ApplicationId]
  , [ClientId]
  , [ServerId]
  , [RowStatus]
  , [EventType]
  , [EventName]
  , [EventDescription]
  , [EventDetails]
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
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ApplicationId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ClientId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ServerId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The current application status of the record.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who initially created the record.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was initially created.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A unique key for the record. Also set as the SQL Server ROWGUIDCOL for record.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventType'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventDescription'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventDetails'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'EventLogId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ApplicationId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ApplicationId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ClientId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ClientId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ServerId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ServerId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'EventType',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventType'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'EventName',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'EventDescription',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventDescription'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'EventDetails',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventDetails'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for EventLogId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ApplicationId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ApplicationId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ClientId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ClientId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ServerId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'ServerId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for EventType',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventType'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for EventName',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog',
  @level2type=N'COLUMN',
  @level2name=N'EventName'
GO

/* -------------------------------------------------------------------------- */
/* Table Description */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Transactional table.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'EventLog'
GO