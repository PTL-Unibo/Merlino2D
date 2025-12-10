function [mshpp] = PreProcessing(msh_name, coordinates, options)
arguments
    msh_name (1,:) char
    coordinates (1,:) char
    options.remove_dielectric (1,:) char {mustBeMember(options.remove_dielectric,{'yes','no'})} = 'no'
end
% Physical curves with tag >= 1000 are considered to be dielectric
% interfaces.
% Physical surfaces with tag >= 2 are considered to be dielectric regions.

% Run the mesh .m file created by gmesh
run(msh_name + ".m")

if options.remove_dielectric == "yes"
    [msh,nodes_mapping] = RemoveDielectric(msh); %#ok<NODEF>
end

ns_from_c = msh.TRIANGLES(:,1:3);
[dim_cID, cID_from_c, cs_from_cID, ~] = OrderingID(msh.TRIANGLES(:,4));
% modify ns_from_c so that nodes are ordered
ns_from_c = Order3Matrix(ns_from_c);

li_d = msh.LINES(:,3) >= 1000;
ns_from_d = msh.LINES(li_d,1:2);
[dim_dID, dID_from_d, ds_from_dID, ~] = OrderingID(msh.LINES(li_d,3));
msh.LINES(li_d,:) = [];
% modify ns_from_d so that nodes are ordered
li_ordered = ns_from_d(:,1) < ns_from_d(:,2);
ns_from_d = li_ordered.*ns_from_d + (~li_ordered).*ns_from_d(:,[2,1]);

ns_from_b = msh.LINES(:,1:2);
[dim_bID, bID_from_b, bs_from_bID, ~] = OrderingID(msh.LINES(:,3));
% modify ns_from_b so that nodes are ordered
li_ordered = ns_from_b(:,1) < ns_from_b(:,2);
ns_from_b = li_ordered.*ns_from_b + (~li_ordered).*ns_from_b(:,[2,1]);

all_faces = [ns_from_c(:,[1,2]); ns_from_c(:,[2,3]); ns_from_c(:,[1,3])];
ns_from_f = unique(all_faces,'rows');

Nc = size(ns_from_c,1);
Nd = size(ns_from_d,1);
Nn = size(msh.POS,1);
Nb = size(ns_from_b,1);
Nf = size(ns_from_f,1);

xn = msh.POS(:,1);
yn = msh.POS(:,2);

Xc = xn(ns_from_c);
Yc = yn(ns_from_c);
Xf = xn(ns_from_f);
Yf = yn(ns_from_f);

xc = sum(Xc,2) / 3;
yc = sum(Yc,2) / 3;
xf = (Xf(:,1) + Xf(:,2)) / 2;
yf = (Yf(:,1) + Yf(:,2)) / 2;

f_from_ns = sparse(ns_from_f(:,1)', ns_from_f(:,2)', 1:Nf, Nn, Nn);

f_from_b = full(f_from_ns(sub2ind([Nn,Nn],ns_from_b(:,1),ns_from_b(:,2))));
f_from_d = full(f_from_ns(sub2ind([Nn,Nn],ns_from_d(:,1),ns_from_d(:,2))));

b_from_f = zeros(Nf,1);
b_from_f(f_from_b) = 1:Nb;
b_from_f = sparse(b_from_f);

d_from_f = zeros(Nf,1);
d_from_f(f_from_d) = 1:Nd;
d_from_f = sparse(d_from_f);

if options.remove_dielectric == "no"
    all_b_faces = f_from_b;
    total_num_b = Nb;
elseif options.remove_dielectric == "yes"
    all_b_faces = [f_from_b; f_from_d];
    total_num_b = Nb + Nd;
end

n_from_bn = unique(ns_from_f(all_b_faces,:));
temp = sortrows([reshape(ns_from_f(all_b_faces,:),[],1), repmat(all_b_faces,2,1)]);
fs_from_bn = sparse(temp(:,1), repmat([1,2],1,total_num_b), temp(:,2), Nn, 2);
fs_from_bn = full(fs_from_bn(n_from_bn,:));
bID_from_f = sparse(f_from_b,ones(size(f_from_b)),bID_from_b,Nf,1);
bIDs_from_bn = full(bID_from_f(fs_from_bn));

fs_from_c = full(reshape(f_from_ns(sub2ind([Nn,Nn],all_faces(:,1)',all_faces(:,2)')),[],3));
% modify fs_from_c so that faces are ordered
fs_from_c = Order3Matrix(fs_from_c);

temp = sortrows([[fs_from_c(:); all_b_faces], [repmat((1:Nc)',3,1); ones(total_num_b,1)*(Nc+1)]]);
cs_from_f = reshape(temp(:,2),2,[])';
cs_from_f(cs_from_f==(Nc+1)) = 0;
% normal will be from air to dielectric if dielectric ID tag is greater than
% air ID tag

temp = sortrows([ns_from_c(:), repmat((1:Nc)',3,1)]);
num_cs_from_n = histcounts(temp(:,1),0.5:1:Nn+0.5);
cs_from_n = mat2cell(temp(:,2), num_cs_from_n);
nodes = temp(:,1);
cells = temp(:,2);
d_inv = 1./sqrt((xc(cells) - xn(nodes)).^2 + (yc(cells) - (yn(nodes))).^2);
w_cs_from_n = mat2cell(d_inv, num_cs_from_n);

temp = sortrows([ns_from_f(:), repmat((1:Nf)',2,1)]);
num_fs_from_n = histcounts(temp(:,1),0.5:1:Nn+0.5);
fs_from_n = mat2cell(temp(:,2), num_fs_from_n);
nodes = temp(:,1);
faces = temp(:,2);
d_inv = 1./sqrt((xf(faces) - xn(nodes)).^2 + (yf(faces) - (yn(nodes))).^2);
w_fs_from_n = mat2cell(d_inv, num_fs_from_n);

for i = 1:Nn
    w_cs_from_n{i} = w_cs_from_n{i} / sum(w_cs_from_n{i});
    w_fs_from_n{i} = w_fs_from_n{i} / sum(w_fs_from_n{i});
end

Face2Node = sparse(repelem(1:Nn, num_fs_from_n), vertcat(fs_from_n{:}), vertcat(w_fs_from_n{:}), Nn, Nf);

if lower(coordinates) == "cartesian"
    areaf = sqrt((Xf(:,1)-Xf(:,2)).^2 + (Yf(:,1)-Yf(:,2)).^2);
    vol = TriangleArea(Xc, Yc);
elseif lower(coordinates) == "cylindrical"
    [vol, areaf] = AxisymmetricVolumeArea(ns_from_c, ns_from_f, fs_from_c, f_from_ns, xn, yn, Nc, Nf);
end
inv_vol = 1 ./ vol;

Tv = [Xf(:,2)-Xf(:,1), Yf(:,2)-Yf(:,1)];
I = zeros(Nf,2);
non_b_faces = setdiff(1:Nf,all_b_faces);
I(non_b_faces,:) = [xc(cs_from_f(non_b_faces,2))-xc(cs_from_f(non_b_faces,1)), yc(cs_from_f(non_b_faces,2))-yc(cs_from_f(non_b_faces,1))];
I(all_b_faces,:) = [xf(all_b_faces)-xc(cs_from_f(all_b_faces,1)), yf(all_b_faces)-yc(cs_from_f(all_b_faces,1))];
sn = GetNormal(Xf(:,1)-Xf(:,2), Yf(:,1)-Yf(:,2));
li_flip = DotProduct2D(sn,I) < 0;
sn(li_flip,:) = -sn(li_flip,:);
snsign = sign(cs_from_f(fs_from_c) - (1:Nc)'*[1,1,1] + 0.5);
delta = DotProduct2D(I,sn);

mshpp.name = msh_name;
mshpp.ns_from_c = ns_from_c;
mshpp.dim_cID = dim_cID;
mshpp.cID_from_c = cID_from_c;
mshpp.cs_from_cID = cs_from_cID;
mshpp.ns_from_d = ns_from_d;
mshpp.dim_dID = dim_dID;
mshpp.dID_from_d = dID_from_d;
mshpp.ds_from_dID = ds_from_dID;
mshpp.ns_from_b = ns_from_b;
mshpp.dim_bID = dim_bID;
mshpp.bID_from_b = bID_from_b;
mshpp.bs_from_bID = bs_from_bID;
mshpp.ns_from_f = ns_from_f;
mshpp.f_from_b = f_from_b;
mshpp.b_from_f = b_from_f;
mshpp.f_from_d = f_from_d;
mshpp.d_from_f = d_from_f;
mshpp.n_from_bn = n_from_bn;
mshpp.fs_from_bn = fs_from_bn;
mshpp.bIDs_from_bn = bIDs_from_bn;
mshpp.fs_from_c = fs_from_c;
mshpp.cs_from_f = cs_from_f;
mshpp.cs_from_n = cs_from_n;
mshpp.num_cs_from_n = num_cs_from_n;
mshpp.w_cs_from_n = w_cs_from_n;
mshpp.Face2Node = Face2Node;
mshpp.Nc = Nc;
mshpp.Nd = Nd;
mshpp.Nn = Nn;
mshpp.Nb = Nb;
mshpp.Nf = Nf;
mshpp.xn = xn;
mshpp.yn = yn;
mshpp.xc = xc;
mshpp.yc = yc;
mshpp.xf = xf;
mshpp.yf = yf;
mshpp.areaf = areaf;
mshpp.vol = vol;
mshpp.inv_vol = inv_vol;
mshpp.Tv = Tv;
mshpp.I = I;
mshpp.sn = sn;
mshpp.snsign = snsign;
mshpp.delta = delta;
mshpp.inv_vol_standard = 1./TriangleArea(Xc, Yc);
mshpp.areaf_standard = sqrt((Xf(:,1)-Xf(:,2)).^2 + (Yf(:,1)-Yf(:,2)).^2);
if options.remove_dielectric == "yes"
    mshpp.nodes_mapping = nodes_mapping;
end

end

function [w] = DotProduct2D(v1,v2)
% v1 = [v1x, v1y]
% v2 = [v2x, v2y]
% The function works also with matrices v1 and v2
% that have multiple lines
w = v1(:,1).*v2(:,1) + v1(:,2).*v2(:,2);
end

function [n] = GetNormal(dx,dy)
% dx is a column vector representing the x component of a segment
% dy is a column vector representing the y component of a segment
% n is a matrix: n = [nx, ny] where nx and ny are column vectors
% representing the x and y components of the normal versor to the
% considered segment
D = sqrt(dx.^2 + dy.^2);
n = [dy, -dx] ./ D;
end

function [A] = TriangleArea(X, Y)
% X is a matrix with 3 columns,
% each column contains the x coordinates
% of the vertices 1, 2, 3 of a triangle
% Y is a matrix with 3 columns,
% each column contains the y coordinates
% of the vertices 1, 2, 3 of a triangle
A = abs(0.5 * ((X(:,2)-X(:,3)).*Y(:,1) + (X(:,3)-X(:,1)).*Y(:,2) + (X(:,1)-X(:,2)).*Y(:,3)));
end

function [dim_ID, link_something_to_basic_ID, link_ID_to_something_indices, link_ID_to_something_logical_indices] = OrderingID(link_something_to_ID)
% Converts [30; 189; 189; 189; 1025; 30; 1025] to 
% 3
% [1; 2; 2; 2; 3; 1; 3],
% {[1;6],[2;3;4],[5;7]}
% {[1;0;0;0;0;1;0],[0;1;1;1;0;0;0],[0;0;0;0;1;0;1]}
unique_link = unique(link_something_to_ID);
dim_ID = numel(unique_link);
general_ID_to_ordered = sparse(unique_link', ones(1,dim_ID), 1:dim_ID);
link_something_to_basic_ID = full(general_ID_to_ordered(link_something_to_ID));
link_ID_to_something_indices = cell(dim_ID,1);
link_ID_to_something_logical_indices = cell(dim_ID,1);
for id = 1:dim_ID
    logical_indices = link_something_to_basic_ID == id;
    link_ID_to_something_logical_indices{id} = logical_indices;
    link_ID_to_something_indices{id} = find(logical_indices);
end
end

function [ordered_matrix] = Order3Matrix(matrix)
    dim = size(matrix,1);
    [first_column,i_min] = min(matrix,[],2);
    [last_column,i_max] = max(matrix,[],2);
    middle_column = sum(matrix .* (~logical(sparse(repmat((1:dim)',2,1), [i_min;i_max], ones(2*dim,1), dim, 3))),2);
    ordered_matrix = [first_column, full(middle_column), last_column];
end

function [msh,nodes_mapping] = RemoveDielectric(msh)
    li = msh.TRIANGLES(:,4) > 1;
    diel_nodes = unique(msh.TRIANGLES(li,1:3));
    non_diel_nodes = unique(msh.TRIANGLES(~li,1:3));
    diel_nodes = setdiff(diel_nodes, non_diel_nodes);
    msh.POS(diel_nodes,:) = [];
    msh.TRIANGLES(li,:) = [];
    
    I = setdiff(1:msh.nbNod, diel_nodes);
    nodes_mapping = sparse(I, ones(size(I)), 1:(msh.nbNod-numel(diel_nodes)), msh.nbNod, 1);
    
    li = sum(ismember(msh.LINES(:,1:2),diel_nodes),2) > 0;
    msh.LINES(li,:) = [];
    
    msh.TRIANGLES(:,1:3) = nodes_mapping(msh.TRIANGLES(:,1:3));
    msh.LINES(:,1:2) = nodes_mapping(msh.LINES(:,1:2));
end
