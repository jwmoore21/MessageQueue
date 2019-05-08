/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[masterLists].[uspIns_SecondLevelDomain]') AND type in (N'P', N'PC'))
DROP PROCEDURE [masterLists].[uspIns_SecondLevelDomain]
GO
*/

CREATE PROCEDURE [masterLists].[uspIns_SecondLevelDomain]
  /* Non-identity / guid Primary Key(s) */
  @NewSecondLevelDomain         VARCHAR(16)       ,
  @NewccTLD                     CHAR(3)           ,
  /* Foreign Key(s) */
  @RowStatus                    TINYINT           ,
  /* General Column Data */
  @SecondLevelDomainDescription VARCHAR(1000)      = NULL,
  /* App User Id / Modified By Id */
  @ModifiedBy                    UNIQUEIDENTIFIER  = NULL,

  /* Debug Mode */
  @Debug     BIT = 0,
  @ShowDebug BIT = 0,

  /* Return output options */
  @ReturnOutput                 BIT = 0,
  @ReturnAsTable                BIT = 0,
  @ReturnAsXml                  BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected                 INT = 0 OUTPUT,
  /* Generated Primary Key Value(s) */
  @SecondLevelDomain            VARCHAR(16) = NULL OUTPUT,
  @ccTLD                        CHAR(3) = NULL OUTPUT,
  /* XML Results Output */
  @XmlResults                   XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      masterLists
Object:      uspIns_SecondLevelDomain

Description: Insert a record into the given table.

Returns:     If successful, returns one result set; if not successful, returns
             information about the error that occured during processing.

Author:      John W. Moore
Version:     1.0.0
Copyright:   (c) 2019
License:     Restricted

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
    DECLARE @_NewSecondLevelDomain          VARCHAR(16);
    DECLARE @_NewccTLD                      CHAR(3);
    DECLARE @_RowStatus                     TINYINT;
    DECLARE @_RowGuid                       UNIQUEIDENTIFIER;
    DECLARE @_SecondLevelDomainDescription  VARCHAR(1000);
    DECLARE @_ModifiedBy                  UNIQUEIDENTIFIER;

    SET @_NewSecondLevelDomain           = @NewSecondLevelDomain;
    SET @_NewccTLD                       = @NewccTLD;
    SET @_RowStatus                      = @RowStatus;
    SET @_RowGuid                        = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_SecondLevelDomainDescription   = @SecondLevelDomainDescription;
    SET @_ModifiedBy                     = ( SELECT COALESCE( @ModifiedBy, '1' ) );

    /* ========================================================================= */
    /* Debug Mode */
    DECLARE @_Debug     BIT;
    DECLARE @_ShowDebug BIT;
    SET @_ShowDebug     = @Debug;
    SET @_ShowDebug     = @ShowDebug;

    IF ( @_ShowDebug = 1 )
    BEGIN
      SELECT
          'Input values:'                 AS DebugMessage
        , @_NewSecondLevelDomain           AS [SecondLevelDomain]
        , @_NewccTLD                       AS [ccTLD]
        , @_RowStatus                      AS [RowStatus]
        , @_RowGuid                        AS [RowGuid]
        , @_SecondLevelDomainDescription   AS [SecondLevelDomainDescription]
    END

    /* ========================================================================= */
    /* Create a table var to hold our OUTPUT values */
    CREATE TABLE #OutputTableVar
    (
        [INSERTED_SecondLevelDomain] VARCHAR(16) NOT NULL
      , [INSERTED_ccTLD]             CHAR(3) NOT NULL
    );

    /* ========================================================================= */
    /* Insert our record */
    INSERT INTO [masterLists].[SecondLevelDomain]
    (
         [SecondLevelDomain]
       , [ccTLD]
       , [RowStatus]
       , [CreatedBy]
       , [ModifiedBy]
       , [RowGuid]
       , [SecondLevelDomainDescription]
     )

    OUTPUT
        [INSERTED].[SecondLevelDomain]
      , [INSERTED].[ccTLD]

    INTO
      #OutputTableVar

    VALUES
    (
        @_NewSecondLevelDomain
      , @_NewccTLD
      , @_RowStatus
      , @_ModifiedBy
      , @_ModifiedBy
      , @_RowGuid
      , @_SecondLevelDomainDescription
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
        @SecondLevelDomain = [OutputTableVar].[INSERTED_SecondLevelDomain]
        , @ccTLD = [OutputTableVar].[INSERTED_ccTLD]
      FROM #OutputTableVar AS OutputTableVar

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [SecondLevelDomain].[SecondLevelDomain]
          , [SecondLevelDomain].[ccTLD]
          , [SecondLevelDomain].[RowStatus]
          , [SecondLevelDomain].[CreatedBy]
          , [SecondLevelDomain].[ModifiedBy]
          , [SecondLevelDomain].[CreatedDate]
          , [SecondLevelDomain].[ModifiedDate]
          , [SecondLevelDomain].[RowGuid]
          , [SecondLevelDomain].[SecondLevelDomainDescription]
        FROM
          [masterLists].[SecondLevelDomain] AS [SecondLevelDomain]
        WHERE
          [SecondLevelDomain].[SecondLevelDomain] = @SecondLevelDomain
        AND [SecondLevelDomain].[ccTLD] = @ccTLD
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY

          SELECT
            @XmlResults =
            (
              SELECT
                  [SecondLevelDomain].[SecondLevelDomain]
                , [SecondLevelDomain].[ccTLD]
                , [SecondLevelDomain].[RowStatus]
                , [SecondLevelDomain].[CreatedBy]
                , [SecondLevelDomain].[ModifiedBy]
                , [SecondLevelDomain].[CreatedDate]
                , [SecondLevelDomain].[ModifiedDate]
                , [SecondLevelDomain].[RowGuid]
                , [SecondLevelDomain].[SecondLevelDomainDescription]
              FROM
                [masterLists].[SecondLevelDomain] AS [SecondLevelDomain]
              WHERE
                [SecondLevelDomain].[SecondLevelDomain] = @SecondLevelDomain
              AND [SecondLevelDomain].[ccTLD] = @ccTLD
              FOR XML PATH ('SecondLevelDomain'), ROOT ('InsertedRecords'), ELEMENTS XSINIL
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

DECLARE @RowsAffected                 INT;
DECLARE @XmlResults                   XML;
DECLARE @SecondLevelDomain            VARCHAR(16);
DECLARE @ccTLD                        CHAR(3);
DECLARE @SecondLevelDomainDescription VARCHAR(1000);

SET @SecondLevelDomain             = [dbo].[ufn_LoremIpsumString](16, 0);
SET @ccTLD                         = [dbo].[ufn_LoremIpsumString](3, 0);
SET @SecondLevelDomainDescription  = [dbo].[ufn_LoremIpsumString](1000, 0);

EXEC masterLists.uspIns_SecondLevelDomain
  /* Non-identity / guid Primary Key(s) */
  @SecondLevelDomain             = @SecondLevelDomain,  @ccTLD                         = @ccTLD,  /* Foreign Key(s) */
  @ccTLD                         = @ccTLD,
  @RowStatus                     = @RowStatus,
  /* General Column Data */
  @SecondLevelDomainDescription  = @SecondLevelDomainDescription,
  /* App User Id / Modified By Id */
  @ModifiedBy                    = NULL,
  /* Return output options */
  @ReturnOutput                  = 1,
  @ReturnAsTable                 = 1,
  @ReturnAsXml                   = 1,
  /* Optimistic concurrency value */
  @RowsAffected                  = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @SecondLevelDomain             = @SecondLevelDomain OUTPUT,
  @ccTLD                         = @ccTLD OUTPUT,
  /* XML Results Output */
  @XmlResults                    = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @SecondLevelDomain AS SecondLevelDomain,
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
  @level1name = N'uspIns_SecondLevelDomain';
GO