function fitModel_singleTrial(subj, model_to_fit, saveData)

%%Input:
%subj: subject to fit; 1,2,3 or 4
%model_to_fit: which model_to_fit; 1 to 5, for NMA, RG, CG, IB and OB models respectively
%saveData: whether to save data in mdata folder; 0 or 1

%%
addpath('./upConv/');
addpath('Simulate_Neural_Response');
%addpath(genpath('bads')); %if use BADS for optimization

dataFolder = 'Data/Experiment2and3_saccade';
subjPool = {'S1','S2','S3','S4'};

%%
nrep = 1; %Set 1 here for convenience. Multiple initial points have to be tested and select the best results in real practice.
subj = subjPool{subj};

filename = sprintf('%s/%s_log',dataFolder,subj);
load(filename);

estX = []; fval = [];
switch model_to_fit
    case 1
        %% NMA-B-NT
        modelType = 'NMA';
        modelName = 'NMA_B_NT';
    case 2
        %% RG-B-NT
        modelType = 'RG'; 
        modelName = 'RG_B_NT';
    case 3
        %% CG-B-NT
        modelType = 'CG'; 
        modelName = 'CG_B_NT';
    case 4
        %% IB-B-NT
        modelType = 'IB'; 
        modelName = 'IB_B_NT';
    case 5
        %% OB-B-NT
        modelType = 'OB'; 
        modelName = 'OB_B_NT';
end

%For simplicity here we fit no lapse rate and no tradeOff term
lapse = 0; bias = 1; tradeOff = 0;


if lapse==0 %Wild card for lapse rate
    modelName = [modelName '_NL'];
end

myFunc = @(x)runModel_singleTrial(x, trl, modelType, bias, tradeOff, lapse);

%[lapseRate, log(sigma), exponent, log(sigma_lateNoise), w_neutral, w_toward, AxWidth_l, AxWidth_m, AxWidth_h]
%The first term is lapse rate, but it is treated as a placeholder only here.
lb  = [0 -10 .5 -5  0  0  0  0  0 -5]; %lower bound
ub  = [10^-6 10   4  5  30 30 20 20 20 5]; %upper bound
plb = [0 -4  1 -2  0  0  0  0  0 -.5]; %plausible lower bound (for BADS)
pub = [10^-6 0  2  2  5  5  5  5 5 .5]; %plausible higher bound (for BADS)

x0 = nan(nrep, length(lb));
options  = psoptimset('Display','iter','MeshAccelerator','on');

for rep = 1:nrep
    
    fprintf(1,'--------------- --------------- %s %s modelType:%s  iter %i --------------- ---------------\n', subj, modelName, modelType, rep);
    
    randseed = rand(1,length(plb));
    temp = plb + randseed.*(pub-plb);
    temp(7:9) = sort(temp(7:9));
    x0(rep,:) = temp;
    
    disp(x0(rep,:));
    
    %-----Run this section is use patternsearch or fmincon in MATLAB for optimization-----
    A  =  [0 0 0 0 0 0 1 -1 0 0; 0 0 0 0 0 0 0 1 -1 0];
    b  =  [0, 0];
    
    %[estX(rep,:),fval(rep,:)] = patternsearch(myFunc, x0(rep,:), A, b, [], [], lb, ub, [], options); %% patternsearch
    [estX(rep,:), fval(rep)] = fmincon(myFunc, x0(rep,:), A, b, [], [], lb, ub, [], options); %%fmincon
    
    %-----Run this section is use BADS for optimization-----
    %nonbcon = @(x) x(:,9)<x(:,8) | x(:,8)<x(:,7);
    %[estX(rep,:), fval(rep), ~, ~] = bads(myFunc,x0(rep,:),lb,ub,plb,pub,nonbcon,options);
end

if saveData == 1
    %Save the optimization results in folder 'mdata'
    fn = sprintf('mdata/%s_fit_%s', modelName, subj);
    save(fn, 'estX', 'fval', 'x0', 'lb', 'ub', 'subj', 'duration');
end
