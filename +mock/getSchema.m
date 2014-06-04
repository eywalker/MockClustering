function obj = getSchema
    persistent schemaObject
    if isempty(schemaObject)
        acq.getSchema();
        schemaObject = dj.Schema(dj.conn, 'mock', 'edgarSandbox');
    end
    obj = schemaObject;
end