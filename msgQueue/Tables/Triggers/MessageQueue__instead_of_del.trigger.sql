/*
IF EXISTS ( SELECT 1 FROM sys.triggers WHERE object_id = object_id(N'[msgQueue].[TRG__MessageQueue__instead_of_del]'))
DROP TRIGGER [msgQueue].[TRG__MessageQueue__instead_of_del]
GO
*/
CREATE TRIGGER [msgQueue].[TRG__MessageQueue__instead_of_del] ON [msgQueue].[MessageQueue]
  INSTEAD OF DELETE
AS

/*******************************************************************************
Schema:      msgQueue
Object:      TRG__MessageQueue__instead_of_del

Description: INSTEAD OF DELETE trigger. Automatically ensures that any data
             deleted from our database is tracked in our auditing tables.
             
Returns:     Nothing

Author:      John W. Moore
Version:     1.0.0
Copyright:   (c) 2019
License:     Restricted

*******************************************************************************/
BEGIN

  /* SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements. */
  SET NOCOUNT ON;

  /* Triggers are supposed have this implicitly turned, but let's be sure, render the transaction uncommittable when the constraint violation occurs. */
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRANSACTION;

    /* ========================================================================= */
    /* Auditing Info */
    DECLARE @_AuditStatus    TINYINT;
    DECLARE @_AuditAppUser   INT;
    DECLARE @_AuditSqlUser   VARCHAR(256);
    DECLARE @_AuditDate      DATETIMEOFFSET;
    DECLARE @_AuditBatchId   UNIQUEIDENTIFIER;
    DECLARE @_AuditOperation VARCHAR(255);

    /* Delete */
    SET @_AuditStatus    = 2; 
    SET @_AuditAppUser   = 1; /* we do not have a web user at this point, assign one */
    SET @_AuditSqlUser   = SYSTEM_USER;
    SET @_AuditDate      = GETUTCDATE();
    SET @_AuditBatchId   = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_AuditOperation = 'Autosave by: INSTEAD OF DELETE Trigger : TRG__MessageQueue__instead_of_del';

    /* ========================================================================= */
    /* Create a temp table to hold our updates */
    DECLARE @AuditRecordsToSave TABLE
    (
        [MessageQueueId]        INT               NOT NULL
      , [JsonSchemaName]        VARCHAR(64)       NOT NULL
      , [RowStatus]             TINYINT           NOT NULL
      , [CreatedDate]           DATETIMEOFFSET    NOT NULL
      , [ModifiedDate]          DATETIMEOFFSET    NOT NULL
      , [CreatedByApplication]  VARCHAR(32)       NOT NULL
      , [ModifiedByApplication] VARCHAR(32)       NOT NULL
      , [CreatedBy]             INT               NOT NULL
      , [ModifiedBy]            INT               NOT NULL
      , [Uuid]                  UNIQUEIDENTIFIER  NOT NULL
      , [RunAgainstPort]        INT               NOT NULL
      , [HttpVerb]              VARCHAR(8)        NOT NULL
      , [ccTLD]                 CHAR(3)           NOT NULL
      , [SecondLevelDomain]     VARCHAR(16)       NOT NULL
      , [TopLevelDomain]        VARCHAR(24)       NOT NULL
      , [DomainName]            VARCHAR(188)      NOT NULL
      , [SubHostName]           VARCHAR(63)       NOT NULL
      , [HostName]              VARCHAR(63)       NOT NULL
      , [ScriptName]            VARCHAR(128)      NULL
      , [Datasource]            VARCHAR(255)      NULL
      , [DatabaseName]          NVARCHAR(128)     NULL
      , [DatabaseSchema]        NVARCHAR(128)     NULL
      , [DatabaseTable]         NVARCHAR(128)     NULL
      , [JsonDocument]          NVARCHAR(4000)    NOT NULL
    );

    /* Insert into a TEMP table, all of our deleted values */
    INSERT INTO @AuditRecordsToSave
    (
        [MessageQueueId]
      , [JsonSchemaName]
      , [RowStatus]
      , [CreatedDate]
      , [ModifiedDate]
      , [CreatedByApplication]
      , [ModifiedByApplication]
      , [CreatedBy]
      , [ModifiedBy]
      , [Uuid]
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
    SELECT
        [MessageQueueId]
      , [JsonSchemaName]
      , [RowStatus]
      , [CreatedDate]
      , [ModifiedDate]
      , [CreatedByApplication]
      , [ModifiedByApplication]
      , [CreatedBy]
      , [ModifiedBy]
      , [Uuid]
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
    FROM
      deleted

    /* Insert into a TEMP table, all of our deleted values */
    INSERT INTO [Audit].[AuditMessageQueue]
    (
        [AuditStatus]
      , [AuditAppUser]
      , [AuditSqlUser]
      , [AuditDate]
      , [AuditBatchId]
      , [AuditOperation]
      , [MessageQueueId]
      , [JsonSchemaName]
      , [RowStatus]
      , [CreatedDate]
      , [ModifiedDate]
      , [CreatedByApplication]
      , [ModifiedByApplication]
      , [CreatedBy]
      , [ModifiedBy]
      , [Uuid]
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
    SELECT
        @_AuditStatus
      , @_AuditAppUser
      , @_AuditSqlUser
      , @_AuditDate
      , @_AuditBatchId
      , @_AuditOperation
      , [AuditRecordsToSave].[MessageQueueId]
      , [AuditRecordsToSave].[JsonSchemaName]
      , [AuditRecordsToSave].[RowStatus]
      , [AuditRecordsToSave].[CreatedDate]
      , [AuditRecordsToSave].[ModifiedDate]
      , [AuditRecordsToSave].[CreatedByApplication]
      , [AuditRecordsToSave].[ModifiedByApplication]
      , [AuditRecordsToSave].[CreatedBy]
      , [AuditRecordsToSave].[ModifiedBy]
      , [AuditRecordsToSave].[Uuid]
      , [AuditRecordsToSave].[RunAgainstPort]
      , [AuditRecordsToSave].[HttpVerb]
      , [AuditRecordsToSave].[ccTLD]
      , [AuditRecordsToSave].[SecondLevelDomain]
      , [AuditRecordsToSave].[TopLevelDomain]
      , [AuditRecordsToSave].[DomainName]
      , [AuditRecordsToSave].[SubHostName]
      , [AuditRecordsToSave].[HostName]
      , [AuditRecordsToSave].[ScriptName]
      , [AuditRecordsToSave].[Datasource]
      , [AuditRecordsToSave].[DatabaseName]
      , [AuditRecordsToSave].[DatabaseSchema]
      , [AuditRecordsToSave].[DatabaseTable]
      , [AuditRecordsToSave].[JsonDocument]
    FROM
      @AuditRecordsToSave AS AuditRecordsToSave

    /* Now we can perform the actual delete */
    DELETE recordsToErase
    FROM [msgQueue].[MessageQueue] AS recordsToErase
    INNER JOIN @AuditRecordsToSave AS AuditRecordsToSave
    ON AuditRecordsToSave.[Uuid] = recordsToErase.[Uuid]
    ;

    /* No error or issues, commit the transaction */
    IF @@TRANCOUNT > 0 
      COMMIT TRANSACTION;

  END TRY

  BEGIN CATCH

    /* This rollback affects the whole transaction stack, decrements @@TRANCOUNT to 0 */
    IF XACT_STATE() <> 0
      ROLLBACK TRANSACTION;

    DECLARE
      @DbName         NVARCHAR(128),
      @ErrorMessage   NVARCHAR(2048),
      @ErrorSeverity  TINYINT,
      @ErrorState     TINYINT,
      @ErrorNumber    INT,
      @ErrorProcedure SYSNAME,
      @ErrorLine      INT;

    SELECT
      @DbName         = DB_NAME(),
      @ErrorNumber    = ERROR_NUMBER(),
      @ErrorSeverity  = ERROR_SEVERITY(),
      @ErrorState     = ERROR_STATE(),
      @ErrorProcedure = ERROR_PROCEDURE(),
      @ErrorLine      = ERROR_LINE(),
      @ErrorMessage   = ERROR_MESSAGE();

    /* Raise the error */
    RAISERROR
    (
      @ErrorMessage,
      @ErrorSeverity,
      @ErrorState
    );

    /* Save the error */
    EXECUTE [eventLogs].[DatabaseErrorHandler]
      @DbName         = @DbName,
      @ErrorNumber    = @ErrorNumber,
      @ErrorSeverity  = @ErrorSeverity,
      @ErrorState     = @ErrorState,
      @ErrorProcedure = @ErrorProcedure,
      @ErrorLine      = @ErrorLine,
      @ErrorMessage   = @ErrorMessage;

  END CATCH;

END

GO