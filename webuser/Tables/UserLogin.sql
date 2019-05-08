/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[webuser].[UserLogin]') AND type in (N'U'))
DROP TABLE [webuser].[UserLogin]
GO
*/

CREATE TABLE [webuser].[UserLogin]
(
    [UserId]            INT              NOT NULL 
  , [RowStatus]         TINYINT          NOT NULL
  , [CreatedBy]         INT              NULL
  , [ModifiedBy]        INT              NULL
  , [CreatedDate]       DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]      DATETIMEOFFSET   NOT NULL
  , [RowGuid]           UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [Username]          VARCHAR(64)      MASKED WITH ( FUNCTION = 'default()' ) NOT NULL
  , [Password]          VARCHAR(255)     NOT NULL
  , [Id]                VARCHAR(255)     NOT NULL
  , [IntegrationUser]   SYSNAME          MASKED WITH ( FUNCTION = 'default()' ) NOT NULL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [PK__UserLogin] PRIMARY KEY CLUSTERED
(
  [UserId] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* Column(s) [UserLogin].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [FK__UserLogin__CreatedBy] FOREIGN KEY ( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [webuser].[UserLogin] CHECK CONSTRAINT [FK__UserLogin__CreatedBy]
GO

/* Column(s) [UserLogin].[ModifiedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [FK__UserLogin__ModifiedBy] FOREIGN KEY ( [ModifiedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [webuser].[UserLogin] CHECK CONSTRAINT [FK__UserLogin__ModifiedBy]
GO

/* Column(s) [UserLogin].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [FK__UserLogin__RowStatus] FOREIGN KEY ( [RowStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [webuser].[UserLogin] CHECK CONSTRAINT [FK__UserLogin__RowStatus]
GO


/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [DF__UserLogin__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [DF__UserLogin__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [DF__UserLogin__ModifiedBy] DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [DF__UserLogin__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [DF__UserLogin__ModifiedDate] DEFAULT ( GETUTCDATE() ) FOR [ModifiedDate]
GO

ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [DF__UserLogin__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO

ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [DF__UserLogin__IntegrationUser] DEFAULT ( ('cfapplication') ) FOR [IntegrationUser]
GO

/* -------------------------------------------------------------------------- */
/* Column Check Contraints */
ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [CK__UserLogin__Password] CHECK ( (NOT [Password] like ('%(?=^.{12,25}$)(?=(?:.*?\d){2})(?=.*[a-z])(?=(?:.*?[A-Z]){2})(?=(?:.*?[!@#$%*()_+^&}{:;?.]){2})(?!.*\s)[0-9a-zA-Z!@#$%*()_+^&]*$%') collate SQL_Latin1_General_CP1_CS_AS) )
GO
ALTER TABLE [webuser].[UserLogin] CHECK CONSTRAINT [CK__UserLogin__Password]
GO

ALTER TABLE [webuser].[UserLogin] ADD CONSTRAINT [CK__UserLogin__Username] CHECK ( (NOT [Username] like ('%[^a-zA-Z0-9]%') collate SQL_Latin1_General_CP1_CS_AS) )
GO
ALTER TABLE [webuser].[UserLogin] CHECK CONSTRAINT [CK__UserLogin__Username]
GO


/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__UserLogin__Username] ON [webuser].[UserLogin]
(
    [Username] ASC
)
WITH
(
  PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [UNQ__UserLogin__RowGuid__Covering] ON [webuser].[UserLogin]
(
  [RowGuid] ASC
)
INCLUDE
(
    [UserId]
  , [RowStatus]
  , [ModifiedBy]
  , [ModifiedDate]
  , [Username]
  , [Password]
  , [Id]
  , [IntegrationUser]
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
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'UserId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The current application status of the record.',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who initially created the record.',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The application user id who last modified the record.',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was initially created.',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The date and time of when the record was last modified.',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A unique key for the record. Also set as the SQL Server ROWGUIDCOL for record.',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Web application username',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Username'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Password'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'SQL User to which this web application user is assigned',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'IntegrationUser'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'UserId',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'UserId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'Username',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Username'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'Password',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Password'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'Id',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'SQL Integration User',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'IntegrationUser'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for UserId',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'UserId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for Username',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Username'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for Password',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Password'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for Id',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a SQL user in which this web application user will be integrated with.',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin',
  @level2type=N'COLUMN',
  @level2name=N'IntegrationUser'
GO

/* -------------------------------------------------------------------------- */
/* Table Description */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Transactional table.',
  @level0type=N'SCHEMA',
  @level0name=N'webuser',
  @level1type=N'TABLE',
  @level1name=N'UserLogin'
GO