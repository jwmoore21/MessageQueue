PRINT 'Running 303_MasterList.CountryTld.sql';

SET NOCOUNT ON;

BEGIN TRY

  -- Our script user id = -1
  DECLARE @CreatedByccTLD INT;
  SET @CreatedByccTLD = 1;

  -- Active Row Status
  DECLARE @activeccTLD INT;
  SET @activeccTLD = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsccTLD INT;
  SET @RecordExistsccTLD = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadccTLD AS TABLE
  (
    [RowCounter] INT       NOT NULL IDENTITY(1,1),
    [RowStatus]  [tinyint] NOT NULL,
    [ccTLD]      [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadccTLDOutput AS TABLE
  (
    [ccTLD]        [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [RowStatus]    [tinyint] NOT NULL,
    [CreatedBy]    [UNIQUEIDENTIFIER] NOT NULL,
    [ModifiedBy]   [UNIQUEIDENTIFIER] NOT NULL,
    [CreatedDate]  [DATETIMEOFFSET] NOT NULL,
    [ModifiedDate] [DATETIMEOFFSET] NOT NULL,
    [RowGuid]         [uniqueidentifier] NOT NULL
  );

  -- We need a loop counter var
  DECLARE @CtrccTLD INT;
  SET @CtrccTLD = 0;

  -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadccTLD ( RowStatus, ccTLD )
  VALUES 
  ( @activeccTLD, '.' ),
  ( @activeccTLD, 'ad' ),
  ( @activeccTLD, 'ae' ),
  ( @activeccTLD, 'af' ),
  ( @activeccTLD, 'ag' ),
  ( @activeccTLD, 'ai' ),
  ( @activeccTLD, 'al' ),
  ( @activeccTLD, 'am' ),
  ( @activeccTLD, 'ao' ),
  ( @activeccTLD, 'aq' ),
  ( @activeccTLD, 'ar' ),
  ( @activeccTLD, 'as' ),
  ( @activeccTLD, 'at' ),
  ( @activeccTLD, 'au' ),
  ( @activeccTLD, 'aw' ),
  ( @activeccTLD, 'ax' ),
  ( @activeccTLD, 'az' ),
  ( @activeccTLD, 'ba' ),
  ( @activeccTLD, 'bb' ),
  ( @activeccTLD, 'bd' ),
  ( @activeccTLD, 'be' ),
  ( @activeccTLD, 'bf' ),
  ( @activeccTLD, 'bg' ),
  ( @activeccTLD, 'bh' ),
  ( @activeccTLD, 'bi' ),
  ( @activeccTLD, 'bj' ),
  ( @activeccTLD, 'bl' ),
  ( @activeccTLD, 'bm' ),
  ( @activeccTLD, 'bn' ),
  ( @activeccTLD, 'bo' ),
  ( @activeccTLD, 'bq' ),
  ( @activeccTLD, 'br' ),
  ( @activeccTLD, 'bs' ),
  ( @activeccTLD, 'bt' ),
  ( @activeccTLD, 'bv' ),
  ( @activeccTLD, 'bw' ),
  ( @activeccTLD, 'by' ),
  ( @activeccTLD, 'bz' ),
  ( @activeccTLD, 'ca' ),
  ( @activeccTLD, 'cc' ),
  ( @activeccTLD, 'cd' ),
  ( @activeccTLD, 'cf' ),
  ( @activeccTLD, 'cg' ),
  ( @activeccTLD, 'ch' ),
  ( @activeccTLD, 'ci' ),
  ( @activeccTLD, 'ck' ),
  ( @activeccTLD, 'cl' ),
  ( @activeccTLD, 'cm' ),
  ( @activeccTLD, 'cn' ),
  ( @activeccTLD, 'co' ),
  ( @activeccTLD, 'cr' ),
  ( @activeccTLD, 'cu' ),
  ( @activeccTLD, 'cv' ),
  ( @activeccTLD, 'cw' ),
  ( @activeccTLD, 'cx' ),
  ( @activeccTLD, 'cy' ),
  ( @activeccTLD, 'cz' ),
  ( @activeccTLD, 'de' ),
  ( @activeccTLD, 'dj' ),
  ( @activeccTLD, 'dk' ),
  ( @activeccTLD, 'dm' ),
  ( @activeccTLD, 'do' ),
  ( @activeccTLD, 'dz' ),
  ( @activeccTLD, 'ec' ),
  ( @activeccTLD, 'ee' ),
  ( @activeccTLD, 'eg' ),
  ( @activeccTLD, 'eh' ),
  ( @activeccTLD, 'er' ),
  ( @activeccTLD, 'es' ),
  ( @activeccTLD, 'et' ),
  ( @activeccTLD, 'fi' ),
  ( @activeccTLD, 'fj' ),
  ( @activeccTLD, 'fk' ),
  ( @activeccTLD, 'fm' ),
  ( @activeccTLD, 'fo' ),
  ( @activeccTLD, 'fr' ),
  ( @activeccTLD, 'ga' ),
  ( @activeccTLD, 'gb' ),
  ( @activeccTLD, 'gd' ),
  ( @activeccTLD, 'ge' ),
  ( @activeccTLD, 'gf' ),
  ( @activeccTLD, 'gg' ),
  ( @activeccTLD, 'gh' ),
  ( @activeccTLD, 'gi' ),
  ( @activeccTLD, 'gl' ),
  ( @activeccTLD, 'gm' ),
  ( @activeccTLD, 'gn' ),
  ( @activeccTLD, 'gp' ),
  ( @activeccTLD, 'gq' ),
  ( @activeccTLD, 'gr' ),
  ( @activeccTLD, 'gs' ),
  ( @activeccTLD, 'gt' ),
  ( @activeccTLD, 'gu' ),
  ( @activeccTLD, 'gw' ),
  ( @activeccTLD, 'gy' ),
  ( @activeccTLD, 'hk' ),
  ( @activeccTLD, 'hm' ),
  ( @activeccTLD, 'hn' ),
  ( @activeccTLD, 'hr' ),
  ( @activeccTLD, 'ht' ),
  ( @activeccTLD, 'hu' ),
  ( @activeccTLD, 'id' ),
  ( @activeccTLD, 'ie' ),
  ( @activeccTLD, 'il' ),
  ( @activeccTLD, 'im' ),
  ( @activeccTLD, 'in' ),
  ( @activeccTLD, 'io' ),
  ( @activeccTLD, 'iq' ),
  ( @activeccTLD, 'ir' ),
  ( @activeccTLD, 'is' ),
  ( @activeccTLD, 'it' ),
  ( @activeccTLD, 'je' ),
  ( @activeccTLD, 'jm' ),
  ( @activeccTLD, 'jo' ),
  ( @activeccTLD, 'jp' ),
  ( @activeccTLD, 'ke' ),
  ( @activeccTLD, 'kg' ),
  ( @activeccTLD, 'kh' ),
  ( @activeccTLD, 'ki' ),
  ( @activeccTLD, 'km' ),
  ( @activeccTLD, 'kn' ),
  ( @activeccTLD, 'kp' ),
  ( @activeccTLD, 'kr' ),
  ( @activeccTLD, 'kw' ),
  ( @activeccTLD, 'ky' ),
  ( @activeccTLD, 'kz' ),
  ( @activeccTLD, 'la' ),
  ( @activeccTLD, 'lb' ),
  ( @activeccTLD, 'lc' ),
  ( @activeccTLD, 'li' ),
  ( @activeccTLD, 'lk' ),
  ( @activeccTLD, 'lr' ),
  ( @activeccTLD, 'ls' ),
  ( @activeccTLD, 'lt' ),
  ( @activeccTLD, 'lu' ),
  ( @activeccTLD, 'lv' ),
  ( @activeccTLD, 'ly' ),
  ( @activeccTLD, 'ma' ),
  ( @activeccTLD, 'mc' ),
  ( @activeccTLD, 'md' ),
  ( @activeccTLD, 'me' ),
  ( @activeccTLD, 'mf' ),
  ( @activeccTLD, 'mg' ),
  ( @activeccTLD, 'mh' ),
  ( @activeccTLD, 'mk' ),
  ( @activeccTLD, 'ml' ),
  ( @activeccTLD, 'mm' ),
  ( @activeccTLD, 'mn' ),
  ( @activeccTLD, 'mo' ),
  ( @activeccTLD, 'mp' ),
  ( @activeccTLD, 'mq' ),
  ( @activeccTLD, 'mr' ),
  ( @activeccTLD, 'ms' ),
  ( @activeccTLD, 'mt' ),
  ( @activeccTLD, 'mu' ),
  ( @activeccTLD, 'mv' ),
  ( @activeccTLD, 'mw' ),
  ( @activeccTLD, 'mx' ),
  ( @activeccTLD, 'my' ),
  ( @activeccTLD, 'mz' ),
  ( @activeccTLD, 'na' ),
  ( @activeccTLD, 'nc' ),
  ( @activeccTLD, 'ne' ),
  ( @activeccTLD, 'nf' ),
  ( @activeccTLD, 'ng' ),
  ( @activeccTLD, 'ni' ),
  ( @activeccTLD, 'nl' ),
  ( @activeccTLD, 'no' ),
  ( @activeccTLD, 'np' ),
  ( @activeccTLD, 'nr' ),
  ( @activeccTLD, 'nu' ),
  ( @activeccTLD, 'nz' ),
  ( @activeccTLD, 'om' ),
  ( @activeccTLD, 'pa' ),
  ( @activeccTLD, 'pe' ),
  ( @activeccTLD, 'pf' ),
  ( @activeccTLD, 'pg' ),
  ( @activeccTLD, 'ph' ),
  ( @activeccTLD, 'pk' ),
  ( @activeccTLD, 'pl' ),
  ( @activeccTLD, 'pm' ),
  ( @activeccTLD, 'pn' ),
  ( @activeccTLD, 'pr' ),
  ( @activeccTLD, 'ps' ),
  ( @activeccTLD, 'pt' ),
  ( @activeccTLD, 'pw' ),
  ( @activeccTLD, 'py' ),
  ( @activeccTLD, 'qa' ),
  ( @activeccTLD, 're' ),
  ( @activeccTLD, 'ro' ),
  ( @activeccTLD, 'rs' ),
  ( @activeccTLD, 'ru' ),
  ( @activeccTLD, 'rw' ),
  ( @activeccTLD, 'sa' ),
  ( @activeccTLD, 'sb' ),
  ( @activeccTLD, 'sc' ),
  ( @activeccTLD, 'sd' ),
  ( @activeccTLD, 'se' ),
  ( @activeccTLD, 'sg' ),
  ( @activeccTLD, 'sh' ),
  ( @activeccTLD, 'si' ),
  ( @activeccTLD, 'sj' ),
  ( @activeccTLD, 'sk' ),
  ( @activeccTLD, 'sl' ),
  ( @activeccTLD, 'sm' ),
  ( @activeccTLD, 'sn' ),
  ( @activeccTLD, 'so' ),
  ( @activeccTLD, 'sr' ),
  ( @activeccTLD, 'st' ),
  ( @activeccTLD, 'sv' ),
  ( @activeccTLD, 'sx' ),
  ( @activeccTLD, 'sy' ),
  ( @activeccTLD, 'sz' ),
  ( @activeccTLD, 'tc' ),
  ( @activeccTLD, 'td' ),
  ( @activeccTLD, 'tf' ),
  ( @activeccTLD, 'tg' ),
  ( @activeccTLD, 'th' ),
  ( @activeccTLD, 'tj' ),
  ( @activeccTLD, 'tk' ),
  ( @activeccTLD, 'tl' ),
  ( @activeccTLD, 'tm' ),
  ( @activeccTLD, 'tn' ),
  ( @activeccTLD, 'to' ),
  ( @activeccTLD, 'tr' ),
  ( @activeccTLD, 'tt' ),
  ( @activeccTLD, 'tv' ),
  ( @activeccTLD, 'tw' ),
  ( @activeccTLD, 'tz' ),
  ( @activeccTLD, 'ua' ),
  ( @activeccTLD, 'ug' ),
  ( @activeccTLD, 'um' ),
  ( @activeccTLD, 'us' ),
  ( @activeccTLD, 'uy' ),
  ( @activeccTLD, 'uz' ),
  ( @activeccTLD, 'va' ),
  ( @activeccTLD, 'vc' ),
  ( @activeccTLD, 've' ),
  ( @activeccTLD, 'vg' ),
  ( @activeccTLD, 'vi' ),
  ( @activeccTLD, 'vn' ),
  ( @activeccTLD, 'vu' ),
  ( @activeccTLD, 'wf' ),
  ( @activeccTLD, 'ws' ),
  ( @activeccTLD, 'ye' ),
  ( @activeccTLD, 'yt' ),
  ( @activeccTLD, 'za' ),
  ( @activeccTLD, 'zm' ),
  ( @activeccTLD, 'zw' ),
  ( @activeccTLD, 'uk' )
  ;

  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsccTLD INT;
  SELECT @TotalDataLoadRecordsccTLD = COUNT(1) FROM @DataLoadccTLD;

  -- We need to reset our loop counter var
  SET @CtrccTLD = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrccTLD < = @TotalDataLoadRecordsccTLD )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    masterLists.CountryTld AS ccTLD WITH (nolock)
        WHERE   ccTLD.ccTLD = ( SELECT DataLoad.ccTLD 
                                FROM @DataLoadccTLD AS DataLoad
                                WHERE RowCounter = @CtrccTLD )
      ) 
      BEGIN

        INSERT INTO [MasterLists].[CountryTld] ( [ccTLD],[RowStatus],[CreatedBy],[ModifiedBy],[CreatedDate],[ModifiedDate],[RowGuid] )
        OUTPUT inserted.ccTLD, inserted.RowStatus, inserted.CreatedBy, inserted.ModifiedBy, inserted.CreatedDate, inserted.ModifiedDate, inserted.RowGuid INTO @DataLoadccTLDOutput
        SELECT
          DataLoad.ccTLD,
          @activeccTLD,
          @CreatedByccTLD,
          @CreatedByccTLD,
          GETUTCDATE(),
          GETUTCDATE(),
          NEWID()
        FROM
          @DataLoadccTLD AS DataLoad
        WHERE
          RowCounter = @CtrccTLD

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadccTLDOutput ( ccTLD, RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
        SELECT
          ccTLD.ccTLD,
          @RecordExistsccTLD,
          ccTLD.CreatedBy,
          ccTLD.ModifiedBy,
          ccTLD.CreatedDate,
          ccTLD.CreatedDate,
          ccTLD.RowGuid
        FROM    
          MasterLists.CountryTld AS ccTLD WITH (nolock)
          
          INNER JOIN @DataLoadccTLD AS DataLoad
          ON ccTLD.ccTLD = DataLoad.ccTLD

        WHERE   
          ccTLD.ccTLD = ( SELECT DataLoad.ccTLD 
                          FROM @DataLoadccTLD AS DataLoad
                          WHERE RowCounter = @CtrccTLD )
                
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrccTLD = @CtrccTLD + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadccTLDOutput


END TRY
BEGIN CATCH

  -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrMessageccTLD       nvarchar(2048),
    @ErrSeverityccTLD      tinyint,
    @ErrStateccTLD         tinyint,
    @ErrNumberccTLD        int,
    @ErrProcedureccTLD     sysname,
    @ErrLineccTLD          int
              
  SELECT 
    @ErrNumberccTLD    = ERROR_NUMBER(),
    @ErrSeverityccTLD  = ERROR_SEVERITY(),
    @ErrStateccTLD     = ERROR_STATE(),
    @ErrProcedureccTLD = ERROR_PROCEDURE(),
    @ErrLineccTLD      = ERROR_LINE(),
    @ErrMessageccTLD   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrNumberccTLD,
    @ErrorSeverity  = @ErrSeverityccTLD,
    @ErrorState     = @ErrStateccTLD,
    @ErrorProcedure = @ErrProcedureccTLD,
    @ErrorLine      = @ErrLineccTLD,
    @ErrorMessage   = @ErrMessageccTLD

  --re-raise the error
  RAISERROR ( @ErrMessageccTLD, @ErrSeverityccTLD, @ErrStateccTLD )

END CATCH
