/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[msgQueue].[MessageQueue]') AND type in (N'U'))
DROP TABLE [msgQueue].[MessageQueue]
GO
*/

CREATE TABLE [msgQueue].[MessageQueue]
(
    [MessageQueueId]        INT              NOT NULL IDENTITY(1,1)
  , [JsonSchemaName]        VARCHAR(64)      NOT NULL
  , [RowStatus]             TINYINT          NOT NULL
  , [CreatedDate]           DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]          DATETIMEOFFSET   NOT NULL
  , [CreatedByApplication]  VARCHAR(32)      NOT NULL
  , [ModifiedByApplication] VARCHAR(32)      NOT NULL
  , [CreatedBy]             INT              NOT NULL
  , [ModifiedBy]            INT              NOT NULL
  , [RowGuid]               UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [RunAgainstPort]        INT              NOT NULL
  , [HttpVerb]              VARCHAR(8)       NOT NULL
  , [ccTLD]                 CHAR(3)          NOT NULL
  , [SecondLevelDomain]     VARCHAR(16)      NOT NULL
  , [TopLevelDomain]        VARCHAR(24)      NOT NULL
  , [DomainName]            VARCHAR(188)     NOT NULL
  , [SubHostName]           VARCHAR(63)      NOT NULL
  , [HostName]              VARCHAR(63)      NOT NULL
  , [ScriptName]            VARCHAR(128)     NULL
  , [Datasource]            VARCHAR(255)     NULL
  , [DatabaseName]          NVARCHAR(128)    NULL
  , [DatabaseSchema]        NVARCHAR(128)    NULL
  , [DatabaseTable]         NVARCHAR(128)    NULL
  , [JsonDocument]          NVARCHAR(4000)   NOT NULL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [PK__MessageQueue] PRIMARY KEY CLUSTERED
(
  [MessageQueueId] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* Column(s) [MessageQueue].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__CreatedBy] FOREIGN KEY ( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__CreatedBy]
GO

/* Column(s) [MessageQueue].[DatabaseName] IS A FK TO [masterLists].[DatabaseName].[DatabaseName] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__DatabaseName] FOREIGN KEY ( [DatabaseName] )
REFERENCES [masterLists].[DatabaseName]
(
  [DatabaseName]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__DatabaseName]
GO

/* Column(s) [MessageQueue].[DatabaseSchema] IS A FK TO [masterLists].[DatabaseSchema].[DatabaseSchema] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__DatabaseSchema] FOREIGN KEY ( [DatabaseSchema] )
REFERENCES [masterLists].[DatabaseSchema]
(
  [DatabaseSchema]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__DatabaseSchema]
GO

/* Column(s) [MessageQueue].[DatabaseTable] IS A FK TO [masterLists].[DatabaseTable].[DatabaseTable] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__DatabaseTable] FOREIGN KEY ( [DatabaseTable] )
REFERENCES [masterLists].[DatabaseTable]
(
  [DatabaseTable]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__DatabaseTable]
GO

/* Column(s) [MessageQueue].[Datasource] IS A FK TO [masterLists].[Datasource].[Datasource] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__Datasource] FOREIGN KEY ( [Datasource] )
REFERENCES [masterLists].[Datasource]
(
  [Datasource]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__Datasource]
GO

/* Column(s) [MessageQueue].[ccTLD], [SecondLevelDomain], [TopLevelDomain], [DomainName], [SubHostName], [HostName] IS A FK TO [masterLists].[FullyQualifiedDomainName].[ccTLD], [SecondLevelDomain], [TopLevelDomain], [DomainName], [SubHostName], [HostName] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__FullyQualifiedDomainName] FOREIGN KEY ( [ccTLD], [SecondLevelDomain], [TopLevelDomain], [DomainName], [SubHostName], [HostName] )
REFERENCES [masterLists].[FullyQualifiedDomainName]
(
    [ccTLD]
  , [SecondLevelDomain]
  , [TopLevelDomain]
  , [DomainName]
  , [SubHostName]
  , [HostName]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__FullyQualifiedDomainName]
GO

/* Column(s) [MessageQueue].[HttpVerb] IS A FK TO [masterLists].[HttpVerb].[HttpVerb] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__HttpVerb] FOREIGN KEY ( [HttpVerb] )
REFERENCES [masterLists].[HttpVerb]
(
  [HttpVerb]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__HttpVerb]
GO

/* Column(s) [MessageQueue].[JsonSchemaName] IS A FK TO [msgQueue].[JsonSchema].[JsonSchemaName] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__JsonSchema] FOREIGN KEY ( [JsonSchemaName] )
REFERENCES [msgQueue].[JsonSchema]
(
  [JsonSchemaName]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__JsonSchema]
GO

/* Column(s) [MessageQueue].[ModifiedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__ModifiedBy] FOREIGN KEY ( [ModifiedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__ModifiedBy]
GO

/* Column(s) [MessageQueue].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__RowStatus] FOREIGN KEY ( [RowStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__RowStatus]
GO

/* Column(s) [MessageQueue].[ScriptName] IS A FK TO [masterLists].[ScriptName].[ScriptName] */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [FK__MessageQueue__ScriptName] FOREIGN KEY ( [ScriptName] )
REFERENCES [masterLists].[ScriptName]
(
  [ScriptName]
)
GO

ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [FK__MessageQueue__ScriptName]
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__ModifiedDate] DEFAULT ( GETUTCDATE() ) FOR [ModifiedDate]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__CreatedByApplication] DEFAULT ( ('ServicesTool') ) FOR [CreatedByApplication]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__ModifiedByApplication] DEFAULT ( ('ServicesTool') ) FOR [ModifiedByApplication]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__ModifiedBy] DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__RunAgainstPort] DEFAULT ( ((1433)) ) FOR [RunAgainstPort]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__HttpVerb] DEFAULT ( ('GET') ) FOR [HttpVerb]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__ccTLD] DEFAULT ( ('.') ) FOR [ccTLD]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__SecondLevelDomain] DEFAULT ( ('.') ) FOR [SecondLevelDomain]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__TopLevelDomain] DEFAULT ( ('.') ) FOR [TopLevelDomain]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__DomainName] DEFAULT ( ('.') ) FOR [DomainName]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__SubHostName] DEFAULT ( ('.') ) FOR [SubHostName]
GO

ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [DF__MessageQueue__HostName] DEFAULT ( ('.') ) FOR [HostName]
GO


/* -------------------------------------------------------------------------- */
/* Column Check Contraints */
ALTER TABLE [msgQueue].[MessageQueue] ADD CONSTRAINT [CK__MessageQueue__IsJson] CHECK ( (isjson([JsonDocument])=(1)) )
GO
ALTER TABLE [msgQueue].[MessageQueue] CHECK CONSTRAINT [CK__MessageQueue__IsJson]
GO


/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__MessageQueue__RowGuid__Covering] ON [msgQueue].[MessageQueue]
(
  [RowGuid] ASC
)
INCLUDE
(
    [MessageQueueId]
  , [JsonSchemaName]
  , [RowStatus]
  , [ModifiedDate]
  , [CreatedByApplication]
  , [ModifiedByApplication]
  , [ModifiedBy]
  , [RunAgainstPort]
  , [HttpVerb]
  , [ccTLD]
  , [SecondLevelDomain]
  , [TopLevelDomain]
  , [DomainName]
  , [SubHostName]
  , [HostName]
  , [ScriptName]
  , [Datasource]
  , [DatabaseName]
  , [DatabaseSchema]
  , [DatabaseTable]
  , [JsonDocument]
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
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'MessageQueueId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Link to the Json Schema document in which to validate this document by',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Status of the Message, 0 = Not Run, 1 = Currently Active, 2 = Reserved By Task Manager, 3 = Completed',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Initial Date this record was created',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Latest Date time this record was modified',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Application which created this record',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Application which last modified this record',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'User which created this record',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'User which last modified this record',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A Batch Id to help identify messages added to the queue during a bulk process. Defaults to a unique id.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The SQL Server TCP/IP Port number on which the data should be run against.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RunAgainstPort'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'HTTP Verb of what we are to execute, POST, GET, PUT, PATCH or DELETE',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'HttpVerb'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Composite key of the fully qualified domain name where the SQL server is located to run this data against.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Composite key of the fully qualified domain name where the SQL server is located to run this data against.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'SecondLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Composite key of the fully qualified domain name where the SQL server is located to run this data against.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'TopLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Composite key of the fully qualified domain name where the SQL server is located to run this data against.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DomainName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Composite key of the fully qualified domain name where the SQL server is located to run this data against.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'SubHostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Composite key of the fully qualified domain name where the SQL server is located to run this data against.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The name of a custom script to be run against the data in the Json document. The application pulling this record from the queue must have knowledge of the script specified.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ScriptName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A custom datasource to be used by the application pulling this record from the queue to process.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'Datasource'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A specific database in which to run the data in the Json document against. The application pulling this record from the queue to process must have knowledge of this database.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A specific database schema in which to run the data in the Json document against. The application pulling this record from the queue to process must have knowledge of this schema.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseSchema'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A specific database table in which to run the data in the Json document against. The application pulling this record from the queue to process must have knowledge of this table.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseTable'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The Json document of the message we are to run',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'JsonDocument'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'MessageQueueId',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'MessageQueueId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'JsonSchemaName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedByApplication',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedByApplication',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RunAgainstPort',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RunAgainstPort'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'HttpVerb',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'HttpVerb'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ccTLD',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'SecondLevelDomain',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'SecondLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'TopLevelDomain',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'TopLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'DomainName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DomainName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'SubHostName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'SubHostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'HostName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ScriptName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ScriptName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'Datasource',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'Datasource'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'DatabaseName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'DatabaseSchema',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseSchema'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'DatabaseTable',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DatabaseTable'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'JsonDocument',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'JsonDocument'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for MessageQueueId',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'MessageQueueId'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for JsonSchemaName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedByApplication',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedByApplication',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedByApplication'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RunAgainstPort',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'RunAgainstPort'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for HttpVerb',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'HttpVerb'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ccTLD',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'ccTLD'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for SecondLevelDomain',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'SecondLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for TopLevelDomain',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'TopLevelDomain'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for DomainName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'DomainName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for SubHostName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'SubHostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for HostName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'HostName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for JsonDocument',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue',
  @level2type=N'COLUMN',
  @level2name=N'JsonDocument'
GO

/* -------------------------------------------------------------------------- */
/* Table Description */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Transactional table.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueue'
GO