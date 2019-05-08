/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[eventLogs].[DatabaseErrorHandler]') AND type in (N'P', N'PC'))
DROP PROCEDURE [eventLogs].[DatabaseErrorHandler];
*/

CREATE PROCEDURE [eventLogs].[DatabaseErrorHandler]
  @DbName         NVARCHAR(128) = NULL,
  @ErrorMessage   NVARCHAR(2048),
  @ErrorSeverity  INT,
  @ErrorState     INT,
  @ErrorNumber    INT = NULL,
  @ErrorProcedure SYSNAME = NULL,
  @ErrorLine      INT = NULL

WITH EXECUTE AS SELF
AS
BEGIN

    DECLARE
      @_DbName         NVARCHAR(128),
      @_ErrorMessage   NVARCHAR(2048),
      @_ErrorSeverity  INT,
      @_ErrorState     INT,
      @_ErrorNumber    INT,
      @_ErrorProcedure SYSNAME,
      @_ErrorLine      INT;

    SET @_DbName         = COALESCE( @DbName, DB_NAME() );
    SET @_ErrorMessage   = @ErrorMessage;
    SET @_ErrorSeverity  = @ErrorSeverity;
    SET @_ErrorState     = @ErrorState;
    SET @_ErrorNumber    = @ErrorNumber;
    SET @_ErrorProcedure = @ErrorProcedure;
    SET @_ErrorLine      = @ErrorLine;

   -- Raise the error passed into the proc
    RAISERROR(@_ErrorMessage, @_ErrorSeverity, @_ErrorState);

    INSERT INTO eventLogs.DatabaseErrorLog
    (
        DbName
      , ErrorNumber
      , ErrorSeverity
      , ErrorState
      , ErrorProcedure
      , ErrorLine
      , ErrorMessage
    )
    VALUES
    (
        @_DbName
      , @_ErrorNumber
      , @_ErrorSeverity
      , @_ErrorState
      , @_ErrorProcedure
      , @_ErrorLine
      , @_ErrorMessage
    );

END