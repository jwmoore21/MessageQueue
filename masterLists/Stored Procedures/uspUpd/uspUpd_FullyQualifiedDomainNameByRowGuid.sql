/*
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[masterLists].[uspUpd_FullyQualifiedDomainNameByRowGuid]') AND type in (N'P', N'PC'))
DROP PROCEDURE [masterLists].[uspUpd_FullyQualifiedDomainNameByRowGuid]
GO
*/

CREATE PROCEDURE [masterLists].[uspUpd_FullyQualifiedDomainNameByRowGuid]
  /* Use the table uniqueidentifier as the update key */
  @RowGuid           UNIQUEIDENTIFIER  ,

  /* Identity / guid Primary Key(s) */
  @ccTLD             CHAR(3)           ,
  @SecondLevelDomain VARCHAR(16)       ,
  @TopLevelDomain    VARCHAR(24)       ,
  @DomainName        VARCHAR(188)      ,
  @SubHostName       VARCHAR(63)       ,
  @HostName          VARCHAR(63)       ,

  /* Foreign Key(s) */
  @RowStatus         TINYINT           ,

  /* General Column Data */

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
Schema:      masterLists
Object:      uspUpd_FullyQualifiedDomainNameByRowGuid

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
    DECLARE @_ccTLD              CHAR(3);
    DECLARE @_SecondLevelDomain  VARCHAR(16);
    DECLARE @_TopLevelDomain     VARCHAR(24);
    DECLARE @_DomainName         VARCHAR(188);
    DECLARE @_SubHostName        VARCHAR(63);
    DECLARE @_HostName           VARCHAR(63);
    DECLARE @_RowStatus          TINYINT;
    DECLARE @_RowGuid            UNIQUEIDENTIFIER;
    DECLARE @_ModifiedBy       UNIQUEIDENTIFIER;

    SET @_ccTLD               = @ccTLD;
    SET @_SecondLevelDomain   = @SecondLevelDomain;
    SET @_TopLevelDomain      = @TopLevelDomain;
    SET @_DomainName          = @DomainName;
    SET @_SubHostName         = @SubHostName;
    SET @_HostName            = @HostName;
    SET @_RowStatus           = @RowStatus;
    SET @_RowGuid             = @RowGuid;
    SET @_ModifiedBy       = @ModifiedBy;

    /* ---------------------------------------------------------------------- */
    /* Auditing Info */
    DECLARE @_AuditStatus    TINYINT;
    DECLARE @_AuditAppUser   INT;
    DECLARE @_AuditSqlUser   VARCHAR(256);
    DECLARE @_AuditDate      DATETIMEOFFSET;
    DECLARE @_AuditBatchId   UNIQUEIDENTIFIER;
    DECLARE @_AuditOperation VARCHAR(255);

    SET @_AuditStatus    = 1; /* Update */
    SET @_AuditAppUser   = COALESCE( @ModifiedBy, '1' );
    SET @_AuditSqlUser   = SYSTEM_USER;
    SET @_AuditDate      = GETUTCDATE();
    SET @_AuditBatchId   = COALESCE( @AuditBatchId, CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) );
    SET @_AuditOperation = COALESCE( @AuditOperation, 'Update proc ran: [masterLists].[uspUpd_FullyQualifiedDomainNameByRowGuid]' );

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
      AND [tables].[name] = 'AuditFullyQualifiedDomainName'
    );

    /* An audit table is manditory, no table, no update */
    IF ( @HasAuditTable = 1 )
    BEGIN

      /* Check, does the table we are updating have an audit trigger? */
      DECLARE @TableHasTrigger INT;
      SET @TableHasTrigger = 0;
      IF
      (
        SELECT
          COALESCE( COUNT(1), 0 ) AS HasAfterUpdateTrigger
        FROM
          [sys].[objects] AS [systemObject]
        WHERE
          [systemObject].[type] = 'TR'
        AND OBJECTPROPERTY(object_id, 'SchemaId') = SCHEMA_ID('masterLists')
        AND OBJECT_NAME([systemObject].[parent_object_id]) = 'FullyQualifiedDomainName'
        AND OBJECTPROPERTY( [systemObject].[parent_object_id], N'ExecIsUpdateTrigger') = 1
        AND OBJECTPROPERTY( [systemObject].[parent_object_id], N'ExecIsAfterTrigger') = 1
        AND OBJECTPROPERTY([systemObject].[parent_object_id], N'ExecIsTriggerDisabled') = 0
        AND
        (
          @HasAuditTable
        ) = 1
      ) = 1
      BEGIN

        SET @TableHasTrigger = 1;

      END; /* HasInsteadOfUpdateTrigger */

    /* Show debug data of input params */
    IF @_ShowDebug = 1
    BEGIN
      SELECT
          @ReturnOutput         AS [ReturnOutput]
        , @ReturnAsTable        AS [ReturnAsTable]
        , @ReturnAsXml          AS [ReturnAsXml]
        , @Debug                AS [Debug]
        , @ShowDebug            AS [ShowDebug]
        , @HasAuditTable        AS [HasAuditTable]
        , @HasAuditTable        AS [HasAuditTable]
        , @_ccTLD               AS [ccTLD]
        , @_SecondLevelDomain   AS [SecondLevelDomain]
        , @_TopLevelDomain      AS [TopLevelDomain]
        , @_DomainName          AS [DomainName]
        , @_SubHostName         AS [SubHostName]
        , @_HostName            AS [HostName]
        , @_RowStatus           AS [RowStatus]
        , @_RowGuid             AS [RowGuid]
    END

      /* ---------------------------------------------------------------------- */
      /* Create a temp table to hold our updates */
      CREATE TABLE #ChangeTableVar
      (
          [ccTLD]             CHAR(3)          NULL
        , [SecondLevelDomain] VARCHAR(16)      NULL
        , [TopLevelDomain]    VARCHAR(24)      NULL
        , [DomainName]        VARCHAR(188)     NULL
        , [SubHostName]       VARCHAR(63)      NULL
        , [HostName]          VARCHAR(63)      NULL
        , [RowStatus]         TINYINT          NULL
        , [CreatedBy]         INT              NULL
        , [ModifiedBy]        INT              NULL
        , [CreatedDate]       DATETIMEOFFSET   NULL
        , [ModifiedDate]      DATETIMEOFFSET   NULL
        , [RowGuid]           UNIQUEIDENTIFIER NULL
      );

      /* ---------------------------------------------------------------------- */
      /* Grab all of the records we wish to update first and save them into our
         temp ChangeTableVar. */
      INSERT INTO #ChangeTableVar
      (
          [ccTLD]
        , [SecondLevelDomain]
        , [TopLevelDomain]
        , [DomainName]
        , [SubHostName]
        , [HostName]
        , [RowStatus]
        , [CreatedBy]
        , [ModifiedBy]
        , [CreatedDate]
        , [ModifiedDate]
        , [RowGuid]
      )
      SELECT
          [FullyQualifiedDomainName].[ccTLD]
        , [FullyQualifiedDomainName].[SecondLevelDomain]
        , [FullyQualifiedDomainName].[TopLevelDomain]
        , [FullyQualifiedDomainName].[DomainName]
        , [FullyQualifiedDomainName].[SubHostName]
        , [FullyQualifiedDomainName].[HostName]
        , [FullyQualifiedDomainName].[RowStatus]
        , [FullyQualifiedDomainName].[CreatedBy]
        , [FullyQualifiedDomainName].[ModifiedBy]
        , [FullyQualifiedDomainName].[CreatedDate]
        , [FullyQualifiedDomainName].[ModifiedDate]
        , [FullyQualifiedDomainName].[RowGuid]
      FROM
        [masterLists].[FullyQualifiedDomainName] AS FullyQualifiedDomainName
      WHERE
        [FullyQualifiedDomainName].[RowGuid] = @_RowGuid
      ;

      /* ---------------------------------------------------------------------- */
      /* Make the changes we wish to make to the TEMP data first */
      UPDATE #ChangeTableVar
        SET
           [ccTLD] =
             CASE
               WHEN @_ccTLD IS NOT NULL THEN @_ccTLD
               WHEN LEN( @_ccTLD ) > 0 THEN [ccTLD]
             END
          , [SecondLevelDomain] =
            CASE
              WHEN @_SecondLevelDomain IS NOT NULL THEN @_SecondLevelDomain
              WHEN LEN( @_SecondLevelDomain ) > 0 THEN [SecondLevelDomain]
            END
          , [TopLevelDomain] =
            CASE
              WHEN @_TopLevelDomain IS NOT NULL THEN @_TopLevelDomain
              WHEN LEN( @_TopLevelDomain ) > 0 THEN [TopLevelDomain]
            END
          , [DomainName] =
            CASE
              WHEN @_DomainName IS NOT NULL THEN @_DomainName
              WHEN LEN( @_DomainName ) > 0 THEN [DomainName]
            END
          , [SubHostName] =
            CASE
              WHEN @_SubHostName IS NOT NULL THEN @_SubHostName
              WHEN LEN( @_SubHostName ) > 0 THEN [SubHostName]
            END
          , [HostName] =
            CASE
              WHEN @_HostName IS NOT NULL THEN @_HostName
              WHEN LEN( @_HostName ) > 0 THEN [HostName]
            END
          , [RowStatus] =
            CASE
              WHEN @_RowStatus IS NOT NULL THEN @_RowStatus
              WHEN LEN( @_RowStatus ) > 0 THEN [RowStatus]
            END
          , [ModifiedBy] = @_ModifiedBy
          , [ModifiedDate] = GETUTCDATE()
      WHERE
        [#ChangeTableVar].[RowGuid] = @_RowGuid
      ;

      /* ---------------------------------------------------------------------- */
      /* Update our actual table and audit the changes */
      UPDATE [masterLists].[FullyQualifiedDomainName]
      SET
         [FullyQualifiedDomainName].[RowStatus]         = [ChangeTableVar].[RowStatus]
        , [FullyQualifiedDomainName].[CreatedBy]         = [ChangeTableVar].[CreatedBy]
        , [FullyQualifiedDomainName].[ModifiedBy]        = [ChangeTableVar].[ModifiedBy]
        , [FullyQualifiedDomainName].[CreatedDate]       = [ChangeTableVar].[CreatedDate]
        , [FullyQualifiedDomainName].[ModifiedDate]      = [ChangeTableVar].[ModifiedDate]
        , [FullyQualifiedDomainName].[RowGuid]           = [ChangeTableVar].[RowGuid]

      FROM #ChangeTableVar AS [ChangeTableVar]
        INNER JOIN [masterLists].[FullyQualifiedDomainName] AS FullyQualifiedDomainName
        ON [FullyQualifiedDomainName].[RowGuid] = [ChangeTableVar].[RowGuid]
      ;

      IF ( @TableHasTrigger = 0 )
      BEGIN

        /*
        Now save the audit data ourselves. Do not save the audit data
        directly using an OUTPUT on the UPDATE statement itself. The audit
        tables should have triggers on them to prevent tampering. Tables which
        have triggers can not be written to directly from an OUTPUT statement.
        */
        INSERT INTO [audit].[AuditFullyQualifiedDomainName]
        (
            [AuditId]
          , [AuditStatus]
          , [AuditAppUser]
          , [AuditSqlUser]
          , [AuditDate]
          , [AuditBatchId]
          , [AuditOperation]
          , [ccTLD]
          , [SecondLevelDomain]
          , [TopLevelDomain]
          , [DomainName]
          , [SubHostName]
          , [HostName]
          , [RowStatus]
          , [CreatedBy]
          , [ModifiedBy]
          , [CreatedDate]
          , [ModifiedDate]
          , [RowGuid]
        )
        SELECT
            CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER)
          , @_AuditStatus
          , @_AuditAppUser
          , @_AuditSqlUser
          , @_AuditDate
          , @_AuditBatchId
          , @_AuditOperation
          , [ChangeTableVar].[ccTLD]
          , [ChangeTableVar].[SecondLevelDomain]
          , [ChangeTableVar].[TopLevelDomain]
          , [ChangeTableVar].[DomainName]
          , [ChangeTableVar].[SubHostName]
          , [ChangeTableVar].[HostName]
          , [ChangeTableVar].[RowStatus]
          , [ChangeTableVar].[CreatedBy]
          , [ChangeTableVar].[ModifiedBy]
          , [ChangeTableVar].[CreatedDate]
          , [ChangeTableVar].[ModifiedDate]
          , [ChangeTableVar].[RowGuid]

        FROM
          #ChangeTableVar AS [ChangeTableVar];

      END; /* end if @TableHasTrigger */

    /* Return the number of rows affected to allow for Optimistic Concurrency checks in the calling C sharp code, if desired. */
    SELECT @RowsAffected = COALESCE( COUNT(1), 0 )
    FROM
      [masterLists].[FullyQualifiedDomainName] AS [FullyQualifiedDomainName]
    WHERE
      [FullyQualifiedDomainName].[RowGuid] = @_RowGuid;

    /* Send all of the altered data back to the caller, if they want it */
    IF @_ReturnOutput = 1
    BEGIN

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [FullyQualifiedDomainName].[ccTLD]
          , [FullyQualifiedDomainName].[SecondLevelDomain]
          , [FullyQualifiedDomainName].[TopLevelDomain]
          , [FullyQualifiedDomainName].[DomainName]
          , [FullyQualifiedDomainName].[SubHostName]
          , [FullyQualifiedDomainName].[HostName]
          , [FullyQualifiedDomainName].[RowStatus]
          , [FullyQualifiedDomainName].[CreatedBy]
          , [FullyQualifiedDomainName].[ModifiedBy]
          , [FullyQualifiedDomainName].[CreatedDate]
          , [FullyQualifiedDomainName].[ModifiedDate]
          , [FullyQualifiedDomainName].[RowGuid]
        FROM
          [masterLists].[FullyQualifiedDomainName] AS [FullyQualifiedDomainName]
        WHERE
          [FullyQualifiedDomainName].[RowGuid] = @_RowGuid;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY
          SELECT
            @XmlResults =
            (
              SELECT
                  [FullyQualifiedDomainName].[ccTLD]
                , [FullyQualifiedDomainName].[SecondLevelDomain]
                , [FullyQualifiedDomainName].[TopLevelDomain]
                , [FullyQualifiedDomainName].[DomainName]
                , [FullyQualifiedDomainName].[SubHostName]
                , [FullyQualifiedDomainName].[HostName]
                , [FullyQualifiedDomainName].[RowStatus]
                , [FullyQualifiedDomainName].[CreatedBy]
                , [FullyQualifiedDomainName].[ModifiedBy]
                , [FullyQualifiedDomainName].[CreatedDate]
                , [FullyQualifiedDomainName].[ModifiedDate]
                , [FullyQualifiedDomainName].[RowGuid]
              FROM
                [masterLists].[FullyQualifiedDomainName] AS [FullyQualifiedDomainName]
              WHERE
                [FullyQualifiedDomainName].[RowGuid] = @_RowGuid
              FOR XML PATH ('FullyQualifiedDomainName'), ROOT ('UpdatedRecords'), ELEMENTS XSINIL
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


    END; /* HasAuditTable */
    ELSE
    BEGIN

      /* Prevent the delete from executing, we are missing the audit table, and / or trigger */
      RAISERROR ( 'Unable to delete the requested record(s).  The audit table and / or trigger is missing for this table.', 16, 1 ) WITH LOG;
      RETURN;

    END;

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
DECLARE @ccTLD CHAR;
SET @ccTLD = FILL IN;
DECLARE @SecondLevelDomain VARCHAR;
SET @SecondLevelDomain = FILL IN;
DECLARE @TopLevelDomain VARCHAR;
SET @TopLevelDomain = FILL IN;
DECLARE @DomainName VARCHAR;
SET @DomainName = FILL IN;
DECLARE @SubHostName VARCHAR;
SET @SubHostName = FILL IN;
DECLARE @HostName VARCHAR;
SET @HostName = FILL IN;

EXEC masterLists.uspUpd_FullyQualifiedDomainNameByRowGuid
  @ccTLD = @ccTLD,
  @SecondLevelDomain = @SecondLevelDomain,
  @TopLevelDomain = @TopLevelDomain,
  @DomainName = @DomainName,
  @SubHostName = @SubHostName,
  @HostName = @HostName,
  @ModifiedBy    = 1,ModifiedBy  @ReturnOutput   = 1,
  @ReturnAsTable  = 1,
  @ReturnAsXml    = 1,
  @RowsAffected   = @RowsAffected OUTPUT,
  @XmlResults     = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @XmlResults AS XmlResults
;

SELECT AuditFullyQualifiedDomainName.*
FROM   audit.AuditFullyQualifiedDomainName AS AuditFullyQualifiedDomainName
WHERE
  AuditFullyQualifiedDomainName.ccTLD = @ccTLD
  AuditFullyQualifiedDomainName.SecondLevelDomain = @SecondLevelDomain
  AuditFullyQualifiedDomainName.TopLevelDomain = @TopLevelDomain
  AuditFullyQualifiedDomainName.DomainName = @DomainName
  AuditFullyQualifiedDomainName.SubHostName = @SubHostName
  AuditFullyQualifiedDomainName.HostName = @HostName
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Updates a single record from the table if a coresponding audit table or trigger exists. Otherwise, aborts.',
  @level0type = N'SCHEMA',
  @level0name = N'masterLists',  @level1type = N'PROCEDURE',
  @level1name = N'uspUpd_FullyQualifiedDomainNameByRowGuid';
GO