% ==============================================================================
% TEN FILE: Logger.m
% CHUC NANG: Ghi log va thong bao tien trinh mo phong
% MODULE: logger
% ==============================================================================
%
% Mo ta: Quan ly viec ghi log va hien thi thong bao trong qua trinh mo phong
%        Ho tro nhieu muc do log (INFO, WARNING, ERROR)
%        Co the ghi log ra file hoac chi hien thi ra man hinh
%
classdef Logger < handle
    
    properties
        verbose logical = true
        log_file char = ''
        log_level char = 'INFO'
    end
    
    methods
        function obj = Logger(verbose, log_file)
            % Constructor
            if nargin >= 1
                obj.verbose = verbose;
            end
            if nargin >= 2 && ~isempty(log_file)
                obj.log_file = log_file;
                % Mo file de ghi log
                fid = fopen(log_file, 'w');
                if fid ~= -1
                    fclose(fid);
                end
            end
        end
        
        function info(obj, message, varargin)
            % Ghi thong tin
            obj.log('INFO', message, varargin{:});
        end
        
        function warning(obj, message, varargin)
            % Ghi canh bao
            obj.log('WARNING', message, varargin{:});
        end
        
        function error(obj, message, varargin)
            % Ghi loi
            obj.log('ERROR', message, varargin{:});
        end
        
        function log(obj, level, message, varargin)
            % Ghi log voi muc do cu the
            timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
            formatted_msg = sprintf(message, varargin{:});
            log_line = sprintf('[%s] [%s] %s\n', timestamp, level, formatted_msg);
            
            % Hien thi ra man hinh neu verbose
            if obj.verbose
                fprintf('%s', log_line);
            end
            
            % Ghi vao file neu co
            if ~isempty(obj.log_file)
                fid = fopen(obj.log_file, 'a');
                if fid ~= -1
                    fprintf(fid, '%s', log_line);
                    fclose(fid);
                end
            end
        end
        
        function progress(obj, current, total, prefix)
            % Hien thi tien trinh
            if nargin < 4
                prefix = 'Progress';
            end
            percentage = round(100 * current / total);
            if obj.verbose
                fprintf('\r%s: %d/%d (%d%%)', prefix, current, total, percentage);
                if current == total
                    fprintf('\n');
                end
            end
        end
    end
end

