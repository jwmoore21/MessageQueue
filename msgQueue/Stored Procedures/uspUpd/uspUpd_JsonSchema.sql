/*
IF EXISTS (SELECT 1 FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[msgQueue].[uspUpd_JsonSchema]') AND type in (N'P', N'PC'))
DROP PROCEDURE [msgQueue].[uspUpd_JsonSchema]
GO
*/

CREATE PROCEDURE [msgQueue].[uspUpd_JsonSchema]
  /* Identity / guid Primary Key(s) */
  @JsonSchemaName VARCHAR(64),
  /* Foreign Key(s) */
  /* General Column Data */
  @RowStatus      TINYINT           = NULL,
  @JsonSchema     NVARCHAR(4000)    = NULL,
  @ModifiedBy     INT,
  /* Debug Mode */
  @Debug          BIT = 0,
  /* Auditing Info */
  @AuditBatchId   VARCHAR(64) = NULL,
  @AuditOperation VARCHAR(255) = NULL,
  /* Return output options */
  @ReturnOutput   BIT = 0,
  @ReturnAsTable  BIT = 0,
  @ReturnAsXml    BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected   INT = 0 OUTPUT,
  /* XML Results Output */
  @XmlResults     XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
Schema:      msgQueue
Object:      uspUpd_JsonSchemaByRowGuid

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

    DECLARE @_RowStatus       TINYINT;
    DECLARE @_JsonSchemaName  VARCHAR(64);
    DECLARE @_JsonSchema      NVARCHAR(4000);
    DECLARE @_ModifiedBy      INT;


    SET @_RowStatus        = @RowStatus;
    SET @_JsonSchemaName   = @JsonSchemaName;
    SET @_JsonSchema       = @JsonSchema;
    SET @_ModifiedBy       = @ModifiedBy;

    /* ---------------------------------------------------------------------- */
    /* Debug Mode */
    DECLARE @_Debug    BIT;
    SET @_Debug = @Debug;

    /* ---------------------------------------------------------------------- */
    /* Auditing Info */
    DECLARE @_AuditStatus    TINYINT;
    DECLARE @_AuditAppUser   UNIQUEIDENTIFIER;
    DECLARE @_AuditSqlUser   VARCHAR(256);
    DECLARE @_AuditDate      DATETIME;
    DECLARE @_AuditBatchId   VARCHAR(64);
    DECLARE @_AuditOperation VARCHAR(255);

    SET @_AuditStatus    = 1; /* Update */
    SET @_AuditAppUser   = ( @_ModifiedBy );
    SET @_AuditSqlUser   = SYSTEM_USER;
    SET @_AuditDate      = GETUTCDATE();
    SET @_AuditBatchId   = COALESCE( @AuditBatchId, CONVERT(VARCHAR(64), ( CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER) ) ) );
    SET @_AuditOperation = COALESCE( @AuditOperation, 'Update proc ran: [msgQueue].[uspUpd_JsonSchema]' );

    IF ( @_Debug = 1 )
    BEGIN
      SELECT
          'Input values:'    AS DebugMessage
        , @_JsonSchema       AS JsonSchema
        , @_RowStatus        AS RowStatus
        , @_JsonSchemaName   AS JsonSchemaName
        , @_ModifiedBy       AS ModifiedBy
    END

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
      AND [tables].[name] = 'AuditJsonSchema'
    );

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
      AND OBJECTPROPERTY(object_id, 'SchemaId') = SCHEMA_ID('msgQueue')
      AND OBJECT_NAME([systemObject].[parent_object_id]) = 'JsonSchema'
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

    /* ---------------------------------------------------------------------- */
    /* Create a temp table to hold our updates */
    DECLARE @ChangeTableVar TABLE
    (
        [JsonSchemaName] VARCHAR(64)
      , [RowStatus]      TINYINT          NULL
      , [CreatedBy]      UNIQUEIDENTIFIER NULL
      , [CreatedDate]    DATETIMEOFFSET   NULL
      , [ModifiedBy]     UNIQUEIDENTIFIER NULL
      , [ModifiedDate]   DATETIMEOFFSET   NULL
      , [JsonSchema]     NVARCHAR(4000)   NULL
    );

    /* ---------------------------------------------------------------------- */
    /* Grab all of the records we wish to update first and save them into our
        temp ChangeTableVar. */
    INSERT INTO @ChangeTableVar
    (
        [JsonSchemaName]
      , [RowStatus]
      , [CreatedBy]
      , [CreatedDate]
      , [ModifiedBy]
      , [ModifiedDate] 
      , [JsonSchema]
    )
    SELECT
        [JsonSchema].[JsonSchemaName]
      , [JsonSchema].[RowStatus]
      , [JsonSchema].[CreatedBy]
      , [JsonSchema].[CreatedDate]
      , [JsonSchema].[ModifiedBy]
      , [JsonSchema].[ModifiedDate]
      
      , [JsonSchema].[JsonSchema]
    FROM
      [msgQueue].[JsonSchema] AS JsonSchema
    WHERE
      [JsonSchema].[JsonSchemaName] = @_JsonSchemaName
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
        , [JsonSchemaName] =
          CASE
            WHEN @_JsonSchemaName IS NOT NULL THEN @_JsonSchemaName
            WHEN LEN( @_JsonSchemaName ) > 0 THEN [JsonSchemaName]
            ELSE [JsonSchemaName]
          END
        , [JsonSchema] =
          CASE
            WHEN @_JsonSchema IS NOT NULL THEN @_JsonSchema
            WHEN LEN( @_JsonSchema ) > 0 THEN [JsonSchema]
            ELSE [JsonSchema]
          END
        , [ModifiedBy] = @_ModifiedBy
        , [ModifiedDate] = GETUTCDATE()
    WHERE
      [@ChangeTableVar].[JsonSchemaName] = @_JsonSchemaName
    ;

    IF ( @_Debug = 1 )
    BEGIN
      SELECT
        'Merged record values:' AS DebugMessage
        , [JsonSchemaId]
        , [RowStatus]
        , [CreatedBy]
        , [CreatedDate]
        , [ModifiedBy]
        , [ModifiedDate]
        , [JsonSchemaName]
        , [JsonSchema]
      FROM   @ChangeTableVar
    END

    /* ---------------------------------------------------------------------- */
    /* Update our actual table and audit the changes */
    UPDATE [msgQueue].[JsonSchema]
    SET
        [JsonSchema].[RowStatus]      = [ChangeTableVar].[RowStatus]
      , [JsonSchema].[CreatedBy]      = [ChangeTableVar].[CreatedBy]
      , [JsonSchema].[CreatedDate]    = [ChangeTableVar].[CreatedDate]
      , [JsonSchema].[ModifiedBy]     = [ChangeTableVar].[ModifiedBy]
      , [JsonSchema].[ModifiedDate]   = [ChangeTableVar].[ModifiedDate]
      , [JsonSchema].[JsonSchemaName] = [ChangeTableVar].[JsonSchemaName]
      , [JsonSchema].[JsonSchema]     = [ChangeTableVar].[JsonSchema]

    FROM @ChangeTableVar AS [ChangeTableVar]
    INNER JOIN [msgQueue].[JsonSchema] AS JsonSchema
    ON [JsonSchema].[JsonSchemaId] = [ChangeTableVar].[JsonSchemaId]
    ;

    IF ( @TableHasTrigger = 0 )
    BEGIN

      /*
      Now save the audit data ourselves. Do not save the audit data
      directly using an OUTPUT on the UPDATE statement itself. The audit
      tables should have triggers on them to prevent tampering. Tables which
      have triggers can not be written to directly from an OUTPUT statement.
      */
      INSERT INTO [audit].[AuditJsonSchema]
      (
         [AuditId]
        ,[AuditStatus]
        ,[AuditAppUser]
        ,[AuditSqlUser]
        ,[AuditDate]
        ,[AuditBatchId]
        ,[AuditOperation]
        ,[JsonSchemaName]
        ,[RowStatus]
        ,[CreatedDate]
        ,[ModifiedDate]
        ,[CreatedBy]
        ,[ModifiedBy]
        ,[JsonSchema]
      )
      SELECT
         NEWID()
        ,@_AuditStatus
        ,@_AuditAppUser
        ,@_AuditSqlUser
        ,@_AuditDate
        ,@_AuditBatchId
        ,@_AuditOperation
        ,[ChangeTableVar].[JsonSchemaName]
        ,[ChangeTableVar].[RowStatus]
        ,[ChangeTableVar].[CreatedDate]
        ,[ChangeTableVar].[ModifiedDate]
        ,[ChangeTableVar].[CreatedBy]
        ,[ChangeTableVar].[ModifiedBy]
        ,[ChangeTableVar].[JsonSchema]

      FROM
        @ChangeTableVar AS [ChangeTableVar];

    END; /* end if @TableHasTrigger */

    /* Send all of the altered data back to the caller, if they want it */
    IF @_ReturnOutput = 1
    BEGIN

      SELECT @RowsAffected = COALESCE( COUNT(1), 0 )
      FROM   @ChangeTableVar;

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [ChangeTableVar].[JsonSchemaName]
          , [ChangeTableVar].[RowStatus]
          , [ChangeTableVar].[CreatedBy]
          , [ChangeTableVar].[CreatedDate]
          , [ChangeTableVar].[ModifiedBy]
          , [ChangeTableVar].[ModifiedDate]
          , [ChangeTableVar].[JsonSchema]
        FROM
          @ChangeTableVar AS [ChangeTableVar]
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY
          SELECT
            @XmlResults =
            (
              SELECT
                  [ChangeTableVar].[JsonSchemaName]
                , [ChangeTableVar].[RowStatus]
                , [ChangeTableVar].[CreatedBy]
                , [ChangeTableVar].[CreatedDate]
                , [ChangeTableVar].[ModifiedBy]
                , [ChangeTableVar].[ModifiedDate]
                , [ChangeTableVar].[JsonSchema]
              FROM
                @ChangeTableVar AS [ChangeTableVar]
              FOR XML PATH ('JsonSchema'), ROOT ('UpdatedRecords'), ELEMENTS XSINIL
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

    /* Save the error */
    EXECUTE [eventLogs].[DatabaseErrorHandler]
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
DECLARE @JsonSchemaId   UNIQUEIDENTIFIER;
DECLARE @RowStatus      TINYINT;
DECLARE @ModifiedBy     VARCHAR(32);
DECLARE @JsonSchemaName VARCHAR(64);
DECLARE @JsonSchema     NVARCHAR(4000);

SET @RowStatus      = 1;
SET @ModifiedBy     = '119FD967-4F22-4832-B962-1187209EF83D';
SET @JsonSchemaName = 'Test Schema';
SET @JsonSchemaId   = ( SELECT [JsonSchemaId] FROM [msgQueue].[JsonSchema] WHERE [JsonSchemaName] = @JsonSchemaName );

SET @JsonSchema   = '[{
  "results" :
  {
    "message" : "ERROR",
    "details" : "The operation failed due to an error."
  }
}]';

EXEC msgQueue.uspUpd_JsonSchema
  @JsonSchemaId   = @JsonSchemaId,
  @RowStatus      = @RowStatus,
  @JsonSchemaName = @JsonSchemaName,
  @JsonSchema     = @JsonSchema,
  @ModifiedBy     = @ModifiedBy,
  @Debug          = 0,
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

SET @RowStatus = 0;

EXEC msgQueue.uspUpd_JsonSchema
  @JsonSchemaId   = @JsonSchemaId,
  @RowStatus      = @RowStatus,
  @ModifiedBy     = @ModifiedBy,
  @Debug          = 0,
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

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Updates a single record from the table if a coresponding audit table or trigger exists. Otherwise, aborts.',
  @level0type = N'SCHEMA',
  @level0name = N'msgQueue',  @level1type = N'PROCEDURE',
  @level1name = N'uspUpd_JsonSchema';
GO
