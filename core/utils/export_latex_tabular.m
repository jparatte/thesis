function [ ] = export_latex_tabular( data, col_titles, lines_titles, tab_title, params )
%EXPORT_LATEX_TABULAR Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('params', 'var')
        params = {};
    end
    
    status = 0;
    if isfield(params, 'status_matrix')
       status = 1; 
    end
    
    if isfield(params, 'hl')
        hl = 1;
        hl_type = params.hl; %col, line, all
    else
        hl = 0;
    end

    if isfield(params, 'hl_order') %high (high is best), low (low is best) 
        hl_order = params.hl_order;
    else
       hl_order = 'high'; 
    end
    
    if strcmp(hl_order, 'high')
        high = 1;
    else
        high = 0;
    end
    
    if isfield(params, 'hl_pos') % binary vector of pos [best second_best second_worst worst]
        hl_pos = params.hl_pos;
    else
        if hl
            hl_pos = [1 0 0 0];
        else
            hl_pos = [0 0 0 0];
        end
    end
    
    
    
    if hl
        min_idx = get_indices(data, hl_type, 'min'); 
        smin_idx = get_indices(data, hl_type, 'smin'); 
        smax_idx = get_indices(data, hl_type, 'smax'); 
        max_idx = get_indices(data, hl_type, 'max'); 
        
        if hl_pos(1) && high
            best_idx = max_idx;
        else
            best_idx = min_idx;
        end

        if hl_pos(2) && high
           sbest_idx = smax_idx; 
        else
            sbest_idx = smin_idx;
        end

        if hl_pos(3) && high
           sworst_idx = smin_idx; 
        else
            sworst_idx = smax_idx;
        end

        if hl_pos(4) && high
           worst_idx = min_idx; 
        else
            worst_idx = max_idx;
        end
    end
    
    nb_lines = size(data, 1);
    nb_cols = size(data, 2);

    fprintf('\\begin{tabular}{|');
    for ii = 1:nb_cols+1
       fprintf('c|');
    end
    fprintf('}\n');
    fprintf('\\cline{2-%d}\n', nb_cols+1);
    fprintf('\\multicolumn{1}{r|}{%s}',tab_title);
    for ii = 1:nb_cols
       fprintf(' & %s',col_titles{ii});
    end
    fprintf(' \\\\ \\cline{1-%d} \n', nb_cols+1);
    for ii = 1:nb_lines
       fprintf('%s', lines_titles{ii})
       
       for jj = 1:nb_cols
            linidx = sub2ind(size(data), ii, jj);
            
            if isnan(data(ii, jj))
                if status
                    fprintf('& %s ', params.status_matrix{ii,jj});
                else
                    fprintf('& NA ');
                end
                continue;
            end
            
            if hl_pos(1) && any(best_idx == linidx)
                if isinf(data(ii, jj))
                    if status
                        fprintf('& \\bgreen{%s} ', params.status_matrix{ii,jj});
                    else
                        fprintf('& NA ');
                    end
                else
                    fprintf('& \\bgreen{%.2f} ', data(ii, jj));
                end
                continue;
            end

            if hl_pos(2) && any(sbest_idx == linidx)
                if isinf(data(ii, jj))
                    if status
                        fprintf('& \\blgreen{%s} ', params.status_matrix{ii,jj});
                    else
                        fprintf('& NA ');
                    end
                else
                    fprintf('& \\blgreen{%.2f} ', data(ii, jj));
                end
                continue;
            end

            if hl_pos(3) && any(sworst_idx == linidx)
                if isinf(data(ii, jj))
                    if status
                        fprintf('& \\blred{%s} ', params.status_matrix{ii,jj});
                    else
                        fprintf('& NA ');
                    end
                else
                    fprintf('& \\blred{%.2f} ', data(ii, jj));
                end
                continue;
            end

            if hl_pos(4) && any(worst_idx == linidx)
                if isinf(data(ii, jj))
                    if status
                        fprintf('& \\bred{%s} ', params.status_matrix{ii,jj});
                    else
                        fprintf('& NA ');
                    end
                else
                    fprintf('& \\bred{%.2f} ', data(ii, jj));
                end
                continue;
            end
           
            fprintf('& %.2f ', data(ii, jj));
            
       end
       fprintf(' \\\\ \\cline{1-%d} \n', nb_cols+1);
    end
    fprintf('\\end{tabular}\n');

end

function [idx] = get_indices(data, hl, type)
    nl = size(data, 1);
    nc = size(data, 2);
    switch type
        case 'min'
            switch hl
                case 'col'
                    [~, lineidx] = min(data, [], 1);
                    idx = sub2ind(size(data), lineidx, 1:nc);
                case 'line'
                    [~, colidx] = min(data, [], 2);
                    idx = sub2ind(size(data), (1:nl)', colidx(:));
                case 'all'
                    [~, idx] = min(data(:));
            end
        case 'smin'
            min_idx = get_indices(data, hl, 'min');
            data(min_idx) = NaN;
            idx = get_indices(data, hl, 'min');
        case 'max'
            switch hl
                case 'col'
                    [~, lineidx] = max(data, [], 1);
                    idx = sub2ind(size(data), lineidx, 1:nc);
                case 'line'
                    [~, colidx] = max(data, [], 2);
                    idx = sub2ind(size(data), (1:nl)', colidx(:));
                case 'all'
                    [~, idx] = max(data(:));
            end
        case 'smax'
            max_idx = get_indices(data, hl, 'max');
            data(max_idx) = NaN;
            idx = get_indices(data, hl, 'max');
        otherwise
            error('error in get_indices');

    end
end
