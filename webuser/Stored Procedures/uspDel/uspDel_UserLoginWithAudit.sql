/*
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[webuser].[uspDel_UserLoginWithAudit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [webuser].[uspDel_UserLoginWithAudit]
GO
*/

CREATE PROCEDURE [webuser].[uspDel_UserLoginWithAudit]
  @UserId INT,
  @ModifiedBy     UNIQUEIDENTIFIER = NULL,
  /* Auditing Info */
  @AuditBatchId   UNIQUEIDENTIFIER = NULL,
  @AuditOperation VARCHAR(255) = NULL,
  /* Debug options */
  @Debug          BIT = 0,
  @ShowDebug      BIT = 0,
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
Schema:      webuser
Object:      uspDel_UserLoginWithAudit

Description: Delete a record(s) from the given table. Check for the existance of
             a table INSTEAD OF DELETE trigger, if found, let the table trigger
             handle the audting of the deleted record(s), otherwise, this proc
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
  SET @XmlResults   = NULL;
  SET @RowsAffected = 0;

  /*
  Render the transaction uncommittable when the constraint violation occurs.
  */
  SET XACT_ABORT ON;

  BEGIN TRY
    BEGIN TRANSACTION;

    /* ---------------------------------------------------------------------- */
    /* Output Controls */
    DECLARE @_ReturnOutput   BIT;
    DECLARE @_ReturnAsTable  BIT;
    DECLARE @_ReturnAsXml    BIT;

    SET @_ReturnOutput  = @ReturnOutput;
    SET @_ReturnAsTable = @ReturnAsTable;
    SET @_ReturnAsXml   = @ReturnAsXml;

    /* ---------------------------------------------------------------------- */
    /* Auditing Info */
    DECLARE @_AuditStatus    TINYINT;
    DECLARE @_AuditAppUser   INT;
    DECLARE @_AuditSqlUser   VARCHAR(256);
    DECLARE @_AuditDate      DATETIMEOFFSET;
    DECLARE @_AuditBatchId   UNIQUEIDENTIFIER;
    DECLARE @_AuditOperation VARCHAR(255);

    SET @_AuditStatus    = 2; /* Delete */
    SET @_AuditAppUser   = COALESCE( @ModifiedBy, CONVERT(VARCHAR(64), '119FD967-4F22-4832-B962-1187209EF83D') );
    SET @_AuditSqlUser   = SYSTEM_USER;
    SET @_AuditDate      = GETUTCDATE();
    SET @_AuditBatchId   = COALESCE( @AuditBatchId, CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) );
    SET @_AuditOperation = COALESCE( @AuditOperation, 'Delete proc ran: [webuser].[uspDel_UserLoginWithAudit]' );

    /* ---------------------------------------------------------------------- */
    /* Debug Mode */
    DECLARE @_Debug     BIT;
    DECLARE @_ShowDebug BIT;
    SET @_ShowDebug = @Debug;
    SET @_ShowDebug = @ShowDebug;

    /* ---------------------------------------------------------------------- */
    /* Table Primary Key(s) */
    DECLARE @_UserId  INT;
    SET @_UserId = @UserId;

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
      AND [tables].[name] = 'AuditUserLogin'
    );

    /* ---------------------------------------------------------------------- */
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
      AND USER_NAME([so2].[uid]) = 'webuser'
      AND OBJECT_NAME([so].[parent_obj]) = 'UserLogin'
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
      DELETE FROM [webuser].[UserLogin]

      WHERE
        [UserLogin].[UserId] = @_UserId
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
        CREATE TABLE #OutputTableVar
        (
            [AuditId]         UNIQUEIDENTIFIER NOT NULL
          , [AuditStatus]     TINYINT          NOT NULL
          , [AuditAppUser]    INT              NOT NULL
          , [AuditSqlUser]    VARCHAR(256)     NOT NULL
          , [AuditDate]       DATETIME         NOT NULL
          , [AuditBatchId]    UNIQUEIDENTIFIER NOT NULL
          , [AuditOperation]  VARCHAR(255)     NOT NULL
          , [UserId]          INT              NULL
          , [RowStatus]       TINYINT          NULL
          , [CreatedBy]       INT              NULL
          , [ModifiedBy]      INT              NULL
          , [CreatedDate]     DATETIMEOFFSET   NULL
          , [ModifiedDate]    DATETIMEOFFSET   NULL
          , [RowGuid]         UNIQUEIDENTIFIER NULL
          , [Username]        VARCHAR(64)      NULL
          , [Password]        VARCHAR(255)     NULL
          , [IntegrationUser] SYSNAME          NULL
        );

        /* No update trigger found on the parent table, however, we did find
           the audit table in our audit schema, save the audit data */
        DELETE FROM [webuser].[UserLogin]

        OUTPUT
            CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER)
          , @_AuditStatus
          , @_AuditAppUser
          , @_AuditSqlUser
          , @_AuditDate
          , @_AuditBatchId
          , @_AuditOperation
          , [DELETED].[UserId]
          , [DELETED].[RowStatus]
          , [DELETED].[CreatedBy]
          , [DELETED].[ModifiedBy]
          , [DELETED].[CreatedDate]
          , [DELETED].[ModifiedDate]
          , [DELETED].[RowGuid]
          , [DELETED].[Username]
          , [DELETED].[Password]
          , [DELETED].[Id]
          , [DELETED].[IntegrationUser]

        INTO
          #OutputTableVar

        WHERE
          [UserLogin].[UserId] = @_UserId
        ;

        /*
        Assume there is a trigger on the Audit table, and if so, we can not send
        our OUTPUT data directly into the table. Therefore, manually insert our
        audit data.
        */
        INSERT INTO [audit].[AuditUserLogin]
        (
            [AuditId]
          , [AuditStatus]
          , [AuditAppUser]
          , [AuditSqlUser]
          , [AuditDate]
          , [AuditBatchId]
          , [AuditOperation]
          , [UserId]
          , [RowStatus]
          , [CreatedBy]
          , [ModifiedBy]
          , [CreatedDate]
          , [ModifiedDate]
          , [RowGuid]
          , [Username]
          , [Password]
          , [Id]
          , [IntegrationUser]
        )
        SELECT
            [OutputTableVar].[AuditId]
          , [OutputTableVar].[AuditStatus]
          , [OutputTableVar].[AuditAppUser]
          , [OutputTableVar].[AuditSqlUser]
          , [OutputTableVar].[AuditDate]
          , [OutputTableVar].[AuditBatchId]
          , [OutputTableVar].[AuditOperation]
          , [OutputTableVar].[UserId]
          , [OutputTableVar].[RowStatus]
          , [OutputTableVar].[CreatedBy]
          , [OutputTableVar].[ModifiedBy]
          , [OutputTableVar].[CreatedDate]
          , [OutputTableVar].[ModifiedDate]
          , [OutputTableVar].[RowGuid]
          , [OutputTableVar].[Username]
          , [OutputTableVar].[Password]
          , [OutputTableVar].[Id]
          , [OutputTableVar].[IntegrationUser]

        FROM
          #OutputTableVar AS [OutputTableVar];

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
      [audit].[AuditUserLogin] AS [AuditUserLogin]
    WHERE
      [AuditUserLogin].[AuditBatchId] = @_AuditBatchId;

    /* Send all of the altered data back to the caller, if they want it */
    IF @_ReturnOutput = 1
    BEGIN

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [AuditUserLogin].[UserId]
          , [AuditUserLogin].[RowStatus]
          , [AuditUserLogin].[CreatedBy]
          , [AuditUserLogin].[ModifiedBy]
          , [AuditUserLogin].[CreatedDate]
          , [AuditUserLogin].[ModifiedDate]
          , [AuditUserLogin].[RowGuid]
          , [AuditUserLogin].[Username]
          , [AuditUserLogin].[Password]
          , [AuditUserLogin].[Id]
          , [AuditUserLogin].[IntegrationUser]
        FROM
          [audit].[AuditUserLogin] AS [AuditUserLogin]
        WHERE
          [AuditUserLogin].[AuditBatchId] = @_AuditBatchId;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY
          SELECT
            @XmlResults =
            (
              SELECT
                  [AuditUserLogin].[UserId]
                , [AuditUserLogin].[RowStatus]
                , [AuditUserLogin].[CreatedBy]
                , [AuditUserLogin].[ModifiedBy]
                , [AuditUserLogin].[CreatedDate]
                , [AuditUserLogin].[ModifiedDate]
                , [AuditUserLogin].[RowGuid]
                , [AuditUserLogin].[Username]
                , [AuditUserLogin].[Password]
                , [AuditUserLogin].[Id]
                , [AuditUserLogin].[IntegrationUser]
              FROM
                [audit].[AuditUserLogin] AS [AuditUserLogin]
              WHERE
                [AuditUserLogin].[AuditBatchId] = @_AuditBatchId
              FOR XML PATH ('UserLogin'), ROOT ('DeletedRecords'), ELEMENTS XSINIL
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
      IF OBJECT_ID(N'tempdb..#OutputTableVar') IS NOT NULL
      BEGIN
        DROP TABLE #OutputTableVar;
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

DECLARE @AuditBatchId UNIQUEIDENTIFIER;
SET @AuditBatchId = NEWID();

DECLARE @RowsAffected INT;
DECLARE @XmlResults XML;
DECLARE @UserId INT;
SET @UserId = FILL IN;

EXEC webuser.uspDel_UserLoginWithAudit
  @UserId = @UserId,
  @AuditBatchId    = @AuditBatchId,
  @ModifiedBy   = '119FD967-4F22-4832-B962-1187209EF83D',
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

SELECT AuditUserLogin.*
FROM   audit.AuditUserLogin AS AuditUserLogin
WHERE
  AuditUserLogin.AuditBatchId = @AuditBatchId
;
*/

GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Delete a single record by the primary key(s) and will audit the operation either via a table trigger, if one exists, if not then the proc will store all of the audited data. If the audit table however does not exist, the delete operation is aborted.',
  @level0type = N'SCHEMA',
  @level0name = N'webuser',
  @level1type = N'PROCEDURE',
  @level1name = N'uspDel_UserLoginWithAudit';
GO