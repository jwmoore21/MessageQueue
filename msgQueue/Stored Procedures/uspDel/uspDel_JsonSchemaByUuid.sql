/*
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[msgQueue].[uspDel_JsonSchemaByRowGuid]') AND type in (N'P', N'PC'))
DROP PROCEDURE [msgQueue].[uspDel_JsonSchemaByRowGuid]
GO
*/

CREATE PROCEDURE [msgQueue].[uspDel_JsonSchemaByRowGuid]
  @RowGuid          UNIQUEIDENTIFIER,
  @ModifiedBy    UNIQUEIDENTIFIER = NULL,
  /* Auditing Info */
  @AuditBatchId   VARCHAR(64) = NULL,
  @AuditOperation VARCHAR(255) = NULL,
  /* Return output options */
  @ReturnOutput   BIT = 0,
  @ReturnAsTable  BIT = 0,
  @ReturnAsXml    BIT = 0,
  @RowsAffected   INT = 0 OUTPUT,
  @XmlResults     XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      msgQueue
Object:      uspDel_JsonSchemaByRowGuid

Description: Delete a record by Guid Id from the given table. Check for the existance of
             a table INSTEAD OF DELETE trigger, if found, let the table trigger
             handle the audting of the deleted record(s), otherwise, this proc
             with save the audit trail.

Returns:     If successful, returns one result set; if not successful, returns
             information about the error that occurred during processing.

Author:      John W. Moore
Version:     1.0.0
Copyright:   (c) 2018
License:     Restricted

*******************************************************************************/
BEGIN
  SET NOCOUNT ON;
  /* MS Data Rule SR0013 */
  SET @XmlResults   = NULL;
  SET @RowsAffected = 0;

  /* Render the transaction uncommittable when the constraint violation occurs. */
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRANSACTION;

    /* --------------------------------------------------------------------- */
    /* Output Controls */
    DECLARE @_ReturnOutput   BIT;
    DECLARE @_ReturnAsTable  BIT;
    DECLARE @_ReturnAsXml    BIT;

    SET @_ReturnOutput  = @ReturnOutput;
    SET @_ReturnAsTable = @ReturnAsTable;
    SET @_ReturnAsXml   = @ReturnAsXml;

    /* --------------------------------------------------------------------- */
    /* Auditing Info */
    DECLARE @_AuditStatus    TINYINT;
    DECLARE @_AuditAppUser   UNIQUEIDENTIFIER;
    DECLARE @_AuditSqlUser   VARCHAR(256);
    DECLARE @_AuditDate      DATETIME;
    DECLARE @_AuditBatchId   VARCHAR(64);
    DECLARE @_AuditOperation VARCHAR(255);

    SET @_AuditStatus    = 2; /* Delete */
    SET @_AuditAppUser   = COALESCE( @ModifiedBy, CONVERT(VARCHAR(64), '119FD967-4F22-4832-B962-1187209EF83D') );
    SET @_AuditSqlUser   = SYSTEM_USER;
    SET @_AuditDate      = GETDATE();
    SET @_AuditBatchId   = COALESCE( @AuditBatchId, CONVERT(VARCHAR(64),NEWID()) );
    SET @_AuditOperation = COALESCE( @AuditOperation, 'Delete proc ran: uspDel_JsonSchemaByRowGuid' );

    /* --------------------------------------------------------------------- */
    /* Record Guid */
    DECLARE @_RowGuid UNIQUEIDENTIFIER;
    SET @_RowGuid = @RowGuid;

    /* --------------------------------------------------------------------- */
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

    /* --------------------------------------------------------------------- */
    /* Delete our record(s) */
    IF
    (
      SELECT
        COALESCE( COUNT(1), 0 ) AS HasInsteadOfDeleteTrigger
      FROM
        [sys].[sysobjects] AS [so]
        INNER JOIN [sys].[sysobjects] AS [so2]
        ON [so].[parent_obj] = [so2].[id]
      WHERE
        [so].[type] = 'TR'
      AND USER_NAME([so2].[uid]) = 'msgQueue'
      AND OBJECT_NAME([so].[parent_obj]) = 'JsonSchema'
      AND OBJECTPROPERTY( [so].[id], N'ExecIsDeleteTrigger') = 1
      AND OBJECTPROPERTY( [so].[id], N'ExecIsInsteadOfTrigger') = 1
      AND OBJECTPROPERTY([so].[id], N'ExecIsTriggerDisabled') = 0
      AND
      (
        @HasAuditTable
      ) = 1
    ) = 1
    BEGIN

      /* Parent table has an update trigger enabled, and the audit table
         exists in the local audit schema, let the trigger handle
         the auditing */
      DELETE FROM [msgQueue].[JsonSchema]

      WHERE
        [JsonSchema].[RowGuid] = @_RowGuid
      ;

    END; /* HasInsteadOfDeleteTrigger */
    ELSE
    BEGIN

      IF
      (
        @HasAuditTable
      ) = 1
      BEGIN

        /* ---------------------------------------------------------------------- */
        /* Create a temp table to hold our updates */
        DECLARE @OutputTableVar TABLE
        (
           [AuditId]           UNIQUEIDENTIFIER NOT NULL
          , [AuditStatus]       TINYINT          NOT NULL
          , [AuditAppUser]      UNIQUEIDENTIFIER NOT NULL
          , [AuditSqlUser]      VARCHAR(256)     NOT NULL
          , [AuditDate]         DATETIME         NOT NULL
          , [AuditBatchId]      VARCHAR(64)      NOT NULL
          , [AuditOperation]    VARCHAR(255)     NOT NULL
          , [JsonSchemaName]    VARCHAR(64)      NULL
          , [RowStatus]         TINYINT          NULL
          , [CreatedDate]       DATETIMEOFFSET   NULL
          , [ModifiedDate]      DATETIMEOFFSET   NULL
          , [CreatedBy]         UNIQUEIDENTIFIER NULL
          , [ModifiedBy]        UNIQUEIDENTIFIER NULL
          , [RowGuid]              UNIQUEIDENTIFIER NULL
          , [SchemaDescription] VARCHAR(255)     NULL
          , [JsonSchema]        NVARCHAR(4000)   NULL
        );

        /* No update trigger found on the parent table, however, we did find
           the audit table in our audit schema, save the audit data */
        DELETE FROM [msgQueue].[JsonSchema]

        OUTPUT
           CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER)
          ,@_AuditStatus
          ,@_AuditAppUser
          ,@_AuditSqlUser
          ,@_AuditDate
          ,@_AuditBatchId
          ,@_AuditOperation
          ,[DELETED].[JsonSchemaName]
          ,[DELETED].[RowStatus]
          ,[DELETED].[CreatedDate]
          ,[DELETED].[ModifiedDate]
          ,[DELETED].[CreatedBy]
          ,[DELETED].[ModifiedBy]
          ,[DELETED].[RowGuid]
          ,[DELETED].[SchemaDescription]
          ,[DELETED].[JsonSchema]

        INTO
          @OutputTableVar

        WHERE
          [JsonSchema].[RowGuid] = @_RowGuid
        ;

        /* Now save the audit data */
        INSERT INTO [audit].[AuditJsonSchema]
        (
           [AuditId]
          ,[AuditStatus]
          ,[AuditAppUser]
          ,[AuditSqlUser]
          ,[AuditDate]
          ,[AuditBatchId]
          ,[AuditOperation]
          ,[JsonSchemaName]
          ,[RowStatus]
          ,[CreatedDate]
          ,[ModifiedDate]
          ,[CreatedBy]
          ,[ModifiedBy]
          ,[RowGuid]
          ,[SchemaDescription]
          ,[JsonSchema]
        )
        SELECT
            [OutputTableVar].[AuditId]
          , [OutputTableVar].[AuditStatus]
          , [OutputTableVar].[AuditAppUser]
          , [OutputTableVar].[AuditSqlUser]
          , [OutputTableVar].[AuditDate]
          , [OutputTableVar].[AuditBatchId]
          , [OutputTableVar].[AuditOperation]
          , [OutputTableVar].[JsonSchemaName]
          , [OutputTableVar].[RowStatus]
          , [OutputTableVar].[CreatedDate]
          , [OutputTableVar].[ModifiedDate]
          , [OutputTableVar].[CreatedBy]
          , [OutputTableVar].[ModifiedBy]
          , [OutputTableVar].[RowGuid]
          , [OutputTableVar].[SchemaDescription]
          , [OutputTableVar].[JsonSchema]

        FROM
          @OutputTableVar AS [OutputTableVar];

      END; /* HasAuditTable */
      ELSE
      BEGIN

        /* Prevent the delete from executing, we are missing the audit table, and / or trigger */
        RAISERROR ( 'Unable to delete the requested record(s).  The audit table and / or trigger is missing for this table.', 16, 1 ) WITH LOG;
        RETURN;

      END;

    END; /* audit trigger and table check */

    SELECT @RowsAffected = COALESCE( COUNT(1), 0 )
    FROM
      [audit].[AuditJsonSchema] AS [AuditJsonSchema] WITH(NOLOCK)
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
          [audit].[AuditJsonSchema] AS [AuditJsonSchema] WITH(NOLOCK)
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
                [audit].[AuditJsonSchema] AS [AuditJsonSchema] WITH(NOLOCK)
              WHERE
                [AuditJsonSchema].[AuditBatchId] = @_AuditBatchId
              FOR XML PATH ('JsonSchema'), ROOT ('DeletedRecords'), ELEMENTS XSINIL
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

    /* No error or issues, commit the transaction */
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
      ) WITH LOG;

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

DECLARE @AuditBatchId UNIQUEIDENTIFIER;
SET @AuditBatchId = NEWID();

DECLARE @RowsAffected INT;
DECLARE @XmlResults XML;
DECLARE @RowGuid UNIQUEIDENTIFIER;
SET @RowGuid = FILL IN;

EXEC msgQueue.uspDel_JsonSchemaByRowGuid
  @RowGuid = @RowGuid,
  @AuditBatchId    = @AuditBatchId,
  @ModifiedBy    = '119FD967-4F22-4832-B962-1187209EF83D',
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
FROM   audit.AuditJsonSchema AS AuditJsonSchema WITH(NOLOCK)
WHERE
  AuditJsonSchema.AuditBatchId = @AuditBatchId
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Deletes a single record from the table.  Checks for the existance of an auditing delete trigger. If exists, uses te trigger, otherwise deletes the record and manually audits the operation.',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'PROCEDURE',
  @level1name = N'uspDel_JsonSchemaByRowGuid';
GO