% ==============================================================================
% TEN FILE: exportResults.m
% CHUC NANG: Xuat ket qua ra nhieu dinh dang khac nhau
% MODULE: exporter
% ==============================================================================
%
% Mo ta: Xuat ket qua mo phong ra nhieu dinh dang: MAT, CSV, JSON, Excel
%        Ho tro xuat chi tiet hoac tom tat ket qua
%
function exportResults(results, delays, cfg, output_dir, formats)

% Mac dinh xuat ra MAT va CSV
if nargin < 5
    formats = {'mat', 'csv'};
end

if nargin < 4
    output_dir = cfg.results_dir;
end

% Tao thu muc neu chua ton tai
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Xuat ra MAT (mac dinh)
if ismember('mat', formats)
    mat_file = fullfile(output_dir, 'gcc_simulation_results.mat');
    save(mat_file, 'results', 'delays', 'cfg');
    fprintf('Ket qua da luu vao: %s\n', mat_file);
end

% Xuat ra CSV
if ismember('csv', formats)
    csv_file = fullfile(output_dir, 'gcc_results_summary.csv');
    exportToCSV(results, cfg, csv_file);
    fprintf('Ket qua da luu vao: %s\n', csv_file);
end

% Xuat ra JSON
if ismember('json', formats)
    json_file = fullfile(output_dir, 'gcc_results.json');
    exportToJSON(results, cfg, json_file);
    fprintf('Ket qua da luu vao: %s\n', json_file);
end

% Xuat ra Excel
if ismember('xlsx', formats)
    excel_file = fullfile(output_dir, 'gcc_results.xlsx');
    exportToExcel(results, cfg, excel_file);
    fprintf('Ket qua da luu vao: %s\n', excel_file);
end

end

function exportToCSV(results, cfg, filename)
% Xuat ket qua ra CSV
fid = fopen(filename, 'w');
if fid == -1
    warning('exporter:exportToCSV:CannotOpenFile', ...
            'Khong the mo file CSV de ghi');
    return;
end

% Ghi tieu de
fprintf(fid, 'Method,SNR_dB,Mean,Bias,Std,RMSE,MSE\n');

% Ghi du lieu
n_methods = length(cfg.methods);
n_SNR = length(cfg.SNR);

for iSNR = 1:n_SNR
    for iMethod = 1:n_methods
        stats = results{iMethod, iSNR};
        fprintf(fid, '%s,%d,%.6f,%.6f,%.6f,%.6f,%.6f\n', ...
                cfg.methods{iMethod}, ...
                cfg.SNR(iSNR), ...
                stats.mean, ...
                stats.bias, ...
                stats.std, ...
                stats.rmse, ...
                stats.mse);
    end
end

fclose(fid);
end

function exportToJSON(results, cfg, filename)
% Xuat ket qua ra JSON (don gian)
fid = fopen(filename, 'w');
if fid == -1
    warning('exporter:exportToJSON:CannotOpenFile', ...
            'Khong the mo file JSON de ghi');
    return;
end

fprintf(fid, '{\n');
fprintf(fid, '  "simulation_config": {\n');
fprintf(fid, '    "Nm": %d,\n', cfg.Nm);
fprintf(fid, '    "SNR": [%s],\n', num2str(cfg.SNR));
fprintf(fid, '    "methods": [%s]\n', strjoin(cellfun(@(x) sprintf('"%s"', x), cfg.methods, 'UniformOutput', false), ', '));
fprintf(fid, '  },\n');
fprintf(fid, '  "results": [\n');

n_methods = length(cfg.methods);
n_SNR = length(cfg.SNR);
first = true;

for iSNR = 1:n_SNR
    for iMethod = 1:n_methods
        if ~first
            fprintf(fid, ',\n');
        end
        first = false;
        stats = results{iMethod, iSNR};
        fprintf(fid, '    {\n');
        fprintf(fid, '      "method": "%s",\n', cfg.methods{iMethod});
        fprintf(fid, '      "SNR_dB": %d,\n', cfg.SNR(iSNR));
        fprintf(fid, '      "mean": %.6f,\n', stats.mean);
        fprintf(fid, '      "bias": %.6f,\n', stats.bias);
        fprintf(fid, '      "std": %.6f,\n', stats.std);
        fprintf(fid, '      "rmse": %.6f,\n', stats.rmse);
        fprintf(fid, '      "mse": %.6f\n', stats.mse);
        fprintf(fid, '    }');
    end
end

fprintf(fid, '\n  ]\n');
fprintf(fid, '}\n');
fclose(fid);
end

function exportToExcel(results, cfg, filename)
% Xuat ket qua ra Excel (su dung writetable neu co)
try
    % Tao bang du lieu
    data = [];
    n_methods = length(cfg.methods);
    n_SNR = length(cfg.SNR);
    
    for iSNR = 1:n_SNR
        for iMethod = 1:n_methods
            stats = results{iMethod, iSNR};
            data = [data; {cfg.methods{iMethod}, cfg.SNR(iSNR), ...
                    stats.mean, stats.bias, stats.std, stats.rmse, stats.mse}];
        end
    end
    
    % Ghi ra CSV neu khong co writetable (fallback)
    [~, ~, ext] = fileparts(filename);
    if strcmp(ext, '.xlsx')
        csv_file = strrep(filename, '.xlsx', '.csv');
        exportToCSV(results, cfg, csv_file);
        warning('exporter:exportToExcel:UsingCSV', ...
                'Khong ho tro Excel, da xuat ra CSV thay the: %s', csv_file);
    end
catch ME
    warning('exporter:exportToExcel:Error', ...
            'Loi khi xuat Excel: %s', ME.message);
end
end

