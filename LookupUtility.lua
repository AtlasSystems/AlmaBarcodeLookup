LookupUtility = {};

-- Load the .Net types that we will be using.
local types = {};
types["log4net.LogManager"] = luanet.import_type("log4net.LogManager");
local log = types["log4net.LogManager"].GetLogger(rootLogger .. ".LookupUtility");

local function GetValueDestination(fieldMapping, requestType)
  local valueDestination = "";
  -- If the fieldMapping.ImportField is a string, it is a direct mapping from response to data field
  if(type(fieldMapping.ImportField) == "string") then
    valueDestination = Utility.StringSplit(".", fieldMapping.ImportField);
  else
      -- If it is not a string, it is a specific request type or an invalid fieldMapping
      if requestType == "Loan" then
        log:Debug("requestType is Loan");
        valueDestination = Utility.StringSplit(".", fieldMapping.ImportField.RequestType.Loan);
      elseif requestType == "Article" then
        log:Debug("requestType is Article");
        valueDestination = Utility.StringSplit(".", fieldMapping.ImportField.RequestType.Article);
      else
         log:Warn("Invalid request type");
      end
  end
  return valueDestination;
end

-- Exports
LookupUtility.GetValueDestination = GetValueDestination;