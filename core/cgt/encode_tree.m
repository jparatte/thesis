function [tree, encoding ] = encode_tree( tree )
%ENCODE_NODES Summary of this function goes here
%   Detailed explanation goes here

    encoding = zeros(tree.size, tree.depth+1);
    parent_idx = 0;

    branching = int32(tree.branching);
    [tree, encoding] = encode_node_rec(tree, encoding, parent_idx, branching);

    encoding = int32(encoding);
    for d = 2:tree.depth+1
        encoding(:,d) = idivide(encoding(:,d-1), branching);
    end

end

function [node, encoding] = encode_node_rec(node, encoding, parent_idx, branching)

    base = branching^node.depth;

    if isstruct(node.childs) % If intermediate node
        D = length(node.childs(1).center);
        centers = zeros(branching, D);
        for ii = 1:branching
           centers(ii,:) =  node.childs(ii).center;
        end
        
        W = squareform(pdist(centers));
        order = zeros(branching, 1);
        [~, order(1)] = max(sum(W, 2));
        
        for ii = 1:branching-1
           W(order(ii), order(ii)) = Inf;
           [~ , order(ii+1)] = min(W(:,order(ii)));
           W(order(ii), :) = Inf;
           W(:, order(ii)) = Inf;
        end
        
        for jj = 1:branching
            ii = order(jj);
            %ii = jj;
            node.childs(ii).idx = parent_idx + (jj-1)*base;
            node.childs(ii).lidx = idivide(node.childs(ii).idx, int32(base));
            node.childs(ii).depth = node.depth - 1;
            [node.childs(ii), encoding] = encode_node_rec(node.childs(ii), encoding, node.childs(ii).idx, branching);
        end
    else %If leaf node
        %fprintf('-%d:%d-', parent_idx, depth);
        if length(node.childs) > branching
            for ii = 1:length(node.childs)
                encoding(node.childs(ii), 1) = parent_idx;
            end
        else
            for ii = 1:length(node.childs)
                encoding(node.childs(ii), 1) = parent_idx + (ii-1)*base;
            end
        end
    end
end
