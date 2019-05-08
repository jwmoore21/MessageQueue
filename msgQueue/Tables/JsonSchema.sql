/*
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[msgQueue].[JsonSchema]') AND type in (N'U'))
DROP TABLE [msgQueue].[JsonSchema]
GO
*/

CREATE TABLE [msgQueue].[JsonSchema]
(
    [JsonSchemaName]    VARCHAR(64)      NOT NULL
  , [RowStatus]         TINYINT          NOT NULL
  , [CreatedDate]       DATETIMEOFFSET   NOT NULL
  , [ModifiedDate]      DATETIMEOFFSET   NOT NULL
  , [CreatedBy]         INT              NOT NULL
  , [ModifiedBy]        INT              NOT NULL
  , [RowGuid]              UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [SchemaDescription] VARCHAR(255)     NOT NULL
  , [JsonSchema]        NVARCHAR(4000)   NOT NULL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [msgQueue].[JsonSchema] ADD CONSTRAINT [PK__JsonSchema] PRIMARY KEY CLUSTERED
(
  [JsonSchemaName] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Foreign Key Constraints */

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [msgQueue].[JsonSchema] ADD CONSTRAINT [DF__JsonSchema__RowStatus] DEFAULT ( 1 ) FOR [RowStatus]
GO

ALTER TABLE [msgQueue].[JsonSchema] ADD CONSTRAINT [DF__JsonSchema__CreatedDate] DEFAULT ( GETUTCDATE() ) FOR [CreatedDate]
GO

ALTER TABLE [msgQueue].[JsonSchema] ADD CONSTRAINT [DF__JsonSchema__ModifiedDate] DEFAULT ( GETUTCDATE() ) FOR [ModifiedDate]
GO

ALTER TABLE [msgQueue].[JsonSchema] ADD CONSTRAINT [DF__JsonSchema__CreatedBy] DEFAULT ( 1 ) FOR [CreatedBy]
GO

ALTER TABLE [msgQueue].[JsonSchema] ADD CONSTRAINT [DF__JsonSchema__ModifiedBy] DEFAULT ( 1 ) FOR [ModifiedBy]
GO

ALTER TABLE [msgQueue].[JsonSchema] ADD CONSTRAINT [DF__JsonSchema__RowGuid] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [RowGuid]
GO


/* -------------------------------------------------------------------------- */
/* Column Check Contraints */
ALTER TABLE [msgQueue].[JsonSchema] ADD CONSTRAINT [CK__JsonSchema__IsJson] CHECK ( (isjson([JsonSchema])=(1)) )
GO
ALTER TABLE [msgQueue].[JsonSchema] CHECK CONSTRAINT [CK__JsonSchema__IsJson]
GO


/* -------------------------------------------------------------------------- */
/* Indexes */
CREATE NONCLUSTERED INDEX [UNQ__JsonSchema__RowGuid__Covering] ON [msgQueue].[JsonSchema]
(
  [RowGuid] ASC
)
INCLUDE
(
    [JsonSchemaName]
  , [RowStatus]
  , [ModifiedDate]
  , [ModifiedBy]
  , [SchemaDescription]
  , [JsonSchema]
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
  @value=N'The unique Json Schema document name',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Status of the record, 0 = none or inactive, 1 = Currently Active, 2 = Reserved by a Task Scheduler, 4 = Error State, 5 = Complet',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Date time in which the record was created',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Date time in which the record was last modified',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'User which created the record',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'User who last modified the record',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Unique Row Guid, primary key',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'A short description of what this Json schema defines and is used for.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'SchemaDescription'
GO

EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'The Json Schema itself.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchema'
GO

/* -------------------------------------------------------------------------- */
/* Column Form Labels for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'JsonSchemaName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'SchemaDescription',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'SchemaDescription'
GO

EXEC sys.sp_addextendedproperty
  @name=N'Label_en_US',
  @value=N'JsonSchema',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchema'
GO

/* -------------------------------------------------------------------------- */
/* Column Required Fields Error Messages for en_US */
EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for JsonSchemaName',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchemaName'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowStatus',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'RowStatus'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'CreatedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedDate',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for CreatedBy',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for ModifiedBy',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'ModifiedBy'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for RowGuid',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'RowGuid'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for SchemaDescription',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'SchemaDescription'
GO

EXEC sys.sp_addextendedproperty
  @name=N'ErrorRequired_en_US',
  @value=N'Please enter a valid value for JsonSchema',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema',
  @level2type=N'COLUMN',
  @level2name=N'JsonSchema'
GO

/* -------------------------------------------------------------------------- */
/* Table Description */
EXEC sys.sp_addextendedproperty
  @name=N'MS_Description',
  @value=N'Transactional table.',
  @level0type=N'SCHEMA',
  @level0name=N'msgQueue',
  @level1type=N'TABLE',
  @level1name=N'JsonSchema'
GO