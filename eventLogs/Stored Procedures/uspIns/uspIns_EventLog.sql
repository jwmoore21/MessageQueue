/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[eventLogs].[uspIns_EventLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [eventLogs].[uspIns_EventLog]
GO
*/

CREATE PROCEDURE [eventLogs].[uspIns_EventLog]
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @EventType        VARCHAR(255)      ,
  /* General Column Data */
  @ApplicationId    INT               ,
  @ClientId         INT               ,
  @ServerId         INT               ,
  @RowStatus        TINYINT           ,
  @EventName        VARCHAR(255)      ,
  @EventDescription VARCHAR(1000)      = NULL,
  @EventDetails     XML                = NULL,
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
  @EventLogId       INT = NULL OUTPUT,
  /* XML Results Output */
  @XmlResults       XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      eventLogs
Object:      uspIns_EventLog

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
    DECLARE @_ApplicationId     INT;
    DECLARE @_ClientId          INT;
    DECLARE @_ServerId          INT;
    DECLARE @_RowStatus         TINYINT;
    DECLARE @_RowGuid           UNIQUEIDENTIFIER;
    DECLARE @_EventType         VARCHAR(255);
    DECLARE @_EventName         VARCHAR(255);
    DECLARE @_EventDescription  VARCHAR(1000);
    DECLARE @_EventDetails      XML;
    DECLARE @_ModifiedBy      UNIQUEIDENTIFIER;

    SET @_ApplicationId      = @ApplicationId;
    SET @_ClientId           = @ClientId;
    SET @_ServerId           = @ServerId;
    SET @_RowStatus          = @RowStatus;
    SET @_RowGuid            = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_EventType          = @EventType;
    SET @_EventName          = @EventName;
    SET @_EventDescription   = @EventDescription;
    SET @_EventDetails       = @EventDetails;
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
        , @_ApplicationId      AS [ApplicationId]
        , @_ClientId           AS [ClientId]
        , @_ServerId           AS [ServerId]
        , @_RowStatus          AS [RowStatus]
        , @_RowGuid            AS [RowGuid]
        , @_EventType          AS [EventType]
        , @_EventName          AS [EventName]
        , @_EventDescription   AS [EventDescription]
        , @_EventDetails       AS [EventDetails]
    END

    /* ========================================================================= */
    /* Create a table var to hold our OUTPUT values */
    CREATE TABLE #OutputTableVar
    (
        [INSERTED_EventLogId] INT NOT NULL
    );

    /* ========================================================================= */
    /* Insert our record */
    INSERT INTO [eventLogs].[EventLog]
    (
         [ApplicationId]
       , [ClientId]
       , [ServerId]
       , [RowStatus]
       , [CreatedBy]
       , [RowGuid]
       , [EventType]
       , [EventName]
       , [EventDescription]
       , [EventDetails]
     )

    OUTPUT
        [INSERTED].[EventLogId]

    INTO
      #OutputTableVar

    VALUES
    (
        @_ApplicationId
      , @_ClientId
      , @_ServerId
      , @_RowStatus
      , @_ModifiedBy
      , @_RowGuid
      , @_EventType
      , @_EventName
      , @_EventDescription
      , @_EventDetails
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
        @EventLogId = [OutputTableVar].[INSERTED_EventLogId]
      FROM #OutputTableVar AS OutputTableVar

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [EventLog].[EventLogId]
          , [EventLog].[ApplicationId]
          , [EventLog].[ClientId]
          , [EventLog].[ServerId]
          , [EventLog].[RowStatus]
          , [EventLog].[CreatedBy]
          , [EventLog].[CreatedDate]
          , [EventLog].[RowGuid]
          , [EventLog].[EventType]
          , [EventLog].[EventName]
          , [EventLog].[EventDescription]
          , [EventLog].[EventDetails]
        FROM
          [eventLogs].[EventLog] AS [EventLog]
        WHERE
          [EventLog].[EventLogId] = @EventLogId
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY

          SELECT
            @XmlResults =
            (
              SELECT
                  [EventLog].[EventLogId]
                , [EventLog].[ApplicationId]
                , [EventLog].[ClientId]
                , [EventLog].[ServerId]
                , [EventLog].[RowStatus]
                , [EventLog].[CreatedBy]
                , [EventLog].[CreatedDate]
                , [EventLog].[RowGuid]
                , [EventLog].[EventType]
                , [EventLog].[EventName]
                , [EventLog].[EventDescription]
                , [EventLog].[EventDetails]
              FROM
                [eventLogs].[EventLog] AS [EventLog]
              WHERE
                [EventLog].[EventLogId] = @EventLogId
              FOR XML PATH ('EventLog'), ROOT ('InsertedRecords'), ELEMENTS XSINIL
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
DECLARE @EventLogId       INT;
DECLARE @ApplicationId    INT;
DECLARE @ClientId         INT;
DECLARE @ServerId         INT;
DECLARE @RowStatus        TINYINT;
DECLARE @EventName        VARCHAR(255);
DECLARE @EventDescription VARCHAR(1000);
DECLARE @EventDetails     XML;

SET @ApplicationId     = 9;
SET @ClientId          = 9;
SET @ServerId          = 9;
SET @RowStatus         = 1;
SET @EventName         = [dbo].[ufn_LoremIpsumString](255, 0);
SET @EventDescription  = [dbo].[ufn_LoremIpsumString](1000, 0);
SET @EventDetails      = unknown GetUnitTestDataBySqlDataType::Microsoft.SqlServer.Management.Smo.DataType;

EXEC eventLogs.uspIns_EventLog
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @EventType         = @EventType,
  /* General Column Data */
  @ApplicationId     = @ApplicationId,
  @ClientId          = @ClientId,
  @ServerId          = @ServerId,
  @RowStatus         = @RowStatus,
  @EventName         = @EventName,
  @EventDescription  = @EventDescription,
  @EventDetails      = @EventDetails,
  /* App User Id / Modified By Id */
  @ModifiedBy        = NULL,
  /* Return output options */
  @ReturnOutput      = 1,
  @ReturnAsTable     = 1,
  @ReturnAsXml       = 1,
  /* Optimistic concurrency value */
  @RowsAffected      = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @EventLogId        = @EventLogId OUTPUT,
  /* XML Results Output */
  @XmlResults        = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @EventLogId AS EventLogId,
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
  @level1name = N'uspIns_EventLog';
GO