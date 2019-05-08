/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[msgQueue].[uspIns_JsonSchema]') AND type in (N'P', N'PC'))
DROP PROCEDURE [msgQueue].[uspIns_JsonSchema]
GO
*/

CREATE PROCEDURE [msgQueue].[uspIns_JsonSchema]
  /* Non-identity / guid Primary Key(s) */
  @NewJsonSchemaName VARCHAR(64)       ,
  /* Foreign Key(s) */
  /* General Column Data */
  @RowStatus         TINYINT           ,
  @SchemaDescription VARCHAR(255)      ,
  @JsonSchema        NVARCHAR(4000)    ,
  /* App User Id / Modified By Id */
  @ModifiedBy         UNIQUEIDENTIFIER  = NULL,

  /* Debug Mode */
  @Debug     BIT = 0,
  @ShowDebug BIT = 0,

  /* Return output options */
  @ReturnOutput      BIT = 0,
  @ReturnAsTable     BIT = 0,
  @ReturnAsXml       BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected      INT = 0 OUTPUT,
  /* Generated Primary Key Value(s) */
  @JsonSchemaName    VARCHAR(64) = NULL OUTPUT,
  /* XML Results Output */
  @XmlResults        XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      msgQueue
Object:      uspIns_JsonSchema

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
    DECLARE @_NewJsonSchemaName  VARCHAR(64);
    DECLARE @_RowStatus          TINYINT;
    DECLARE @_RowGuid            UNIQUEIDENTIFIER;
    DECLARE @_SchemaDescription  VARCHAR(255);
    DECLARE @_JsonSchema         NVARCHAR(4000);
    DECLARE @_ModifiedBy       UNIQUEIDENTIFIER;

    SET @_NewJsonSchemaName   = @NewJsonSchemaName;
    SET @_RowStatus           = @RowStatus;
    SET @_RowGuid             = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_SchemaDescription   = @SchemaDescription;
    SET @_JsonSchema          = @JsonSchema;
    SET @_ModifiedBy          = ( SELECT COALESCE( @ModifiedBy, '1' ) );

    /* ========================================================================= */
    /* Debug Mode */
    DECLARE @_Debug     BIT;
    DECLARE @_ShowDebug BIT;
    SET @_ShowDebug     = @Debug;
    SET @_ShowDebug     = @ShowDebug;

    IF ( @_ShowDebug = 1 )
    BEGIN
      SELECT
          'Input values:'      AS DebugMessage
        , @_NewJsonSchemaName   AS [JsonSchemaName]
        , @_RowStatus           AS [RowStatus]
        , @_RowGuid             AS [RowGuid]
        , @_SchemaDescription   AS [SchemaDescription]
        , @_JsonSchema          AS [JsonSchema]
    END

    /* ========================================================================= */
    /* Create a table var to hold our OUTPUT values */
    CREATE TABLE #OutputTableVar
    (
        [INSERTED_JsonSchemaName] VARCHAR(64) NOT NULL
    );

    /* ========================================================================= */
    /* Insert our record */
    INSERT INTO [msgQueue].[JsonSchema]
    (
         [JsonSchemaName]
       , [RowStatus]
       , [CreatedBy]
       , [ModifiedBy]
       , [RowGuid]
       , [SchemaDescription]
       , [JsonSchema]
     )

    OUTPUT
        [INSERTED].[JsonSchemaName]

    INTO
      #OutputTableVar

    VALUES
    (
        @_NewJsonSchemaName
      , @_RowStatus
      , @_ModifiedBy
      , @_ModifiedBy
      , @_RowGuid
      , @_SchemaDescription
      , @_JsonSchema
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
        @JsonSchemaName = [OutputTableVar].[INSERTED_JsonSchemaName]
      FROM #OutputTableVar AS OutputTableVar

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [JsonSchema].[JsonSchemaName]
          , [JsonSchema].[RowStatus]
          , [JsonSchema].[CreatedDate]
          , [JsonSchema].[ModifiedDate]
          , [JsonSchema].[CreatedBy]
          , [JsonSchema].[ModifiedBy]
          , [JsonSchema].[RowGuid]
          , [JsonSchema].[SchemaDescription]
          , [JsonSchema].[JsonSchema]
        FROM
          [msgQueue].[JsonSchema] AS [JsonSchema]
        WHERE
          [JsonSchema].[JsonSchemaName] = @JsonSchemaName
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY

          SELECT
            @XmlResults =
            (
              SELECT
                  [JsonSchema].[JsonSchemaName]
                , [JsonSchema].[RowStatus]
                , [JsonSchema].[CreatedDate]
                , [JsonSchema].[ModifiedDate]
                , [JsonSchema].[CreatedBy]
                , [JsonSchema].[ModifiedBy]
                , [JsonSchema].[RowGuid]
                , [JsonSchema].[SchemaDescription]
                , [JsonSchema].[JsonSchema]
              FROM
                [msgQueue].[JsonSchema] AS [JsonSchema]
              WHERE
                [JsonSchema].[JsonSchemaName] = @JsonSchemaName
              FOR XML PATH ('JsonSchema'), ROOT ('InsertedRecords'), ELEMENTS XSINIL
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

DECLARE @RowsAffected      INT;
DECLARE @XmlResults        XML;
DECLARE @JsonSchemaName    VARCHAR(64);
DECLARE @RowStatus         TINYINT;
DECLARE @CreatedBy         INT;
DECLARE @ModifiedBy        INT;
DECLARE @SchemaDescription VARCHAR(255);
DECLARE @JsonSchema        NVARCHAR(4000);

SET @JsonSchemaName     = [dbo].[ufn_LoremIpsumString](64, 0);
SET @RowStatus          = 1;
SET @CreatedBy          = 9;
SET @ModifiedBy         = 9;
SET @SchemaDescription  = [dbo].[ufn_LoremIpsumString](255, 0);
SET @JsonSchema         = [dbo].[ufn_LoremIpsumString](4000, 0);

EXEC msgQueue.uspIns_JsonSchema
  /* Non-identity / guid Primary Key(s) */
  @JsonSchemaName     = @JsonSchemaName,  /* Foreign Key(s) */
  /* General Column Data */
  @RowStatus          = @RowStatus,
  @CreatedBy          = @CreatedBy,
  @ModifiedBy         = @ModifiedBy,
  @SchemaDescription  = @SchemaDescription,
  @JsonSchema         = @JsonSchema,
  /* App User Id / Modified By Id */
  @ModifiedBy         = NULL,
  /* Return output options */
  @ReturnOutput       = 1,
  @ReturnAsTable      = 1,
  @ReturnAsXml        = 1,
  /* Optimistic concurrency value */
  @RowsAffected       = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @JsonSchemaName     = @JsonSchemaName OUTPUT,
  /* XML Results Output */
  @XmlResults         = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @JsonSchemaName AS JsonSchemaName,
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
  @level1name = N'uspIns_JsonSchema';
GO
