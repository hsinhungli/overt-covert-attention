set(0,'DefaultLineLineWidth',1);
addpath('./upConv/');
addpath('Simulate_Neural_Response');

%% Options : Subject and models to plot
subj = 'S2'; %Enter subject to plot (S1, S2, S3 or S4)
modelType = 'RG'; %Which model to plot: 'NMA', 'RG', 'CG', 'IB' or 'OB'
modelName = 'RG_B_NT_NL'; %Specific model names. Should be those in the mdata folders (RG_B_NT_NL, NMA_B_NT_NL, CG_B_NT_NL, IB_B_NT_NL or OB_B_NT_NL)

%% Setup for simulation and plotting
dataFolder = 'Data/Experiment2and3_saccade';
fn_data= sprintf('%s/%s_log',dataFolder,subj);
load(fn_data);

bias = 1 ; tradeoff = 0; lapse = 0;
nloc = 4; %three location plus one condition for summing all location
nunc = 3; 

fn_fit = sprintf('mdata/%s_fit_%s',modelName,subj);
load(fn_fit);

contrasts = [0.0500 0.1000 0.1414 0.2000 0.2731 0.3730 0.5094 0.6956 0.9500];
rcond = 1:3; %neutral, 

bestPar = estX;

%Have to select the best results if results using multiple initial pointsare saved
%[mfval, mInd] = min(fval); %Get the best fitting results from all tested initial points
%bestPar = estX(mInd,:);

%% Retrieve behavioral data
for cond = rcond
    for unc = 1:nunc
        for loc = 1:nloc
            for c = 1:9
                
                if loc == 4 %Pool all locations
                    condInd = trl.cond==cond & trl.unc == unc & trl.contrastIdx==c;
                else
                    condInd = trl.cond==cond & trl.unc == unc & trl.targetpos==loc & trl.contrastIdx==c;
                end
                
                [~, dp(cond,c,unc,loc), ~, ~, ~, ntrl(cond,c,unc,loc)] = getdprime(condInd, trl.targetoriIdx==1, trl.response==1, 0);
            end
        end
    end
end

%% Predicted responses
[~, estDprime, p_r_r, p_l_r] = runModel_singleTrial(bestPar, trl, modelType, bias, tradeoff, lapse);

for cond = rcond
    for unc = 1:nunc
        for loc = 1:nloc
            for c = 1:9
                
                if loc ~= 4
                    
                    hitRate = p_r_r(cond, c, unc, loc);
                    faRate = p_l_r(cond, c, unc, loc);
                    dprime(cond, c, unc, loc) = norminv(hitRate)-norminv(faRate);
                    
                else
                    
                    ratio = squeeze(ntrl(cond, c, unc, 1:3) / ntrl(cond, c, unc, 4));
                    hitRate = nansum(squeeze(p_r_r(cond, c, unc, 1:3)) .* ratio);
                    faRate = nansum(squeeze(p_l_r(cond, c, unc, 1:3)) .* ratio);
                    dprime(cond, c, unc, loc) = norminv(hitRate)-norminv(faRate);
                    
                end
                
            end
        end
    end
end

%%
colmat = [0 0 0; .1 .3 1; 1 .3 .1];
loc = 4; %Plot results by pooling all locations
conditionName = {'Low Uncertainty','Mediu Uncertainty','High Uncertainty'};
cpsFigure(1.5,.6);
for unc = 1:nunc
    subplot(1,3,unc);
    for cond = 1:3
        plot(contrasts, dp(cond, :, unc, loc), 'o', 'Color', colmat(cond,:)); hold on;
        plot(contrasts, dprime(cond, :, unc, loc), 'Color', colmat(cond,:));
    end
    set(gca, 'XScale', 'log');
    xlim([min(contrasts) max(contrasts)]);
    ylim([-.5 4.5]);
    title(conditionName{unc});
    xlabel('Log Contrast');
    ylabel('Dprime');
end

%% The code for saving individual model fit fot plotting group-averaged data
% dp_behav = squeeze(dp(:,:,:,4));
% dp_neural = squeeze(dprime(:,:,:,4));
% fn = sprintf('plotdata/%s_%s',subj,modelName);
% save(fn, 'dp_*');