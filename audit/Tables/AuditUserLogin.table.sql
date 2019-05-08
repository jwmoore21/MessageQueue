CREATE TABLE [audit].[AuditUserLogin]
(
    [AuditId]           UNIQUEIDENTIFIER  NOT NULL ROWGUIDCOL
  , [AuditStatus]       TINYINT           NOT NULL
  , [AuditAppUser]      INT               NOT NULL
  , [AuditSqlUser]      VARCHAR(256)      NOT NULL
  , [AuditDate]         DATETIMEOFFSET    NOT NULL
  , [AuditBatchId]      UNIQUEIDENTIFIER  NOT NULL
  , [AuditOperation]    VARCHAR(255)      NOT NULL
  , [UserId]            INT               NULL
  , [RowStatus]         TINYINT           NULL
  , [CreatedBy]         INT               NULL
  , [ModifiedBy]        INT               NULL
  , [CreatedDate]       DATETIMEOFFSET    NULL
  , [ModifiedDate]      DATETIMEOFFSET    NULL
  , [RowGuid]              UNIQUEIDENTIFIER  NULL
  , [Username]          VARCHAR(64)       MASKED WITH (FUNCTION = 'default()') NULL
  , [Password]          VARCHAR(255)      NULL
  , [Id]                VARCHAR(255)      NULL
  , [IntegrationUser]   NVARCHAR(128)     MASKED WITH (FUNCTION = 'default()') NULL
  , [EmailLocalPart]    VARCHAR(64)       MASKED WITH (FUNCTION = 'default()') NULL
  , [ccTLD]             CHAR(3)           MASKED WITH (FUNCTION = 'default()') NULL
  , [SecondLevelDomain] VARCHAR(16)       MASKED WITH (FUNCTION = 'default()') NULL
  , [TopLevelDomain]    VARCHAR(24)       MASKED WITH (FUNCTION = 'default()') NULL
  , [DomainName]        VARCHAR(188)      MASKED WITH (FUNCTION = 'default()') NULL
  , [SubHostName]       VARCHAR(63)       MASKED WITH (FUNCTION = 'default()') NULL
  , [EmailAlias]        VARCHAR(64)       MASKED WITH (FUNCTION = 'default()') NULL
)
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [audit].[AuditUserLogin] ADD CONSTRAINT [PK__AuditUserLogin] PRIMARY KEY CLUSTERED
(
  [AuditId] ASC
)
WITH
(
  PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
)
ON [PRIMARY]
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [audit].[AuditUserLogin] ADD CONSTRAINT [DF__AuditUserLogin__AuditId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditId]
GO

ALTER TABLE [audit].[AuditUserLogin] ADD CONSTRAINT [DF__AuditUserLogin__AuditStatus] DEFAULT ((1)) FOR [AuditStatus]
GO

ALTER TABLE [audit].[AuditUserLogin] ADD CONSTRAINT [DF__AuditUserLogin__AuditAppUser] DEFAULT ( 1 ) FOR [AuditAppUser]
GO

ALTER TABLE [audit].[AuditUserLogin] ADD CONSTRAINT [DF__AuditUserLogin__AuditSqlUser] DEFAULT (suser_sname()) FOR [AuditSqlUser]
GO

ALTER TABLE [audit].[AuditUserLogin] ADD CONSTRAINT [DF__AuditUserLogin__AuditDate] DEFAULT (GETUTCDATE()) FOR [AuditDate]
GO

EXEC sys.sp_addextendedproperty 
  @name=N'MS_Description',
  @value=N'Transactional audit table.  Source is webuser.UserLogin',
  @level0type=N'SCHEMA',
  @level0name=N'audit',
  @level1type=N'TABLE',
  @level1name=N'AuditUserLogin'
GO