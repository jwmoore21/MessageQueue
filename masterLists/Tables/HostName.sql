/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[masterLists].[HostName]') AND type in (N'U'))
DROP TABLE [masterLists].[HostName]
GO
*/

CREATE TABLE [masterLists].[HostName]
(
    [HostName]       VARCHAR(63)      NOT NULL
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
ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [PK__HostName] PRIMARY KEY CLUSTERED
(
  [HostName] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* Column(s) [HostName].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [FK__HostName__Status] FOREIGN KEY ( [RowStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [masterLists].[HostName] CHECK CONSTRAINT [FK__HostName__Status]
GO

/* Column(s) [HostName].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [FK__HostName__UserCreatedBy] FOREIGN KEY ( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [masterLists].[HostName] CHECK CONSTRAINT [FK__HostName__UserCreatedBy]
GO

/* Column(s) [HostName].[ModifiedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [FK__HostName__UserModifiedBy] FOREIGN KEY ( [ModifiedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [masterLists].[HostName] CHECK CONSTRAINT [FK__HostName__UserModifiedBy]
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [DF__HostName__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [DF__HostName__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [DF__HostName__ModifiedBy] DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [DF__HostName__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [DF__HostName__ModifiedDate] DEFAULT ( GETUTCDATE() ) FOR [ModifiedDate]
GO

ALTER TABLE [masterLists].[HostName] ADD CONSTRAINT [DF__HostName__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO


/* -------------------------------------------------------------------------- */
/* Column Check Contraints */

/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__HostName__RowGuid__Covering] ON [masterLists].[HostName]
(
  [RowGuid] ASC
)
INCLUDE
(
    [HostName]
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
  @value=N'https://tools.ietf.org/html/rfc2181#section-11',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The current application status of the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who initially created the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who last modified the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was initially created.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was last modified.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A unique key for the record. Also set as the SQL Server ROWGUIDCOL for record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'HostName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for HostName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'HostName',
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
  @level1name=N'HostName'
GO