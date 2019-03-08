%% Calculate error between a query set and reference set, to understand how well is the query set represented in the reference set
function [err,ind,data_ref,data_query]= KNN_CalcError(k,data_ref,data_query,scaling)
    % INPUTS
    % data_query: M x N1 matrix, N1 = number of trajectories; M = number of
    % time points
    % data_ref: M x N2 matrix, N2 = number of trajectories; M = number of
    % time points
    % OUTPUTS:
    % err,ind = N1 x 1 array 
    if scaling==1 % rescale ref and query data to [0,1]
        data_ref = rescale(data_ref,'InputMin',min(data_ref),'InputMax',max(data_ref));
        data_query = rescale(data_query,'InputMin',min(data_ref),'InputMax',max(data_ref));
    end
    %%
    err = zeros(k,size(data_query,2)); % we will calculate an error for each point in the query set
    ind = zeros(k,size(data_query,2)); % the index of the ref point that minimizes the error
    for i = 1:size(data_query,2) % for each data point in the query set
        tic
        trajectory = data_query(:,i);
        out = pdist2(data_ref',trajectory'); % calculate distance to each point in the reference set
        [sorted_out,sorted_index] = sort(out);
        err(:,i) = sorted_out(1:k); % find the k smallest distances
        ind(:,i) = sorted_index(1:k); % find the index of the ref point with the min distance
        if mod(i,50)==0
            toc
        end
    end
end
