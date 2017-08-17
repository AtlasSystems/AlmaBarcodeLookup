local AlmaApiInternal = {};
AlmaApiInternal.ApiUrl = nil;
AlmaApiInternal.ApiKey = nil;


local types = {};
types["log4net.LogManager"] = luanet.import_type("log4net.LogManager");
types["System.Net.WebClient"] = luanet.import_type("System.Net.WebClient");
types["System.Text.Encoding"] = luanet.import_type("System.Text.Encoding");
types["System.Xml.XmlTextReader"] = luanet.import_type("System.Xml.XmlTextReader");
types["System.Xml.XmlDocument"] = luanet.import_type("System.Xml.XmlDocument");

-- Create a logger
local log = types["log4net.LogManager"].GetLogger(rootLogger .. ".AlmaApi");

AlmaApi = AlmaApiInternal;

local function RetrieveHoldingsList( mmsId )
    local requestUrl = AlmaApiInternal.ApiUrl .."bibs/"..
        Utility.URLEncode(mmsId) .."/holdings?apikey=" .. Utility.URLEncode(AlmaApiInternal.ApiKey);
    local headers = {"Accept: application/xml", "Content-Type: application/xml"};
    log:DebugFormat("Request URL: {0}", requestUrl);
    local response = WebClient.GetRequest(requestUrl, headers);
    log:DebugFormat("response = {0}", response);

    return WebClient.ReadResponse(response);
end

local function RetrieveBibs( mmsId )
    local requestUrl = AlmaApiInternal.ApiUrl .. "bibs?apikey="..
         Utility.URLEncode(AlmaApiInternal.ApiKey) .. "&mms_id=" .. Utility.URLEncode(mmsId);
    local headers = {"Accept: application/xml", "Content-Type: application/xml"};
    log:DebugFormat("Request URL: {0}", requestUrl);

    local response = WebClient.GetRequest(requestUrl, headers);
    log:DebugFormat("response = {0}", response);

    return WebClient.ReadResponse(response);
end

local function RetrieveItemByBarcode( barcode )
    local requestUrl = AlmaApiInternal.ApiUrl .. "items?apikey="..
         Utility.URLEncode(AlmaApiInternal.ApiKey) .. "&item_barcode=" .. Utility.URLEncode(barcode);
    local headers = {"Accept: application/xml", "Content-Type: application/xml"};
    log:DebugFormat("Request URL: {0}", requestUrl);

    local response = WebClient.GetRequest(requestUrl, headers);
    log:DebugFormat("response = {0}", response);

    return WebClient.ReadResponse(response);
end

-- Exports
AlmaApi.RetrieveHoldingsList = RetrieveHoldingsList;
AlmaApi.RetrieveBibs = RetrieveBibs;
AlmaApi.RetrieveItemByBarcode = RetrieveItemByBarcode;