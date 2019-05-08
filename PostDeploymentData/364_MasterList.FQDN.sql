PRINT 'Running 350_MasterList.FullyQualifiedDomainName.sql';

SET NOCOUNT ON;

BEGIN TRY

  -- Our script user id = -1
  DECLARE @CreatedByFullyQualifiedDomainName INT;
  SET @CreatedByFullyQualifiedDomainName = 1;

  -- Active Row Status
  DECLARE @activeFullyQualifiedDomainName INT;
  SET @activeFullyQualifiedDomainName = 8;

  DECLARE @VerbodenFullyQualifiedDomainName INT;
  SET @VerbodenFullyQualifiedDomainName = 11;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsFullyQualifiedDomainName INT;
  SET @RecordExistsFullyQualifiedDomainName = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadFullyQualifiedDomainName AS TABLE
  (
    [RowCounter]        INT            NOT NULL IDENTITY(1,1),
    [RowStatus]         [tinyint]      NOT NULL,
    [ccTLD]             [char](3)      NOT NULL,
    [SecondLevelDomain] [varchar](16)  NOT NULL,
    [TopLevelDomain]    [varchar](24)  NOT NULL,
    [DomainName]        [varchar](188) NOT NULL,
    [SubHostName]       [varchar](63)  NOT NULL,
    [HostName]          [varchar](63)  NOT NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadFullyQualifiedDomainNameOutput AS TABLE
  (
    [ccTLD]             [char](3)          NOT NULL,
    [SecondLevelDomain] [varchar](16)      NOT NULL,
    [TopLevelDomain]    [varchar](24)      NOT NULL,
    [DomainName]        [varchar](188)     NOT NULL,
    [SubHostName]       [varchar](63)      NOT NULL,
    [HostName]          [varchar](63)      NOT NULL,
    [RowStatus]         [tinyint]          NOT NULL,
    [CreatedBy]         [uniqueidentifier] NULL,
    [ModifiedBy]        [uniqueidentifier] NULL,
    [CreatedDate]       [DATETIMEOFFSET]         NULL,
    [ModifiedDate]      [DATETIMEOFFSET]         NULL,
    [RowGuid]              [uniqueidentifier] NULL ROWGUIDCOL  
  );

  -- We need a loop counter var
  DECLARE @CtrFullyQualifiedDomainName INT;
  SET @CtrFullyQualifiedDomainName = 0;

  /* FK vars to check for value existance */
  DECLARE @fqdn_ccTLD             char(3);
  DECLARE @fqdn_SecondLevelDomain varchar(16);
  DECLARE @fqdn_TopLevelDomain    varchar(24);
  DECLARE @fqdn_DomainName        varchar(188);
  DECLARE @fqdn_SubHostName       varchar(63); 
  DECLARE @fqdn_HostName          varchar(63);

  /* Bulk load the data we wish to try and insert to our data loader table */
  INSERT INTO @DataLoadFullyQualifiedDomainName ( RowStatus, ccTLD, SecondLevelDomain, TopLevelDomain, DomainName, SubHostName, HostName )
  VALUES 
  ( @activeFullyQualifiedDomainName,   '.',  '.',   '.',     '.',                          '.', '.' ),
  ( @activeFullyQualifiedDomainName,   '.',  '.',   'com',   'bootstrap',                  '.', 'www' ),
  ( @activeFullyQualifiedDomainName,   '.',  '.',   'com',   'jquery',                     '.', 'www' ),
  ( @activeFullyQualifiedDomainName,   '.',  '.',   'com',   'google',                     '.', 'www' ),
  ( @activeFullyQualifiedDomainName,   '.',  '.',   'com',   'outlook',                    '.', 'www' ),
  ( @activeFullyQualifiedDomainName,   'uk', 'co',  '.',     'bbc',                        '.', 'www' ),
  ( @activeFullyQualifiedDomainName,   '.',  '.',   'com',   'facebook',                   '.', 'www' ),
  ( @activeFullyQualifiedDomainName,   'au', 'com', '.',     'amazon',                     '.', 'www' ),
  ( @activeFullyQualifiedDomainName,   'uk', 'co',  '.',     'amazon',                     '.', 'www' )  
  ;



  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsFullyQualifiedDomainName INT;
  SELECT @TotalDataLoadRecordsFullyQualifiedDomainName = COUNT(1) FROM @DataLoadFullyQualifiedDomainName;

  -- We need to reset our loop counter var
  SET @CtrFullyQualifiedDomainName = 1;
 

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrFullyQualifiedDomainName < = @TotalDataLoadRecordsFullyQualifiedDomainName )
  BEGIN
    
    BEGIN TRANSACTION;

    /* Check FK values */

    SET @fqdn_ccTLD = 
    (
      SELECT ISNULL( DataLoad.ccTLD, NULL )
      FROM @DataLoadFullyQualifiedDomainName AS DataLoad
      WHERE RowCounter = @CtrFullyQualifiedDomainName 
    );

    IF NOT EXISTS
    (
      SELECT 1
      FROM   masterLists.CountryTLD
      WHERE  CountryTLD.ccTLD = @fqdn_ccTLD
    )
    BEGIN
      /* Missing ccTLD */
      PRINT 'Missing ccTLD: ' + @fqdn_ccTLD;

      UPDATE @DataLoadFullyQualifiedDomainName
        SET RowStatus = 0
      WHERE RowCounter = @CtrFullyQualifiedDomainName;
    END

    /* ++++++++++++++++++++++++++++++ */
    SET @fqdn_SecondLevelDomain = 
    (
      SELECT ISNULL( DataLoad.SecondLevelDomain, NULL )
      FROM   @DataLoadFullyQualifiedDomainName AS DataLoad
      WHERE  RowCounter = @CtrFullyQualifiedDomainName
    );

    IF NOT EXISTS
    (
      SELECT 1
      FROM   masterLists.SecondLevelDomain
      WHERE  SecondLevelDomain.SecondLevelDomain = @fqdn_SecondLevelDomain
    )
    BEGIN
      /* Missing SecondLevelDomainName */
      PRINT 'Missing SecondLevelDomainName: ' + @fqdn_SecondLevelDomain;

      UPDATE @DataLoadFullyQualifiedDomainName
        SET RowStatus = 0
      WHERE RowCounter = @CtrFullyQualifiedDomainName
    END

    /* ++++++++++++++++++++++++++++++ */
    SET @fqdn_TopLevelDomain = 
    (
      SELECT ISNULL( DataLoad.TopLevelDomain, NULL )
      FROM   @DataLoadFullyQualifiedDomainName AS DataLoad
      WHERE  RowCounter = @CtrFullyQualifiedDomainName
    );

    IF NOT EXISTS
    (
      SELECT 1
      FROM   masterLists.TopLevelDomain
      WHERE  TopLevelDomain.TopLevelDomain = @fqdn_TopLevelDomain
    )
    BEGIN
      /* Missing TopLevelDomainName */
      PRINT 'Missing TopLevelDomainName: ' + @fqdn_TopLevelDomain;

      UPDATE @DataLoadFullyQualifiedDomainName
        SET RowStatus = 0
      WHERE RowCounter = @CtrFullyQualifiedDomainName
    END

    /* ++++++++++++++++++++++++++++++ */
    SET @fqdn_DomainName = 
    (
      SELECT ISNULL( DataLoad.DomainName, NULL )
      FROM   @DataLoadFullyQualifiedDomainName AS DataLoad
      WHERE  RowCounter = @CtrFullyQualifiedDomainName
    );

    IF NOT EXISTS
    (
      SELECT 1
      FROM   masterLists.DomainName
      WHERE  DomainName.DomainName = @fqdn_DomainName
    )
    BEGIN
      /* Missing DomainName */
      PRINT 'Missing DomainName: ' + @fqdn_DomainName;

      UPDATE @DataLoadFullyQualifiedDomainName
        SET RowStatus = 0
      WHERE RowCounter = @CtrFullyQualifiedDomainName;
    END

    /* ++++++++++++++++++++++++++++++ */
    SET @fqdn_SubHostName = 
    (
      SELECT ISNULL( DataLoad.SubHostName, NULL )
      FROM   @DataLoadFullyQualifiedDomainName AS DataLoad
      WHERE  RowCounter = @CtrFullyQualifiedDomainName 
    );
    
    IF NOT EXISTS
    (
      SELECT 1
      FROM   masterLists.SubHostName
      WHERE  SubHostName.SubHostName = @fqdn_SubHostName
    )
    BEGIN
      /* Missing SubHostName */
      PRINT 'Missing SubHostName: ' + @fqdn_SubHostName;

      UPDATE @DataLoadFullyQualifiedDomainName
        SET RowStatus = 0
      WHERE RowCounter = @CtrFullyQualifiedDomainName;
    END

    /* ++++++++++++++++++++++++++++++ */
    SET @fqdn_HostName = 
    (
      SELECT ISNULL( DataLoad.HostName, NULL )
      FROM   @DataLoadFullyQualifiedDomainName AS DataLoad
      WHERE  RowCounter = @CtrFullyQualifiedDomainName 
    );

    IF NOT EXISTS
    (
      SELECT 1
      FROM   masterLists.HostName
      WHERE  HostName.HostName = @fqdn_HostName
    )
    BEGIN
    
      IF NOT EXISTS 
      ( 
        SELECT 1
        FROM   masterLists.HostName AS HostName WITH (nolock)
        WHERE  
          HostName.RowStatus = 1   
        AND HostName.HostName = @fqdn_HostName
      )
      BEGIN
        /* Missing HostName */
        PRINT 'Missing HostName: ' + @fqdn_HostName;

        UPDATE @DataLoadFullyQualifiedDomainName
          SET RowStatus = 0
        WHERE RowCounter = @CtrFullyQualifiedDomainName 
      END

    END

    /* ------------------------------------------------------------------- */
    /* Now attempt to insert our record */
    IF 
    (
      SELECT RowStatus
      FROM   @DataLoadFullyQualifiedDomainName AS DataLoad
      WHERE  RowCounter = @CtrFullyQualifiedDomainName 
    ) <> 0
    BEGIN

      IF NOT EXISTS 
      ( 
        SELECT 1
        FROM   masterLists.FullyQualifiedDomainName AS FullyQualifiedDomainName WITH (nolock)
        WHERE  
          FullyQualifiedDomainName.RowStatus = 1   
        AND FullyQualifiedDomainName.ccTLD = 
          ( 
            SELECT DataLoad.ccTLD 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.SecondLevelDomain = 
          ( 
            SELECT DataLoad.SecondLevelDomain 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.TopLevelDomain = 
          ( 
            SELECT DataLoad.TopLevelDomain 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.DomainName = 
          ( 
            SELECT DataLoad.DomainName 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.SubHostName = 
          ( 
            SELECT DataLoad.SubHostName 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.HostName = 
          ( 
            SELECT DataLoad.HostName 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
      ) 
      BEGIN

        BEGIN TRY

          INSERT INTO [MasterLists].[FullyQualifiedDomainName] ( [ccTLD], [SecondLevelDomain], [TopLevelDomain], [DomainName], [SubHostName], [HostName], [RowStatus],[CreatedBy],[ModifiedBy],[CreatedDate],[ModifiedDate],[RowGuid] )
          OUTPUT inserted.ccTLD, inserted.SecondLevelDomain, inserted.TopLevelDomain, inserted.DomainName, inserted.SubHostName, inserted.HostName, inserted.RowStatus, inserted.CreatedBy, inserted.ModifiedBy, inserted.CreatedDate, inserted.ModifiedDate, inserted.RowGuid INTO @DataLoadFullyQualifiedDomainNameOutput
          SELECT
            DataLoad.[ccTLD],
            DataLoad.[SecondLevelDomain],
            DataLoad.[TopLevelDomain],
            DataLoad.[DomainName],
            DataLoad.[SubHostName],
            DataLoad.[HostName],
            @activeFullyQualifiedDomainName,
            @CreatedByFullyQualifiedDomainName,
            @CreatedByFullyQualifiedDomainName,
            GETUTCDATE(),
            GETUTCDATE(),
            NEWID()
          FROM
            @DataLoadFullyQualifiedDomainName AS DataLoad
          WHERE
            RowCounter = @CtrFullyQualifiedDomainName

        END TRY
        BEGIN CATCH
            
          /* re-raise the error */
          PRINT ERROR_MESSAGE();

        END CATCH

      END

      ELSE
      BEGIN
      
        /* One of the FKs is missing */
        INSERT INTO @DataLoadFullyQualifiedDomainNameOutput ( [ccTLD], [SecondLevelDomain], [TopLevelDomain], [DomainName], [SubHostName], [HostName], RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
        SELECT
          FullyQualifiedDomainName.[ccTLD],
          FullyQualifiedDomainName.[SecondLevelDomain],
          FullyQualifiedDomainName.[TopLevelDomain],
          FullyQualifiedDomainName.[DomainName],
          FullyQualifiedDomainName.[SubHostName],
          FullyQualifiedDomainName.[HostName],
          @RecordExistsFullyQualifiedDomainName,
          FullyQualifiedDomainName.CreatedBy,
          FullyQualifiedDomainName.ModifiedBy,
          FullyQualifiedDomainName.CreatedDate,
          FullyQualifiedDomainName.CreatedDate,
          FullyQualifiedDomainName.RowGuid
        FROM    
          MasterLists.FullyQualifiedDomainName AS FullyQualifiedDomainName
          
          INNER JOIN @DataLoadFullyQualifiedDomainName AS DataLoad
          ON FullyQualifiedDomainName.ccTLD = DataLoad.ccTLD
          AND FullyQualifiedDomainName.SecondLevelDomain = DataLoad.SecondLevelDomain
          AND FullyQualifiedDomainName.TopLevelDomain = DataLoad.TopLevelDomain
          AND FullyQualifiedDomainName.DomainName = DataLoad.DomainName
          AND FullyQualifiedDomainName.SubHostName = DataLoad.SubHostName
          AND FullyQualifiedDomainName.HostName = DataLoad.HostName
          
          /*
        WHERE FullyQualifiedDomainName.ccTLD = 
          ( 
            SELECT DataLoad.ccTLD 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.TopLevelDomain = 
          ( 
            SELECT DataLoad.TopLevelDomain 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.DomainName = 
          ( 
            SELECT DataLoad.DomainName 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.SubHostName = 
          ( 
            SELECT DataLoad.SubHostName 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )
        AND FullyQualifiedDomainName.HostName = 
          ( 
            SELECT DataLoad.HostName 
            FROM @DataLoadFullyQualifiedDomainName AS DataLoad
            WHERE RowCounter = @CtrFullyQualifiedDomainName 
          )         
          */
      END /* end if exists */

    END
    ELSE
    BEGIN

      /* The record exists, just add it to our output statused appropriately */
      INSERT INTO @DataLoadFullyQualifiedDomainNameOutput ( [ccTLD], [SecondLevelDomain], [TopLevelDomain], [DomainName], [SubHostName], [HostName], RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid )
      SELECT
        DataLoad.[ccTLD],
        DataLoad.[SecondLevelDomain],
        DataLoad.[TopLevelDomain],
        DataLoad.[DomainName],
        DataLoad.[SubHostName],
        DataLoad.[HostName],
        DataLoad.[RowStatus],
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
      FROM    
        @DataLoadFullyQualifiedDomainName AS DataLoad
      
      WHERE
        DataLoad.RowCounter = @CtrFullyQualifiedDomainName;
        

    
    END /* If rowstatus = 1 */

    -- Increase our counter by 1
    SET @CtrFullyQualifiedDomainName = @CtrFullyQualifiedDomainName + 1;


    COMMIT TRANSACTION;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadFullyQualifiedDomainNameOutput


END TRY
BEGIN CATCH

  -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

  DECLARE 
    @ErrMessageFullyQualifiedDomainName       nvarchar(2048),
    @ErrSeverityFullyQualifiedDomainName      tinyint,
    @ErrStateFullyQualifiedDomainName         tinyint,
    @ErrNumberFullyQualifiedDomainName        int,
    @ErrProcedureFullyQualifiedDomainName     sysname,
    @ErrLineFullyQualifiedDomainName          int
              
  SELECT 
    @ErrNumberFullyQualifiedDomainName    = ERROR_NUMBER(),
    @ErrSeverityFullyQualifiedDomainName  = ERROR_SEVERITY(),
    @ErrStateFullyQualifiedDomainName     = ERROR_STATE(),
    @ErrProcedureFullyQualifiedDomainName = ERROR_PROCEDURE(),
    @ErrLineFullyQualifiedDomainName      = ERROR_LINE(),
    @ErrMessageFullyQualifiedDomainName   = ERROR_MESSAGE();

  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrNumberFullyQualifiedDomainName,
    @ErrorSeverity  = @ErrSeverityFullyQualifiedDomainName,
    @ErrorState     = @ErrStateFullyQualifiedDomainName,
    @ErrorProcedure = @ErrProcedureFullyQualifiedDomainName,
    @ErrorLine      = @ErrLineFullyQualifiedDomainName,
    @ErrorMessage   = @ErrMessageFullyQualifiedDomainName

  --re-raise the error
  RAISERROR ( @ErrMessageFullyQualifiedDomainName, @ErrSeverityFullyQualifiedDomainName, @ErrStateFullyQualifiedDomainName )

END CATCH
