-- Populate our lookup table of unique schema names across all of the databases
-- that we test data validation with

PRINT 'Running DatabaseCatalogNames.data.sql'

BEGIN TRY

  BEGIN TRANSACTION; 

 
  INSERT INTO masterLists.DatabaseName ( DatabaseName )
  VALUES 
  ( DB_NAME() );

  COMMIT TRANSACTION; 

END TRY
BEGIN CATCH

    -- Error trapping vars
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrorMessageDbCatalog       nvarchar(2048),
    @ErrorSeverityDbCatalog      tinyint,
    @ErrorStateDbCatalog         tinyint,
    @ErrorNumberDbCatalog        int,
    @ErrorProcedureDbCatalog     sysname,
    @ErrorLineDbCatalog          int
              
	SELECT 
    @ErrorNumberDbCatalog    = ERROR_NUMBER(),
    @ErrorSeverityDbCatalog  = ERROR_SEVERITY(),
    @ErrorStateDbCatalog     = ERROR_STATE(),
    @ErrorProcedureDbCatalog = ERROR_PROCEDURE(),
    @ErrorLineDbCatalog      = ERROR_LINE(),
    @ErrorMessageDbCatalog   = ERROR_MESSAGE();

	EXECUTE [eventLogs].[DatabaseErrorHandler]
		@ErrorNumber    = @ErrorNumberDbCatalog,
		@ErrorSeverity  = @ErrorSeverityDbCatalog,
		@ErrorState     = @ErrorStateDbCatalog,
		@ErrorProcedure = @ErrorProcedureDbCatalog,
		@ErrorLine      = @ErrorLineDbCatalog,
		@ErrorMessage   = @ErrorMessageDbCatalog

	--re-raise the error
  RAISERROR ( @ErrorMessageDbCatalog, @ErrorSeverityDbCatalog, @ErrorStateDbCatalog )

END CATCH