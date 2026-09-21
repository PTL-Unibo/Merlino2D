function [] = Append_B_to_A(res_folder_1, res_folder_2)
% Append_B_to_A(A,B)

results1 = load(res_folder_1 + filesep + "results.mat");
results2 = load(res_folder_2 + filesep + "results.mat");

save_struct = results1;
save_struct.tout = [results1.tout(1:end-1), results2.tout];
save_struct.yout = [results1.yout(:,1:end-1), results2.yout];
save_struct.y_end = save_struct.yout(:,end);

SaveStruct(res_folder_1 + filesep + "results.mat", save_struct)

end