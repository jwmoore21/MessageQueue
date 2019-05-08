PRINT 'Running 363_MasterList.HostName.sql';

SET NOCOUNT ON;

BEGIN TRY

  BEGIN TRANSACTION;

  -- Our script user id = -1
  DECLARE @CreatedByHostName INT;
  SET @CreatedByHostName = 1;

  -- Active Row Status
  DECLARE @activeHostName INT;
  SET @activeHostName = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsHostName INT;
  SET @RecordExistsHostName = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadHostName AS TABLE
  (
    [RowCounter] INT       NOT NULL IDENTITY(1,1),
    [RowStatus]  [tinyint] NOT NULL,
    [HostName]   [varchar](63) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadHostNameOutput AS TABLE
  (
    [HostName]     [varchar](63) NOT NULL,
    [RowStatus]    [tinyint] NOT NULL,
    [CreatedBy]    [uniqueidentifier] NOT NULL,
    [ModifiedBy]   [uniqueidentifier] NOT NULL,
    [CreatedDate]  [DATETIMEOFFSET] NOT NULL,
    [ModifiedDate] [DATETIMEOFFSET] NOT NULL,
    [RowGuid]      [uniqueidentifier] ROWGUIDCOL  NOT NULL
  );

  -- We need a loop counter var
  DECLARE @CtrHostName INT;
  SET @CtrHostName = 0;

  /* https://en.wikipedia.org/wiki/Character_encoding */

  -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadHostName ( RowStatus, HostName )
  VALUES 
  ( @activeHostName, '.' ),
  ( @activeHostName, 'www' )
  ;

  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsHostName INT;
  SELECT @TotalDataLoadRecordsHostName = COUNT(1) FROM @DataLoadHostName;

  -- We need to reset our loop counter var
  SET @CtrHostName = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrHostName < = @TotalDataLoadRecordsHostName )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    masterLists.HostName AS HostName WITH (nolock)
        WHERE   HostName.HostName = ( SELECT DataLoad.HostName 
                                           FROM @DataLoadHostName AS DataLoad
                                           WHERE RowCounter = @CtrHostName )
      ) 
      BEGIN

        INSERT INTO [MasterLists].[HostName] ( [HostName],[RowStatus],[CreatedBy],[ModifiedBy],[CreatedDate],[ModifiedDate],[RowGuid] )
        OUTPUT inserted.HostName, inserted.RowStatus, inserted.CreatedBy, inserted.ModifiedBy, inserted.CreatedDate, inserted.ModifiedDate, inserted.RowGuid INTO @DataLoadHostNameOutput
        SELECT
          DataLoad.HostName,
          @activeHostName,
          @CreatedByHostName,
          @CreatedByHostName,
          GETUTCDATE(),
          GETUTCDATE(),
          NEWID()
        FROM
          @DataLoadHostName AS DataLoad
        WHERE
          RowCounter = @CtrHostName

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadHostNameOutput ( HostName, RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
        SELECT
          HostName.HostName,
          @RecordExistsHostName,
          HostName.CreatedBy,
          HostName.ModifiedBy,
          HostName.CreatedDate,
          HostName.CreatedDate,
          HostName.RowGuid
        FROM    
          MasterLists.HostName AS HostName WITH (nolock)
          
          INNER JOIN @DataLoadHostName AS DataLoad
          ON HostName.HostName = DataLoad.HostName

        WHERE   
          HostName.HostName = ( SELECT DataLoad.HostName 
                                     FROM @DataLoadHostName AS DataLoad
                                     WHERE RowCounter = @CtrHostName )       
         
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrHostName = @CtrHostName + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadHostNameOutput

  COMMIT TRANSACTION;

END TRY
BEGIN CATCH

  -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrMessageHostName       nvarchar(2048),
    @ErrSeverityHostName      tinyint,
    @ErrStateHostName         tinyint,
    @ErrNumberHostName        int,
    @ErrProcedureHostName     sysname,
    @ErrLineHostName          int
              
  SELECT 
    @ErrNumberHostName    = ERROR_NUMBER(),
    @ErrSeverityHostName  = ERROR_SEVERITY(),
    @ErrStateHostName     = ERROR_STATE(),
    @ErrProcedureHostName = ERROR_PROCEDURE(),
    @ErrLineHostName      = ERROR_LINE(),
    @ErrMessageHostName   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrNumberHostName,
    @ErrorSeverity  = @ErrSeverityHostName,
    @ErrorState     = @ErrStateHostName,
    @ErrorProcedure = @ErrProcedureHostName,
    @ErrorLine      = @ErrLineHostName,
    @ErrorMessage   = @ErrMessageHostName

  --re-raise the error
  RAISERROR ( @ErrMessageHostName, @ErrSeverityHostName, @ErrStateHostName )

END CATCH
