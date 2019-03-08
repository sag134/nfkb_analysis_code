 function [param_clusters,data_clusters,cluster_idx] = cluster_bins(sampled_tr,sampled_par,bin_idx,bin_kval)
    %%
    num_bins = max(bin_idx);
    param_clusters = cell(num_bins,max(bin_kval));
    data_clusters = cell(num_bins,max(bin_kval));
    cluster_idx = cell(num_bins,1);
    for i= 1:num_bins
        trajectory_data = sampled_tr(:,bin_idx==i);
        param_data = sampled_par(:,bin_idx==i);
        scaled_data = rescale(trajectory_data,'InputMin',min(trajectory_data),'InputMax',max(trajectory_data));
        %scaled_data = sum(trajectory_data);
        cluster_idx{i} = kmeans(scaled_data',bin_kval(i));
        for j = 1:bin_kval(i)
            param_clusters{i,j} = param_data(:,cluster_idx{i}==j);
            data_clusters{i,j} = trajectory_data(:,cluster_idx{i}==j);
        end
    end
end