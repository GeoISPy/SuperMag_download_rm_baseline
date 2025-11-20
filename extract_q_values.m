function extracted_data = extract_q_values(file_path)
%EXTRACT_Q_VALUES 从文本文件的每一行提取YYYY, MM和q1到q5的值
%   输入:
%       file_path: 文本文件的路径。
%
%   输出:
%       extracted_data: 一个单元格数组，每一行对应文件中的一行数据，
%                      包含该行提取的YYYY, MM, q1, q2, q3, q4, q5的值。
    fid = fopen(file_path, 'r');
    file_content = fread(fid, '*char')';
    fclose(fid);
    lines = splitlines(file_content);
    header_line = '';
    for i = 1:length(lines)
        if contains(lines{i}, 'YYYY MM') % 修改了标题行查找条件
            header_line = lines{i};
            break;
        end
    end
    if isempty(header_line)
        extracted_data = {};
        warning('未找到包含 "YYYY MM" 的标题行。');
        return;
    end
    % q_indices =;
    start_index = strfind(header_line, 'q1');
    if ~isempty(start_index)
        q_indices = [start_index];
        for i = 2:5
            q_str = sprintf('q%d', i);
            start_index = strfind(header_line, q_str);
            if ~isempty(start_index)
                q_indices = [q_indices, start_index];
            else
                warning(['未找到 "', q_str, '" 在标题行中。']);
                extracted_data = {};
                return;
            end
        end
    else
        warning('未找到 "q1" 在标题行中。');
        extracted_data = {};
        return;
    end
    num_q = length(q_indices);
    extracted_data = cell(0, num_q + 2); % 修改了输出单元格数组的列数
    data_start_index = find(strcmp(lines, header_line)) + 1;
    for i = data_start_index:length(lines)
        line = lines{i};
        if length(line) < 7 % 确保行长度足够提取 YYYY 和 MM
            continue;
        end
        YYYY = line(1:4);
        MM = line(6:7);
        q_values_row = cell(1, num_q + 2); % 创建包含 YYYY, MM 和 q 值的行
        q_values_row{1} = YYYY;
        q_values_row{2} = MM;
        for j = 1:num_q
            start_idx = q_indices(j);
            end_idx = min(start_idx + 1, length(line));
            if start_idx <= length(line) - 1
                q_values_row{j + 2} = line(start_idx:end_idx); % q 值从第三列开始
            else
                q_values_row{j + 2} = ''; % 如果该行长度不够，则为空
            end
        end
        extracted_data = [extracted_data; q_values_row];
    end
    extracted_data = str2double(extracted_data);
end