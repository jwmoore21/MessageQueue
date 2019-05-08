/*
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[webuser].[uspUpd_UserLoginByRowGuid]') AND type in (N'P', N'PC'))
DROP PROCEDURE [webuser].[uspUpd_UserLoginByRowGuid]
GO
*/

CREATE PROCEDURE [webuser].[uspUpd_UserLoginByRowGuid]
  /* Use the table uniqueidentifier as the update key */
  @RowGuid         UNIQUEIDENTIFIER  ,

  /* Identity / guid Primary Key(s) */
  @UserId          INT               ,

  /* Foreign Key(s) */
  @RowStatus       TINYINT           ,

  /* General Column Data */
  @Username        VARCHAR(64)       = NULL,
  @Password        VARCHAR(255)      = NULL,
  @Id              VARCHAR(255)      = NULL,
  @IntegrationUser SYSNAME           = NULL,

  /* App User Id / Modified By Id */
  @ModifiedBy      UNIQUEIDENTIFIER  = NULL,

  /* Auditing Info */
  @AuditBatchId    VARCHAR(64)       = NULL,
  @AuditOperation  VARCHAR(255)      = NULL,

  /* Debug Mode */
  @Debug           BIT = 0,
  @ShowDebug       BIT = 0,

  /* Return output options */
  @ReturnOutput    BIT = 0,
  @ReturnAsTable   BIT = 0,
  @ReturnAsXml     BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected    INT = 0 OUTPUT,
  /* XML Results Output */
  @XmlResults      XML = NULL OUTPUT


WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      webuser
Object:      uspUpd_UserLoginByRowGuid

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
    DECLARE @_UserId           INT;
    DECLARE @_RowStatus        TINYINT;
    DECLARE @_RowGuid          UNIQUEIDENTIFIER;
    DECLARE @_Username         VARCHAR(64);
    DECLARE @_Password         VARCHAR(255);
    DECLARE @_Id               VARCHAR(255);
    DECLARE @_IntegrationUser  SYSNAME;
    DECLARE @_ModifiedBy     UNIQUEIDENTIFIER;

    SET @_UserId            = @UserId;
    SET @_RowStatus         = @RowStatus;
    SET @_RowGuid           = @RowGuid;
    SET @_Username          = @Username;
    SET @_Password          = @Password;
    SET @_Id                = @Id;
    SET @_IntegrationUser   = @IntegrationUser;
    SET @_ModifiedBy     = @ModifiedBy;

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
    SET @_AuditOperation = COALESCE( @AuditOperation, 'Update proc ran: [webuser].[uspUpd_UserLoginByRowGuid]' );

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
        AND OBJECTPROPERTY(object_id, 'SchemaId') = SCHEMA_ID('webuser')
        AND OBJECT_NAME([systemObject].[parent_object_id]) = 'UserLogin'
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
          @ReturnOutput       AS [ReturnOutput]
        , @ReturnAsTable      AS [ReturnAsTable]
        , @ReturnAsXml        AS [ReturnAsXml]
        , @Debug              AS [Debug]
        , @ShowDebug          AS [ShowDebug]
        , @HasAuditTable      AS [HasAuditTable]
        , @HasAuditTable      AS [HasAuditTable]
        , @_UserId            AS [UserId]
        , @_RowStatus         AS [RowStatus]
        , @_RowGuid           AS [RowGuid]
        , @_Username          AS [Username]
        , @_Password          AS [Password]
        , @_Id                AS [Id]
        , @_IntegrationUser   AS [IntegrationUser]
    END

      /* ---------------------------------------------------------------------- */
      /* Create a temp table to hold our updates */
      CREATE TABLE #ChangeTableVar
      (
          [UserId]          INT              NULL
        , [RowStatus]       TINYINT          NULL
        , [CreatedBy]       INT              NULL
        , [ModifiedBy]      INT              NULL
        , [CreatedDate]     DATETIMEOFFSET   NULL
        , [ModifiedDate]    DATETIMEOFFSET   NULL
        , [RowGuid]         UNIQUEIDENTIFIER NULL
        , [Username]        VARCHAR(64)      NULL
        , [Password]        VARCHAR(255)     NULL
        , [Id]              VARCHAR(255)     NULL
        , [IntegrationUser] SYSNAME          NULL
      );

      /* ---------------------------------------------------------------------- */
      /* Grab all of the records we wish to update first and save them into our
         temp ChangeTableVar. */
      INSERT INTO #ChangeTableVar
      (
          [UserId]
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
          [UserLogin].[UserId]
        , [UserLogin].[RowStatus]
        , [UserLogin].[CreatedBy]
        , [UserLogin].[ModifiedBy]
        , [UserLogin].[CreatedDate]
        , [UserLogin].[ModifiedDate]
        , [UserLogin].[RowGuid]
        , [UserLogin].[Username]
        , [UserLogin].[Password]
        , [UserLogin].[Id]
        , [UserLogin].[IntegrationUser]
      FROM
        [webuser].[UserLogin] AS UserLogin
      WHERE
        [UserLogin].[RowGuid] = @_RowGuid
      ;

      /* ---------------------------------------------------------------------- */
      /* Make the changes we wish to make to the TEMP data first */
      UPDATE #ChangeTableVar
        SET
           [UserId] =
             CASE
               WHEN @_UserId IS NOT NULL THEN @_UserId
               WHEN LEN( @_UserId ) > 0 THEN [UserId]
             END
          , [RowStatus] =
            CASE
              WHEN @_RowStatus IS NOT NULL THEN @_RowStatus
              WHEN LEN( @_RowStatus ) > 0 THEN [RowStatus]
            END
          , [Username] =
            CASE
              WHEN @_Username IS NOT NULL THEN @_Username
              WHEN LEN( @_Username ) > 0 THEN [Username]
            END
          , [Password] =
            CASE
              WHEN @_Password IS NOT NULL THEN @_Password
              WHEN LEN( @_Password ) > 0 THEN [Password]
            END
          , [Id] =
            CASE
              WHEN @_Id IS NOT NULL THEN @_Id
              WHEN LEN( @_Id ) > 0 THEN [Id]
            END
          , [IntegrationUser] =
            CASE
              WHEN @_IntegrationUser IS NOT NULL THEN @_IntegrationUser
              WHEN LEN( @_IntegrationUser ) > 0 THEN [IntegrationUser]
            END
          , [ModifiedBy] = @_ModifiedBy
          , [ModifiedDate] = GETUTCDATE()
      WHERE
        [#ChangeTableVar].[RowGuid] = @_RowGuid
      ;

      /* ---------------------------------------------------------------------- */
      /* Update our actual table and audit the changes */
      UPDATE [webuser].[UserLogin]
      SET
         [UserLogin].[RowStatus]       = [ChangeTableVar].[RowStatus]
        , [UserLogin].[CreatedBy]       = [ChangeTableVar].[CreatedBy]
        , [UserLogin].[ModifiedBy]      = [ChangeTableVar].[ModifiedBy]
        , [UserLogin].[CreatedDate]     = [ChangeTableVar].[CreatedDate]
        , [UserLogin].[ModifiedDate]    = [ChangeTableVar].[ModifiedDate]
        , [UserLogin].[RowGuid]         = [ChangeTableVar].[RowGuid]
        , [UserLogin].[Username]        = [ChangeTableVar].[Username]
        , [UserLogin].[Password]        = [ChangeTableVar].[Password]
        , [UserLogin].[Id]              = [ChangeTableVar].[Id]
        , [UserLogin].[IntegrationUser] = [ChangeTableVar].[IntegrationUser]

      FROM #ChangeTableVar AS [ChangeTableVar]
        INNER JOIN [webuser].[UserLogin] AS UserLogin
        ON [UserLogin].[RowGuid] = [ChangeTableVar].[RowGuid]
      ;

      IF ( @TableHasTrigger = 0 )
      BEGIN

        /*
        Now save the audit data ourselves. Do not save the audit data
        directly using an OUTPUT on the UPDATE statement itself. The audit
        tables should have triggers on them to prevent tampering. Tables which
        have triggers can not be written to directly from an OUTPUT statement.
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
            CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER)
          , @_AuditStatus
          , @_AuditAppUser
          , @_AuditSqlUser
          , @_AuditDate
          , @_AuditBatchId
          , @_AuditOperation
          , [ChangeTableVar].[UserId]
          , [ChangeTableVar].[RowStatus]
          , [ChangeTableVar].[CreatedBy]
          , [ChangeTableVar].[ModifiedBy]
          , [ChangeTableVar].[CreatedDate]
          , [ChangeTableVar].[ModifiedDate]
          , [ChangeTableVar].[RowGuid]
          , [ChangeTableVar].[Username]
          , [ChangeTableVar].[Password]
          , [ChangeTableVar].[Id]
          , [ChangeTableVar].[IntegrationUser]

        FROM
          #ChangeTableVar AS [ChangeTableVar];

      END; /* end if @TableHasTrigger */

    /* Return the number of rows affected to allow for Optimistic Concurrency checks in the calling C sharp code, if desired. */
    SELECT @RowsAffected = COALESCE( COUNT(1), 0 )
    FROM
      [webuser].[UserLogin] AS [UserLogin]
    WHERE
      [UserLogin].[RowGuid] = @_RowGuid;

    /* Send all of the altered data back to the caller, if they want it */
    IF @_ReturnOutput = 1
    BEGIN

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [UserLogin].[UserId]
          , [UserLogin].[RowStatus]
          , [UserLogin].[CreatedBy]
          , [UserLogin].[ModifiedBy]
          , [UserLogin].[CreatedDate]
          , [UserLogin].[ModifiedDate]
          , [UserLogin].[RowGuid]
          , [UserLogin].[Username]
          , [UserLogin].[Password]
          , [UserLogin].[Id]
          , [UserLogin].[IntegrationUser]
        FROM
          [webuser].[UserLogin] AS [UserLogin]
        WHERE
          [UserLogin].[RowGuid] = @_RowGuid;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY
          SELECT
            @XmlResults =
            (
              SELECT
                  [UserLogin].[UserId]
                , [UserLogin].[RowStatus]
                , [UserLogin].[CreatedBy]
                , [UserLogin].[ModifiedBy]
                , [UserLogin].[CreatedDate]
                , [UserLogin].[ModifiedDate]
                , [UserLogin].[RowGuid]
                , [UserLogin].[Username]
                , [UserLogin].[Password]
                , [UserLogin].[Id]
                , [UserLogin].[IntegrationUser]
              FROM
                [webuser].[UserLogin] AS [UserLogin]
              WHERE
                [UserLogin].[RowGuid] = @_RowGuid
              FOR XML PATH ('UserLogin'), ROOT ('UpdatedRecords'), ELEMENTS XSINIL
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
DECLARE @UserId INT;
SET @UserId = FILL IN;

EXEC webuser.uspUpd_UserLoginByRowGuid
  @UserId = @UserId,
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

SELECT AuditUserLogin.*
FROM   audit.AuditUserLogin AS AuditUserLogin
WHERE
  AuditUserLogin.UserId = @UserId
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Updates a single record from the table if a coresponding audit table or trigger exists. Otherwise, aborts.',
  @level0type = N'SCHEMA',
  @level0name = N'webuser',  @level1type = N'PROCEDURE',
  @level1name = N'uspUpd_UserLoginByRowGuid';
GO