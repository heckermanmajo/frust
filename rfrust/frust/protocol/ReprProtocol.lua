

ReprProtocol = {}

function ReprProtocol.repr(instance, _visited_instances)
    -- todo: check and init
    return instance:__repr__()
end

function ReprProtocol.from_repr(string, class)
    -- todo: check and init
    return class.__from_repr__(string)
end

-- repr of std types and tables with only std types

function ReprProtocol.repr_table(table, visited_instances)

end