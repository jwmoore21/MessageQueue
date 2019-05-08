PRINT 'Running 000_MasterLists.Status.data.sql';

SET NOCOUNT ON;

BEGIN TRY

  -- Our script user id = -1
  DECLARE @CreatedByStatus INT;
  SET @CreatedByStatus = -1;

  -- activeStatus Row Status
  DECLARE @activeStatus INT;
  SET @activeStatus = 8;

  -- If the record is found, indicate as a status 250 in our output
  DECLARE @RecordExistsStatus INT;
  SET @RecordExistsStatus = 250;

  -- Create a table to hold the data we are going to load. All columns except the hashbytes column should be included
  DECLARE @DataLoadStatus AS TABLE
  (
    [RowCounter]        [INT]     NOT NULL IDENTITY(1,1),
    [RowStatus]         [tinyint] NOT NULL,
    [bSystemOnly]       [bit] NOT NULL,
    [StatusName]        [varchar](24) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [StatusDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
  );

  -- Create a table to hold out output
  DECLARE @DataLoadStatusOutput AS TABLE
  (
    [RowStatus]         [tinyint] NOT NULL,
    [bSystemOnly]       [bit] NOT NULL,
    [StatusName]        [varchar](24) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [StatusDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [RowGuid]           [uniqueidentifier] NOT NULL
  );

  -- We need a loop counter var
  DECLARE @CtrStatus INT;
  SET @CtrStatus = 0;

  -- Bulk load the data we wish to try and insert to our data loader table
  INSERT INTO @DataLoadStatus ( [RowStatus],[bSystemOnly],[StatusName],[StatusDescription] )
  VALUES 
( 0,0,'Inactive','Records that are hidden from view, but still usable in the application.' ),
( 1,0,'Active','Records that are active in the application.' ),
( 2,0,'Deleted','Records that are deleted in the application.' ),
( 3,0,'Pending','Records that are pending in the application.' ),
( 4,0,'Recovered','Records that are recovered in the application.' ),
( 5,0,'Archived','Records that are archived in the application.' ),
( 6,0,'New','Records that are new in the application.' ),
( 7,1,'Locked','Records that are active and locked in the application.' ),
( 8,1,'System','Records that are active that are system records and can not be edited by the users in the application.' ),
( 9,1,'System - Preferred','Records that are active that are system records, and labled as the preferred record to use as indicated by the user.' ),
( 10,1,'System - Hidden','Records that are active, that are system records, and are hidden from the users view.' ),
( 11,1,'System - Restricted','Records that are active, that are system records, and restricted from being used elsewhere in the application.' ),
( 66,1,'Data Error','Records attempting to be bulk loaded but encountered a SQL error. Most likely a missing or invalid foreign key value.' ),
( 166,1,'Failed Check Contraint','Records attempting to be loaded that failed to pass a column check contraint.' ),
( 231,1,'System - QA - Active','QA Test data only!' ),
( 232,1,'System - QA - Inactive','QA Test data only!' ),
( 240,1,'System - Inserted Test','Test data only!' ),
( 245,1,'System - Updated Test','Test data only!' ),
( 250,1,'System - Record Exists','Used when bulk loading data in to the database as a status to indicate that the record attempting to be loaded, already exists.' )
;

  -- We need a var to hold the total number of records we are going to try and dataload
  DECLARE @TotalDataLoadRecordsStatus INT;
  SELECT @TotalDataLoadRecordsStatus = COUNT(1) FROM @DataLoadStatus;

  -- We need to reset our loop counter var
  SET @CtrStatus = 1;

  -- Loop over each record, attempt to load it. If the record exists, status it with the Found status
  WHILE ( @CtrStatus < = @TotalDataLoadRecordsStatus )
  BEGIN

      IF NOT EXISTS 
      ( 
        SELECT  1
        FROM    [masterLists].[Status] AS [Status] WITH (nolock)
        WHERE   [Status].[RowStatus] = ( SELECT DataLoad.[RowStatus]
                                           FROM @DataLoadStatus AS DataLoad
                                           WHERE RowCounter = @CtrStatus )
      ) 
      BEGIN

        INSERT INTO [MasterLists].[Status] ( [RowStatus],[bSystemOnly],[StatusName],[StatusDescription],[RowGuid] )
        OUTPUT inserted.[RowStatus], inserted.[bSystemOnly], inserted.[StatusName], inserted.[StatusDescription], inserted.[RowGuid]  INTO @DataLoadStatusOutput
        SELECT
          DataLoad.[RowStatus],
          DataLoad.[bSystemOnly],
          DataLoad.StatusName,
          DataLoad.StatusDescription,
          NEWID()
          
        FROM
          @DataLoadStatus AS DataLoad
        WHERE
          RowCounter = @CtrStatus

      END

      ELSE
      BEGIN
      
        -- The record exists, just add it to our output statused appropriately
        INSERT INTO @DataLoadStatusOutput ( [RowStatus],[bSystemOnly],[StatusName],[StatusDescription],[RowGuid] )
        SELECT
          [Status].[RowStatus],
          [Status].bSystemOnly,
          [Status].StatusName,
          [Status].StatusDescription,
          [Status].RowGuid
          
        FROM    
          MasterLists.[Status] AS [Status] WITH (nolock)
          
          INNER JOIN @DataLoadStatus AS DataLoad
          ON [Status].[RowStatus] = DataLoad.[RowStatus]

        WHERE   
          [Status].[RowStatus] = ( SELECT DataLoad.[RowStatus] 
                                   FROM @DataLoadStatus AS DataLoad
                                   WHERE RowCounter = @CtrStatus )
       
         
      END -- end if exists

      -- Increase our counter by 1
      SET @CtrStatus = @CtrStatus + 1;

  END -- end while

  -- Show the results
  SELECT * FROM @DataLoadStatusOutput


END TRY
BEGIN CATCH

    -- Error trapping vars
  IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      

    DECLARE @ErrorMessageStatus       nvarchar(2048),
        @ErrorSeverityStatus      tinyint,
        @ErrorStateStatus         tinyint,
        @ErrorNumberStatus        int,
        @ErrorProcedureStatus     sysname,
        @ErrorLineStatus          int
              
  SELECT @ErrorNumberStatus    = ERROR_NUMBER(),
       @ErrorSeverityStatus  = ERROR_SEVERITY(),
           @ErrorStateStatus     = ERROR_STATE(),
           @ErrorProcedureStatus = ERROR_PROCEDURE(),
           @ErrorLineStatus      = ERROR_LINE(),
           @ErrorMessageStatus   = ERROR_MESSAGE();
           /*
  EXECUTE [eventLogs].[DatabaseErrorHandler]
    @ErrorNumber    = @ErrorNumberStatus,
    @ErrorSeverity  = @ErrorSeverityStatus,
    @ErrorState     = @ErrorStateStatus,
    @ErrorProcedure = @ErrorProcedureStatus,
    @ErrorLine      = @ErrorLineStatus,
    @ErrorMessage   = @ErrorMessageStatus
    */
  --re-raise the error
    RAISERROR ( @ErrorMessageStatus, @ErrorSeverityStatus, @ErrorStateStatus )

END CATCH
