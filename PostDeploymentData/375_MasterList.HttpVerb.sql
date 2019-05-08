PRINT 'Running 375_MasterList.HttpVerb.sql';

SET NOCOUNT ON;

BEGIN TRY

  BEGIN TRANSACTION;

  -- Our script user id = -1
  DECLARE @CreatedByHttpVerb INT;
  SET @CreatedByHttpVerb = 1;

  -- Active Row Status
  DECLARE @activeHttpVerb INT;
  SET @activeHttpVerb = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsHttpVerb INT;
  SET @RecordExistsHttpVerb = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadHttpVerb AS TABLE
  (
    [RowCounter]  INT          NOT NULL IDENTITY(1,1),
    [RowStatus]   [tinyint]    NOT NULL,
    [HttpVerb]    [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadHttpVerbOutput AS TABLE
  (
    [HttpVerb]     [varchar](8)       NOT NULL,
    [RowStatus]    [tinyint]          NOT NULL,
    [CreatedBy]    [uniqueidentifier] NOT NULL,
    [ModifiedBy]   [uniqueidentifier] NOT NULL,
    [CreatedDate]  [DATETIMEOFFSET]   NOT NULL,
    [ModifiedDate] [DATETIMEOFFSET]   NOT NULL,
    [RowGuid]      [uniqueidentifier] NOT NULL ROWGUIDCOL
  );

  -- We need a loop counter var
  DECLARE @CtrHttpVerb INT;
  SET @CtrHttpVerb = 0;

  /* https://en.wikipedia.org/wiki/Character_encoding */

  -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadHttpVerb ( RowStatus, HttpVerb )
  VALUES 
  ( @activeHttpVerb, 'GET' )
  ,( @activeHttpVerb, 'POST' )
  ,( @activeHttpVerb, 'PUT' )
  ,( @activeHttpVerb, 'PATCH' )
  ,( @activeHttpVerb, 'DELETE' )
  ,( @activeHttpVerb, 'COPY' )
  ,( @activeHttpVerb, 'HEAD' )
  ,( @activeHttpVerb, 'OPTIONS' )
  ,( @activeHttpVerb, 'LINK' )
  ,( @activeHttpVerb, 'UNLINK' )
  ,( @activeHttpVerb, 'PURGE' )
  ,( @activeHttpVerb, 'LOCK' )
  ,( @activeHttpVerb, 'UNLOCK' )
  ,( @activeHttpVerb, 'PROPFIND' )
  ,( @activeHttpVerb, 'VIEW' )
  
  ;

  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsHttpVerb INT;
  SELECT @TotalDataLoadRecordsHttpVerb = COUNT(1) FROM @DataLoadHttpVerb;

  -- We need to reset our loop counter var
  SET @CtrHttpVerb = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrHttpVerb < = @TotalDataLoadRecordsHttpVerb )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    masterLists.HttpVerb AS HttpVerb WITH (nolock)
        WHERE   HttpVerb.HttpVerb = ( SELECT DataLoad.HttpVerb 
                                      FROM @DataLoadHttpVerb AS DataLoad
                                      WHERE RowCounter = @CtrHttpVerb )
      ) 
      BEGIN

        INSERT INTO [MasterLists].[HttpVerb] ( [HttpVerb],[RowStatus],[CreatedBy],[ModifiedBy],[CreatedDate],[ModifiedDate],[RowGuid] )
        OUTPUT inserted.HttpVerb, inserted.RowStatus, inserted.CreatedBy, inserted.ModifiedBy, inserted.CreatedDate, inserted.ModifiedDate, inserted.RowGuid INTO @DataLoadHttpVerbOutput
        SELECT
          DataLoad.HttpVerb,
          @activeHttpVerb,
          @CreatedByHttpVerb,
          @CreatedByHttpVerb,
          GETUTCDATE(),
          GETUTCDATE(),
          NEWID()
        FROM
          @DataLoadHttpVerb AS DataLoad
        WHERE
          RowCounter = @CtrHttpVerb

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadHttpVerbOutput ( HttpVerb, RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
        SELECT
          HttpVerb.HttpVerb,
          @RecordExistsHttpVerb,
          HttpVerb.CreatedBy,
          HttpVerb.ModifiedBy,
          HttpVerb.CreatedDate,
          HttpVerb.CreatedDate,
          HttpVerb.RowGuid
        FROM    
          MasterLists.HttpVerb AS HttpVerb WITH (nolock)
          
          INNER JOIN @DataLoadHttpVerb AS DataLoad
          ON HttpVerb.HttpVerb = DataLoad.HttpVerb

        WHERE   
          HttpVerb.HttpVerb = ( SELECT DataLoad.HttpVerb 
                                     FROM @DataLoadHttpVerb AS DataLoad
                                     WHERE RowCounter = @CtrHttpVerb )       
         
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrHttpVerb = @CtrHttpVerb + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadHttpVerbOutput

  COMMIT TRANSACTION;

END TRY
BEGIN CATCH

  -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrMessageHttpVerb       nvarchar(2048),
    @ErrSeverityHttpVerb      tinyint,
    @ErrStateHttpVerb         tinyint,
    @ErrNumberHttpVerb        int,
    @ErrProcedureHttpVerb     sysname,
    @ErrLineHttpVerb          int
              
  SELECT 
    @ErrNumberHttpVerb    = ERROR_NUMBER(),
    @ErrSeverityHttpVerb  = ERROR_SEVERITY(),
    @ErrStateHttpVerb     = ERROR_STATE(),
    @ErrProcedureHttpVerb = ERROR_PROCEDURE(),
    @ErrLineHttpVerb      = ERROR_LINE(),
    @ErrMessageHttpVerb   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrNumberHttpVerb,
    @ErrorSeverity  = @ErrSeverityHttpVerb,
    @ErrorState     = @ErrStateHttpVerb,
    @ErrorProcedure = @ErrProcedureHttpVerb,
    @ErrorLine      = @ErrLineHttpVerb,
    @ErrorMessage   = @ErrMessageHttpVerb

  --re-raise the error
  RAISERROR ( @ErrMessageHttpVerb, @ErrSeverityHttpVerb, @ErrStateHttpVerb )

END CATCH
