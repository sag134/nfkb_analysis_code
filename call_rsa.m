addpath('../lib');
addpath('../model_files');
N_tr = 48;
var_index = 1:3;
N_samples = 50000;
LB = [2,1,1];
UB = [7,7,5];
%load('./data25_V5_progress500000.mat')
load('../newrun1/data25_2_progress500000.mat')
for i = 300000:1000:500000
    base_par = params_chain(1,:,i);
    [a,b,c] = rsa(N_tr,var_index,UB,LB,base_par,N_samples,@lhsu,@simulation_function,['../newrun1_res/',num2str(i),'.mat']);
end