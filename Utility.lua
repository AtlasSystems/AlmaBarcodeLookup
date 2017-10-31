local UtilityInternal = {};
UtilityInternal.DebugLogging = false;

Utility = UtilityInternal;

luanet.load_assembly("System");

local types = {};
types["System.Type"] = luanet.import_type("System.Type");
types["System.Action"] = luanet.import_type("System.Action");

local function Log(input, debugOnly)
  debugOnly = debugOnly or false;

  if ((not debugOnly) or (debugOnly and UtilityInternal.DebugLogging)) then
    local t = type(input);

    if (t == "string" or t == "number") then
      LogDebug(input);
    elseif (t == "table") then
      LogTable(input);
    elseif (t == "nil") then
      LogDebug("(nil)");
    elseif (t == "boolean") then
      if (input == true) then
        LogDebug("True");
      else
        LogDebug("False");
      end
    elseif (t == "function") then
      local success, result = pcall(input);

      if (success) then
        Log(result, debugOnly);
      end
    elseif (t == "userdata") then
      if (IsType(input, "System.Exception")) then
        LogException(input);
      else
        pcall(function()
        LogDebug(input:ToString());
        end);
      end
    end
  end
end

local function Trim(s)
  local n = s:find"%S"
  return n and s:match(".*%S", n) or ""
end

local function IsType(o, t, checkFullName)
  if ((o and type(o) == "userdata") and (t and type(t) == "string")) then
    local comparisonType = types["System.Type"].GetType(t);
    if (comparisonType) then
      -- The comparison type was successfully loaded so we can do a check
      -- that the object can be assigned to the comparison type.
      return comparisonType:IsAssignableFrom(o:GetType()), true;
    else
      -- The comparison type was could not be loaded so we can only check
      -- based on the names of the types.
      if(checkFullName) then
        return (o:GetType().FullName == t), false;
      else
        return (o:GetType().Name == t), false;
      end
    end
  end

  return false, false;
end

local function LogIndented(entry, depth)
  depth = (depth or 0);
  LogDebug(string.rep("> ", depth) .. entry);
end

local function LogTable(input, depth)
  assert(type(input) == "table", "LogTable expects a LUA table");

  depth = (depth or 0);

  for key, value in pairs(input) do
    if (value and type(value) == "table") then
      LogIndented("Key: " .. key, depth);
      LogTable(value, depth + 1);
    else
      local success, result = pcall(string.format, "%s", (value or "(nil)"));

      if (success) then
        LogIndented("Key: " .. key .. " = " .. (value or "(nil)"), depth);
      else
        LogIndented("Key: " .. key .. " = (?)", depth);
      end
    end
  end

  for index, value in ipairs(input) do
    if (value and type(value) == "table") then
      LogIndented("Index: " .. index, depth);
      LogTable(value, depth + 1);
    else
      LogIndented("Index: " .. index .. " = " .. (value or "(nil)"), depth);
    end
  end
end

function LogException(exception, depth)
  depth = (depth or 0);

  if (exception) then
    LogIndented(exception.Message, depth);
    LogException(exception.InnerException, depth + 1);
  end
end



function URLDecode(s)
  s = string.gsub(s, "+", " ");
  s = string.gsub(s, "%%(%x%x)", function(h)
  return string.char(tonumber(h, 16));
  end);

  s = string.gsub(s, "\r\n", "\n");

  return s;
end

function StringSplit(delimiter, text)
  if delimiter == nil then
    delimiter = "%s"
  end
  local t={};
  local i=1;
  for str in string.gmatch(text, "([^"..delimiter.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

local function URLEncode(s)
  if (s) then
    s = string.gsub(s, "\n", "\r\n")
    s = string.gsub(s, "([^%w %-%_%.%~])",
    function (c)
      return string.format("%%%02X", string.byte(c))
      end);
      s = string.gsub(s, " ", "+")
    end
    return s
  end

  local function CreateQueryString(t)

    local query = nil;

    if (t and type(t) == "table") then
      for k, v in pairs(t) do
        if (v) then
          local success, value = pcall(URLEncode, v);
          if (success) then
            query = string.format("%s%s=%s", ((query and (query .. "&")) or ""), k, value);
          end
        end
      end
    end

    return query;
  end

  local function GetNodeCount(xmlElement, xPath, namespaceManager)
    if (xmlElement == nil or xPath == nil) then
      Log("Invalid Element/Path to retrieve value", true);
      return nil;
    end

    Log("GetNodeCount Path: ".. xPath, true);

    local datafieldNode = nil;

    if (namespaceManager ~= nil) then
      datafieldNode = xmlElement:SelectNodes(xPath, namespaceManager);
    else
      datafieldNode = xmlElement:SelectNodes(xPath);
    end

    return datafieldNode.Count;
  end

  local function GetChildValue(xmlElement, xPath, namespaceManager)
    Log("[Utility.GetChildValue] "..xPath);
    if (xmlElement == nil or xPath == nil) then
      Log("Invalid Element/Path to retrieve value.");
      return nil;
    end

    local datafieldNode = nil;

    if (namespaceManager ~= nil) then
      datafieldNode = xmlElement:SelectNodes(xPath, namespaceManager);
    else
      datafieldNode = xmlElement:SelectNodes(xPath);
    end

    Log("Found "..datafieldNode.Count.." node elements matching "..xPath);
    local fieldValue = "";
    for d = 0, (datafieldNode.Count - 1) do
      Log("datafieldnode value is: " .. datafieldNode:Item(d).InnerText, true);
      fieldValue = fieldValue .. " " .. datafieldNode:Item(d).InnerText;
    end

    fieldValue = Trim(fieldValue);
    Log("GetChildValue Result: " .. fieldValue, true);

    return fieldValue;
  end

  UtilityInternal.Trim = Trim;
  UtilityInternal.IsType = IsType;
  UtilityInternal.Log = Log;
  UtilityInternal.URLDecode = URLDecode;
  UtilityInternal.URLEncode = URLEncode;
  UtilityInternal.StringSplit = StringSplit;
  UtilityInternal.CreateQueryString = CreateQueryString;
  UtilityInternal.GetXmlChildValue = GetChildValue;
  UtilityInternal.GetXmlNodeCount = GetNodeCount;
  UtilityInternal.RemoveTrailingSpecialCharacters = RemoveTrailingSpecialCharacters;
