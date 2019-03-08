%% Bin data by some scalar feature
function [bin_idx] = bin_data(X,scalar_feature_function,bin_range)
%%
    feature = scalar_feature_function(X);
    bin_idx = zeros(1,size(X,2));
    [u,v] = sort(feature);
    for i = 1:length(bin_range)-1
        idx = (u > bin_range(i) & u <= bin_range(i+1));
        bin_idx(v(idx)) = i;
    end
end