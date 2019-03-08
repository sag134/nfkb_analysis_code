function response = dose_response_prediction(doses,dose_simulation_handle,parameters,response_handle)
    ndoses = length(doses);
    n_par_sets = size(parameters,1);
    response = zeros(1,length(doses));
    for i = 1:ndoses
        for j = 1:n_par_sets
            [err, obsv] = dose_simulation_handle(doses(i),parameters(j,:)); % simulate model
            if err == 0
                response(i,j) = response_handle(obsv);
            else
                response(i,j) = 1e29;
            end
        end
    end
end