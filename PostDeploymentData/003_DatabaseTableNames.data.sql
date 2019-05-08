-- Populate our lookup table of unique schema names across all of the databases
-- that we test data validation with

PRINT 'Running DatabaseTableNames.data.sql'

BEGIN TRY

  BEGIN TRANSACTION; 

  INSERT INTO masterLists.DatabaseTable ( DatabaseTable )
  SELECT DISTINCT TABLE_NAME AS TableName
  FROM
  (
    SELECT TABLE_SCHEMA, TABLE_NAME
    FROM   INFORMATION_SCHEMA.TABLES
  ) s;

  COMMIT TRANSACTION; 

END TRY

BEGIN CATCH

    -- Error trapping vars
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

    DECLARE @ErrorMessageDbTables       nvarchar(2048),
		    @ErrorSeverityDbTables      tinyint,
		    @ErrorStateDbTables         tinyint,
		    @ErrorNumberDbTables        int,
		    @ErrorProcedureDbTables     sysname,
		    @ErrorLineDbTables          int
              
	SELECT @ErrorNumberDbTables    = ERROR_NUMBER(),
		   @ErrorSeverityDbTables  = ERROR_SEVERITY(),
           @ErrorStateDbTables     = ERROR_STATE(),
           @ErrorProcedureDbTables = ERROR_PROCEDURE(),
           @ErrorLineDbTables      = ERROR_LINE(),
           @ErrorMessageDbTables   = ERROR_MESSAGE();

	EXECUTE [eventLogs].[DatabaseErrorHandler]
		@ErrorNumber    = @ErrorNumberDbTables,
		@ErrorSeverity  = @ErrorSeverityDbTables,
		@ErrorState     = @ErrorStateDbTables,
		@ErrorProcedure = @ErrorProcedureDbTables,
		@ErrorLine      = @ErrorLineDbTables,
		@ErrorMessage  = @ErrorMessageDbTables

	--re-raise the error
    RAISERROR ( @ErrorMessageDbTables, @ErrorSeverityDbTables, @ErrorStateDbTables )

END CATCH