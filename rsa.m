%% Regional sensitivity analysis
function [sampled_tr,sampled_par,par_matrix] = rsa(N_tr,var_index,UB,LB,base_par,N_samples,sampling_handle,simulation_handle,save_path)
    %% INPUTS
    % var_index is an array of indices of all parameters to vary
    % base par is a base parameter array, constant parameter values are
    % selected from here
    % save path is the directory in which to save after
    % sampling_handle is a handle to a function that draws samples from
    % high D parameter space
    % N is the number of samples
    %% Outputs
    % sampled_par is the sampled parameter values (a matrix)
    % sampled_tr is the sampled trajectories
    N_par = length(base_par); % number of model parameters
    lb = base_par;
    ub = lb;    
    if ~isempty(var_index)
        ub(var_index) = UB;
        lb(var_index) = LB;
    end
    par_matrix = sampling_handle(lb,ub,N_samples); % parameters sampled
    sampled_tr = zeros(N_tr,N_samples);
    sampled_par = zeros(N_par,N_samples);
    accepted_samples = 1;
    tic;
    for i = 1:N_samples
        if mod(i,100)==0
            toc;
            tic;
        end
        parameters = par_matrix(i,:);
        [err, obsv] = simulation_handle(parameters); % simulate model
        if err == 0 % keep sample if simulation ran correctly
            sampled_tr(:,accepted_samples) = obsv;
            sampled_par(:,accepted_samples) = parameters';
            accepted_samples = accepted_samples + 1;
        end
    end
    accepted_samples = accepted_samples - 1;
    %truncate matrices
    sampled_tr = sampled_tr(:,1:accepted_samples);
    sampled_par = sampled_par(:,1:accepted_samples);
    if save_path~=0
        save(save_path,'sampled_tr','sampled_par','par_matrix','base_par','accepted_samples','-v7.3');
    end
end 