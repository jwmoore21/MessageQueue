-- Populate our lookup table of unique schema names across all of the databases
-- that we test data validation with

PRINT 'Running DatabaseSchemaNames.data.sql'

BEGIN TRY

  BEGIN TRANSACTION; 

  INSERT INTO masterLists.DatabaseSchema ( DatabaseSchema )
  SELECT DISTINCT s.SCHEMA_NAME AS SchemaName
  FROM
  (
    SELECT SCHEMA_NAME
    FROM   INFORMATION_SCHEMA.SCHEMATA
  ) s;

  COMMIT TRANSACTION; 

END TRY

BEGIN CATCH

    -- Error trapping vars
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

    DECLARE 
      @ErrorMessageDbSchemas       nvarchar(2048),
      @ErrorSeverityDbSchemas      tinyint,
      @ErrorStateDbSchemas         tinyint,
      @ErrorNumberDbSchemas        int,
      @ErrorProcedureDbSchemas     sysname,
      @ErrorLineDbSchemas          int
              
	SELECT 
    @ErrorNumberDbSchemas    = ERROR_NUMBER(),
    @ErrorSeverityDbSchemas  = ERROR_SEVERITY(),
    @ErrorStateDbSchemas     = ERROR_STATE(),
    @ErrorProcedureDbSchemas = ERROR_PROCEDURE(),
    @ErrorLineDbSchemas      = ERROR_LINE(),
    @ErrorMessageDbSchemas   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
		@ErrorNumber    = @ErrorNumberDbSchemas,
		@ErrorSeverity  = @ErrorSeverityDbSchemas,
		@ErrorState     = @ErrorStateDbSchemas,
		@ErrorProcedure = @ErrorProcedureDbSchemas,
		@ErrorLine      = @ErrorLineDbSchemas,
		@ErrorMessage   = @ErrorMessageDbSchemas

	--re-raise the error
    RAISERROR ( @ErrorMessageDbSchemas, @ErrorSeverityDbSchemas, @ErrorStateDbSchemas )

END CATCH