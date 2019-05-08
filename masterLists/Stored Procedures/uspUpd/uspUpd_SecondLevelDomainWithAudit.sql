/*
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[masterLists].[uspUpd_SecondLevelDomainWithAudit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [masterLists].[uspUpd_SecondLevelDomainWithAudit]
GO
*/

CREATE PROCEDURE [masterLists].[uspUpd_SecondLevelDomainWithAudit]
  /* Identity / guid Primary Key(s) */
  @SecondLevelDomain            VARCHAR(16)       ,
  @ccTLD                        CHAR(3)           ,

  /* Foreign Key(s) */
  @RowStatus                    TINYINT           ,

  /* General Column Data */
  @SecondLevelDomainDescription VARCHAR(1000)     = NULL,

  /* App User Id / Modified By Id */
  @ModifiedBy                   UNIQUEIDENTIFIER  = NULL,

  /* Auditing Info */
  @AuditBatchId                 VARCHAR(64)       = NULL,
  @AuditOperation               VARCHAR(255)      = NULL,

  /* Debug Mode */
  @Debug                        BIT = 0,
  @ShowDebug                    BIT = 0,

  /* Return output options */
  @ReturnOutput                 BIT = 0,
  @ReturnAsTable                BIT = 0,
  @ReturnAsXml                  BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected                 INT = 0 OUTPUT,
  /* XML Results Output */
  @XmlResults                   XML = NULL OUTPUT


WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      masterLists
Object:      uspUpd_SecondLevelDomainWithAudit

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
    DECLARE @_SecondLevelDomain             VARCHAR(16);
    DECLARE @_ccTLD                         CHAR(3);
    DECLARE @_RowStatus                     TINYINT;
    DECLARE @_SecondLevelDomainDescription  VARCHAR(1000);
    DECLARE @_ModifiedBy                  UNIQUEIDENTIFIER;

    SET @_SecondLevelDomain              = @SecondLevelDomain;
    SET @_ccTLD                          = @ccTLD;
    SET @_RowStatus                      = @RowStatus;
    SET @_SecondLevelDomainDescription   = @SecondLevelDomainDescription;
    SET @_ModifiedBy                  = @ModifiedBy;

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
    SET @_AuditOperation = COALESCE( @AuditOperation, 'Update proc ran: [masterLists].[uspUpd_SecondLevelDomainWithAudit]' );

    /* ---------------------------------------------------------------------- */
    /* Create a temp table to hold our updates */
    CREATE TABLE #ChangeTableVar
    (
        [SecondLevelDomain]            VARCHAR(16)      NULL
      , [ccTLD]                        CHAR(3)          NULL
      , [RowStatus]                    TINYINT          NULL
      , [CreatedBy]                    INT              NULL
      , [ModifiedBy]                   INT              NULL
      , [CreatedDate]                  DATETIMEOFFSET   NULL
      , [ModifiedDate]                 DATETIMEOFFSET   NULL
      , [RowGuid]                      UNIQUEIDENTIFIER NULL
      , [SecondLevelDomainDescription] VARCHAR(1000)    NULL
    );

    /* ---------------------------------------------------------------------- */
    /* Grab all of the records we wish to update first and save them into our
       temp ChangeTableVar. */
    INSERT INTO #ChangeTableVar
    (
        [SecondLevelDomain]
      , [ccTLD]
      , [RowStatus]
      , [CreatedBy]
      , [ModifiedBy]
      , [CreatedDate]
      , [ModifiedDate]
      , [RowGuid]
      , [SecondLevelDomainDescription]
    )
    SELECT
        [SecondLevelDomain].[SecondLevelDomain]
      , [SecondLevelDomain].[ccTLD]
      , [SecondLevelDomain].[RowStatus]
      , [SecondLevelDomain].[CreatedBy]
      , [SecondLevelDomain].[ModifiedBy]
      , [SecondLevelDomain].[CreatedDate]
      , [SecondLevelDomain].[ModifiedDate]
      , [SecondLevelDomain].[RowGuid]
      , [SecondLevelDomain].[SecondLevelDomainDescription]
    FROM
      [masterLists].[SecondLevelDomain] AS SecondLevelDomain
    WHERE
      [SecondLevelDomain].[ccTLD] = @_ccTLD
    ;

    /* ---------------------------------------------------------------------- */
    /* Make the changes we wish to make to the TEMP data first */
    UPDATE #ChangeTableVar
      SET
         [SecondLevelDomain] =
           CASE
             WHEN @_SecondLevelDomain IS NOT NULL THEN @_SecondLevelDomain
             WHEN LEN( @_SecondLevelDomain ) > 0 THEN [SecondLevelDomain]
           END
        , [ccTLD] =
          CASE
            WHEN @_ccTLD IS NOT NULL THEN @_ccTLD
            WHEN LEN( @_ccTLD ) > 0 THEN [ccTLD]
          END
        , [RowStatus] =
          CASE
            WHEN @_RowStatus IS NOT NULL THEN @_RowStatus
            WHEN LEN( @_RowStatus ) > 0 THEN [RowStatus]
          END
        , [SecondLevelDomainDescription] =
          CASE
            WHEN @_SecondLevelDomainDescription IS NOT NULL THEN @_SecondLevelDomainDescription
            WHEN LEN( @_SecondLevelDomainDescription ) > 0 THEN [SecondLevelDomainDescription]
            ELSE NULL
          END
        ,[ModifiedBy] = @_ModifiedBy
        ,[ModifiedDate] = GETUTCDATE()
    WHERE
      ccTLD = @_ccTLD
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
      AND [tables].[name] = 'AuditSecondLevelDomain'
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
      AND OBJECTPROPERTY(object_id, 'SchemaId') = SCHEMA_ID('masterLists')
      AND OBJECT_NAME([systemObject].[parent_object_id]) = 'SecondLevelDomain'
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
      UPDATE [masterLists].[SecondLevelDomain]
      SET
         [SecondLevelDomain].[RowStatus]                    = [ChangeTableVar].[RowStatus]
        , [SecondLevelDomain].[CreatedBy]                    = [ChangeTableVar].[CreatedBy]
        , [SecondLevelDomain].[ModifiedBy]                   = [ChangeTableVar].[ModifiedBy]
        , [SecondLevelDomain].[CreatedDate]                  = [ChangeTableVar].[CreatedDate]
        , [SecondLevelDomain].[ModifiedDate]                 = [ChangeTableVar].[ModifiedDate]
        , [SecondLevelDomain].[RowGuid]                      = [ChangeTableVar].[RowGuid]
        , [SecondLevelDomain].[SecondLevelDomainDescription] = [ChangeTableVar].[SecondLevelDomainDescription]

      FROM #ChangeTableVar AS [ChangeTableVar]
        INNER JOIN [masterLists].[SecondLevelDomain] AS SecondLevelDomain
        ON [SecondLevelDomain].[SecondLevelDomain] = [ChangeTableVar].[SecondLevelDomain]
        AND  [SecondLevelDomain].[ccTLD] = [ChangeTableVar].[ccTLD]
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
        UPDATE [masterLists].[SecondLevelDomain]
        SET
           [SecondLevelDomain].[RowStatus]                    = [ChangeTableVar].[RowStatus]
          , [SecondLevelDomain].[CreatedBy]                    = [ChangeTableVar].[CreatedBy]
          , [SecondLevelDomain].[ModifiedBy]                   = [ChangeTableVar].[ModifiedBy]
          , [SecondLevelDomain].[CreatedDate]                  = [ChangeTableVar].[CreatedDate]
          , [SecondLevelDomain].[ModifiedDate]                 = [ChangeTableVar].[ModifiedDate]
          , [SecondLevelDomain].[RowGuid]                      = [ChangeTableVar].[RowGuid]
          , [SecondLevelDomain].[SecondLevelDomainDescription] = [ChangeTableVar].[SecondLevelDomainDescription]

        FROM #ChangeTableVar AS [ChangeTableVar]
          INNER JOIN [masterLists].[SecondLevelDomain] AS SecondLevelDomain
          ON [SecondLevelDomain].[SecondLevelDomain] = [ChangeTableVar].[SecondLevelDomain]
          AND  [SecondLevelDomain].[ccTLD] = [ChangeTableVar].[ccTLD]
        ;

        /* Now save our audit trail data */
        INSERT INTO [audit].[AuditSecondLevelDomain]
        (
            [AuditId]
          , [AuditStatus]
          , [AuditAppUser]
          , [AuditSqlUser]
          , [AuditDate]
          , [AuditBatchId]
          , [AuditOperation]
          , [SecondLevelDomain]
          , [ccTLD]
          , [RowStatus]
          , [CreatedBy]
          , [ModifiedBy]
          , [CreatedDate]
          , [ModifiedDate]
          , [RowGuid]
          , [SecondLevelDomainDescription]
        )
        SELECT
           CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER)
          , @_AuditStatus
          , @_AuditAppUser
          , @_AuditSqlUser
          , @_AuditDate
          , @_AuditBatchId
          , @_AuditOperation
          , [ChangeTableVar].[SecondLevelDomain]
          , [ChangeTableVar].[ccTLD]
          , [ChangeTableVar].[RowStatus]
          , [ChangeTableVar].[CreatedBy]
          , [ChangeTableVar].[ModifiedBy]
          , [ChangeTableVar].[CreatedDate]
          , [ChangeTableVar].[ModifiedDate]
          , [ChangeTableVar].[RowGuid]
          , [ChangeTableVar].[SecondLevelDomainDescription]

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
      [audit].[AuditSecondLevelDomain] AS [AuditSecondLevelDomain]
    WHERE
      [AuditSecondLevelDomain].[AuditBatchId] = @_AuditBatchId;

    /* Send all of the altered data back to the caller, if they want it */
    IF @_ReturnOutput = 1
    BEGIN

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [AuditSecondLevelDomain].[SecondLevelDomain]
          , [AuditSecondLevelDomain].[ccTLD]
          , [AuditSecondLevelDomain].[RowStatus]
          , [AuditSecondLevelDomain].[CreatedBy]
          , [AuditSecondLevelDomain].[ModifiedBy]
          , [AuditSecondLevelDomain].[CreatedDate]
          , [AuditSecondLevelDomain].[ModifiedDate]
          , [AuditSecondLevelDomain].[RowGuid]
          , [AuditSecondLevelDomain].[SecondLevelDomainDescription]
        FROM
          [audit].[AuditSecondLevelDomain] AS [AuditSecondLevelDomain]
        WHERE
          [AuditSecondLevelDomain].[AuditBatchId] = @_AuditBatchId;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY
          SELECT
            @XmlResults =
            (
              SELECT
                  [AuditSecondLevelDomain].[SecondLevelDomain]
                , [AuditSecondLevelDomain].[ccTLD]
                , [AuditSecondLevelDomain].[RowStatus]
                , [AuditSecondLevelDomain].[CreatedBy]
                , [AuditSecondLevelDomain].[ModifiedBy]
                , [AuditSecondLevelDomain].[CreatedDate]
                , [AuditSecondLevelDomain].[ModifiedDate]
                , [AuditSecondLevelDomain].[RowGuid]
                , [AuditSecondLevelDomain].[SecondLevelDomainDescription]
              FROM
                [audit].[AuditSecondLevelDomain] AS [AuditSecondLevelDomain]
              WHERE
                [AuditSecondLevelDomain].[AuditBatchId] = @_AuditBatchId
              FOR XML PATH ('SecondLevelDomain'), ROOT ('UpdatedRecords'), ELEMENTS XSINIL
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
DECLARE @SecondLevelDomain VARCHAR;
SET @SecondLevelDomain = FILL IN;
DECLARE @ccTLD CHAR;
SET @ccTLD = FILL IN;

EXEC masterLists.uspUpd_SecondLevelDomainWithAudit
  @SecondLevelDomain = @SecondLevelDomain,
  @ccTLD = @ccTLD,
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

SELECT AuditSecondLevelDomain.*
FROM   audit.AuditSecondLevelDomain AS AuditSecondLevelDomain
WHERE
  AuditSecondLevelDomain.SecondLevelDomain = @SecondLevelDomain
  AuditSecondLevelDomain.ccTLD = @ccTLD
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Updates a single record from the table if a coresponding audit table or trigger exists. Otherwise, aborts.',
  @level0type = N'SCHEMA',
  @level0name = N'masterLists',  @level1type = N'PROCEDURE',
  @level1name = N'uspUpd_SecondLevelDomainWithAudit';
GO