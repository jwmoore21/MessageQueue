/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[msgQueue].[uspIns_ExecutionLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [msgQueue].[uspIns_ExecutionLog]
GO
*/

CREATE PROCEDURE [msgQueue].[uspIns_ExecutionLog]
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @MessageQueueId   INT               ,
  @JsonSchemaName   VARCHAR(64)       ,
  /* General Column Data */
  @RowStatus        TINYINT           ,
  @RanByApplication VARCHAR(32)       ,
  @RanByHost        VARCHAR(32)       ,
  @RanOnDate        DATETIMEOFFSET    ,
  @RanByUser        INT               ,
  @Results          NVARCHAR(4000)    ,
  /* App User Id / Modified By Id */
  @ModifiedBy        UNIQUEIDENTIFIER  = NULL,

  /* Debug Mode */
  @Debug     BIT = 0,
  @ShowDebug BIT = 0,

  /* Return output options */
  @ReturnOutput     BIT = 0,
  @ReturnAsTable    BIT = 0,
  @ReturnAsXml      BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected     INT = 0 OUTPUT,
  /* Generated Primary Key Value(s) */
  @ExecutionLogId   INT = NULL OUTPUT,
  /* XML Results Output */
  @XmlResults       XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      msgQueue
Object:      uspIns_ExecutionLog

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
    DECLARE @_RowGuid           UNIQUEIDENTIFIER;
    DECLARE @_MessageQueueId    INT;
    DECLARE @_JsonSchemaName    VARCHAR(64);
    DECLARE @_RowStatus         TINYINT;
    DECLARE @_RanByApplication  VARCHAR(32);
    DECLARE @_RanByHost         VARCHAR(32);
    DECLARE @_RanOnDate         DATETIMEOFFSET;
    DECLARE @_RanByUser         INT;
    DECLARE @_Results           NVARCHAR(4000);
    DECLARE @_ModifiedBy      UNIQUEIDENTIFIER;

    SET @_RowGuid            = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_MessageQueueId     = @MessageQueueId;
    SET @_JsonSchemaName     = @JsonSchemaName;
    SET @_RowStatus          = @RowStatus;
    SET @_RanByApplication   = @RanByApplication;
    SET @_RanByHost          = @RanByHost;
    SET @_RanOnDate          = @RanOnDate;
    SET @_RanByUser          = @RanByUser;
    SET @_Results            = @Results;
    SET @_ModifiedBy         = ( SELECT COALESCE( @ModifiedBy, '1' ) );

    /* ========================================================================= */
    /* Debug Mode */
    DECLARE @_Debug     BIT;
    DECLARE @_ShowDebug BIT;
    SET @_ShowDebug     = @Debug;
    SET @_ShowDebug     = @ShowDebug;

    IF ( @_ShowDebug = 1 )
    BEGIN
      SELECT
          'Input values:'     AS DebugMessage
        , @_RowGuid            AS [RowGuid]
        , @_MessageQueueId     AS [MessageQueueId]
        , @_JsonSchemaName     AS [JsonSchemaName]
        , @_RowStatus          AS [RowStatus]
        , @_RanByApplication   AS [RanByApplication]
        , @_RanByHost          AS [RanByHost]
        , @_RanOnDate          AS [RanOnDate]
        , @_RanByUser          AS [RanByUser]
        , @_Results            AS [Results]
    END

    /* ========================================================================= */
    /* Create a table var to hold our OUTPUT values */
    CREATE TABLE #OutputTableVar
    (
        [INSERTED_ExecutionLogId] INT NOT NULL
    );

    /* ========================================================================= */
    /* Insert our record */
    INSERT INTO [msgQueue].[ExecutionLog]
    (
         [RowGuid]
       , [MessageQueueId]
       , [JsonSchemaName]
       , [RowStatus]
       , [RanByApplication]
       , [RanByHost]
       , [RanOnDate]
       , [RanByUser]
       , [Results]
     )

    OUTPUT
        [INSERTED].[ExecutionLogId]

    INTO
      #OutputTableVar

    VALUES
    (
        @_RowGuid
      , @_MessageQueueId
      , @_JsonSchemaName
      , @_RowStatus
      , @_RanByApplication
      , @_RanByHost
      , @_RanOnDate
      , @_RanByUser
      , @_Results
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
        @ExecutionLogId = [OutputTableVar].[INSERTED_ExecutionLogId]
      FROM #OutputTableVar AS OutputTableVar

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [ExecutionLog].[ExecutionLogId]
          , [ExecutionLog].[RowGuid]
          , [ExecutionLog].[MessageQueueId]
          , [ExecutionLog].[JsonSchemaName]
          , [ExecutionLog].[RowStatus]
          , [ExecutionLog].[RanByApplication]
          , [ExecutionLog].[RanByHost]
          , [ExecutionLog].[RanOnDate]
          , [ExecutionLog].[RanByUser]
          , [ExecutionLog].[Results]
        FROM
          [msgQueue].[ExecutionLog] AS [ExecutionLog]
        WHERE
          [ExecutionLog].[ExecutionLogId] = @ExecutionLogId
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY

          SELECT
            @XmlResults =
            (
              SELECT
                  [ExecutionLog].[ExecutionLogId]
                , [ExecutionLog].[RowGuid]
                , [ExecutionLog].[MessageQueueId]
                , [ExecutionLog].[JsonSchemaName]
                , [ExecutionLog].[RowStatus]
                , [ExecutionLog].[RanByApplication]
                , [ExecutionLog].[RanByHost]
                , [ExecutionLog].[RanOnDate]
                , [ExecutionLog].[RanByUser]
                , [ExecutionLog].[Results]
              FROM
                [msgQueue].[ExecutionLog] AS [ExecutionLog]
              WHERE
                [ExecutionLog].[ExecutionLogId] = @ExecutionLogId
              FOR XML PATH ('ExecutionLog'), ROOT ('InsertedRecords'), ELEMENTS XSINIL
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

DECLARE @RowsAffected     INT;
DECLARE @XmlResults       XML;
DECLARE @ExecutionLogId   INT;
DECLARE @RowStatus        TINYINT;
DECLARE @RanByApplication VARCHAR(32);
DECLARE @RanByHost        VARCHAR(32);
DECLARE @RanOnDate        DATETIMEOFFSET;
DECLARE @RanByUser        INT;
DECLARE @Results          NVARCHAR(4000);

SET @RowStatus         = 1;
SET @RanByApplication  = [dbo].[ufn_LoremIpsumString](32, 0);
SET @RanByHost         = [dbo].[ufn_LoremIpsumString](32, 0);
SET @RanOnDate         = GETUTCDATE();
SET @RanByUser         = 9;
SET @Results           = [dbo].[ufn_LoremIpsumString](4000, 0);

EXEC msgQueue.uspIns_ExecutionLog
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @MessageQueueId    = @MessageQueueId,
  @JsonSchemaName    = @JsonSchemaName,
  /* General Column Data */
  @RowStatus         = @RowStatus,
  @RanByApplication  = @RanByApplication,
  @RanByHost         = @RanByHost,
  @RanOnDate         = @RanOnDate,
  @RanByUser         = @RanByUser,
  @Results           = @Results,
  /* App User Id / Modified By Id */
  @ModifiedBy        = NULL,
  /* Return output options */
  @ReturnOutput      = 1,
  @ReturnAsTable     = 1,
  @ReturnAsXml       = 1,
  /* Optimistic concurrency value */
  @RowsAffected      = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @ExecutionLogId    = @ExecutionLogId OUTPUT,
  /* XML Results Output */
  @XmlResults        = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @ExecutionLogId AS ExecutionLogId,
  @XmlResults AS XmlResults
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Inserts a single record into the table.',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'PROCEDURE',
  @level1name = N'uspIns_ExecutionLog';
GO
