/*
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[msgQueue].[uspUpd_JsonSchemaWithAudit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [msgQueue].[uspUpd_JsonSchemaWithAudit]
GO
*/

CREATE PROCEDURE [msgQueue].[uspUpd_JsonSchemaWithAudit]
  /* Identity / guid Primary Key(s) */
  @JsonSchemaName    VARCHAR(64)       ,

  /* Foreign Key(s) */

  /* General Column Data */
  @RowStatus         TINYINT           = NULL,
  @SchemaDescription VARCHAR(255)      = NULL,
  @JsonSchema        NVARCHAR(4000)    = NULL,

  /* App User Id / Modified By Id */
  @ModifiedBy        UNIQUEIDENTIFIER  = NULL,

  /* Auditing Info */
  @AuditBatchId      VARCHAR(64)       = NULL,
  @AuditOperation    VARCHAR(255)      = NULL,

  /* Debug Mode */
  @Debug             BIT = 0,
  @ShowDebug         BIT = 0,

  /* Return output options */
  @ReturnOutput      BIT = 0,
  @ReturnAsTable     BIT = 0,
  @ReturnAsXml       BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected      INT = 0 OUTPUT,
  /* XML Results Output */
  @XmlResults        XML = NULL OUTPUT


WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      msgQueue
Object:      uspUpd_JsonSchemaWithAudit

Description: Updates a record(s) from the given table. Check for the existence of
             a table INSTEAD OF UPDATE trigger, if found, let the table trigger
             handle the auditing of the deleted record(s), otherwise, this proc
             with save the audit trail.

Returns:     If successful, returns one result set; if not successful, returns
             information about the error that occurred during processing.

Author:      John W. Moore
Version:     1.0.0
Copyright:   (c) 2019
License:     GNU GPLv3

*******************************************************************************/
BEGIN
  SET NOCOUNT ON;
  /* MS Data Rule SR0013 */
  SET @XmlResults = NULL;
  SET @RowsAffected = 0;

  /* Render the transaction uncommittable when the constraint violation occurs. */
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRANSACTION;

    /* ---------------------------------------------------------------------- */
    /* Output Controls */
    DECLARE @_ReturnOutput   BIT;
    DECLARE @_ReturnAsTable  BIT;
    DECLARE @_ReturnAsXml    BIT;

    SET @_ReturnOutput       = @ReturnOutput;
    SET @_ReturnAsTable      = @ReturnAsTable;
    SET @_ReturnAsXml        = @ReturnAsXml;

    /* ---------------------------------------------------------------------- */
    /* Debug Mode */
    DECLARE @_Debug     BIT;
    DECLARE @_ShowDebug BIT;
    SET @_Debug     = @Debug;
    SET @_ShowDebug = @ShowDebug;

    /* ---------------------------------------------------------------------- */
    /* Local Vars */
    DECLARE @_JsonSchemaName     VARCHAR(64);
    DECLARE @_RowStatus          TINYINT;
    DECLARE @_SchemaDescription  VARCHAR(255);
    DECLARE @_JsonSchema         NVARCHAR(4000);
    DECLARE @_ModifiedBy       UNIQUEIDENTIFIER;

    SET @_JsonSchemaName      = @JsonSchemaName;
    SET @_RowStatus           = @RowStatus;
    SET @_SchemaDescription   = @SchemaDescription;
    SET @_JsonSchema          = @JsonSchema;
    SET @_ModifiedBy       = @ModifiedBy;

    /* ---------------------------------------------------------------------- */
    /* Create a table var to hold our OUTPUT values */
    /* ---------------------------------------------------------------------- */
    /* Auditing Info */
    DECLARE @_AuditStatus    TINYINT;
    DECLARE @_AuditAppUser   UNIQUEIDENTIFIER;
    DECLARE @_AuditSqlUser   VARCHAR(256);
    DECLARE @_AuditDate      DATETIMEOFFSET;
    DECLARE @_AuditBatchId   UNIQUEIDENTIFIER;
    DECLARE @_AuditOperation VARCHAR(255);

    SET @_AuditStatus    = 1; /* Update */
    SET @_AuditAppUser   = COALESCE( @AuditBatchId, CONVERT(VARCHAR(64), '1' ) );
    SET @_AuditSqlUser   = SYSTEM_USER;
    SET @_AuditDate      = GETUTCDATE();
    SET @_AuditBatchId   = COALESCE( @ModifiedBy, CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) );
    SET @_AuditOperation = COALESCE( @AuditOperation, 'Update proc ran: [msgQueue].[uspUpd_JsonSchemaWithAudit]' );

    /* ---------------------------------------------------------------------- */
    /* Create a temp table to hold our updates */
    CREATE TABLE #ChangeTableVar
    (
        [JsonSchemaName]    VARCHAR(64)      NULL
      , [RowStatus]         TINYINT          NULL
      , [CreatedDate]       DATETIMEOFFSET   NULL
      , [ModifiedDate]      DATETIMEOFFSET   NULL
      , [CreatedBy]         INT              NULL
      , [ModifiedBy]        INT              NULL
      , [RowGuid]           UNIQUEIDENTIFIER NULL
      , [SchemaDescription] VARCHAR(255)     NULL
      , [JsonSchema]        NVARCHAR(4000)   NULL
    );

    /* ---------------------------------------------------------------------- */
    /* Grab all of the records we wish to update first and save them into our
       temp ChangeTableVar. */
    INSERT INTO #ChangeTableVar
    (
        [JsonSchemaName]
      , [RowStatus]
      , [CreatedDate]
      , [ModifiedDate]
      , [CreatedBy]
      , [ModifiedBy]
      , [RowGuid]
      , [SchemaDescription]
      , [JsonSchema]
    )
    SELECT
        [JsonSchema].[JsonSchemaName]
      , [JsonSchema].[RowStatus]
      , [JsonSchema].[CreatedDate]
      , [JsonSchema].[ModifiedDate]
      , [JsonSchema].[CreatedBy]
      , [JsonSchema].[ModifiedBy]
      , [JsonSchema].[RowGuid]
      , [JsonSchema].[SchemaDescription]
      , [JsonSchema].[JsonSchema]
    FROM
      [msgQueue].[JsonSchema] AS JsonSchema
    WHERE
      [JsonSchema].[JsonSchemaName] = @_JsonSchemaName
    ;

    /* ---------------------------------------------------------------------- */
    /* Make the changes we wish to make to the TEMP data first */
    UPDATE #ChangeTableVar
      SET
         [JsonSchemaName] =
           CASE
             WHEN @_JsonSchemaName IS NOT NULL THEN @_JsonSchemaName
             WHEN LEN( @_JsonSchemaName ) > 0 THEN [JsonSchemaName]
           END
        , [RowStatus] =
          CASE
            WHEN @_RowStatus IS NOT NULL THEN @_RowStatus
            WHEN LEN( @_RowStatus ) > 0 THEN [RowStatus]
          END
        , [SchemaDescription] =
          CASE
            WHEN @_SchemaDescription IS NOT NULL THEN @_SchemaDescription
            WHEN LEN( @_SchemaDescription ) > 0 THEN [SchemaDescription]
          END
        , [JsonSchema] =
          CASE
            WHEN @_JsonSchema IS NOT NULL THEN @_JsonSchema
            WHEN LEN( @_JsonSchema ) > 0 THEN [JsonSchema]
          END
        ,[ModifiedBy] = @_ModifiedBy
        ,[ModifiedDate] = GETUTCDATE()
    WHERE
      JsonSchemaName = @_JsonSchemaName
    ;
    /* ---------------------------------------------------------------------- */
    /* Check for the Audit table */
    DECLARE @HasAuditTable TINYINT;
    SET @HasAuditTable =
    (
      SELECT
        COALESCE( COUNT(1), 0 ) AS HasAuditTable
      FROM
        [sys].[tables] AS [tables]
      WHERE
        SCHEMA_NAME([tables].[schema_id]) = 'audit'
      AND [tables].[name] = 'AuditJsonSchema'
    );

    /* ---------------------------------------------------------------------- */
    /* Update our actual table and audit the changes */
    IF
    (
      SELECT
        COALESCE( COUNT(1), 0 ) AS HasAfterUpdateTrigger
      FROM
        [sys].[objects] AS [systemObject]
      WHERE
        [systemObject].[type] = 'TR'
      AND OBJECTPROPERTY(object_id, 'SchemaId') = SCHEMA_ID('msgQueue')
      AND OBJECT_NAME([systemObject].[parent_object_id]) = 'JsonSchema'
      AND OBJECTPROPERTY( [systemObject].[parent_object_id], N'ExecIsUpdateTrigger') = 1
      AND OBJECTPROPERTY( [systemObject].[parent_object_id], N'ExecIsAfterTrigger') = 1
      AND OBJECTPROPERTY([systemObject].[parent_object_id], N'ExecIsTriggerDisabled') = 0
      AND
      (
        @HasAuditTable
      ) = 1
    ) = 1
    BEGIN

      /* Parent table has an update trigger enabled, and the audit table
         exists in the local audit schema, let the trigger handle
         the auditing */
      UPDATE [msgQueue].[JsonSchema]
      SET
         [JsonSchema].[RowStatus]         = [ChangeTableVar].[RowStatus]
        , [JsonSchema].[CreatedDate]       = [ChangeTableVar].[CreatedDate]
        , [JsonSchema].[ModifiedDate]      = [ChangeTableVar].[ModifiedDate]
        , [JsonSchema].[CreatedBy]         = [ChangeTableVar].[CreatedBy]
        , [JsonSchema].[ModifiedBy]        = [ChangeTableVar].[ModifiedBy]
        , [JsonSchema].[RowGuid]           = [ChangeTableVar].[RowGuid]
        , [JsonSchema].[SchemaDescription] = [ChangeTableVar].[SchemaDescription]
        , [JsonSchema].[JsonSchema]        = [ChangeTableVar].[JsonSchema]

      FROM #ChangeTableVar AS [ChangeTableVar]
        INNER JOIN [msgQueue].[JsonSchema] AS JsonSchema
        ON [JsonSchema].[JsonSchemaName] = [ChangeTableVar].[JsonSchemaName]
      ;

    END; /* HasInsteadOfUpdateTrigger */
    ELSE
    BEGIN

      IF
      (
        @HasAuditTable
      ) = 1
      BEGIN

        /* No update trigger found on the parent table, however, we did find
           the audit table in our audit schema, save the audit data */
        UPDATE [msgQueue].[JsonSchema]
        SET
           [JsonSchema].[RowStatus]         = [ChangeTableVar].[RowStatus]
          , [JsonSchema].[CreatedDate]       = [ChangeTableVar].[CreatedDate]
          , [JsonSchema].[ModifiedDate]      = [ChangeTableVar].[ModifiedDate]
          , [JsonSchema].[CreatedBy]         = [ChangeTableVar].[CreatedBy]
          , [JsonSchema].[ModifiedBy]        = [ChangeTableVar].[ModifiedBy]
          , [JsonSchema].[RowGuid]           = [ChangeTableVar].[RowGuid]
          , [JsonSchema].[SchemaDescription] = [ChangeTableVar].[SchemaDescription]
          , [JsonSchema].[JsonSchema]        = [ChangeTableVar].[JsonSchema]

        FROM #ChangeTableVar AS [ChangeTableVar]
          INNER JOIN [msgQueue].[JsonSchema] AS JsonSchema
          ON [JsonSchema].[JsonSchemaName] = [ChangeTableVar].[JsonSchemaName]
        ;

        /* Now save our audit trail data */
        INSERT INTO [audit].[AuditJsonSchema]
        (
            [AuditId]
          , [AuditStatus]
          , [AuditAppUser]
          , [AuditSqlUser]
          , [AuditDate]
          , [AuditBatchId]
          , [AuditOperation]
          , [JsonSchemaName]
          , [RowStatus]
          , [CreatedDate]
          , [ModifiedDate]
          , [CreatedBy]
          , [ModifiedBy]
          , [RowGuid]
          , [SchemaDescription]
          , [JsonSchema]
        )
        SELECT
           CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER)
          , @_AuditStatus
          , @_AuditAppUser
          , @_AuditSqlUser
          , @_AuditDate
          , @_AuditBatchId
          , @_AuditOperation
          , [ChangeTableVar].[JsonSchemaName]
          , [ChangeTableVar].[RowStatus]
          , [ChangeTableVar].[CreatedDate]
          , [ChangeTableVar].[ModifiedDate]
          , [ChangeTableVar].[CreatedBy]
          , [ChangeTableVar].[ModifiedBy]
          , [ChangeTableVar].[RowGuid]
          , [ChangeTableVar].[SchemaDescription]
          , [ChangeTableVar].[JsonSchema]

        FROM
          #ChangeTableVar AS [ChangeTableVar];

      END; /* HasAuditTable */
      ELSE
      BEGIN

        /* Prevent the delete from executing, we are missing the audit table, and / or trigger */
        RAISERROR ( 'Unable to delete the requested record(s).  The audit table and / or trigger is missing for this table.', 16, 1 ) WITH LOG;
        RETURN;

      END;

    END; /* audit trigger and table check */

    /* Return the number of rows affected to allow for Optimistic Concurrency checks in the calling C sharp code, if desired. */
    SELECT @RowsAffected = COALESCE( COUNT(1), 0 )
    FROM
      [audit].[AuditJsonSchema] AS [AuditJsonSchema]
    WHERE
      [AuditJsonSchema].[AuditBatchId] = @_AuditBatchId;

    /* Send all of the altered data back to the caller, if they want it */
    IF @_ReturnOutput = 1
    BEGIN

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [AuditJsonSchema].[JsonSchemaName]
          , [AuditJsonSchema].[RowStatus]
          , [AuditJsonSchema].[CreatedDate]
          , [AuditJsonSchema].[ModifiedDate]
          , [AuditJsonSchema].[CreatedBy]
          , [AuditJsonSchema].[ModifiedBy]
          , [AuditJsonSchema].[RowGuid]
          , [AuditJsonSchema].[SchemaDescription]
          , [AuditJsonSchema].[JsonSchema]
        FROM
          [audit].[AuditJsonSchema] AS [AuditJsonSchema]
        WHERE
          [AuditJsonSchema].[AuditBatchId] = @_AuditBatchId;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY
          SELECT
            @XmlResults =
            (
              SELECT
                  [AuditJsonSchema].[JsonSchemaName]
                , [AuditJsonSchema].[RowStatus]
                , [AuditJsonSchema].[CreatedDate]
                , [AuditJsonSchema].[ModifiedDate]
                , [AuditJsonSchema].[CreatedBy]
                , [AuditJsonSchema].[ModifiedBy]
                , [AuditJsonSchema].[RowGuid]
                , [AuditJsonSchema].[SchemaDescription]
                , [AuditJsonSchema].[JsonSchema]
              FROM
                [audit].[AuditJsonSchema] AS [AuditJsonSchema]
              WHERE
                [AuditJsonSchema].[AuditBatchId] = @_AuditBatchId
              FOR XML PATH ('JsonSchema'), ROOT ('UpdatedRecords'), ELEMENTS XSINIL
            );

        END TRY

        BEGIN CATCH
          SELECT CONVERT(XML, '<xmlError>Unable to properly parse data into xml</xmlerror>', 1);
        END CATCH;

      END;

    END;
    ELSE
    BEGIN
      /* MS Data Rule SR0013 */
      SET @XmlResults   = NULL;
      SET @RowsAffected = 0;
    END; /* end return output */

    /* -------------------------------------------------------------------------
    No error or issues, commit the transaction, if we are not in debug mode        */
    IF ( @_Debug = 0 )
    BEGIN
      IF OBJECT_ID(N'tempdb..#ChangeTableVar') IS NOT NULL
      BEGIN
        DROP TABLE #ChangeTableVar;
      END

      COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
      ROLLBACK TRANSACTION;
      PRINT 'DEBUG MODE IS ENABLED... Transaction has been ROLLED BACK';
    END


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

END;

/*
Example usage:

DECLARE @RowsAffected INT;
DECLARE @XmlResults XML;
DECLARE @JsonSchemaName VARCHAR;
SET @JsonSchemaName = FILL IN;

EXEC msgQueue.uspUpd_JsonSchemaWithAudit
  @JsonSchemaName = @JsonSchemaName,
  @modified_by    = -73,
  @ReturnOutput   = 1,
  @ReturnAsTable  = 1,
  @ReturnAsXml    = 1,
  @RowsAffected   = @RowsAffected OUTPUT,
  @XmlResults     = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @XmlResults AS XmlResults
;

SELECT AuditJsonSchema.*
FROM   audit.AuditJsonSchema AS AuditJsonSchema
WHERE
  AuditJsonSchema.JsonSchemaName = @JsonSchemaName
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Updates a single record from the table if a coresponding audit table or trigger exists. Otherwise, aborts.',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',  @level1type = N'PROCEDURE',
  @level1name = N'uspUpd_JsonSchemaWithAudit';
GO