function [] = huffmantree(p)
% HUFFMANTREE(P)
% Generates a Huffman tree for the probabilities in vector P.

if nargin < 1
   print_usage();
   return
end

if sum(p) < 1-eps()
    disp('Error: Probabilities in P do not add to 1');
    return
end

input_num_probabilities = length(p);
if length(p) <= 2
    disp('More probabilities please');
    return
end

BASE_DEPTH = 10;
BASE_HEIGHT = 10;
X_TEXT_SPACING = 10;
Y_TEXT_SPACING = 10;

probabilities = sort(p, 'ascend');
y = BASE_HEIGHT;
nodeID = 0;

% Create starting nodes
for i = 1:length(p)
    nodeID = nodeID + 1;
    pobj(i) = probclass(nodeID, BASE_DEPTH, y, probabilities(i), 1);   
    y = y + Y_TEXT_SPACING;
end

node_prob = 0;
index_ignore = [];
branches = [];
largest_branch_level = 1;

% Loop while the node prob is < 1 (while we are not at the base branch)
while node_prob < 1
    num_p = length(pobj);
    
    % Finding the lowest p
    lowestp = 1;
    for i = 1:num_p
        % ignore branches that have already been paired
        if max(ismember(index_ignore, pobj(i).nodeID))
            continue
        end
        
        if pobj(i).p < lowestp
            lowestp = pobj(i).p;
            lowestp_index = i;
        end
    end
    
    % Finding the next lowest p to branch to
    branch_lowestp = 1;
    for i = 1:num_p
        % ignore the branch we want to join to
        if i == lowestp_index
            continue;
        end
        
        % ignore branches that have already been paired
        if max(ismember(index_ignore, pobj(i).nodeID))
            continue
        end

        if pobj(i).p < branch_lowestp
           branch_lowestp = pobj(i).p;
           branch_lowestp_index = i;
        end
    end

    % add above nodes to ignore list
    index_ignore = [index_ignore, pobj(lowestp_index).nodeID,...
                    pobj(branch_lowestp_index).nodeID];
            
    % create a new branch between the two nodes
    new_branch = branchclass(pobj(lowestp_index).x,...
                             pobj(lowestp_index).y,...
                             pobj(branch_lowestp_index).x,...
                             pobj(branch_lowestp_index).y);
              
    % add it to the list of branches
    branches = [branches, new_branch];
    
    % create a new node
    branch_level = max(pobj(lowestp_index).blvl,...
                       pobj(branch_lowestp_index).blvl) + 1;
    if branch_level > largest_branch_level
        largest_branch_level = branch_level;
    end
    
    nodeID = nodeID + 1;
    x = X_TEXT_SPACING*branch_level;
    y = (pobj(lowestp_index).y + pobj(branch_lowestp_index).y)/2;
    node_prob = pobj(lowestp_index).p + pobj(branch_lowestp_index).p;
    new_node = probclass(nodeID, x, y, node_prob, branch_level);
    
    % add it to the list of nodes
    pobj = [new_node, pobj(1:lowestp_index), pobj(lowestp_index+1:end)];
    
    % DEBUG
%     fprintf('lowestp: %.4f\nlowestp_index: %.4f\nbranch_lowestp: %.4f\nbranch_lowestp_index: %.4f\n\n',...
%         lowestp, lowestp_index, branch_lowestp, branch_lowestp_index);

end

% Draw the tree
close all;
fig_handle = figure;
axis([0, X_TEXT_SPACING*(largest_branch_level + 1),...
      0, Y_TEXT_SPACING*(input_num_probabilities + 1)]);
%set(fig_handle, 'Visible', 'off');
set(gca, 'xtick', [], 'ytick', []);
set(fig_handle, 'position', [230, 210, 1200, 720]);

% Draw nodes
for i = 1:length(pobj)
   pobj(i).draw(fig_handle);    
end

% Draw branches
for i = 1:length(branches)
   branches(i).draw(fig_handle); 
end

% White background fill
set(fig_handle, 'Color', [1, 1, 1]);
axis off;

end

function print_usage
    fprintf('HUFFMANTREE(P)\n');
    fprintf('Generates a Huffman tree for the probabilities in vector P\n');
end

