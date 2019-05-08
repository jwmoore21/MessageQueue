PRINT 'Running 362_MasterList.SubHostName.sql';

SET NOCOUNT ON;

BEGIN TRY

  BEGIN TRANSACTION;

  -- Our script user id = -1
  DECLARE @CreatedBySubHostName INT;
  SET @CreatedBySubHostName = 1;

  -- Active Row Status
  DECLARE @activeSubHostName INT;
  SET @activeSubHostName = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsSubHostName INT;
  SET @RecordExistsSubHostName = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadSubHostName AS TABLE
  (
    [RowCounter]       INT       NOT NULL IDENTITY(1,1),
    [RowStatus]        [tinyint] NOT NULL,
    [SubHostName]     [varchar](24) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadSubHostNameOutput AS TABLE
  (
    [SubHostName] [varchar](24) NOT NULL,
    [RowStatus] [tinyint] NOT NULL,
    [CreatedBy] [uniqueidentifier] NOT NULL,
    [ModifiedBy] [uniqueidentifier] NOT NULL,
    [CreatedDate] [DATETIMEOFFSET] NOT NULL,
    [ModifiedDate] [DATETIMEOFFSET] NOT NULL,
    [RowGuid] [uniqueidentifier] ROWGUIDCOL  NOT NULL
  );

  -- We need a loop counter var
  DECLARE @CtrSubHostName INT;
  SET @CtrSubHostName = 0;

  -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadSubHostName ( RowStatus, SubHostName )
  VALUES 
  ( @activeSubHostName, '.' )
  ;

  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsSubHostName INT;
  SELECT @TotalDataLoadRecordsSubHostName = COUNT(1) FROM @DataLoadSubHostName;

  -- We need to reset our loop counter var
  SET @CtrSubHostName = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrSubHostName < = @TotalDataLoadRecordsSubHostName )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    masterLists.SubHostName AS SubHostName WITH (nolock)
        WHERE   SubHostName.SubHostName = ( SELECT DataLoad.SubHostName 
                                           FROM @DataLoadSubHostName AS DataLoad
                                           WHERE RowCounter = @CtrSubHostName )
      ) 
      BEGIN

        INSERT INTO [MasterLists].SubHostName ( [SubHostName],[RowStatus],[CreatedBy],[ModifiedBy],[CreatedDate],[ModifiedDate],[RowGuid] )
        OUTPUT inserted.SubHostName, inserted.RowStatus, inserted.CreatedBy, inserted.ModifiedBy, inserted.CreatedDate, inserted.ModifiedDate, inserted.RowGuid INTO @DataLoadSubHostNameOutput
        SELECT
          DataLoad.SubHostName,
          @activeSubHostName,
          @CreatedBySubHostName,
          @CreatedBySubHostName,
          GETUTCDATE(),
          GETUTCDATE(),
          NEWID()
        FROM
          @DataLoadSubHostName AS DataLoad
        WHERE
          RowCounter = @CtrSubHostName

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadSubHostNameOutput ( SubHostName, RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
        SELECT
          SubHostName.SubHostName,
          @RecordExistsSubHostName,
          SubHostName.CreatedBy,
          SubHostName.ModifiedBy,
          SubHostName.CreatedDate,
          SubHostName.CreatedDate,
          SubHostName.RowGuid
        FROM    
          MasterLists.SubHostName AS SubHostName WITH (nolock)
          
          INNER JOIN @DataLoadSubHostName AS DataLoad
          ON SubHostName.SubHostName = DataLoad.SubHostName

        WHERE   
          SubHostName.SubHostName = ( SELECT DataLoad.SubHostName 
                                     FROM @DataLoadSubHostName AS DataLoad
                                     WHERE RowCounter = @CtrSubHostName )       
         
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrSubHostName = @CtrSubHostName + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadSubHostNameOutput

  COMMIT TRANSACTION;

END TRY
BEGIN CATCH

  -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrMessageSubHostName       nvarchar(2048),
    @ErrSeveritySubHostName      tinyint,
    @ErrStateSubHostName         tinyint,
    @ErrNumberSubHostName        int,
    @ErrProcedureSubHostName     sysname,
    @ErrLineSubHostName          int
              
  SELECT 
    @ErrNumberSubHostName    = ERROR_NUMBER(),
    @ErrSeveritySubHostName  = ERROR_SEVERITY(),
    @ErrStateSubHostName     = ERROR_STATE(),
    @ErrProcedureSubHostName = ERROR_PROCEDURE(),
    @ErrLineSubHostName      = ERROR_LINE(),
    @ErrMessageSubHostName   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrNumberSubHostName,
    @ErrorSeverity  = @ErrSeveritySubHostName,
    @ErrorState     = @ErrStateSubHostName,
    @ErrorProcedure = @ErrProcedureSubHostName,
    @ErrorLine      = @ErrLineSubHostName,
    @ErrorMessage   = @ErrMessageSubHostName

  --re-raise the error
  RAISERROR ( @ErrMessageSubHostName, @ErrSeveritySubHostName, @ErrStateSubHostName )

END CATCH
