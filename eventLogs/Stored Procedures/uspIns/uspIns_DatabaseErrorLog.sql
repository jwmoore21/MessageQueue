/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[eventLogs].[uspIns_DatabaseErrorLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [eventLogs].[uspIns_DatabaseErrorLog]
GO
*/

CREATE PROCEDURE [eventLogs].[uspIns_DatabaseErrorLog]
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  /* General Column Data */
  @RowStatus      TINYINT           ,
  @ErrorNumber    INT                = NULL,
  @ErrorSeverity  INT                = NULL,
  @ErrorState     INT                = NULL,
  @ErrorLine      INT                = NULL,
  @DbName         NVARCHAR(128)      = NULL,
  @ErrorProcedure NVARCHAR(128)      = NULL,
  @ErrorMessage   NVARCHAR(2048)     = NULL,
  /* App User Id / Modified By Id */
  @ModifiedBy      UNIQUEIDENTIFIER  = NULL,

  /* Debug Mode */
  @Debug     BIT = 0,
  @ShowDebug BIT = 0,

  /* Return output options */
  @ReturnOutput   BIT = 0,
  @ReturnAsTable  BIT = 0,
  @ReturnAsXml    BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected   INT = 0 OUTPUT,
  /* Generated Primary Key Value(s) */
  @ErrorLogId     INT = NULL OUTPUT,
  /* XML Results Output */
  @XmlResults     XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      eventLogs
Object:      uspIns_DatabaseErrorLog

Description: Insert a record into the given table.

Returns:     If successful, returns one result set; if not successful, returns
             information about the error that occured during processing.

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

    /* ========================================================================= */
    /* Output Controls */
    DECLARE @_ReturnOutput   BIT;
    DECLARE @_ReturnAsTable  BIT;
    DECLARE @_ReturnAsXml    BIT;

    SET @_ReturnOutput       = @ReturnOutput;
    SET @_ReturnAsTable      = @ReturnAsTable;
    SET @_ReturnAsXml        = @ReturnAsXml;

    /* ========================================================================= */
    /* Local vars */
    DECLARE @_RowStatus       TINYINT;
    DECLARE @_RowGuid         UNIQUEIDENTIFIER;
    DECLARE @_ErrorNumber     INT;
    DECLARE @_ErrorSeverity   INT;
    DECLARE @_ErrorState      INT;
    DECLARE @_ErrorLine       INT;
    DECLARE @_DbName          NVARCHAR(128);
    DECLARE @_ErrorProcedure  NVARCHAR(128);
    DECLARE @_ErrorMessage    NVARCHAR(2048);
    DECLARE @_ModifiedBy    UNIQUEIDENTIFIER;

    SET @_RowStatus        = @RowStatus;
    SET @_RowGuid          = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_ErrorNumber      = @ErrorNumber;
    SET @_ErrorSeverity    = @ErrorSeverity;
    SET @_ErrorState       = @ErrorState;
    SET @_ErrorLine        = @ErrorLine;
    SET @_DbName           = @DbName;
    SET @_ErrorProcedure   = @ErrorProcedure;
    SET @_ErrorMessage     = @ErrorMessage;
    SET @_ModifiedBy       = ( SELECT COALESCE( @ModifiedBy, '1' ) );

    /* ========================================================================= */
    /* Debug Mode */
    DECLARE @_Debug     BIT;
    DECLARE @_ShowDebug BIT;
    SET @_ShowDebug     = @Debug;
    SET @_ShowDebug     = @ShowDebug;

    IF ( @_ShowDebug = 1 )
    BEGIN
      SELECT
          'Input values:'   AS DebugMessage
        , @_RowStatus        AS [RowStatus]
        , @_RowGuid          AS [RowGuid]
        , @_ErrorNumber      AS [ErrorNumber]
        , @_ErrorSeverity    AS [ErrorSeverity]
        , @_ErrorState       AS [ErrorState]
        , @_ErrorLine        AS [ErrorLine]
        , @_DbName           AS [DbName]
        , @_ErrorProcedure   AS [ErrorProcedure]
        , @_ErrorMessage     AS [ErrorMessage]
    END

    /* ========================================================================= */
    /* Create a table var to hold our OUTPUT values */
    CREATE TABLE #OutputTableVar
    (
        [INSERTED_ErrorLogId] INT NOT NULL
    );

    /* ========================================================================= */
    /* Insert our record */
    INSERT INTO [eventLogs].[DatabaseErrorLog]
    (
         [RowStatus]
       , [CreatedBy]
       , [RowGuid]
       , [ErrorNumber]
       , [ErrorSeverity]
       , [ErrorState]
       , [ErrorLine]
       , [DbName]
       , [ErrorProcedure]
       , [ErrorMessage]
     )

    OUTPUT
        [INSERTED].[ErrorLogId]

    INTO
      #OutputTableVar

    VALUES
    (
        @_RowStatus
      , @_ModifiedBy
      , @_RowGuid
      , @_ErrorNumber
      , @_ErrorSeverity
      , @_ErrorState
      , @_ErrorLine
      , @_DbName
      , @_ErrorProcedure
      , @_ErrorMessage
    )
    ;

    /* Send all of the altered data back to the caller, if they want it */
    IF @_ReturnOutput = 1
    BEGIN

      /* Return the number of rows affected to allow for Optimistic Concurrency checks in the calling C sharp code, if desired. */
      SELECT @RowsAffected = COALESCE( COUNT(1), 0 )
      FROM   #OutputTableVar AS OutputTableVar

      /* Return the primary key of the record inserted */
      SELECT
        @ErrorLogId = [OutputTableVar].[INSERTED_ErrorLogId]
      FROM #OutputTableVar AS OutputTableVar

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [DatabaseErrorLog].[ErrorLogId]
          , [DatabaseErrorLog].[RowStatus]
          , [DatabaseErrorLog].[CreatedBy]
          , [DatabaseErrorLog].[CreatedDate]
          , [DatabaseErrorLog].[RowGuid]
          , [DatabaseErrorLog].[ErrorNumber]
          , [DatabaseErrorLog].[ErrorSeverity]
          , [DatabaseErrorLog].[ErrorState]
          , [DatabaseErrorLog].[ErrorLine]
          , [DatabaseErrorLog].[DbName]
          , [DatabaseErrorLog].[ErrorProcedure]
          , [DatabaseErrorLog].[ErrorMessage]
        FROM
          [eventLogs].[DatabaseErrorLog] AS [DatabaseErrorLog]
        WHERE
          [DatabaseErrorLog].[ErrorLogId] = @ErrorLogId
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY

          SELECT
            @XmlResults =
            (
              SELECT
                  [DatabaseErrorLog].[ErrorLogId]
                , [DatabaseErrorLog].[RowStatus]
                , [DatabaseErrorLog].[CreatedBy]
                , [DatabaseErrorLog].[CreatedDate]
                , [DatabaseErrorLog].[RowGuid]
                , [DatabaseErrorLog].[ErrorNumber]
                , [DatabaseErrorLog].[ErrorSeverity]
                , [DatabaseErrorLog].[ErrorState]
                , [DatabaseErrorLog].[ErrorLine]
                , [DatabaseErrorLog].[DbName]
                , [DatabaseErrorLog].[ErrorProcedure]
                , [DatabaseErrorLog].[ErrorMessage]
              FROM
                [eventLogs].[DatabaseErrorLog] AS [DatabaseErrorLog]
              WHERE
                [DatabaseErrorLog].[ErrorLogId] = @ErrorLogId
              FOR XML PATH ('DatabaseErrorLog'), ROOT ('InsertedRecords'), ELEMENTS XSINIL
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
      SET @XmlResults = NULL;
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

DECLARE @RowsAffected   INT;
DECLARE @XmlResults     XML;
DECLARE @ErrorLogId     INT;
DECLARE @RowStatus      TINYINT;
DECLARE @CreatedBy      INT;
DECLARE @ErrorNumber    INT;
DECLARE @ErrorSeverity  INT;
DECLARE @ErrorState     INT;
DECLARE @ErrorLine      INT;
DECLARE @DbName         NVARCHAR(128);
DECLARE @ErrorProcedure NVARCHAR(128);
DECLARE @ErrorMessage   NVARCHAR(2048);

SET @RowStatus       = 1;
SET @CreatedBy       = 9;
SET @ErrorNumber     = 9;
SET @ErrorSeverity   = 9;
SET @ErrorState      = 9;
SET @ErrorLine       = 9;
SET @DbName          = [dbo].[ufn_LoremIpsumString](128, 0);
SET @ErrorProcedure  = [dbo].[ufn_LoremIpsumString](128, 0);
SET @ErrorMessage    = [dbo].[ufn_LoremIpsumString](2048, 0);

EXEC eventLogs.uspIns_DatabaseErrorLog
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  /* General Column Data */
  @RowStatus       = @RowStatus,
  @CreatedBy       = @CreatedBy,
  @ErrorNumber     = @ErrorNumber,
  @ErrorSeverity   = @ErrorSeverity,
  @ErrorState      = @ErrorState,
  @ErrorLine       = @ErrorLine,
  @DbName          = @DbName,
  @ErrorProcedure  = @ErrorProcedure,
  @ErrorMessage    = @ErrorMessage,
  /* App User Id / Modified By Id */
  @ModifiedBy      = NULL,
  /* Return output options */
  @ReturnOutput    = 1,
  @ReturnAsTable   = 1,
  @ReturnAsXml     = 1,
  /* Optimistic concurrency value */
  @RowsAffected    = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @ErrorLogId      = @ErrorLogId OUTPUT,
  /* XML Results Output */
  @XmlResults      = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @ErrorLogId AS ErrorLogId,
  @XmlResults AS XmlResults
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Inserts a single record into the table.',
  @level0type = N'SCHEMA',
  @level0name = N'eventLogs',
  @level1type = N'PROCEDURE',
  @level1name = N'uspIns_DatabaseErrorLog';
GO