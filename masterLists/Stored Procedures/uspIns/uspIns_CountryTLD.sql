/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[masterLists].[uspIns_CountryTLD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [masterLists].[uspIns_CountryTLD]
GO
*/

CREATE PROCEDURE [masterLists].[uspIns_CountryTLD]
  /* Non-identity / guid Primary Key(s) */
  @NewccTLD       CHAR(3)           ,
  /* Foreign Key(s) */
  @RowStatus      TINYINT           ,
  /* General Column Data */
  @Entity         VARCHAR(128)       = NULL,
  @Notes          VARCHAR(2000)      = NULL,
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
  @ccTLD          CHAR(3) = NULL OUTPUT,
  /* XML Results Output */
  @XmlResults     XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      masterLists
Object:      uspIns_CountryTLD

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
    DECLARE @_NewccTLD        CHAR(3);
    DECLARE @_RowStatus       TINYINT;
    DECLARE @_RowGuid         UNIQUEIDENTIFIER;
    DECLARE @_Entity          VARCHAR(128);
    DECLARE @_Notes           VARCHAR(2000);
    DECLARE @_ModifiedBy    UNIQUEIDENTIFIER;

    SET @_NewccTLD         = @NewccTLD;
    SET @_RowStatus        = @RowStatus;
    SET @_RowGuid          = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_Entity           = @Entity;
    SET @_Notes            = @Notes;
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
        , @_NewccTLD         AS [ccTLD]
        , @_RowStatus        AS [RowStatus]
        , @_RowGuid          AS [RowGuid]
        , @_Entity           AS [Entity]
        , @_Notes            AS [Notes]
    END

    /* ========================================================================= */
    /* Create a table var to hold our OUTPUT values */
    CREATE TABLE #OutputTableVar
    (
        [INSERTED_ccTLD] CHAR(3) NOT NULL
    );

    /* ========================================================================= */
    /* Insert our record */
    INSERT INTO [masterLists].[CountryTLD]
    (
         [ccTLD]
       , [RowStatus]
       , [CreatedBy]
       , [ModifiedBy]
       , [RowGuid]
       , [Entity]
       , [Notes]
     )

    OUTPUT
        [INSERTED].[ccTLD]

    INTO
      #OutputTableVar

    VALUES
    (
        @_NewccTLD
      , @_RowStatus
      , @_ModifiedBy
      , @_ModifiedBy
      , @_RowGuid
      , @_Entity
      , @_Notes
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
        @ccTLD = [OutputTableVar].[INSERTED_ccTLD]
      FROM #OutputTableVar AS OutputTableVar

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [CountryTLD].[ccTLD]
          , [CountryTLD].[RowStatus]
          , [CountryTLD].[CreatedBy]
          , [CountryTLD].[ModifiedBy]
          , [CountryTLD].[CreatedDate]
          , [CountryTLD].[ModifiedDate]
          , [CountryTLD].[RowGuid]
          , [CountryTLD].[Entity]
          , [CountryTLD].[Notes]
        FROM
          [masterLists].[CountryTLD] AS [CountryTLD]
        WHERE
          [CountryTLD].[ccTLD] = @ccTLD
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY

          SELECT
            @XmlResults =
            (
              SELECT
                  [CountryTLD].[ccTLD]
                , [CountryTLD].[RowStatus]
                , [CountryTLD].[CreatedBy]
                , [CountryTLD].[ModifiedBy]
                , [CountryTLD].[CreatedDate]
                , [CountryTLD].[ModifiedDate]
                , [CountryTLD].[RowGuid]
                , [CountryTLD].[Entity]
                , [CountryTLD].[Notes]
              FROM
                [masterLists].[CountryTLD] AS [CountryTLD]
              WHERE
                [CountryTLD].[ccTLD] = @ccTLD
              FOR XML PATH ('CountryTLD'), ROOT ('InsertedRecords'), ELEMENTS XSINIL
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

DECLARE @RowsAffected   INT;
DECLARE @XmlResults     XML;
DECLARE @ccTLD          CHAR(3);
DECLARE @Entity         VARCHAR(128);
DECLARE @Notes          VARCHAR(2000);

SET @ccTLD           = [dbo].[ufn_LoremIpsumString](3, 0);
SET @Entity          = [dbo].[ufn_LoremIpsumString](128, 0);
SET @Notes           = [dbo].[ufn_LoremIpsumString](2000, 0);

EXEC masterLists.uspIns_CountryTLD
  /* Non-identity / guid Primary Key(s) */
  @ccTLD           = @ccTLD,  /* Foreign Key(s) */
  @RowStatus       = @RowStatus,
  /* General Column Data */
  @Entity          = @Entity,
  @Notes           = @Notes,
  /* App User Id / Modified By Id */
  @ModifiedBy      = NULL,
  /* Return output options */
  @ReturnOutput    = 1,
  @ReturnAsTable   = 1,
  @ReturnAsXml     = 1,
  /* Optimistic concurrency value */
  @RowsAffected    = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @ccTLD           = @ccTLD OUTPUT,
  /* XML Results Output */
  @XmlResults      = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @ccTLD AS ccTLD,
  @XmlResults AS XmlResults
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Inserts a single record into the table.',
  @level0type = N'SCHEMA',
  @level0name = N'masterLists',
  @level1type = N'PROCEDURE',
  @level1name = N'uspIns_CountryTLD';
GO