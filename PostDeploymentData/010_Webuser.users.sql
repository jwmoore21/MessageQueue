PRINT 'Running 010_Webuser.users.sql';

SET NOCOUNT ON;

  -- Our script user id = -1
  DECLARE @CreatedByWebUser INT;
  SET @CreatedByWebUser = 1;

  -- activeWebUser Row WebUser
  DECLARE @activeWebUser INT;
  SET @activeWebUser = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsWebUser INT;
  SET @RecordExistsWebUser = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadWebUser AS TABLE
  (
    [RowCounter]     INT              NOT NULL IDENTITY(1,1),
    [UserId]         INT              NOT NULL,
    [RowGuid]        UNIQUEIDENTIFIER NOT NULL,
    [RowStatus]      TINYINT          NOT NULL,
    [Username]       VARCHAR (64)     NOT NULL,
    [Password]       VARCHAR (255)    NOT NULL,
    [Id]             VARCHAR (255)    NOT NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadWebUserOutput AS TABLE
  (
    [UserId]         UNIQUEIDENTIFIER NOT NULL,
    [RowStatus]      TINYINT          DEFAULT ((1)) NOT NULL,
    [CreatedBy]      INT              DEFAULT (1),
    [ModifiedBy]     INT              DEFAULT (1),
    [CreatedDate]    DATETIMEOFFSET   DEFAULT (GETUTCDATE()) NOT NULL,
    [ModifiedDate]   DATETIMEOFFSET   DEFAULT (GETUTCDATE()) NOT NULL,
    [RowGuid]        UNIQUEIDENTIFIER NOT NULL,
    [Username]       VARCHAR (64)     NOT NULL,
    [Password]       VARCHAR (255)    NOT NULL,
    [Id]             VARCHAR (255)    NOT NULL
  );

  -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadWebUser ( UserId, [RowGuid], RowStatus, Username, Password, Id )
  VALUES 
  ( 1, '119FD967-4F22-4832-B962-1187209EF83D', @activeWebUser,  'DefaultDataEntryUser', 'a1ff00b2166ed7be276909548c65de443e76569504913fb57c15ce45eb2d0241', '29T^suhcnu*^CqwFcp$tb' ),
  ( 2, '8A508284-B642-4F90-27CC-39C87DC6B5A2', @activeWebUser,  'UnknownUser',          'a1ff00b2166ed7be276909548c65de443e76569504913fb57c15ce45eb2d0241', '29T^suhcnu*^CqwFcp$tb' ),
  ( 3, 'B93DAD1D-D570-34CE-1C26-39C87DEB93BF', @activeWebUser,  'SystemScript',         'a1ff00b2166ed7be276909548c65de443e76569504913fb57c15ce45eb2d0241', '29T^suhcnu*^CqwFcp$tb' ),
  ( 4, '791CFBC9-6A68-4C47-5EC5-39C863473A32', @activeWebUser,  'SystemTrigger',        'a1ff00b2166ed7be276909548c65de443e76569504913fb57c15ce45eb2d0241', '29T^suhcnu*^CqwFcp$tb' ),
  ( 5, 'E29F90B4-5459-F1AB-69CE-39C87DEC44F3', @activeWebUser,  'AspDotNet',            'ad13024f3a478c09bf995e7d81438a99c765c4dd3885c0ba76d35e89378c08d3', '29T^suhcnu*^CqwFcp$tb' ),
  ( 6, '2AEA39BF-6C73-A14A-7E98-39C87DEC96D5', @activeWebUser,  'ColdFusion',           'a1ff00b2166ed7be276909548c65de443e76569504913fb57c15ce45eb2d0241', '29T^suhcnu*^CqwFcp$tb' ),
  ( 7, '2AEA39BF-6C73-A14A-7E98-39C87DEC96D5', @activeWebUser,  'PowerShell',           'a1ff00b2166ed7be276909548c65de443e76569504913fb57c15ce45eb2d0241', '29T^suhcnu*^CqwFcp$tb' ),
  ( 8, 'EC93AE5A-BBDC-B8CF-4225-39C87DECBC17', @activeWebUser,  'AutomationTest',       'a1ff00b2166ed7be276909548c65de443e76569504913fb57c15ce45eb2d0241', '29T^suhcnu*^CqwFcp$tb' )
  ;


  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsWebUserUsers INT;
  SELECT @TotalDataLoadRecordsWebUserUsers = COUNT(1) FROM @DataLoadWebUser;

  -- We need a loop counter var
  DECLARE @CtrWebUserUsers INT;
  SET @CtrWebUserUsers = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrWebUserUsers < = @TotalDataLoadRecordsWebUserUsers )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    webuser.UserLogin WITH (nolock)
        WHERE   UserLogin.UserId = ( SELECT DataLoad.UserId 
                                     FROM @DataLoadWebUser AS DataLoad
                                     WHERE RowCounter = @CtrWebUserUsers )
      ) 
      BEGIN

        INSERT INTO [webuser].[UserLogin] 
        ( 
          [UserId], 
          [RowStatus], 
          [CreatedBy], 
          [ModifiedBy], 
          [CreatedDate], 
          [ModifiedDate],
          [RowGuid], 
          [Username], 
          [Password], 
          [Id]
        )

        OUTPUT 
          inserted.UserId, 
          inserted.RowStatus, 
          inserted.CreatedBy, 
          inserted.ModifiedBy, 
          inserted.CreatedDate, 
          inserted.ModifiedDate, 
          inserted.RowGuid, 
          inserted.Username, 
          inserted.Password, 
          inserted.Id
        INTO 
          @DataLoadWebUserOutput
         
        SELECT
          DataLoad.UserId,
          @activeWebUser,
          @CreatedByWebUser,
          @CreatedByWebUser,
          GETUTCDATE(),
          GETUTCDATE(),
          DataLoad.RowGuid,
          DataLoad.Username,
          DataLoad.Password,
          DataLoad.Id
        FROM
          @DataLoadWebUser AS DataLoad
        WHERE
          RowCounter = @CtrWebUserUsers   

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadWebUserOutput ( UserId, RowStatus, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, RowGuid, Username, Password, Id )
        SELECT
          UserLogin.UserId,
          @RecordExistsWebUser,
          UserLogin.CreatedBy,
          UserLogin.ModifiedBy,
          UserLogin.CreatedDate,
          UserLogin.CreatedDate,
          UserLogin.RowGuid,
          UserLogin.Username,
          UserLogin.Password,
          UserLogin.Id
        FROM    
          webuser.UserLogin AS UserLogin WITH (nolock)
          
          INNER JOIN @DataLoadWebUser AS DataLoad
          ON UserLogin.UserId = DataLoad.UserId

        WHERE   
          UserLogin.UserId = ( SELECT DataLoad.UserId 
                                     FROM @DataLoadWebUser AS DataLoad
                                     WHERE RowCounter = @CtrWebUserUsers )
         
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrWebUserUsers = @CtrWebUserUsers + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadWebUserOutput


