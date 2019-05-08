/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[masterLists].[FullyQualifiedDomainName]') AND type in (N'U'))
DROP TABLE [masterLists].[FullyQualifiedDomainName]
GO
*/

CREATE TABLE [masterLists].[FullyQualifiedDomainName]
(
    [ccTLD]             CHAR(3)          NOT NULL
  , [SecondLevelDomain] VARCHAR(16)      NOT NULL
  , [TopLevelDomain]    VARCHAR(24)      NOT NULL
  , [DomainName]        VARCHAR(188)     NOT NULL
  , [SubHostName]       VARCHAR(63)      NOT NULL
  , [HostName]          VARCHAR(63)      NOT NULL
  , [RowStatus]         TINYINT          NOT NULL
  , [CreatedBy]         INT              NOT NULL
  , [ModifiedBy]        INT              NOT NULL
  , [CreatedDate]       DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]      DATETIMEOFFSET   NOT NULL
  , [RowGuid]              UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [PK__FullyQualifiedDomainName] PRIMARY KEY CLUSTERED
(
  [ccTLD] ASC,
  [SecondLevelDomain] ASC,
  [TopLevelDomain] ASC,
  [DomainName] ASC,
  [SubHostName] ASC,
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

/* Column(s) [FullyQualifiedDomainName].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [FK__FullyQualifiedDomainName__CreatedBy] FOREIGN KEY ( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] CHECK CONSTRAINT [FK__FullyQualifiedDomainName__CreatedBy]
GO

/* Column(s) [FullyQualifiedDomainName].[DomainName] IS A FK TO [masterLists].[DomainName].[DomainName] */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [FK__FullyQualifiedDomainName__DomainName] FOREIGN KEY ( [DomainName] )
REFERENCES [masterLists].[DomainName]
(
  [DomainName]
)
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] CHECK CONSTRAINT [FK__FullyQualifiedDomainName__DomainName]
GO

/* Column(s) [FullyQualifiedDomainName].[HostName] IS A FK TO [masterLists].[HostName].[HostName] */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [FK__FullyQualifiedDomainName__HostName] FOREIGN KEY ( [HostName] )
REFERENCES [masterLists].[HostName]
(
  [HostName]
)
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] CHECK CONSTRAINT [FK__FullyQualifiedDomainName__HostName]
GO

/* Column(s) [FullyQualifiedDomainName].[ModifiedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [FK__FullyQualifiedDomainName__ModifiedBy] FOREIGN KEY ( [ModifiedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] CHECK CONSTRAINT [FK__FullyQualifiedDomainName__ModifiedBy]
GO

/* Column(s) [FullyQualifiedDomainName].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [FK__FullyQualifiedDomainName__RowStatus] FOREIGN KEY ( [RowStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] CHECK CONSTRAINT [FK__FullyQualifiedDomainName__RowStatus]
GO

/* Column(s) [FullyQualifiedDomainName].[SecondLevelDomain], [ccTLD] IS A FK TO [masterLists].[SecondLevelDomain].[SecondLevelDomain], [ccTLD] */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [FK__FullyQualifiedDomainName__SecondLevelDomain] FOREIGN KEY ( [SecondLevelDomain], [ccTLD] )
REFERENCES [masterLists].[SecondLevelDomain]
(
    [SecondLevelDomain]
  , [ccTLD]
)
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] CHECK CONSTRAINT [FK__FullyQualifiedDomainName__SecondLevelDomain]
GO

/* Column(s) [FullyQualifiedDomainName].[SubHostName] IS A FK TO [masterLists].[SubHostName].[SubHostName] */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [FK__FullyQualifiedDomainName__SubHostName] FOREIGN KEY ( [SubHostName] )
REFERENCES [masterLists].[SubHostName]
(
  [SubHostName]
)
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] CHECK CONSTRAINT [FK__FullyQualifiedDomainName__SubHostName]
GO

/* Column(s) [FullyQualifiedDomainName].[TopLevelDomain] IS A FK TO [masterLists].[TopLevelDomain].[TopLevelDomain] */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [FK__FullyQualifiedDomainName__TopLevelDomain] FOREIGN KEY ( [TopLevelDomain] )
REFERENCES [masterLists].[TopLevelDomain]
(
  [TopLevelDomain]
)
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] CHECK CONSTRAINT [FK__FullyQualifiedDomainName__TopLevelDomain]
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [DF__FullyQualifiedDomainName__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [DF__FullyQualifiedDomainName__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [DF__FullyQualifiedDomainName__ModifiedBy] DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [DF__FullyQualifiedDomainName__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [DF__FullyQualifiedDomainName__ModifiedDate] DEFAULT ( GETUTCDATE() ) FOR [ModifiedDate]
GO

ALTER TABLE [masterLists].[FullyQualifiedDomainName] ADD CONSTRAINT [DF__FullyQualifiedDomainName__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO


/* -------------------------------------------------------------------------- */
/* Column Check Contraints */

/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__FullyQualifiedDomainName__RowGuid__Covering] ON [masterLists].[FullyQualifiedDomainName]
(
  [RowGuid] ASC
)
INCLUDE
(
    [ccTLD]
  , [SecondLevelDomain]
  , [TopLevelDomain]
  , [DomainName]
  , [SubHostName]
  , [HostName]
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
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'SecondLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'TopLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'DomainName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'SubHostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The current application status of the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who initially created the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who last modified the record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was initially created.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was last modified.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A unique key for the record. Also set as the SQL Server ROWGUIDCOL for record.',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ccTLD',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'SecondLevelDomain',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'SecondLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'TopLevelDomain',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'TopLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'DomainName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'DomainName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'SubHostName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'SubHostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'HostName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ccTLD',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for SecondLevelDomain',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'SecondLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for TopLevelDomain',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'TopLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for DomainName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'DomainName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for SubHostName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'SubHostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for HostName',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'masterLists',
  @level1type=N'TABLE',
  @level1name=N'FullyQualifiedDomainName',
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
  @level1name=N'FullyQualifiedDomainName'
GO