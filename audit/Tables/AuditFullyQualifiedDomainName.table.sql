/*
IF EXISTS ( SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[audit].[AuditFullyQualifiedDomainName]') AND type in (N'U') )
DROP TABLE [audit].[AuditFullyQualifiedDomainName]
GO
*/

CREATE TABLE [audit].[AuditFullyQualifiedDomainName]
(
    [AuditId]            UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL
  , [AuditStatus]        TINYINT          NOT NULL
  , [AuditAppUser]       INT              NOT NULL
  , [AuditSqlUser]       VARCHAR(256)     NOT NULL
  , [AuditDate]          DATETIMEOFFSET   NOT NULL
  , [AuditBatchId]       UNIQUEIDENTIFIER NOT NULL
  , [AuditOperation]     VARCHAR(255)     NOT NULL
  , [ccTLD]              CHAR(3)          NULL
  , [SecondLevelDomain]  VARCHAR(16)      NULL
  , [TopLevelDomain]     VARCHAR(24)      NULL
  , [DomainName]         VARCHAR(188)     NULL
  , [SubHostName]        VARCHAR(63)      NULL
  , [HostName]           VARCHAR(63)      NULL
  , [RowStatus]          TINYINT          NULL
  , [CreatedBy]          INT              NULL
  , [ModifiedBy]         INT              NULL
  , [CreatedDate]        DATETIMEOFFSET   NULL
  , [ModifiedDate]       DATETIMEOFFSET   NULL
  , [RowGuid]               UNIQUEIDENTIFIER NULL
);
GO

/* -------------------------------------------------------------------------- */
/* Primary Key */
ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [PK__AuditFullyQualifiedDomainName] PRIMARY KEY CLUSTERED
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
/* Foreign Key Constraints */

/* Column(s) [AuditFullyQualifiedDomainName].[RowStatus] IS A FK TO [masterLists].[Status].[RowStatus] */
ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [FK__AuditFullyQualifiedDomainName__AuditStatus] FOREIGN KEY( [AuditStatus] )
REFERENCES [masterLists].[Status]
(
  [RowStatus]
)
GO

ALTER TABLE [audit].[AuditFullyQualifiedDomainName] CHECK CONSTRAINT [FK__AuditFullyQualifiedDomainName__AuditStatus]
GO

/* Column(s) [AuditFullyQualifiedDomainName].[CreatedBy] IS A FK TO [webuser].[UserLogin].[UserId] */
ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [FK__AuditFullyQualifiedDomainName__AuditAppUser] FOREIGN KEY ( [AuditAppUser] )
REFERENCES [webuser].[UserLogin]
(
  [UserId]
);
GO

ALTER TABLE [audit].[AuditFullyQualifiedDomainName] CHECK CONSTRAINT [FK__AuditFullyQualifiedDomainName__AuditAppUser];
GO

/* -------------------------------------------------------------------------- */
/* Default Column Contraints */
ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [DF__AuditFullyQualifiedDomainName__AuditId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditId];
GO

ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [DF__AuditFullyQualifiedDomainName__AuditStatus] DEFAULT ( (1) ) FOR [AuditStatus];
GO

ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [DF__AuditFullyQualifiedDomainName__AuditAppUser] DEFAULT ( '1' ) FOR [AuditAppUser];
GO

ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [DF__AuditFullyQualifiedDomainName__AuditSqlUser] DEFAULT ( SUSER_SNAME() ) FOR [AuditSqlUser];
GO

ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [DF__AuditFullyQualifiedDomainName__AuditDate] DEFAULT ( GETUTCDATE() ) FOR [AuditDate];
GO

ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [DF__AuditFullyQualifiedDomainName__AuditBatchId] DEFAULT ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) FOR [AuditBatchId];
GO

ALTER TABLE [audit].[AuditFullyQualifiedDomainName] ADD CONSTRAINT [DF__AuditFullyQualifiedDomainName__AuditOperation] DEFAULT ( 'Adhoc operation' ) FOR [AuditOperation];
GO

/* -------------------------------------------------------------------------- */
/* Extended Properties - Table Description */
EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Transactional auditing table for the parent table [FullyQualifiedDomainName].',
  @level0type = N'SCHEMA',
  @level0name = N'audit',
  @level1type = N'TABLE',
  @level1name = N'AuditFullyQualifiedDomainName';
GO