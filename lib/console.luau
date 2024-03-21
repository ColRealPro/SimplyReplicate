local console = {}
local IsStudio = game:GetService("RunService"):IsStudio()
local ShowLogs = false -- IsStudio
local TestTable = false

local prefix = "[ReplicatorDebug]"

local function FixTable(tbl, index, indent)
    if IsStudio then return tbl end
    if not index then index = 1 end
    local result = (indent and string.rep("  ", index-1) or "").."{\n"
    local iterated = false
    for k, v in pairs(tbl) do
        iterated = true
        result = result .. string.rep("  ", index)

        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result .."[\""..k.."\"]".." = "
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..FixTable(v, index+1)
        elseif type(v) == "boolean" or type(v) == "number" then
            result = result..tostring(v)
        else
            result = result.."\""..tostring(v).."\""
        end
        result = result..",\n"
    end
    -- Remove leading commas from the result
    if result ~= "" and iterated then
        result = result:sub(1, result:len()-2)
        result = result.."\n"
    end
    return result.. string.rep("  ", index-1) .."}"
end

function console.log(...)
    if not ShowLogs then return end

    local args = {...}
    for i,v in args do
        if typeof(v) == "table" then
            args[i] = FixTable(v)
        end
    end
    
    print(prefix, table.unpack(args))
end

function console.warn(...)
    if not ShowLogs then return end

    local args = {...}
    for i,v in args do
        if typeof(v) == "table" then
            args[i] = FixTable(v)
        end
    end

    warn(prefix, table.unpack(args))
end

-- function console.WriteEnv()
--     local fenv = getfenv(2)
--     fenv.print = console.log
--     fenv.warn = console.warn
-- end

if TestTable then
    IsStudio = false
    console.log("Testing FixTable: ", {
        Hello = "hi",
        Test = true,
        Number = 3,
    
        Table = {
            Hello2 = "goodbye",
            Test2 = false,
            Number2 = 2,
    
            Array = {
                "TestString",
                "TestString2",
                3,
                {
                    End = true
                }
            }
        }
    })
end

return console
