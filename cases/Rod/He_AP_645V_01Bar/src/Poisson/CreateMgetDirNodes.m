function [MgetDirNodes] = CreateMgetDirNodes(link_node_to_bfaces, link_bface_to_ID, Dirichlet_nodes_indices, BCEL_FLAG)

numDir_nodes = numel(Dirichlet_nodes_indices);
numIDs = numel(BCEL_FLAG);

bfaces = link_node_to_bfaces(Dirichlet_nodes_indices,:);
ids = link_bface_to_ID(bfaces);
flags = 1 - BCEL_FLAG(ids);
coeff = flags./(sum(flags,2));

MgetDirNodes = sparse(repmat((1:numDir_nodes)',2,1), ids(:), coeff(:), numDir_nodes, numIDs);

end
