PRINT 'Running 358_MasterList.SecondLevelDomain.sql';

SET NOCOUNT ON;

BEGIN TRY

  BEGIN TRANSACTION;

  -- Our script user id = -1
  DECLARE @CreatedBySecondLevelDomain INT;
  SET @CreatedBySecondLevelDomain = 1;

  -- Active Row Status
  DECLARE @activeSecondLevelDomain INT;
  SET @activeSecondLevelDomain = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsSecondLevelDomain INT;
  SET @RecordExistsSecondLevelDomain = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadSecondLevelDomain AS TABLE
  (
    [RowCounter]                   INT       NOT NULL IDENTITY(1,1),
    [RowStatus]                    [tinyint] NOT NULL,
    [SecondLevelDomain]            [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [ccTLD]                        [char](3)     COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [SecondLevelDomainDescription] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadSecondLevelDomainOutput AS TABLE
  (
    [SecondLevelDomain]            [varchar](16)      NOT NULL,
    [ccTLD]                        [char](3)          NOT NULL,
    [SecondLevelDomainDescription] [varchar](1000)    NULL,
    [RowStatus]                    [tinyint]          NOT NULL,
    [CreatedBy]                    [uniqueidentifier] NOT NULL,
    [ModifiedBy]                   [uniqueidentifier] NOT NULL,
    [CreatedDate]                  [DATETIMEOFFSET]   NOT NULL,
    [ModifiedDate]                 [DATETIMEOFFSET]   NOT NULL,
    [RowGuid]                      [uniqueidentifier] NOT NULL ROWGUIDCOL
  );

  -- We need a loop counter var
  DECLARE @CtrSecondLevelDomain INT;
  SET @CtrSecondLevelDomain = 0;

    -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadSecondLevelDomain ( RowStatus, SecondLevelDomain, ccTLD, SecondLevelDomainDescription )
  VALUES 
  ( @activeSecondLevelDomain, '.',     '.',  'Unknown / placeholder' ),
  ( @activeSecondLevelDomain, 'asn',   'au', 'for associations, political parties and clubs.' ),
  ( @activeSecondLevelDomain, 'com',   'au', 'for commercial use.' ),
  ( @activeSecondLevelDomain, 'net',   'au', 'for registered companies.' ),
  ( @activeSecondLevelDomain, 'id',    'au', 'for Australian citizens only.' ),
  ( @activeSecondLevelDomain, 'org',   'au', 'for Australian citizens only.' ),
  ( @activeSecondLevelDomain, 'edu',   'au', 'for academic institutions.' ),
  ( @activeSecondLevelDomain, 'gov',   'au', 'for government bodies.' ),
  ( @activeSecondLevelDomain, 'csiro', 'au', 'for the Commonwealth Science and Industry Research Organisation (CSIRO). The domain is administrated by CSIRO itself.' ),
  ( @activeSecondLevelDomain, 'act',   'au', 'for the Australian Capital Territory.' ),
  ( @activeSecondLevelDomain, 'nsw',   'au', 'for New South Wales.' ),
  ( @activeSecondLevelDomain, 'nt',    'au', 'for the Northern Territory.' ),
  ( @activeSecondLevelDomain, 'qld',   'au', 'for Queensland.' ),
  ( @activeSecondLevelDomain, 'sa',    'au', 'for South Australia.' ),
  ( @activeSecondLevelDomain, 'tas',   'au', 'for Tasmania.' ),
  ( @activeSecondLevelDomain, 'vic',   'au', 'for Victoria.' ),
  ( @activeSecondLevelDomain, 'wa',    'au', 'for Western Australia.[2] Historically, Australia''s country code top-level domain was .oz. After the introduction of the .au ccTLD, the domains in .oz were moved under the oz.au second-level domain.[3]' ),


  ( @activeSecondLevelDomain, 'co',   'at', 'intended for commercial enterprises' ),
  ( @activeSecondLevelDomain, 'or',   'at', 'intended for organizations.[4]' ),
  ( @activeSecondLevelDomain, 'priv',   'at', 'is restricted to Austrian citizens only, while' ),
  ( @activeSecondLevelDomain, 'ac',   'at', 'reserved for educational institutions and governmental bodies respectively.[5][6]' ),
  ( @activeSecondLevelDomain, 'gv',   'at', 'reserved for educational institutions and governmental bodies respectively.[5][6]' ),

  ( @activeSecondLevelDomain, 'avocat',      'fr', 'for attorneys,' ),
  ( @activeSecondLevelDomain, 'aeroport',    'fr', 'for airports' ),
  ( @activeSecondLevelDomain, 'veterinaire', 'fr', 'for vets' ),

  ( @activeSecondLevelDomain, 'co', 'hu', NULL ),
  ( @activeSecondLevelDomain, 'film', 'hu', NULL ),
  ( @activeSecondLevelDomain, 'lakas', 'hu', NULL ),
  ( @activeSecondLevelDomain, 'ingatlan', 'hu', NULL ),
  ( @activeSecondLevelDomain, 'sport', 'hu', NULL ),
  ( @activeSecondLevelDomain, 'hotel', 'hu', NULL ),

  ( @activeSecondLevelDomain, '.',      'nz', 'first level NZ domain, general use.' ),
  ( @activeSecondLevelDomain, 'ac',     'nz', 'for tertiary educational institutions and related organisations.' ),
  ( @activeSecondLevelDomain, 'co',     'nz', 'for commercial use.' ),
  ( @activeSecondLevelDomain, 'geek',   'nz', 'For people who are concentrative, technically skilled and imaginative who are generally adept with computers.' ),
  ( @activeSecondLevelDomain, 'gen',    'nz', 'General. For Individuals and other organisations not covered elsewhere' ),
  ( @activeSecondLevelDomain, 'kiwi',   'nz', 'For people or organisations that associate with being ''Kiwi'' (the colloquial term for New Zealanders)' ),
  ( @activeSecondLevelDomain, 'maori',  'nz', 'Māori people, groups, and organisations.' ),
  ( @activeSecondLevelDomain, 'net',    'nz', 'Organisations and service providers directly related to the NZ Internet' ),
  ( @activeSecondLevelDomain, 'org',    'nz', 'For non-profit organisations.' ),
  ( @activeSecondLevelDomain, 'school', 'nz', 'Primary, secondary and pre-schools and related organisations' ),

  ( @activeSecondLevelDomain, 'co',  'uk', 'for Australian citizens only.' )
  ;

  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsSecondLevelDomain INT;
  SELECT @TotalDataLoadRecordsSecondLevelDomain = COUNT(1) FROM @DataLoadSecondLevelDomain;

  -- We need to reset our loop counter var
  SET @CtrSecondLevelDomain = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrSecondLevelDomain < = @TotalDataLoadRecordsSecondLevelDomain )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    masterLists.SecondLevelDomain AS SecondLevelDomain WITH (nolock)
        WHERE   SecondLevelDomain.SecondLevelDomain = 
                ( 
                  SELECT DataLoad.SecondLevelDomain 
                  FROM   @DataLoadSecondLevelDomain AS DataLoad
                  WHERE  RowCounter = @CtrSecondLevelDomain 
                )
       AND      SecondLevelDomain.ccTLD =
                ( 
                  SELECT DataLoad.ccTLD
                  FROM   @DataLoadSecondLevelDomain AS DataLoad
                  WHERE  RowCounter = @CtrSecondLevelDomain 
                )

      ) 
      BEGIN

        INSERT INTO [MasterLists].[SecondLevelDomain] ( [SecondLevelDomain], [ccTLD], [SecondLevelDomainDescription], [RowStatus], [CreatedBy], [ModifiedBy],[CreatedDate],[ModifiedDate],[RowGuid] )
        OUTPUT inserted.SecondLevelDomain, inserted.ccTLD, inserted.SecondLevelDomainDescription, inserted.RowStatus, inserted.CreatedBy, inserted.ModifiedBy, inserted.CreatedDate, inserted.ModifiedDate, inserted.RowGuid INTO @DataLoadSecondLevelDomainOutput
        SELECT
          DataLoad.SecondLevelDomain,
          DataLoad.ccTLD,
          DataLoad.SecondLevelDomainDescription,
          @activeSecondLevelDomain,
          @CreatedBySecondLevelDomain,
          @CreatedBySecondLevelDomain,
          GETUTCDATE(),
          GETUTCDATE(),
          NEWID()
        FROM
          @DataLoadSecondLevelDomain AS DataLoad
        WHERE
          RowCounter = @CtrSecondLevelDomain

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadSecondLevelDomainOutput ( SecondLevelDomain, ccTLD, SecondLevelDomainDescription, RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
        SELECT
          SecondLevelDomain.SecondLevelDomain,
          SecondLevelDomain.ccTLD,
          SecondLevelDomain.SecondLevelDomainDescription,
          @RecordExistsSecondLevelDomain,
          SecondLevelDomain.CreatedBy,
          SecondLevelDomain.ModifiedBy,
          SecondLevelDomain.CreatedDate,
          SecondLevelDomain.CreatedDate,
          SecondLevelDomain.RowGuid
        FROM    
          MasterLists.SecondLevelDomain AS SecondLevelDomain WITH (nolock)
          
          INNER JOIN @DataLoadSecondLevelDomain AS DataLoad
          ON SecondLevelDomain.SecondLevelDomain = DataLoad.SecondLevelDomain

        WHERE   
          SecondLevelDomain.SecondLevelDomain = ( SELECT DataLoad.SecondLevelDomain 
                                     FROM @DataLoadSecondLevelDomain AS DataLoad
                                     WHERE RowCounter = @CtrSecondLevelDomain )       
         
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrSecondLevelDomain = @CtrSecondLevelDomain + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadSecondLevelDomainOutput

  COMMIT TRANSACTION;

END TRY
BEGIN CATCH

  -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrMessageSecondLevelDomain       nvarchar(2048),
    @ErrSeveritySecondLevelDomain      tinyint,
    @ErrStateSecondLevelDomain         tinyint,
    @ErrNumberSecondLevelDomain        int,
    @ErrProcedureSecondLevelDomain     sysname,
    @ErrLineSecondLevelDomain          int
              
  SELECT 
    @ErrNumberSecondLevelDomain    = ERROR_NUMBER(),
    @ErrSeveritySecondLevelDomain  = ERROR_SEVERITY(),
    @ErrStateSecondLevelDomain     = ERROR_STATE(),
    @ErrProcedureSecondLevelDomain = ERROR_PROCEDURE(),
    @ErrLineSecondLevelDomain      = ERROR_LINE(),
    @ErrMessageSecondLevelDomain   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrNumberSecondLevelDomain,
    @ErrorSeverity  = @ErrSeveritySecondLevelDomain,
    @ErrorState     = @ErrStateSecondLevelDomain,
    @ErrorProcedure = @ErrProcedureSecondLevelDomain,
    @ErrorLine      = @ErrLineSecondLevelDomain,
    @ErrorMessage   = @ErrMessageSecondLevelDomain

  --re-raise the error
  RAISERROR ( @ErrMessageSecondLevelDomain, @ErrSeveritySecondLevelDomain, @ErrStateSecondLevelDomain )

END CATCH
