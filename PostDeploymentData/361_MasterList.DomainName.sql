PRINT 'Running 361_MasterList.DomainName.sql';

SET NOCOUNT ON;

BEGIN TRY

  BEGIN TRANSACTION;

  -- Our script user id = -1
  DECLARE @CreatedByDomainName INT;
  SET @CreatedByDomainName = 1;

  -- Active Row Status
  DECLARE @activeDomainName INT;
  SET @activeDomainName = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsDomainName INT;
  SET @RecordExistsDomainName = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadDomainName AS TABLE
  (
    [RowCounter]  INT       NOT NULL IDENTITY(1,1),
    [RowStatus]   [tinyint] NOT NULL,
    [DomainName]  [varchar](188) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadDomainNameOutput AS TABLE
  (
    [DomainName] [varchar](188) NOT NULL,
    [RowStatus] [tinyint] NOT NULL,
    [CreatedBy] [uniqueidentifier] NOT NULL,
    [ModifiedBy] [uniqueidentifier] NOT NULL,
    [CreatedDate] [DATETIMEOFFSET] NOT NULL,
    [ModifiedDate] [DATETIMEOFFSET] NOT NULL,
    [RowGuid] [uniqueidentifier] ROWGUIDCOL  NOT NULL
  );

  -- We need a loop counter var
  DECLARE @CtrDomainName INT;
  SET @CtrDomainName = 0;

  /* https://en.wikipedia.org/wiki/Character_encoding */

  -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadDomainName ( RowStatus, DomainName )
  VALUES 
  ( @activeDomainName, '.' ),
  ( @activeDomainName, 'adobe' ),
  ( @activeDomainName, 'amazon' ),
  ( @activeDomainName, 'apple' ),
  ( @activeDomainName, 'bbc' ),
  ( @activeDomainName, 'bootstrap' ),
  ( @activeDomainName, 'docker' ),
  ( @activeDomainName, 'facebook' ),
  ( @activeDomainName, 'gmail' ),
  ( @activeDomainName, 'godaddy' ),
  ( @activeDomainName, 'google' ),
  ( @activeDomainName, 'jquery' ),
  ( @activeDomainName, 'live' ),
  ( @activeDomainName, 'nonprod'  ),  
  ( @activeDomainName, 'microsoft' ),
  ( @activeDomainName, 'mysql' ),
  ( @activeDomainName, 'oracle' ),
  ( @activeDomainName, 'outlook' ),
  ( @activeDomainName, 'yahoo' )
  ;

  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsDomainName INT;
  SELECT @TotalDataLoadRecordsDomainName = COUNT(1) FROM @DataLoadDomainName;

  -- We need to reset our loop counter var
  SET @CtrDomainName = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrDomainName < = @TotalDataLoadRecordsDomainName )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    masterLists.DomainName AS DomainName WITH (nolock)
        WHERE   DomainName.DomainName = ( SELECT DataLoad.DomainName 
                                           FROM @DataLoadDomainName AS DataLoad
                                           WHERE RowCounter = @CtrDomainName )
      ) 
      BEGIN

        INSERT INTO [MasterLists].[DomainName] ( [DomainName],[RowStatus],[CreatedBy],[ModifiedBy],[CreatedDate],[ModifiedDate],[RowGuid] )
        OUTPUT inserted.DomainName, inserted.RowStatus, inserted.CreatedBy, inserted.ModifiedBy, inserted.CreatedDate, inserted.ModifiedDate, inserted.RowGuid INTO @DataLoadDomainNameOutput
        SELECT
          DataLoad.DomainName,
          @activeDomainName,
          @CreatedByDomainName,
          @CreatedByDomainName,
          GETUTCDATE(),
          GETUTCDATE(),
          NEWID()
        FROM
          @DataLoadDomainName AS DataLoad
        WHERE
          RowCounter = @CtrDomainName

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadDomainNameOutput ( DomainName, RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
        SELECT
          DomainName.DomainName,
          @RecordExistsDomainName,
          DomainName.CreatedBy,
          DomainName.ModifiedBy,
          DomainName.CreatedDate,
          DomainName.CreatedDate,
          DomainName.RowGuid
        FROM    
          MasterLists.DomainName AS DomainName WITH (nolock)
          
          INNER JOIN @DataLoadDomainName AS DataLoad
          ON DomainName.DomainName = DataLoad.DomainName

        WHERE   
          DomainName.DomainName = ( SELECT DataLoad.DomainName 
                                     FROM @DataLoadDomainName AS DataLoad
                                     WHERE RowCounter = @CtrDomainName )       
         
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrDomainName = @CtrDomainName + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadDomainNameOutput

  COMMIT TRANSACTION;

END TRY
BEGIN CATCH

  -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrMessageDomainName       nvarchar(2048),
    @ErrSeverityDomainName      tinyint,
    @ErrStateDomainName         tinyint,
    @ErrNumberDomainName        int,
    @ErrProcedureDomainName     sysname,
    @ErrLineDomainName          int
              
  SELECT 
    @ErrNumberDomainName    = ERROR_NUMBER(),
    @ErrSeverityDomainName  = ERROR_SEVERITY(),
    @ErrStateDomainName     = ERROR_STATE(),
    @ErrProcedureDomainName = ERROR_PROCEDURE(),
    @ErrLineDomainName      = ERROR_LINE(),
    @ErrMessageDomainName   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrNumberDomainName,
    @ErrorSeverity  = @ErrSeverityDomainName,
    @ErrorState     = @ErrStateDomainName,
    @ErrorProcedure = @ErrProcedureDomainName,
    @ErrorLine      = @ErrLineDomainName,
    @ErrorMessage   = @ErrMessageDomainName

  --re-raise the error
  RAISERROR ( @ErrMessageDomainName, @ErrSeverityDomainName, @ErrStateDomainName )

END CATCH
