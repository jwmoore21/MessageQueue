
BEGIN TRANSACTION

  DECLARE @CreatedBy INT = 1;
  DECLARE @JsonSchemaName VARCHAR(64) = 'AddressType';

  IF NOT EXISTS
  (
    SELECT
      [JsonSchemaName]
    FROM
      [msgQueue].[JsonSchema]
    WHERE
      [JsonSchemaName] = @JsonSchemaName
  )
  BEGIN

    INSERT INTO [msgQueue].[JsonSchema]
    (
        [RowStatus]
      , [CreatedBy]
      , [ModifiedBy]
      , [JsonSchemaName]
      , [SchemaDescription]
      , [JsonSchema]
    )
    VALUES
    (
      1
      , @CreatedBy
      , @CreatedBy
      , @JsonSchemaName
      , 'Sample Address Type Json Schema'
      , '[{
  "type" : "object",
  "properties" :
  {
    "AddressType" :
    {
      "type" : "array",
      "items" :
      {
        "type" : "object",
        "properties" :
        {
          "AddressType"      : { "type" : "string" },
          "RowStatus"        : { "type" : "number", "optional" : true, "default" : "1" },
          "ModifiedBy"       : { "type" : "string", "optional" : true },
          "RowGuid"             : { "type" : "string", "optional" : true },
          "CustomOrder"      : { "type" : "number", "optional" : true, "default" : "1" },
          "AddressTypeGroup" : { "type" : "string", "optional" : true }
        }
      }
    }
  }
}]'
    );

  END


  SET @JsonSchemaName = 'Results Message';

  IF NOT EXISTS
  (
    SELECT
      [JsonSchemaName]
    FROM
      [msgQueue].[JsonSchema]
    WHERE
      [JsonSchemaName] = @JsonSchemaName
  )
  BEGIN

    INSERT INTO [msgQueue].[JsonSchema]
    (
        [RowStatus]
      , [CreatedBy]
      , [ModifiedBy]
      , [JsonSchemaName]
      , [SchemaDescription]
      , [JsonSchema]
    )
    VALUES
    (
      1
      , @CreatedBy
      , @CreatedBy
      , @JsonSchemaName
      , 'Schema used for sending back a result message.'
      , '[{
  "type" : "object",
  "properties" :
  {
    "results" :
    {
      "type" : "array",
      "items" :
      {
        "type" : "object",
        "properties" :
        {
          "message" : { "type" : "string" },
          "details" : { "type" : "string", "optional" : true }
        }
      }
    }
  }
}]'
    );

  END


COMMIT TRANSACTION
