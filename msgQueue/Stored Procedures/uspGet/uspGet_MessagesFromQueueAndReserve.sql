/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[msgQueue].[uspGet_MessagesFromQueueAndReserve]') AND type in (N'P', N'PC'))
DROP PROCEDURE [msgQueue].[uspGet_MessagesFromQueueAndReserve]
GO
*/

CREATE PROCEDURE [msgQueue].[uspGet_MessagesFromQueueAndReserve]
  @TotalMsgToFind        TINYINT     = 20,
  @ModifiedByApplication VARCHAR(32) = 'CFScheduler',
  @ModifiedBy            UNIQUEIDENTIFIER,
  /* Debug Mode */
  @Debug                 BIT         = 0
WITH EXECUTE AS SELF
AS

/*******************************************************************************
Schema:      msgQueue
Object:      uspIns_messagequeue

Description: Insert a record into the given table.

Returns:     If successful, returns one result set; if not successful, returns
             information about the error that occured during processing.

*******************************************************************************/
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRANSACTION;

    /* ---------------------------------------------------------------------- */
    /* Local Vars */

    DECLARE @_TotalMsgToFind        INT;
    DECLARE @_ModifiedByApplication VARCHAR(32);
    DECLARE @_ModifiedBy            UNIQUEIDENTIFIER;
    DECLARE @_Debug                 BIT;

    SET @_TotalMsgToFind        = @TotalMsgToFind
    SET @_ModifiedByApplication = @ModifiedByApplication  
    SET @_ModifiedBy            = @ModifiedBy
    SET @_Debug                 = @Debug

    DECLARE @_NotRun   TINYINT     = ( 0 );
    DECLARE @_Reserved TINYINT     = ( 3 );

    DECLARE @MessagesToProcess AS TABLE
    (
      [MessageQueueId] UNIQUEIDENTIFIER NOT NULL
    );

    /* First, attempt to locate any messages to process */
    INSERT INTO @MessagesToProcess
    (
      [MessageQueueId]
    )
    SELECT
      TOP ( @TotalMsgToFind )
      [MessageQueue].[MessageQueueId]
    FROM 
      [msgQueue].[MessageQueue] AS [MessageQueue]

      INNER JOIN [msgQueue].[JsonSchema] AS [JsonSchema]
      ON [MessageQueue].[JsonSchemaName] = [JsonSchema].[JsonSchemaName]

    WHERE 
      [MessageQueue].[RowStatus] = @_NotRun
    ORDER BY 
      [MessageQueue].[CreatedDate] DESC
    ;

    /* If we have an records to process, reserve them, then send back to the caller */
    IF ( SELECT COALESCE( COUNT(1), 0 ) FROM @MessagesToProcess  ) > 0 
    BEGIN

      UPDATE [msgQueue].[MessageQueue]
        SET 
            [RowStatus] = @_Reserved
          , [ModifiedDate] = GETUTCDATE()
          , [ModifiedByApplication] = @_ModifiedByApplication
          , [ModifiedBy] = @_ModifiedBy
    
        FROM @MessagesToProcess AS [MessagesToProcess]
    
        INNER JOIN [msgQueue].[MessageQueue] AS MessageQueue
        ON [MessageQueue].[MessageQueueId] = [MessagesToProcess].[MessageQueueId]
  
      SELECT  
          [MessageQueue].[MessageQueueId]
        , [MessageQueue].[JsonSchemaId]
        , [MessageQueue].[RowStatus]
        , [MessageQueue].[RunAgainstHost]
        , [MessageQueue].[RunAgainstDatabase]
        , [MessageQueue].[RunAgainstSchema]
        , [MessageQueue].[RunAgainstTable]
        , [MessageQueue].[HttpVerb]
        , [JsonSchema].[JsonSchemaName]
        , [JsonSchema].[JsonSchema]
        , [MessageQueue].[JsonDocument]
      FROM 
        [msgQueue].[MessageQueue] AS [MessageQueue]

        INNER JOIN @MessagesToProcess AS [MessagesToProcess]
        ON [MessageQueue].[MessageQueueId] = [MessagesToProcess].[MessageQueueId]

        INNER JOIN [msgQueue].[JsonSchema] AS [JsonSchema]
        ON [MessageQueue].[JsonSchemaId] = [JsonSchema].[JsonSchemaId]
      ;

    END 

    /* No error or issues, commit the transaction, if we are not in debug mode */
    IF ( @Debug = 0 )
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
    );

  END CATCH;

END;
/*
Example usage:

DECLARE @TotalMsgToFind        INT         = ( 5 );
DECLARE @ModifiedByApplication VARCHAR(32) = ( 'CFScheduler' );
DECLARE @ModifiedBy            VARCHAR(32) = ( 'CFScheduler' );
DECLARE @Debug                 BIT         = ( 1 );

EXEC [msgQueue].[uspGet_MessagesFromQueueAndReserve]
  @TotalMsgToFind        = @TotalMsgToFind,
  @ModifiedByApplication = @ModifiedByApplication,
  @ModifiedBy            = @ModifiedBy,
  @Debug                 = @Debug

EXEC [msgQueue].[uspGet_MessagesFromQueueAndReserve]
  @TotalMsgToFind        = 5,
  @Debug                 = 1

*/
GO

EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Attempts to locate any Message Queue records that have not been processed. If found, reserves them for the calling task scheduler',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',
  @level1type = N'PROCEDURE',
  @level1name = N'uspGet_MessagesFromQueueAndReserve';
GO