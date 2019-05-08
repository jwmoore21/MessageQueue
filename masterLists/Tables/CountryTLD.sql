/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[masterLists].[CountryTLD]') AND type in (N'U'))
DROP TABLE [masterLists].[CountryTLD]
GO
*/

CREATE TABLE [masterLists].[CountryTLD]
(
    [ccTLD]          CHAR(3)          NOT NULL
  , [RowStatus]      TINYINT          NOT NULL
  , [CreatedBy]      INT              NOT NULL
  , [ModifiedBy]     INT              NOT NULL
  , [CreatedDate]    DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]   DATETIMEOFFSET   NOT NULL
  , [RowGuid]           UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [Entity]         VARCHAR(128)     NULL
  , [Notes]          VARCHAR(2000)    NULL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [PK__CountryTLD] PRIMARY KEY CLUSTERED
(
  [ccTLD] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* Column(s) [CountryTLD].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [FK__CountryTLD__Status] FOREIGN KEY ( [RowStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [masterLists].[CountryTLD] CHECK CONSTRAINT [FK__CountryTLD__Status]
GO

/* Column(s) [CountryTLD].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [FK__CountryTLD__UserCreatedBy] FOREIGN KEY ( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [masterLists].[CountryTLD] CHECK CONSTRAINT [FK__CountryTLD__UserCreatedBy]
GO

/* Column(s) [CountryTLD].[ModifiedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [FK__CountryTLD__UserModifiedBy] FOREIGN KEY ( [ModifiedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [masterLists].[CountryTLD] CHECK CONSTRAINT [FK__CountryTLD__UserModifiedBy]
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [DF__CountryTLD__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [DF__CountryTLD__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [DF__CountryTLD__ModifiedBy] DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [DF__CountryTLD__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [DF__CountryTLD__ModifiedDate] DEFAULT ( GETUTCDATE() ) FOR [ModifiedDate]
GO

ALTER TABLE [masterLists].[CountryTLD] ADD CONSTRAINT [DF__CountryTLD__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO


/* -------------------------------------------------------------------------- */
/* Column Check Contraints */

/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__CountryTLD__RowGuid__Covering] ON [masterLists].[CountryTLD]
(
  [RowGuid] ASC
)
INCLUDE
(
    [ccTLD]
  , [RowStatus]
  , [ModifiedBy]
  , [ModifiedDate]
  , [Entity]
  , [Notes]
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
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The current application status of the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who initially created the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who last modified the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was initially created.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was last modified.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A unique key for the record. Also set as the SQL Server ROWGUIDCOL for record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'Entity'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'Notes'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ccTLD',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'Entity',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'Entity'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'Notes',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'Notes'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ccTLD',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'CountryTLD',
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
  @level1name=N'CountryTLD'
GO