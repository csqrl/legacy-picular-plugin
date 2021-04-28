return function(callback, ...)
    local initArgs = {...}

    return function(...)
        local newArgs = {...}

        for index, arg in ipairs(initArgs) do
            table.insert(newArgs, index, arg)
        end

        return callback(table.unpack(newArgs))
    end
end
