CREATE TABLE [msgQueue].[MessageQueueJsonSchemaBasic]
(
    [MessageQueueJsonSchemaBasicId] INT NOT NULL IDENTITY(1,1)
  , [RowStatus]             TINYINT          NOT NULL
  , [CreatedDate]           DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]          DATETIMEOFFSET   NOT NULL
  , [CreatedByApplication]  VARCHAR(32)      NOT NULL
  , [ModifiedByApplication] VARCHAR(32)      NOT NULL
  , [CreatedBy]             INT              NOT NULL
  , [ModifiedBy]            INT              NOT NULL
  , [RowGuid]               UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [JsonDocument]          NVARCHAR(4000)   NOT NULL
  CONSTRAINT [PK__MessageQueueJsonSchemaBasic] PRIMARY KEY CLUSTERED
  (
    [MessageQueueJsonSchemaBasicId] ASC
  )
  WITH
  (
    PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
  ) ON [PRIMARY]
) ON [PRIMARY]
GO

/* Column Defaults */

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [DF__MessageQueueJsonSchemaBasic__RowStatus]  DEFAULT ((0)) FOR [RowStatus]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [DF__MessageQueueJsonSchemaBasic__CreatedDate]  DEFAULT (GETUTCDATE()) FOR [CreatedDate]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [DF__MessageQueueJsonSchemaBasic__ModifiedDate]  DEFAULT (GETUTCDATE()) FOR [ModifiedDate]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [DF__MessageQueueJsonSchemaBasic__CreatedByApplication]  DEFAULT ('ServicesTool') FOR [CreatedByApplication]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [DF__MessageQueueJsonSchemaBasic__ModifiedByApplication]  DEFAULT ('ServicesTool') FOR [ModifiedByApplication]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [DF__MessageQueueJsonSchemaBasic__CreatedBy]  DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [DF__MessageQueueJsonSchemaBasic__ModifiedBy]  DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [DF__MessageQueueJsonSchemaBasic__RowGuid]  DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO

/* Column(s) [msgQueue].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [FK__MessageQueueJsonSchemaBasic__RowStatus] FOREIGN KEY([RowStatus])
REFERENCES [masterLists].[Status] ([RowStatus])
GO


/* Column(s) [msgQueue].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [FK__MessageQueueJsonSchemaBasic__CreatedBy] FOREIGN KEY( [CreatedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] CHECK CONSTRAINT [FK__MessageQueueJsonSchemaBasic__CreatedBy]
GO

/* Column(s) [msgQueue].[ModifiedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] ADD CONSTRAINT [FK__MessageQueueJsonSchemaBasic__ModifiedBy] FOREIGN KEY( [ModifiedBy] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
)
GO

ALTER TABLE [msgQueue].[MessageQueueJsonSchemaBasic] CHECK CONSTRAINT [FK__MessageQueueJsonSchemaBasic__ModifiedBy]
GO

/* Column Descriptions */
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Unique Row Guid, primary key',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = N'MessageQueueJsonSchemaBasicId'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Status of the Message, 0 = Not Run, 1 = Currently Active, 2 = Reserved By Task Manager, 3 = Completed',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = N'RowStatus'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Initial Date this record was created',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = N'CreatedDate'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Latest Date time this record was modified',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = N'ModifiedDate'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Application which created this record',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = N'CreatedByApplication'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Application which last modified this record',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = N'ModifiedByApplication'
GO
EXEC sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'User which created this record',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = N'CreatedBy'
GO
EXEC sp_addextendedproperty 
  @name = N'MS_Description',
  @value = N'User which last modified this record',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = 'ModifiedBy'
GO
EXEC sp_addextendedproperty 
  @name = N'MS_Description',
  @value = N'A Batch Id to help identify messages added to the queue during a bulk process. Defaults to a unique id.',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'TABLE',
  @level1name = N'MessageQueueJsonSchemaBasic',
  @level2type = N'COLUMN',
  @level2name = 'RowGuid'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'The Json document of the message we are to run',
    @level0type = N'SCHEMA',
    @level0name = N'msgQueue',
    @level1type = N'TABLE',
    @level1name = N'MessageQueueJsonSchemaBasic',
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
  @level1name=N'MessageQueueJsonSchemaBasic'
GO
