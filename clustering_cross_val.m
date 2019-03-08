%% Cross validation for k means clustering to cluster with optimal k
% Ref: https://stats.stackexchange.com/questions/87098/can-you-compare-different-clustering-methods-on-a-dataset-with-no-ground-truth-b
% ,Tibshirani & Walther (2005), "Cluster Validation by Prediction Strength", Journal of Computational and Graphical Statistics, 14, 3.
function [optimalK,quality,ps] = clustering_cross_val(X,fold,kval)
   %% INPUTS
   % X is an n x p data set, n observations each with p dimensions
   % fold is the 1/fraction of data that we will use for testing
   % kval is a range of k values to test for k means clustering
   %% OUTPUTS
   %shuffle data
   kcounter=0;
   ps = zeros(1,length(kval));
   ps_se = zeros(1,length(kval));
   for k = kval
       kcounter=kcounter+1;
       N_data = size(X,2); % total number of data points 
       %%
       % shuffle the data
       shuffle_index = randperm(N_data);
       %%
       X_shuffled = X(:,shuffle_index);
       fold_size = floor(N_data/fold);
       %%
       counter = 1;
       cluster_quality = zeros(k,fold);
       %%
       for i = 1:fold
           test_data_index = counter:counter+fold_size-1;
           train_data_index = setdiff(1:N_data,test_data_index);
           test_data = X_shuffled(:,test_data_index);
           train_data = X_shuffled(:,train_data_index);
           counter = counter+fold_size;
           % kmeans clustering on the train data
           [idx_train,C_train] = kmeans(train_data',k);
           % kmeans clustering on the test data
           idx_test = kmeans(test_data',k,'MaxIter',10000);
           % Calculate distance from each test point to each train centroid
           test_distance_matrix = pdist2(test_data',C_train);
           % Assign test points to train clusters based on centroid
           % distances
           [M,I] = min(test_distance_matrix,[],2);
           % for each test cluster
           for cluster = 1:k
                %find the number of pairs of observations where each pair
                %is in the same train cluster
                cluster_idx = idx_test==cluster; % find elements of cluster
                num_cluster = sum(cluster_idx); % number of elements per cluster
                cluster_idx_train = I(cluster_idx); % check if elements in this cluster are in the same train cluster
                total_number_of_pairs = num_cluster * (num_cluster-1)/2;
                pairs_in_same_cluster = 0;
                pairs_in_diff_cluster = 0;
                c = 0;
                for x = 1:num_cluster
                    for y = x+1:num_cluster
                        c = c+1;
                        if cluster_idx_train(x) == cluster_idx_train(y)
                            pairs_in_same_cluster = pairs_in_same_cluster + 1;
                        else
                            pairs_in_diff_cluster = pairs_in_diff_cluster + 1;
                        end
                    end
                end
                if pairs_in_same_cluster + pairs_in_diff_cluster ~= total_number_of_pairs
                    disp('problem');
                    return
                end
                cluster_quality(cluster,i) = pairs_in_same_cluster/total_number_of_pairs;
           end  
       end
       % take the min quality across clusters averaged across folds
       ps(kcounter) = mean(min(cluster_quality));
       ps_se(kcounter) = std(min(cluster_quality))/(fold^(1/2));
   end
   tmp_idx = find(ps+ps_se>0.8);
   optimalK = kval(tmp_idx(end));
   quality = ps(tmp_idx(end));
end