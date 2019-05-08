/*
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[msgQueue].[uspUpd_MessageQueue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [msgQueue].[uspUpd_MessageQueue]
GO
*/

CREATE PROCEDURE [msgQueue].[uspUpd_MessageQueue]
  /* Identity / guid Primary Key(s) */
  @MessageQueueId        INT  ,
  /* Foreign Key(s) */
  @JsonSchemaName        VARCHAR(64)  ,
  /* General Column Data */
  @RowStatus             TINYINT           = NULL,
  @ModifiedByApplication VARCHAR(32)       = NULL,
  @ModifiedBy            UNIQUEIDENTIFIER  = NULL,
  @HttpVerb              VARCHAR(6)        = NULL,
  @JsonDocument          NVARCHAR(4000)    = NULL,
  /* Debug Mode */
  @Debug                 BIT = 0,
  /* Return output options */
  @ReturnOutput          BIT = 0,
  @ReturnAsTable         BIT = 0,
  @ReturnAsXml           BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected          INT = 0 OUTPUT,
  /* XML Results Output */
  @XmlResults            XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
Schema:      msgQueue
Object:      uspUpd_MessageQueue

Description: Updates a record(s) from the given table. Check for the existence of
             a table INSTEAD OF UPDATE trigger, if found, let the table trigger
             handle the auditing of the deleted record(s), otherwise, this proc
             with save the audit trail.

Returns:     If successful, returns one result set; if not successful, returns
             information about the error that occurred during processing.

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
    /* Local Vars */
    DECLARE @_MessageQueueId         INT;
    DECLARE @_JsonSchemaName         VARCHAR(64);
    DECLARE @_RowStatus              TINYINT;
    DECLARE @_ModifiedByApplication  VARCHAR(32);
    DECLARE @_ModifiedBy             UNIQUEIDENTIFIER;
    DECLARE @_HttpVerb               VARCHAR(6);
    DECLARE @_JsonDocument           NVARCHAR(4000);

    SET @_MessageQueueId          = @MessageQueueId;
    SET @_JsonSchemaName          = @JsonSchemaName;
    SET @_RowStatus               = @RowStatus;
    SET @_ModifiedByApplication   = @ModifiedByApplication;
    SET @_ModifiedBy              = @ModifiedBy;
    SET @_HttpVerb                = @HttpVerb;
    SET @_JsonDocument            = @JsonDocument;

    /* ---------------------------------------------------------------------- */
    /* Debug Mode */
    DECLARE @_Debug    BIT;
    SET @_Debug = @Debug;

    IF ( @_Debug = 1 )
    BEGIN
      SELECT
          'Input values:'         AS DebugMessage
        , @_MessageQueueId        AS MessageQueueId
        , @_JsonSchemaName        AS JsonSchemaName
        , @_RowStatus             AS RowStatus
        , @_ModifiedByApplication AS ModifiedByApplication
        , @_ModifiedBy            AS ModifiedBy
        , @_HttpVerb              AS HttpVerb
        , @_JsonDocument          AS JsonDocument
    END

    /* ---------------------------------------------------------------------- */
    /* Create a temp table to hold our updates */
    DECLARE @ChangeTableVar TABLE
    (
        [MessageQueueId]        INT              NULL
      , [JsonSchemaName]        VARCHAR(64)      NULL
      , [RowStatus]             tinyint          NULL
      , [CreatedDate]           DATETIMEOFFSET   NULL
      , [ModifiedDate]          DATETIMEOFFSET   NULL
      , [CreatedByApplication]  varchar(32)      NULL
      , [ModifiedByApplication] varchar(32)      NULL
      , [CreatedBy]             UNIQUEIDENTIFIER NULL
      , [ModifiedBy]            UNIQUEIDENTIFIER NULL
      , [HttpVerb]              varchar(6)       NULL
      , [JsonDocument]          nvarchar(4000)   NULL
    );

    /* ---------------------------------------------------------------------- */
    /* Grab all of the records we wish to update first and save them into our
        temp ChangeTableVar. */
    INSERT INTO @ChangeTableVar
    (
        [MessageQueueId]
      , [JsonSchemaName]
      , [RowStatus]
      , [CreatedDate]
      , [ModifiedDate]
      , [CreatedByApplication]
      , [ModifiedByApplication]
      , [CreatedBy]
      , [ModifiedBy]
      , [HttpVerb]
      , [JsonDocument]
    )
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
      , [MessageQueue].[HttpVerb]
      , [MessageQueue].[JsonDocument]
    FROM
      [msgQueue].[MessageQueue] AS MessageQueue
    WHERE
      [MessageQueue].[MessageQueueId] = @_MessageQueueId
    ;

    /* ---------------------------------------------------------------------- */
    /* Make the changes we wish to make to the TEMP data first */
    UPDATE @ChangeTableVar
      SET
          [RowStatus] =
          CASE
            WHEN @_RowStatus IS NOT NULL THEN @_RowStatus
            WHEN LEN( @_RowStatus ) > 0 THEN [RowStatus]
            ELSE [RowStatus]
          END
        , [ModifiedByApplication] =
          CASE
            WHEN @_ModifiedByApplication IS NOT NULL THEN @_ModifiedByApplication
            WHEN LEN( @_ModifiedByApplication ) > 0 THEN [ModifiedByApplication]
            ELSE [ModifiedByApplication]
          END
        , [HttpVerb] =
          CASE
            WHEN @_HttpVerb IS NOT NULL THEN @_HttpVerb
            WHEN LEN( @_HttpVerb ) > 0 THEN [HttpVerb]
            ELSE [HttpVerb]
          END
        , [JsonDocument] =
          CASE
            WHEN @_JsonDocument IS NOT NULL THEN @_JsonDocument
            WHEN LEN( @_JsonDocument ) > 0 THEN [JsonDocument]
            ELSE [JsonDocument]
          END
        , [ModifiedBy] = @_ModifiedBy
        , [ModifiedDate] = GETUTCDATE()
    WHERE
      [@ChangeTableVar].[MessageQueueId] = @_MessageQueueId
    AND [@ChangeTableVar].[JsonSchemaName] = @_JsonSchemaName
    ;

    IF ( @_Debug = 1 )
    BEGIN
      SELECT 
        'Merged record values:' AS DebugMessage
        , [MessageQueueId]        
        , [JsonSchemaName]          
        , [RowStatus]             
        , [CreatedDate]           
        , [ModifiedDate]          
        , [CreatedByApplication]  
        , [ModifiedByApplication] 
        , [CreatedBy]             
        , [ModifiedBy]   
        , [HttpVerb]              
        , [JsonDocument]     
      FROM
        @ChangeTableVar
    END

    /* ---------------------------------------------------------------------- */
    /* Update our actual table and audit the changes */
    UPDATE [msgQueue].[MessageQueue]
    SET
        [MessageQueue].[RowStatus]             = [ChangeTableVar].[RowStatus]
      , [MessageQueue].[ModifiedDate]          = [ChangeTableVar].[ModifiedDate]
      , [MessageQueue].[ModifiedByApplication] = [ChangeTableVar].[ModifiedByApplication]
      , [MessageQueue].[ModifiedBy]            = [ChangeTableVar].[ModifiedBy]
      , [MessageQueue].[HttpVerb]              = [ChangeTableVar].[HttpVerb]
      , [MessageQueue].[JsonDocument]          = [ChangeTableVar].[JsonDocument]

    FROM @ChangeTableVar AS [ChangeTableVar]
    INNER JOIN [msgQueue].[MessageQueue] AS MessageQueue
    ON [MessageQueue].[MessageQueueId] = [ChangeTableVar].[MessageQueueId]
    AND [MessageQueue].[JsonSchemaName] = [ChangeTableVar].[JsonSchemaName]
    ;

    /* Send all of the altered data back to the caller, if they want it */
    IF @_ReturnOutput = 1
    BEGIN

      SELECT @RowsAffected = COALESCE( COUNT(1), 0 )
      FROM   @ChangeTableVar;

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [ChangeTableVar].[MessageQueueId]
          , [ChangeTableVar].[JsonSchemaName]
          , [ChangeTableVar].[RowStatus]
          , [ChangeTableVar].[CreatedDate]
          , [ChangeTableVar].[ModifiedDate]
          , [ChangeTableVar].[CreatedByApplication]
          , [ChangeTableVar].[ModifiedByApplication]
          , [ChangeTableVar].[CreatedBy]
          , [ChangeTableVar].[ModifiedBy]
          , [ChangeTableVar].[RunAgainstHost]
          , [ChangeTableVar].[RunAgainstDatabase]
          , [ChangeTableVar].[RunAgainstSchema]
          , [ChangeTableVar].[RunAgainstTable]
          , [ChangeTableVar].[HttpVerb]
          , [ChangeTableVar].[JsonDocument]
        FROM
          @ChangeTableVar AS [ChangeTableVar];

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY
          SELECT
            @XmlResults =
            (
              SELECT
                  [ChangeTableVar].[MessageQueueId]
                , [ChangeTableVar].[JsonSchemaName]
                , [ChangeTableVar].[RowStatus]
                , [ChangeTableVar].[CreatedDate]
                , [ChangeTableVar].[ModifiedDate]
                , [ChangeTableVar].[CreatedByApplication]
                , [ChangeTableVar].[ModifiedByApplication]
                , [ChangeTableVar].[CreatedBy]
                , [ChangeTableVar].[ModifiedBy]
                , [ChangeTableVar].[RunAgainstHost]
                , [ChangeTableVar].[RunAgainstDatabase]
                , [ChangeTableVar].[RunAgainstSchema]
                , [ChangeTableVar].[RunAgainstTable]
                , [ChangeTableVar].[HttpVerb]
                , [ChangeTableVar].[JsonDocument]
              FROM
                @ChangeTableVar AS [ChangeTableVar]
              FOR XML PATH ('MessageQueue'), ROOT ('UpdatedRecords'), ELEMENTS XSINIL
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

    /* No error or issues, commit the transaction, if we are not in debug mode */
    IF @_Debug = 0
    BEGIN
      COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
      ROLLBACK TRANSACTION;
      PRINT 'DEBUG MODE IS ENABLED... Transaction has been ROLLED BACK'
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
    ) WITH LOG;

    /* Save the error
    EXECUTE [eventLogs].[DatabaseErrorHandler]
      @DbName         = @DbName,
      @ErrorNumber    = @ErrorNumber,
      @ErrorSeverity  = @ErrorSeverity,
      @ErrorState     = @ErrorState,
      @ErrorProcedure = @ErrorProcedure,
      @ErrorLine      = @ErrorLine,
      @ErrorMessage   = @ErrorMessage;
    */
  END CATCH;

END;

/*
Example usage:

DECLARE @RowsAffected          INT;
DECLARE @XmlResults            XML;
DECLARE @ExecutionLogId        UNIQUEIDENTIFIER;
DECLARE @MessageQueueId        UNIQUEIDENTIFIER;
DECLARE @JsonSchemaId          UNIQUEIDENTIFIER;
DECLARE @RowStatus             TINYINT;
DECLARE @ModifiedByApplication VARCHAR(32);
DECLARE @ModifiedBy            UNIQUEIDENTIFIER;
DECLARE @RunAgainstHost        VARCHAR(128);
DECLARE @RunAgainstDatabase    NVARCHAR(128);
DECLARE @RunAgainstSchema      NVARCHAR(128);
DECLARE @RunAgainstTable       NVARCHAR(128);
DECLARE @HttpVerb              VARCHAR(6);
DECLARE @JsonDocument          NVARCHAR(4000);

DECLARE @JsonSchemaName        VARCHAR(64) = 'AppMgr.masterLists.AddressType';

SET @MessageQueueId =
(
  SELECT TOP 1
    [MessageQueue].[MessageQueueId]

  FROM [msgQueue].[MessageQueue] AS [MessageQueue]

  INNER JOIN [msgQueue].[JsonSchema] AS [JsonSchema]
  ON [MessageQueue].JsonSchemaId = [JsonSchema].JsonSchemaId
  AND [JsonSchema].JsonSchemaName = @JsonSchemaName

  WHERE
    [MessageQueue].[RowStatus] = 1
  ORDER BY
    [MessageQueue].[CreatedDate] DESC

);
SET @JsonSchemaId      = ( SELECT JsonSchemaId FROM [msgQueue].[JsonSchema] WHERE [JsonSchemaName] = @JsonSchemaName );

SET @RunAgainstHost     = '127.0.0.1';
SET @RunAgainstDatabase = 'AppMgr';
SET @RunAgainstSchema   = 'masterLists';
SET @RunAgainstTable    = 'facilities';

SET @ModifiedBy = '119FD967-4F22-4832-B962-1187209EF83D';
SET @HttpVerb = 'GET';

EXEC msgQueue.uspUpd_MessageQueue
  @MessageQueueId        = @MessageQueueId,
  @JsonSchemaId          = @JsonSchemaId,
  @RowStatus             = @RowStatus,
  @ModifiedByApplication = @ModifiedByApplication,
  @ModifiedBy            = @ModifiedBy,
  @RunAgainstHost        = @RunAgainstHost,
  @RunAgainstDatabase    = @RunAgainstDatabase,
  @RunAgainstSchema      = @RunAgainstSchema,
  @RunAgainstTable       = @RunAgainstTable,
  @HttpVerb              = @HttpVerb,
  @JsonDocument          = @JsonDocument,
  @Debug                 = 1,
  @ReturnOutput          = 1,
  @ReturnAsTable         = 1,
  @ReturnAsXml           = 1,
  @RowsAffected          = @RowsAffected OUTPUT,
  @XmlResults            = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @XmlResults AS XmlResults
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Updates a single record from the table if a coresponding audit table or trigger exists. Otherwise, aborts.',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'PROCEDURE',
  @level1name = N'uspUpd_MessageQueue';
GO
