/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[masterLists].[DatabaseName]') AND type in (N'U'))
DROP TABLE [masterLists].[DatabaseName]
GO
*/

CREATE TABLE [masterLists].[DatabaseName]
(
    [DatabaseName]   NVARCHAR(128)    NOT NULL
  , [RowStatus]      TINYINT          NOT NULL
  , [CreatedBy]      INT              NOT NULL
  , [ModifiedBy]     INT              NOT NULL
  , [CreatedDate]    DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]   DATETIMEOFFSET   NOT NULL
  , [RowGuid]           UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [PK__DatabaseName] PRIMARY KEY CLUSTERED
(
  [DatabaseName] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* Column(s) [DatabaseName].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [FK__DatabaseName__Status] FOREIGN KEY ( [RowStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [masterLists].[DatabaseName] CHECK CONSTRAINT [FK__DatabaseName__Status]
GO

/* Column(s) [DatabaseName].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [FK__DatabaseName__UserCreatedBy] FOREIGN KEY ( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [masterLists].[DatabaseName] CHECK CONSTRAINT [FK__DatabaseName__UserCreatedBy]
GO

/* Column(s) [DatabaseName].[ModifiedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [FK__DatabaseName__UserModifiedBy] FOREIGN KEY ( [ModifiedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [masterLists].[DatabaseName] CHECK CONSTRAINT [FK__DatabaseName__UserModifiedBy]
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [DF__DatabaseName__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [DF__DatabaseName__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [DF__DatabaseName__ModifiedBy] DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [DF__DatabaseName__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [DF__DatabaseName__ModifiedDate] DEFAULT ( GETUTCDATE() ) FOR [ModifiedDate]
GO

ALTER TABLE [masterLists].[DatabaseName] ADD CONSTRAINT [DF__DatabaseName__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO


/* -------------------------------------------------------------------------- */
/* Column Check Contraints */

/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__DatabaseName__RowGuid__Covering] ON [masterLists].[DatabaseName]
(
  [RowGuid] ASC
)
INCLUDE
(
    [DatabaseName]
  , [RowStatus]
  , [ModifiedBy]
  , [ModifiedDate]
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
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The current application status of the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who initially created the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who last modified the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was initially created.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was last modified.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A unique key for the record. Also set as the SQL Server ROWGUIDCOL for record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'DatabaseName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for DatabaseName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

/* -------------------------------------------------------------------------- */
/* Table Description */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Transactional table.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'DatabaseName'
GO