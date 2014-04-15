classdef vsiData
    properties
        path
        containingDirName
        containingDirPath
        filetype
        name
        date
        bytes
        isdir
        datenum
        dataPath
    end

    methods
        function obj = vsiData(file, containingDirPath, dataDumpPath)
            % Add dir() created fields to the obj
            fileFields = fieldnames(file);
            for i = 1:length(fileFields)
                setfield(obj, fileFields{i}, getfield(file, fileFields{i}));
            end

            % Get path and filetype
            obj.path = fullfile(containingDirPath, file.name);
            [obj.containingDirPath, ~, obj.filetype] = fileparts(obj.path);
            [~, obj.containingDirName] = fileparts(obj.containingDirPath);

            % Ensure dump path
            obj.ensureDumpPath(dataDumpPath)
        end

        function ensureDumpPath(self, dumpPath)
            % check for the corresponding directory
            if ~exist(dumpPath, 'dir')
                mkdir(dumpPath)
            end
            % store path name
            self.dataPath = dumpPath;
        end
    end
end

