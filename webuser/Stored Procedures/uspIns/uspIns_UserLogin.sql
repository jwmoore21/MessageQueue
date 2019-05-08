/*
IF  EXISTS (SELECT * FROM [sys].[objects] WHERE object_id = OBJECT_ID(N'[webuser].[uspIns_UserLogin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [webuser].[uspIns_UserLogin]
GO
*/

CREATE PROCEDURE [webuser].[uspIns_UserLogin]
  /* Non-identity / guid Primary Key(s) */
  @NewUserId       INT               ,
  /* Foreign Key(s) */
  @RowStatus       TINYINT           ,
  /* General Column Data */
  @Username        VARCHAR(64)       ,
  @Password        VARCHAR(255)      ,
  @Id              VARCHAR(255)      ,
  @IntegrationUser SYSNAME           ,
  /* App User Id / Modified By Id */
  @ModifiedBy       UNIQUEIDENTIFIER  = NULL,

  /* Debug Mode */
  @Debug     BIT = 0,
  @ShowDebug BIT = 0,

  /* Return output options */
  @ReturnOutput    BIT = 0,
  @ReturnAsTable   BIT = 0,
  @ReturnAsXml     BIT = 0,
  /* Optimistic concurrency value */
  @RowsAffected    INT = 0 OUTPUT,
  /* Generated Primary Key Value(s) */
  @UserId          INT = NULL OUTPUT,
  /* XML Results Output */
  @XmlResults      XML = NULL OUTPUT

WITH EXECUTE AS SELF
AS

/*******************************************************************************
WARNING: THIS IS A GENERATED CODE FILE! PLEASE DO NOT ALTER!
================================================================================
Schema:      webuser
Object:      uspIns_UserLogin

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
    DECLARE @_NewUserId        INT;
    DECLARE @_RowStatus        TINYINT;
    DECLARE @_RowGuid          UNIQUEIDENTIFIER;
    DECLARE @_Username         VARCHAR(64);
    DECLARE @_Password         VARCHAR(255);
    DECLARE @_Id               VARCHAR(255);
    DECLARE @_IntegrationUser  SYSNAME;
    DECLARE @_ModifiedBy     UNIQUEIDENTIFIER;

    SET @_NewUserId         = @NewUserId;
    SET @_RowStatus         = @RowStatus;
    SET @_RowGuid           = CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER);
    SET @_Username          = @Username;
    SET @_Password          = @Password;
    SET @_Id                = @Id;
    SET @_IntegrationUser   = @IntegrationUser;
    SET @_ModifiedBy        = ( SELECT COALESCE( @ModifiedBy, '1' ) );

    /* ========================================================================= */
    /* Debug Mode */
    DECLARE @_Debug     BIT;
    DECLARE @_ShowDebug BIT;
    SET @_ShowDebug     = @Debug;
    SET @_ShowDebug     = @ShowDebug;

    IF ( @_ShowDebug = 1 )
    BEGIN
      SELECT
          'Input values:'    AS DebugMessage
        , @_NewUserId         AS [UserId]
        , @_RowStatus         AS [RowStatus]
        , @_RowGuid           AS [RowGuid]
        , @_Username          AS [Username]
        , @_Password          AS [Password]
        , @_Id                AS [Id]
        , @_IntegrationUser   AS [IntegrationUser]
    END

    /* ========================================================================= */
    /* Create a table var to hold our OUTPUT values */
    CREATE TABLE #OutputTableVar
    (
        [INSERTED_UserId] INT NOT NULL
    );

    /* ========================================================================= */
    /* Insert our record */
    INSERT INTO [webuser].[UserLogin]
    (
         [UserId]
       , [RowStatus]
       , [CreatedBy]
       , [ModifiedBy]
       , [RowGuid]
       , [Username]
       , [Password]
       , [Id]
       , [IntegrationUser]
     )

    OUTPUT
        [INSERTED].[UserId]

    INTO
      #OutputTableVar

    VALUES
    (
        @_NewUserId
      , @_RowStatus
      , @_ModifiedBy
      , @_ModifiedBy
      , @_RowGuid
      , @_Username
      , @_Password
      , @_Id
      , @_IntegrationUser
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
        @UserId = [OutputTableVar].[INSERTED_UserId]
      FROM #OutputTableVar AS OutputTableVar

      IF @_ReturnAsTable = 1
      BEGIN

        SELECT
            [UserLogin].[UserId]
          , [UserLogin].[RowStatus]
          , [UserLogin].[CreatedBy]
          , [UserLogin].[ModifiedBy]
          , [UserLogin].[CreatedDate]
          , [UserLogin].[ModifiedDate]
          , [UserLogin].[RowGuid]
          , [UserLogin].[Username]
          , [UserLogin].[Password]
          , [UserLogin].[Id]
          , [UserLogin].[IntegrationUser]
        FROM
          [webuser].[UserLogin] AS [UserLogin]
        WHERE
          [UserLogin].[UserId] = @UserId
        ;

      END;

      IF @_ReturnAsXml = 1
      BEGIN

        BEGIN TRY

          SELECT
            @XmlResults =
            (
              SELECT
                  [UserLogin].[UserId]
                , [UserLogin].[RowStatus]
                , [UserLogin].[CreatedBy]
                , [UserLogin].[ModifiedBy]
                , [UserLogin].[CreatedDate]
                , [UserLogin].[ModifiedDate]
                , [UserLogin].[RowGuid]
                , [UserLogin].[Username]
                , [UserLogin].[Password]
                , [UserLogin].[Id]
                , [UserLogin].[IntegrationUser]
              FROM
                [webuser].[UserLogin] AS [UserLogin]
              WHERE
                [UserLogin].[UserId] = @UserId
              FOR XML PATH ('UserLogin'), ROOT ('InsertedRecords'), ELEMENTS XSINIL
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

DECLARE @RowsAffected    INT;
DECLARE @XmlResults      XML;
DECLARE @UserId          INT;
DECLARE @Username        VARCHAR(64);
DECLARE @Password        VARCHAR(255);
DECLARE @Id              VARCHAR(255);
DECLARE @IntegrationUser SYSNAME;

SET @UserId           = 9;
SET @Username         = [dbo].[ufn_LoremIpsumString](64, 0);
SET @Password         = [dbo].[ufn_LoremIpsumString](255, 0);
SET @Id               = [dbo].[ufn_LoremIpsumString](255, 0);
SET @IntegrationUser  = unknown GetUnitTestDataBySqlDataType:SYSNAME:Microsoft.SqlServer.Management.Smo.DataType;

EXEC webuser.uspIns_UserLogin
  /* Non-identity / guid Primary Key(s) */
  @UserId           = @UserId,  /* Foreign Key(s) */
  @RowStatus        = @RowStatus,
  /* General Column Data */
  @Username         = @Username,
  @Password         = @Password,
  @Id               = @Id,
  @IntegrationUser  = @IntegrationUser,
  /* App User Id / Modified By Id */
  @ModifiedBy       = NULL,
  /* Return output options */
  @ReturnOutput     = 1,
  @ReturnAsTable    = 1,
  @ReturnAsXml      = 1,
  /* Optimistic concurrency value */
  @RowsAffected     = @RowsAffected OUTPUT,
  /* Generated Primary Key Value(s) */
  @UserId           = @UserId OUTPUT,
  /* XML Results Output */
  @XmlResults       = @XmlResults OUTPUT
;

SELECT
  @RowsAffected AS RowsAffected,
  @UserId AS UserId,
  @XmlResults AS XmlResults
;

*/
GO


EXECUTE sp_addextendedproperty
  @name = N'MS_Description',
  @value = N'Inserts a single record into the table.',
  @level0type = N'SCHEMA',
  @level0name = N'webuser',
  @level1type = N'PROCEDURE',
  @level1name = N'uspIns_UserLogin';
GO