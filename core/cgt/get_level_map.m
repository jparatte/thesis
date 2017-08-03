function [ level_features, level_idx ] = get_level_map(tree, features, encoding, level )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    target_depth = tree.depth - level;
    
    if (target_depth == -1)
       fprintf('Max depth queried, returning the full set of features\n');
       level_features = features;
       level_idx = 1:tree.size;
       return
    end
    
    if (target_depth < -1)
        error('Level bigger than max depth');
    end

    map = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    map = get_level_map_rec(map, tree, features, encoding, target_depth);
    
    
    %mapkeys = cell2mat(map.keys);
    level_features = cell2mat(map.values);

    %ind2level = encoding(:,tree.depth-level+2);
    %level2kind = [keys; 1:length(keys)]';
    kmap = containers.Map(map.keys, 1:length(map.keys));
    level_idx = cell2mat(values(kmap, num2cell(encoding(:,target_depth+2))));
end

function [map] = get_level_map_rec(map, node, features, encoding, target_depth)
    if node.depth == target_depth
        map(node.lidx) = node.center;
    else
       if isstruct(node.childs)
          for ii = 1:length(node.childs)
             map = get_level_map_rec(map, node.childs(ii), features, encoding, target_depth);
          end
       else
          for ii = 1:length(node.childs)
              map(encoding(node.childs(ii),target_depth+2)) = features(:, node.childs(ii));
          end
       end
    end
end