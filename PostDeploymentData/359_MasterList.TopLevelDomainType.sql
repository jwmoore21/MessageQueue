PRINT 'Running 359_MasterList.TopLevelDomainType.sql';

SET NOCOUNT ON;

BEGIN TRY

  BEGIN TRANSACTION;

  -- Our script user id = -1
  DECLARE @CreatedByTopLevelDomainType UNIQUEIDENTIFIER;
  SET @CreatedByTopLevelDomainType = '119FD967-4F22-4832-B962-1187209EF83D';

  -- Active Row Status
  DECLARE @activeTopLevelDomainType INT;
  SET @activeTopLevelDomainType = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsTopLevelDomainType INT;
  SET @RecordExistsTopLevelDomainType = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadTopLevelDomainType AS TABLE
  (
    [RowCounter]         INT       NOT NULL IDENTITY(1,1),
    [RowStatus]          [tinyint] NOT NULL,
    [TopLevelDomainType] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadTopLevelDomainTypeOutput AS TABLE
  (
    [TopLevelDomainType] [varchar](64) NOT NULL,
    [RowStatus] [tinyint] NOT NULL,
    [CreatedBy] [uniqueidentifier] NOT NULL,
    [ModifiedBy] [uniqueidentifier] NOT NULL,
    [CreatedDate] [DATETIMEOFFSET] NOT NULL,
    [ModifiedDate] [DATETIMEOFFSET] NOT NULL,
    [RowGuid] [uniqueidentifier] ROWGUIDCOL  NOT NULL
  );

  -- We need a loop counter var
  DECLARE @CtrTopLevelDomainType INT;
  SET @CtrTopLevelDomainType = 0;

    -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadTopLevelDomainType ( RowStatus, TopLevelDomainType )
  VALUES 
  ( @activeTopLevelDomainType, 'Custom' ),
  ( @activeTopLevelDomainType, 'Country' ),
  ( @activeTopLevelDomainType, 'Original' ),
  ( @activeTopLevelDomainType, 'Infrastructure' ),
  ( @activeTopLevelDomainType, 'ICANN-era Generic - English' ),
  ( @activeTopLevelDomainType, 'ICANN-era Generic - Chinese' ),
  ( @activeTopLevelDomainType, 'ICANN-era Generic - French' ),
  ( @activeTopLevelDomainType, 'ICANN-era Generic - German' ),
  ( @activeTopLevelDomainType, 'ICANN-era Generic - Hindi' ),
  ( @activeTopLevelDomainType, 'ICANN-era Generic - Italian' ),
  ( @activeTopLevelDomainType, 'ICANN-era Generic - Portuguese' ),
  ( @activeTopLevelDomainType, 'ICANN-era Generic - Spanish' ),
  ( @activeTopLevelDomainType, 'Corporate identifiers' ),
  ( @activeTopLevelDomainType, 'Africa' ),
  ( @activeTopLevelDomainType, 'Asia' ),
  ( @activeTopLevelDomainType, 'Europe' ),
  ( @activeTopLevelDomainType, 'North America' ),
  ( @activeTopLevelDomainType, 'Oceania' ),
  ( @activeTopLevelDomainType, 'South America' ),
  ( @activeTopLevelDomainType, 'Brand' ),
  ( @activeTopLevelDomainType, 'Special Use' )
  ;
  
  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsTopLevelDomainType INT;
  SELECT @TotalDataLoadRecordsTopLevelDomainType = COUNT(1) FROM @DataLoadTopLevelDomainType;

  -- We need to reset our loop counter var
  SET @CtrTopLevelDomainType = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrTopLevelDomainType < = @TotalDataLoadRecordsTopLevelDomainType )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    masterLists.TopLevelDomainType AS TopLevelDomainType WITH (nolock)
        WHERE   TopLevelDomainType.TopLevelDomainType = ( SELECT DataLoad.TopLevelDomainType 
                                           FROM @DataLoadTopLevelDomainType AS DataLoad
                                           WHERE RowCounter = @CtrTopLevelDomainType )
      ) 
      BEGIN

        INSERT INTO [MasterLists].[TopLevelDomainType] ( [TopLevelDomainType],[RowStatus],[CreatedBy],[ModifiedBy],[CreatedDate],[ModifiedDate],[RowGuid] )
        OUTPUT inserted.TopLevelDomainType, inserted.RowStatus, inserted.CreatedBy, inserted.ModifiedBy, inserted.CreatedDate, inserted.ModifiedDate, inserted.RowGuid INTO @DataLoadTopLevelDomainTypeOutput
        SELECT
          DataLoad.TopLevelDomainType,
          @activeTopLevelDomainType,
          @CreatedByTopLevelDomainType,
          @CreatedByTopLevelDomainType,
          GETUTCDATE(),
          GETUTCDATE(),
          dbo.SequentialGuidAtEnd()
        FROM
          @DataLoadTopLevelDomainType AS DataLoad
        WHERE
          RowCounter = @CtrTopLevelDomainType

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadTopLevelDomainTypeOutput ( TopLevelDomainType, RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
        SELECT
          TopLevelDomainType.TopLevelDomainType,
          @RecordExistsTopLevelDomainType,
          TopLevelDomainType.CreatedBy,
          TopLevelDomainType.ModifiedBy,
          TopLevelDomainType.CreatedDate,
          TopLevelDomainType.CreatedDate,
          TopLevelDomainType.RowGuid
        FROM    
          MasterLists.TopLevelDomainType AS TopLevelDomainType WITH (nolock)
          
          INNER JOIN @DataLoadTopLevelDomainType AS DataLoad
          ON TopLevelDomainType.TopLevelDomainType = DataLoad.TopLevelDomainType

        WHERE   
          TopLevelDomainType.TopLevelDomainType = ( SELECT DataLoad.TopLevelDomainType 
                                     FROM @DataLoadTopLevelDomainType AS DataLoad
                                     WHERE RowCounter = @CtrTopLevelDomainType )       
         
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrTopLevelDomainType = @CtrTopLevelDomainType + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadTopLevelDomainTypeOutput

  COMMIT TRANSACTION;

END TRY
BEGIN CATCH

  -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrMessageTopLevelDomainType       nvarchar(2048),
    @ErrSeverityTopLevelDomainType      tinyint,
    @ErrStateTopLevelDomainType         tinyint,
    @ErrNumberTopLevelDomainType        int,
    @ErrProcedureTopLevelDomainType     sysname,
    @ErrLineTopLevelDomainType          int
              
  SELECT 
    @ErrNumberTopLevelDomainType    = ERROR_NUMBER(),
    @ErrSeverityTopLevelDomainType  = ERROR_SEVERITY(),
    @ErrStateTopLevelDomainType     = ERROR_STATE(),
    @ErrProcedureTopLevelDomainType = ERROR_PROCEDURE(),
    @ErrLineTopLevelDomainType      = ERROR_LINE(),
    @ErrMessageTopLevelDomainType   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrNumberTopLevelDomainType,
    @ErrorSeverity  = @ErrSeverityTopLevelDomainType,
    @ErrorState     = @ErrStateTopLevelDomainType,
    @ErrorProcedure = @ErrProcedureTopLevelDomainType,
    @ErrorLine      = @ErrLineTopLevelDomainType,
    @ErrorMessage   = @ErrMessageTopLevelDomainType

  --re-raise the error
  RAISERROR ( @ErrMessageTopLevelDomainType, @ErrSeverityTopLevelDomainType, @ErrStateTopLevelDomainType )

END CATCH
