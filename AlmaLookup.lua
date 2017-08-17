AlmaLookup = {};

-- Load the .Net types that we will be using.
local types = {};
types["log4net.LogManager"] = luanet.import_type("log4net.LogManager");
types["System.Xml.XmlDocument"] = luanet.import_type("System.Xml.XmlDocument");

local log = types["log4net.LogManager"].GetLogger(rootLogger .. ".AlmaLookup");
local allowOverwriteWithBlankValue = nil;
local fieldsToImport = nil;
local requestType = nil;

local function InitializeVariables(almaApiUrl, almaApiKey, overwriteWithBlankValue, toImport)
    AlmaApi.ApiUrl = almaApiUrl;
    AlmaApi.ApiKey = almaApiKey;
    allowOverwriteWithBlankValue = overwriteWithBlankValue;
    fieldsToImport = toImport;

    if(product == "ILLiad") then
        requestType = GetFieldValue("Transaction","RequestType");
    end
end

local function DoLookup( itemBarcode )
    local succeeded, response = pcall(AlmaApi.RetrieveItemByBarcode, itemBarcode);

    if not succeeded then
        log:Error("Error performing lookup");
        return nil;
    end

    return PrepareLookupResults(response);
end

function PrepareLookupResults(response)
    local lookupResults = {};

    for _, fieldMapping in ipairs(DataMapping.FieldMapping[product]) do
        for _, fieldToImport in ipairs(fieldsToImport) do
            if(string.lower(Utility.Trim(fieldToImport)) == string.lower(fieldMapping.MappingName)) then
                local destination = LookupUtility.GetValueDestination(fieldMapping, requestType);
                log:DebugFormat("Destination = {0}.{1}", destination[1], destination[2]);
                local importItem = response:GetElementsByTagName(fieldMapping.ObjectMapping):Item(0);
                local toImport = "";

                -- If we selected a tag, take its InnerText
                if(importItem ~= nil) then
                    toImport = importItem.InnerText;
                end

                log:DebugFormat("To Import = {0}", toImport);
                -- If overwrite with blank value is false and the value to import is nil or empty, break
                if(not allowOverwriteWithBlankValue and (toImport == nil or toImport == "") ) then
                    break;
                end

                table.insert( lookupResults,{
                  valueDestination = destination;
                  valueToImport = toImport;
                });
            end
        end
    end

    return lookupResults;
end

-- Exports
AlmaLookup.DoLookup = DoLookup;
AlmaLookup.InitializeVariables = InitializeVariables;