CREATE TABLE [msgQueue].[MessageQueueJsonSchema]
(
    [MessageQueueJsonSchemaId] INT NOT NULL 
  , [JsonSchemaName]        VARCHAR(64)      NOT NULL
  , [RowStatus]             TINYINT          NOT NULL
  , [CreatedDate]           DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]          DATETIMEOFFSET   NOT NULL
  , [CreatedByApplication]  VARCHAR(32)      NOT NULL
  , [ModifiedByApplication] VARCHAR(32)      NOT NULL
  , [CreatedBy]             INT              NOT NULL
  , [ModifiedBy]            INT              NOT NULL
  , [RowGuid]               UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [JsonDocument]          NVARCHAR(4000)   NOT NULL
  CONSTRAINT [PK__MessageQueueJsonSchema] PRIMARY KEY CLUSTERED
  (
    [MessageQueueJsonSchemaId] ASC
  )
  WITH
  (
    PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
  ) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Column Defaults */
ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [DF__MessageQueueJsonSchema__RowStatus]  DEFAULT ((0)) FOR [RowStatus]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [DF__MessageQueueJsonSchema__CreatedDate]  DEFAULT (GETUTCDATE()) FOR [CreatedDate]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [DF__MessageQueueJsonSchema__ModifiedDate]  DEFAULT (GETUTCDATE()) FOR [ModifiedDate]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [DF__MessageQueueJsonSchema__CreatedByApplication]  DEFAULT ('ServicesTool') FOR [CreatedByApplication]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [DF__MessageQueueJsonSchema__ModifiedByApplication]  DEFAULT ('ServicesTool') FOR [ModifiedByApplication]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [DF__MessageQueueJsonSchema__CreatedBy]  DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [DF__MessageQueueJsonSchema__ModifiedBy]  DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [DF__MessageQueueJsonSchema__RowGuid]  DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO

/* Foreign Keys */
ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [FK__MessageQueueJsonSchema__JsonSchema] FOREIGN KEY([JsonSchemaName])
REFERENCES [msgQueue].[JsonSchema] ([JsonSchemaName])
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] CHECK CONSTRAINT [FK__MessageQueueJsonSchema__JsonSchema]
GO

/* Column(s) [msgQueue].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [FK__MessageQueueJsonSchema__RowStatus] FOREIGN KEY([RowStatus])
REFERENCES [masterLists].[Status] ([RowStatus])
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] CHECK CONSTRAINT [FK__MessageQueueJsonSchema__JsonSchema]
GO

/* Column(s) [msgQueue].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [FK__MessageQueueJsonSchema__CreatedBy] FOREIGN KEY( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] CHECK CONSTRAINT [FK__MessageQueueJsonSchema__CreatedBy]
GO

/* Column(s) [msgQueue].[ModifiedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [FK__MessageQueueJsonSchema__ModifiedBy] FOREIGN KEY( [ModifiedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] CHECK CONSTRAINT [FK__MessageQueueJsonSchema__ModifiedBy]
GO

/* Check Contraints */
ALTER TABLE [msgQueue].[MessageQueueJsonSchema] ADD CONSTRAINT [CK__MessageQueueJsonSchema__IsJson] CHECK ((isjson([JsonDocument])=(1)))
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchema] CHECK CONSTRAINT [CK__MessageQueueJsonSchema__IsJson]
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Validates that the data in the MessageQueueJsonSchema column is a properly formated Json document.' ,
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueueJsonSchema',
  @level2type=N'CONSTRAINT',
  @level2name=N'CK__MessageQueueJsonSchema__IsJson'
GO

/* Column Descriptions */
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Unique Row Guid, primary key',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = N'MessageQueueJsonSchemaId'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Link to the Json Schema document in which to validate this document by',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = N'JsonSchemaName'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Status of the Message, 0 = Not Run, 1 = Currently Active, 2 = Reserved By Task Manager, 3 = Completed',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = N'RowStatus'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Initial Date this record was created',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = N'CreatedDate'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Latest Date time this record was modified',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = N'ModifiedDate'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Application which created this record',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = N'CreatedByApplication'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Application which last modified this record',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = N'ModifiedByApplication'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'User which created this record',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = N'CreatedBy'
GO
EXEC sp_addextendedproperty 
  @name = N'MS_Description',
  @value = N'User which last modified this record',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = 'ModifiedBy'
GO
EXEC sp_addextendedproperty 
  @name = N'MS_Description',
  @value = N'A Batch Id to help identify messages added to the queue during a bulk process. Defaults to a unique id.',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchema',
  @level2type = N'COLUMN',
  @level2name = 'RowGuid'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'The Json document of the message we are to run',
    @level0type = N'SCHEMA',
    @level0name = N'msgQueue',
    @level1type = N'TABLE',
    @level1name = N'MessageQueueJsonSchema',
    @level2type = N'COLUMN',
    @level2name = N'JsonDocument'
GO


/* Table Description */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Messaging table designed to hold Json documents to be processed by a scheudler. Designed to be language angnostic, CFML, RabbitMQ, C# etc can all use this message table. Data to be run against a SQL Server, not NOSQL.' ,
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'MessageQueueJsonSchema'
GO
