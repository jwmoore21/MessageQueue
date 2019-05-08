/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[eventLogs].[DatabaseErrorLog]') AND type in (N'U'))
DROP TABLE [eventLogs].[DatabaseErrorLog]
GO
*/

CREATE TABLE [eventLogs].[DatabaseErrorLog]
(
    [ErrorLogId]     INT              NOT NULL IDENTITY(1,1)
  , [RowStatus]      TINYINT          NOT NULL
  , [CreatedBy]      INT              NOT NULL
  , [CreatedDate]    DATETIMEOFFSET   NOT NULL
  , [RowGuid]        UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [ErrorNumber]    INT              NULL
  , [ErrorSeverity]  INT              NULL
  , [ErrorState]     INT              NULL
  , [ErrorLine]      INT              NULL
  , [DbName]   NVARCHAR(128)    NULL
  , [ErrorProcedure] NVARCHAR(128)    NULL
  , [ErrorMessage]   NVARCHAR(2048)   NULL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [eventLogs].[DatabaseErrorLog] ADD CONSTRAINT [PK__ErrorLogId] PRIMARY KEY CLUSTERED
(
  [ErrorLogId] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO
/* Foreign Key Constraints */

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [eventLogs].[DatabaseErrorLog] ADD CONSTRAINT [DF__DatabaseErrorLog__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [eventLogs].[DatabaseErrorLog] ADD CONSTRAINT [DF__DatabaseErrorLog__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [eventLogs].[DatabaseErrorLog] ADD CONSTRAINT [DF__DatabaseErrorLog__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [eventLogs].[DatabaseErrorLog] ADD CONSTRAINT [DF__DatabaseErrorLog__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO

/* -------------------------------------------------------------------------- */
/* Column Check Contraints */

/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__DatabaseErrorLog__RowGuid__Covering] ON [eventLogs].[DatabaseErrorLog]
(
  [RowGuid] ASC
)
INCLUDE
(
    [ErrorLogId]
  , [RowStatus]
  , [DbName]
  , [ErrorNumber]
  , [ErrorSeverity]
  , [ErrorState]
  , [ErrorLine]
  , [ErrorProcedure]
  , [ErrorMessage]
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
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The current application status of the record.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who initially created the record.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was initially created.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A unique key for the record. Also set as the SQL Server ROWGUIDCOL for record.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'SQL Error number',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorNumber'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'SQL Error Severity',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorSeverity'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorState'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorLine'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorProcedure'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorMessage'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ErrorLogId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ErrorNumber',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorNumber'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ErrorSeverity',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorSeverity'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ErrorState',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorState'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ErrorLine',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorLine'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ErrorProcedure',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorProcedure'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ErrorMessage',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorMessage'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ErrorLogId',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'ErrorLogId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

/* -------------------------------------------------------------------------- */
/* Table Description */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Transactional table.',
  @level0type=N'SCHEMA',
  @level0name=N'eventLogs',
  @level1type=N'TABLE',
  @level1name=N'DatabaseErrorLog'
GO