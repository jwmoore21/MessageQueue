/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[msgQueue].[uspIns_MessageQueue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [msgQueue].[uspIns_MessageQueue]
GO
*/

CREATE PROCEDURE [msgQueue].[uspIns_MessageQueue]
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @JsonSchemaName        VARCHAR(64)       ,
  @RowStatus             TINYINT           ,
  @HttpVerb              VARCHAR(8)        ,
  @ccTLD                 CHAR(3)           ,
  @SecondLevelDomain     VARCHAR(16)       ,
  @TopLevelDomain        VARCHAR(24)       ,
  @DomainName            VARCHAR(188)      ,
  @SubHostName           VARCHAR(63)       ,
  @HostName              VARCHAR(63)       ,
  @ScriptName            VARCHAR(128)       = NULL,
  @Datasource            VARCHAR(255)       = NULL,
  @DatabaseName          NVARCHAR(128)      = NULL,
  @DatabaseSchema        NVARCHAR(128)      = NULL,
  @DatabaseTable         NVARCHAR(128)      = NULL,
  /* General Column Data */
  @CreatedByApplication  VARCHAR(32)       ,
  @ModifiedByApplication VARCHAR(32)       ,
  @RunAgainstPort        INT               ,
  @JsonDocument          NVARCHAR(4000)    ,
  /* App User Id / Modified By Id */
  @ModifiedBy             UNIQUEIDENTIFIER  = NULL,

  /* Debug Mode */
  @Debug     BIT = 0,
  @ShowDebug BIT = 0,

  /* Return output options */
  @ReturnOutput          BIT = 0,
  @ReturnAsTable         BIT = 0,
  @ReturnAsXml           BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected          INT = 0 OUTPUT,
  /* Generated Primary Key Value(s) */
  @MessageQueueId        INT = NULL OUTPUT,
  /* XML Results Output */
  @XmlResults            XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      msgQueue
Object:      uspIns_MessageQueue

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
    DECLARE @_JsonSchemaName         VARCHAR(64);
    DECLARE @_RowStatus              TINYINT;
    DECLARE @_CreatedByApplication   VARCHAR(32);
    DECLARE @_ModifiedByApplication  VARCHAR(32);
    DECLARE @_RowGuid                UNIQUEIDENTIFIER;
    DECLARE @_RunAgainstPort         INT;
    DECLARE @_HttpVerb               VARCHAR(8);
    DECLARE @_ccTLD                  CHAR(3);
    DECLARE @_SecondLevelDomain      VARCHAR(16);
    DECLARE @_TopLevelDomain         VARCHAR(24);
    DECLARE @_DomainName             VARCHAR(188);
    DECLARE @_SubHostName            VARCHAR(63);
    DECLARE @_HostName               VARCHAR(63);
    DECLARE @_ScriptName             VARCHAR(128);
    DECLARE @_Datasource             VARCHAR(255);
    DECLARE @_DatabaseName           NVARCHAR(128);
    DECLARE @_DatabaseSchema         NVARCHAR(128);
    DECLARE @_DatabaseTable          NVARCHAR(128);
    DECLARE @_JsonDocument           NVARCHAR(4000);
    DECLARE @_ModifiedBy           UNIQUEIDENTIFIER;

    SET @_JsonSchemaName          = @JsonSchemaName;
    SET @_RowStatus               = @RowStatus;
    SET @_CreatedByApplication    = @CreatedByApplication;
    SET @_ModifiedByApplication   = @ModifiedByApplication;
    SET @_RowGuid                 = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_RunAgainstPort          = @RunAgainstPort;
    SET @_HttpVerb                = @HttpVerb;
    SET @_ccTLD                   = @ccTLD;
    SET @_SecondLevelDomain       = @SecondLevelDomain;
    SET @_TopLevelDomain          = @TopLevelDomain;
    SET @_DomainName              = @DomainName;
    SET @_SubHostName             = @SubHostName;
    SET @_HostName                = @HostName;
    SET @_ScriptName              = @ScriptName;
    SET @_Datasource              = @Datasource;
    SET @_DatabaseName            = @DatabaseName;
    SET @_DatabaseSchema          = @DatabaseSchema;
    SET @_DatabaseTable           = @DatabaseTable;
    SET @_JsonDocument            = @JsonDocument;
    SET @_ModifiedBy              = ( SELECT COALESCE( @ModifiedBy, '1' ) );

    /* ========================================================================= */
    /* Debug Mode */
    DECLARE @_Debug     BIT;
    DECLARE @_ShowDebug BIT;
    SET @_ShowDebug     = @Debug;
    SET @_ShowDebug     = @ShowDebug;

    IF ( @_ShowDebug = 1 )
    BEGIN
      SELECT
          'Input values:'          AS DebugMessage
        , @_JsonSchemaName          AS [JsonSchemaName]
        , @_RowStatus               AS [RowStatus]
        , @_CreatedByApplication    AS [CreatedByApplication]
        , @_ModifiedByApplication   AS [ModifiedByApplication]
        , @_RowGuid                 AS [RowGuid]
        , @_RunAgainstPort          AS [RunAgainstPort]
        , @_HttpVerb                AS [HttpVerb]
        , @_ccTLD                   AS [ccTLD]
        , @_SecondLevelDomain       AS [SecondLevelDomain]
        , @_TopLevelDomain          AS [TopLevelDomain]
        , @_DomainName              AS [DomainName]
        , @_SubHostName             AS [SubHostName]
        , @_HostName                AS [HostName]
        , @_ScriptName              AS [ScriptName]
        , @_Datasource              AS [Datasource]
        , @_DatabaseName            AS [DatabaseName]
        , @_DatabaseSchema          AS [DatabaseSchema]
        , @_DatabaseTable           AS [DatabaseTable]
        , @_JsonDocument            AS [JsonDocument]
    END

    /* ========================================================================= */
    /* Create a table var to hold our OUTPUT values */
    CREATE TABLE #OutputTableVar
    (
        [INSERTED_MessageQueueId] INT NOT NULL
    );

    /* ========================================================================= */
    /* Insert our record */
    INSERT INTO [msgQueue].[MessageQueue]
    (
         [JsonSchemaName]
       , [RowStatus]
       , [CreatedByApplication]
       , [ModifiedByApplication]
       , [CreatedBy]
       , [ModifiedBy]
       , [RowGuid]
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

    OUTPUT
        [INSERTED].[MessageQueueId]

    INTO
      #OutputTableVar

    VALUES
    (
        @_JsonSchemaName
      , @_RowStatus
      , @_ModifiedBy
      , @_ModifiedByApplication
      , @_ModifiedBy
      , @_ModifiedBy
      , @_RowGuid
      , @_RunAgainstPort
      , @_HttpVerb
      , @_ccTLD
      , @_SecondLevelDomain
      , @_TopLevelDomain
      , @_DomainName
      , @_SubHostName
      , @_HostName
      , @_ScriptName
      , @_Datasource
      , @_DatabaseName
      , @_DatabaseSchema
      , @_DatabaseTable
      , @_JsonDocument
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
        @MessageQueueId = [OutputTableVar].[INSERTED_MessageQueueId]
      FROM #OutputTableVar AS OutputTableVar

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [MessageQueue].[MessageQueueId]
          , [MessageQueue].[JsonSchemaName]
          , [MessageQueue].[RowStatus]
          , [MessageQueue].[CreatedDate]
          , [MessageQueue].[ModifiedDate]
          , [MessageQueue].[CreatedByApplication]
          , [MessageQueue].[ModifiedByApplication]
          , [MessageQueue].[CreatedBy]
          , [MessageQueue].[ModifiedBy]
          , [MessageQueue].[RowGuid]
          , [MessageQueue].[RunAgainstPort]
          , [MessageQueue].[HttpVerb]
          , [MessageQueue].[ccTLD]
          , [MessageQueue].[SecondLevelDomain]
          , [MessageQueue].[TopLevelDomain]
          , [MessageQueue].[DomainName]
          , [MessageQueue].[SubHostName]
          , [MessageQueue].[HostName]
          , [MessageQueue].[ScriptName]
          , [MessageQueue].[Datasource]
          , [MessageQueue].[DatabaseName]
          , [MessageQueue].[DatabaseSchema]
          , [MessageQueue].[DatabaseTable]
          , [MessageQueue].[JsonDocument]
        FROM
          [msgQueue].[MessageQueue] AS [MessageQueue]
        WHERE
          [MessageQueue].[MessageQueueId] = @MessageQueueId
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY

          SELECT
            @XmlResults =
            (
              SELECT
                  [MessageQueue].[MessageQueueId]
                , [MessageQueue].[JsonSchemaName]
                , [MessageQueue].[RowStatus]
                , [MessageQueue].[CreatedDate]
                , [MessageQueue].[ModifiedDate]
                , [MessageQueue].[CreatedByApplication]
                , [MessageQueue].[ModifiedByApplication]
                , [MessageQueue].[CreatedBy]
                , [MessageQueue].[ModifiedBy]
                , [MessageQueue].[RowGuid]
                , [MessageQueue].[RunAgainstPort]
                , [MessageQueue].[HttpVerb]
                , [MessageQueue].[ccTLD]
                , [MessageQueue].[SecondLevelDomain]
                , [MessageQueue].[TopLevelDomain]
                , [MessageQueue].[DomainName]
                , [MessageQueue].[SubHostName]
                , [MessageQueue].[HostName]
                , [MessageQueue].[ScriptName]
                , [MessageQueue].[Datasource]
                , [MessageQueue].[DatabaseName]
                , [MessageQueue].[DatabaseSchema]
                , [MessageQueue].[DatabaseTable]
                , [MessageQueue].[JsonDocument]
              FROM
                [msgQueue].[MessageQueue] AS [MessageQueue]
              WHERE
                [MessageQueue].[MessageQueueId] = @MessageQueueId
              FOR XML PATH ('MessageQueue'), ROOT ('InsertedRecords'), ELEMENTS XSINIL
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

DECLARE @RowsAffected          INT;
DECLARE @XmlResults            XML;
DECLARE @MessageQueueId        INT;
DECLARE @CreatedByApplication  VARCHAR(32);
DECLARE @ModifiedByApplication VARCHAR(32);
DECLARE @RunAgainstPort        INT;
DECLARE @JsonDocument          NVARCHAR(4000);

SET @CreatedByApplication   = [dbo].[ufn_LoremIpsumString](32, 0);
SET @ModifiedByApplication  = [dbo].[ufn_LoremIpsumString](32, 0);
SET @RunAgainstPort         = 9;
SET @JsonDocument           = [dbo].[ufn_LoremIpsumString](4000, 0);

EXEC msgQueue.uspIns_MessageQueue
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @JsonSchemaName         = @JsonSchemaName,
  @RowStatus              = @RowStatus,
  @HttpVerb               = @HttpVerb,
  @ccTLD                  = @ccTLD,
  @SecondLevelDomain      = @SecondLevelDomain,
  @TopLevelDomain         = @TopLevelDomain,
  @DomainName             = @DomainName,
  @SubHostName            = @SubHostName,
  @HostName               = @HostName,
  @ScriptName             = @ScriptName,
  @Datasource             = @Datasource,
  @DatabaseName           = @DatabaseName,
  @DatabaseSchema         = @DatabaseSchema,
  @DatabaseTable          = @DatabaseTable,
  /* General Column Data */
  @CreatedByApplication   = @CreatedByApplication,
  @ModifiedByApplication  = @ModifiedByApplication,
  @RunAgainstPort         = @RunAgainstPort,
  @JsonDocument           = @JsonDocument,
  /* App User Id / Modified By Id */
  @ModifiedBy             = NULL,
  /* Return output options */
  @ReturnOutput           = 1,
  @ReturnAsTable          = 1,
  @ReturnAsXml            = 1,
  /* Optimistic concurrency value */
  @RowsAffected           = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @MessageQueueId         = @MessageQueueId OUTPUT,
  /* XML Results Output */
  @XmlResults             = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @MessageQueueId AS MessageQueueId,
  @XmlResults AS XmlResults
;

SET @HttpVerb     = 'PUT';
SET @JsonDocument = '[{
  "facilities" :
  {
    "TempID"       : "1350",
    "Oriented"     : "0",
    "ShareTempYN"  : "",
    "FacilityNote" : "Facility updated by Mass DNR",
    "recordid"     : "1025",
    "ClockingID"   : "",
    "FacilityDNR"  : "yes",
    "FacilityPref" :  ""
  }
}]';

EXEC msgQueue.uspIns_messagequeue
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @JsonSchemaId           = @JsonSchemaId,  /* General Column Data */
  @RowStatus              = @RowStatus,
  @ModifiedByApplication  = @ModifiedByApplication,
  @ModifiedBy             = @ModifiedBy,
  @RunAgainstHost         = @RunAgainstHost,
  @RunAgainstDatabase     = @RunAgainstDatabase,
  @RunAgainstSchema       = @RunAgainstSchema,
  @RunAgainstTable        = @RunAgainstTable,
  @HttpVerb               = @HttpVerb,
  @JsonDocument           = @JsonDocument,
  @Debug                  = 0,
  /* Return output options */
  @ReturnOutput           = 1,
  @ReturnAsTable          = 1,
  @ReturnAsXml            = 1,
  /* Optimistic concurrency value */
  @RowsAffected           = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @MessageQueueId         = @MessageQueueId OUTPUT,
  /* XML Results Output */
  @XmlResults             = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @MessageQueueId AS MessageQueueId,
  @XmlResults AS XmlResults
;

SET @HttpVerb     = 'POST';
SET @JsonDocument = '[{
  "facilities" :
  {
    "TempID"       : "1350",
    "Oriented"     : "0",
    "ShareTempYN"  : "",
    "FacilityNote" : "Facility updated by Mass DNR",
    "recordid"     : "1025",
    "ClockingID"   : "",
    "FacilityDNR"  : "yes",
    "FacilityPref" :  ""
  }
}]';

EXEC msgQueue.uspIns_messagequeue
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @JsonSchemaId           = @JsonSchemaId,  /* General Column Data */
  @RowStatus              = @RowStatus,
  @ModifiedByApplication  = @ModifiedByApplication,
  @ModifiedBy             = @ModifiedBy,
  @RunAgainstHost         = @RunAgainstHost,
  @RunAgainstDatabase     = @RunAgainstDatabase,
  @RunAgainstSchema       = @RunAgainstSchema,
  @RunAgainstTable        = @RunAgainstTable,
  @HttpVerb               = @HttpVerb,
  @JsonDocument           = @JsonDocument,
  @Debug                  = 0,
  /* Return output options */
  @ReturnOutput           = 1,
  @ReturnAsTable          = 1,
  @ReturnAsXml            = 1,
  /* Optimistic concurrency value */
  @RowsAffected           = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @MessageQueueId         = @MessageQueueId OUTPUT,
  /* XML Results Output */
  @XmlResults             = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @MessageQueueId AS MessageQueueId,
  @XmlResults AS XmlResults
;

SET @HttpVerb     = 'PUT';
SET @JsonDocument = '[{
  "facilities" :
  {
    "recordid"     : "844",
    "FacilityNote" : "Facility updated by Mass DNR"
  }
}]';

EXEC msgQueue.uspIns_messagequeue
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @JsonSchemaId           = @JsonSchemaId,  /* General Column Data */
  @RowStatus              = @RowStatus,
  @ModifiedByApplication  = @ModifiedByApplication,
  @ModifiedBy             = @ModifiedBy,
  @RunAgainstHost         = @RunAgainstHost,
  @RunAgainstDatabase     = @RunAgainstDatabase,
  @RunAgainstSchema       = @RunAgainstSchema,
  @RunAgainstTable        = @RunAgainstTable,
  @HttpVerb               = @HttpVerb,
  @JsonDocument           = @JsonDocument,
  @Debug                  = 0,
  /* Return output options */
  @ReturnOutput           = 1,
  @ReturnAsTable          = 1,
  @ReturnAsXml            = 1,
  /* Optimistic concurrency value */
  @RowsAffected           = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @MessageQueueId         = @MessageQueueId OUTPUT,
  /* XML Results Output */
  @XmlResults             = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @MessageQueueId AS MessageQueueId,
  @XmlResults AS XmlResults
;


SET @HttpVerb     = 'PATCH';
SET @JsonDocument = '[{
  "facilities" :
  {
    "recordid"     : "270",
    "FacilityID"   : "729",
    "TempID"       : "1610",
    "FacilityNote" :  "Facility updated by CFScheduler"
  }
}]';

EXEC msgQueue.uspIns_messagequeue
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @JsonSchemaId           = @JsonSchemaId,  /* General Column Data */
  @RowStatus              = @RowStatus,
  @ModifiedByApplication  = @ModifiedByApplication,
  @ModifiedBy             = @ModifiedBy,
  @RunAgainstHost         = @RunAgainstHost,
  @RunAgainstDatabase     = @RunAgainstDatabase,
  @RunAgainstSchema       = @RunAgainstSchema,
  @RunAgainstTable        = @RunAgainstTable,
  @HttpVerb               = @HttpVerb,
  @JsonDocument           = @JsonDocument,
  @Debug                  = 0,
  /* Return output options */
  @ReturnOutput           = 1,
  @ReturnAsTable          = 1,
  @ReturnAsXml            = 1,
  /* Optimistic concurrency value */
  @RowsAffected           = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @MessageQueueId         = @MessageQueueId OUTPUT,
  /* XML Results Output */
  @XmlResults             = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @MessageQueueId AS MessageQueueId,
  @XmlResults AS XmlResults
;

/*
CFML function updateTempFacility(
		required numeric facilityID,
		required numeric tempID,
		numeric facilityStatus = 0,
		string clockingID = "",
		string facilityNote = "",
		boolean oriented = false,
		boolean shareTempYN = false
	)
*/

SET @HttpVerb     = 'PUT';
SET @JsonDocument = '[{
  "facilities" :
  {
    "recordid"     : "844",
    "FacilityID"   : "300",
    "TempID"       : "1350",
    "FacilityPref" :  "",
    "FacilityDNR"  : "yes",
    "FacilityNote" : "Facility updated by Mass DNR",
    "Oriented"     : "0",
    "ShareTempYN"  : "",
    "ClockingID"   : ""
  }
}]';

EXEC msgQueue.uspIns_messagequeue
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @JsonSchemaId           = @JsonSchemaId,  /* General Column Data */
  @RowStatus              = @RowStatus,
  @ModifiedByApplication  = @ModifiedByApplication,
  @ModifiedBy             = @ModifiedBy,
  @RunAgainstHost         = @RunAgainstHost,
  @RunAgainstDatabase     = @RunAgainstDatabase,
  @RunAgainstSchema       = @RunAgainstSchema,
  @RunAgainstTable        = @RunAgainstTable,
  @HttpVerb               = @HttpVerb,
  @JsonDocument           = @JsonDocument,
  @Debug                  = 0,
  /* Return output options */
  @ReturnOutput           = 1,
  @ReturnAsTable          = 1,
  @ReturnAsXml            = 1,
  /* Optimistic concurrency value */
  @RowsAffected           = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @MessageQueueId         = @MessageQueueId OUTPUT,
  /* XML Results Output */
  @XmlResults             = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @MessageQueueId AS MessageQueueId,
  @XmlResults AS XmlResults
;


/*
CFML function deleteTempFacility(required numeric tempID, array facilityIDs)
*/


SET @HttpVerb     = 'DELETE';
SET @JsonDocument = '[{
  "facilities" :
  {
    "recordid"   : "57",
    "FacilityID" : "300"
  }
}]';

EXEC msgQueue.uspIns_messagequeue
  /* Non-identity / guid Primary Key(s) */
  /* Foreign Key(s) */
  @JsonSchemaId           = @JsonSchemaId,  /* General Column Data */
  @RowStatus              = @RowStatus,
  @ModifiedByApplication  = @ModifiedByApplication,
  @ModifiedBy             = @ModifiedBy,
  @RunAgainstHost         = @RunAgainstHost,
  @RunAgainstDatabase     = @RunAgainstDatabase,
  @RunAgainstSchema       = @RunAgainstSchema,
  @RunAgainstTable        = @RunAgainstTable,
  @HttpVerb               = @HttpVerb,
  @JsonDocument           = @JsonDocument,
  @Debug                  = 0,
  /* Return output options */
  @ReturnOutput           = 1,
  @ReturnAsTable          = 1,
  @ReturnAsXml            = 1,
  /* Optimistic concurrency value */
  @RowsAffected           = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @MessageQueueId         = @MessageQueueId OUTPUT,
  /* XML Results Output */
  @XmlResults             = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @MessageQueueId AS MessageQueueId,
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
  @level1name = N'uspIns_MessageQueue';
GO
