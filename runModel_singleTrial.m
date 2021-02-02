% addpath('./upConv');
function [nll, dprime, p_r_r, p_l_r] = runModel_singleTrial(x, trl, modelType, bias, tradeoff, lapse)

%%Input:
%x: a vector containing the value of free parameters
%trl: the data
%modelType: which model to fit:
%bias, tradeoff, lapse: can be set 1 or 0 to change the setup of the model.
%Here for demonstration. Give input as bias=1, tradeoff=0, lapse=0

%%
%x = [lapse log(sigma), exponent, log(sigma_lateNoise), w_neutral, w_saccade, AxWidth_l, AxWidth_m, AxWidth_h]
%Free parameters
p = setParameters;
lapseRate = x(1);
p.sigma = 10.^x(2); %constant suppression
p.p = x(3);      %exponent
sigma_lateNoise(1) = 10^x(4);
sigma_lateNoise(2) = 10^x(4);
sigma_lateNoise(3) = 10^x(4);
p.wa_neutral = x(5); %Strength of attention
p.wa_toward = x(6); %Strength of attention
p.wa_away = 0; %Strength of attention
p.AxWidth_level = max([x(7) x(8) x(9)], eps);

if bias==0 && tradeoff==0
    criterion = 0;
    p.ap = 0;
end
if bias==1 && tradeoff==0
    criterion = x(10);
    p.ap = 0;
end
if bias==0 && tradeoff==1
    criterion = 0;
    p.ap = x(10);
end

%Other setting
rcond = 1:3; %1: Neutral; 2: Toward (valid); 3: Away (invalid)
orivec = -4;
ncond = 3;
nunc = 3; %3 for saccade experiment; 
nloc = 3; %3 for saccade experiment; 

%Set stimuli contrasts
contrasts = [0.0500 0.1000 0.1414 0.2000 0.2731 0.3730 0.5094 0.6956 0.9500];
numContrasts = length(contrasts);

%distance between the target to the central location
location_mat = [0 0 0;... %low uncertainty condition
    1.2 0.65 0;...%medium uncertainty condition
    3 1.5 0]; %high uncertainty condition

%Preallocate some variables
for cond = 1:ncond
    for c = 1:numContrasts
        for unc = 1:nunc
            for loc = 1:nloc

                p.CRF(cond,:,:,c,unc,loc)  = nan(p.ntheta, p.nx);
                %condition X ori X RFcenter X contrast X uncertainty X targetLoc 
                
            end
        end
    end
end

%%
p.stimOrientation = orivec(1);
for cond = rcond
    for unc = 1:nunc
        
        p.AxWidth = p.AxWidth_level(unc);
        p = setAttention(cond, p);
        
        for loc = 1:nloc
            
            if unc == 1 && loc>1
                %low uncertainty only has location 1
                
            else
                shift = location_mat(unc, loc);
                %disp(shift);
                stim_temp  = makeBand(p.theta,p.stimOrientation,p.stimthetaWidth,1) * makeGaussian(p.x,p.stimCenter+shift,p.stimWidth);
                
                for c = 1:numContrasts
                    
                    %stim{cond} = contrasts(c) * stim_temp + contrasts(c) * fliplr(stim_temp); %Two stimulus
                    stim = contrasts(c) * stim_temp;
                    
                    %Stimulus inputs to monocular layers
                    p.i = stim;
                    
                    %Simulate neural response
                    p = attentionModel(p, cond, modelType);
                    p.CRF(cond,:,:,c,unc,loc)  = p.R;
                    
                end
            end
        end
    end
end

%%
dprime = nan(ncond,numContrasts,nunc,nloc);
p_l_l = nan(ncond,numContrasts,nunc,nloc);
p_l_r = nan(ncond,numContrasts,nunc,nloc);
p_r_l = nan(ncond,numContrasts,nunc,nloc);
p_r_r = nan(ncond,numContrasts,nunc,nloc);
signal = nan(ncond,numContrasts,nunc,nloc);

for cond = rcond
    for unc = 1:nunc
        for loc = 1:nloc
            if unc == 1 && loc>1
            else
                for c = 1:9
                    
                    resp_l = squeeze(p.CRF(cond,:,:,c,unc,loc));
                    resp_r = flipud(resp_l);
                    
                    signal(cond,c,unc,loc) = sqrt(sum((resp_l(:) - resp_r(:)).^2));
                    
                    mean_l = -signal(cond,c,unc,loc)/2;
                    mean_r = signal(cond,c,unc,loc)/2;
                    
                    p_l_l(cond,c,unc,loc) = normcdf(criterion*sigma_lateNoise(unc), mean_l, sigma_lateNoise(unc)); %target left, report left
                    p_l_r(cond,c,unc,loc) = 1 - p_l_l(cond,c,unc,loc); %target left, report right
                    
                    p_r_l(cond,c,unc,loc) = normcdf(criterion*sigma_lateNoise(unc), mean_r, sigma_lateNoise(unc));
                    p_r_r(cond,c,unc,loc) = 1 - p_r_l(cond,c,unc,loc);
                    
                    dprime(cond,c,unc,loc) = signal(cond,c,unc,loc)/sigma_lateNoise(unc);
                    
                    %dp_2 = dprime(cond,c,unc,loc)/2;
                    %p_r_r(cond,c,unc,loc) = normcdf(dp_2 - criterion);
                    %p_r_l(cond,c,unc,loc) = 1 - p_r_r(cond,c,unc,loc);
                    
                end
            end
        end
    end
end

if lapse==0
    %fit model with no lapse rate
else
    p_l_l = (1-lapseRate)*p_l_l + lapseRate*.5;
    p_l_r = (1-lapseRate)*p_l_r + lapseRate*.5;
    p_r_l = (1-lapseRate)*p_r_l + lapseRate*.5;
    p_r_r = (1-lapseRate)*p_r_r + lapseRate*.5;
end

%% Compute likelihood of the data
pvec = nan(length(trl.response),1);
for cond = rcond
    for unc = 1:nunc
        for loc = 1:nloc
            for c = 1:9
                
                condInd = trl.cond == cond & trl.unc == unc & trl.targetpos == loc & trl.contrastIdx == c;
                
                respInd = trl.targetoriIdx == -1 & trl.response == -1;
                pvec(condInd & respInd) = p_l_l(cond,c,unc,loc);
                
                respInd = trl.targetoriIdx == -1 & trl.response == 1;
                pvec(condInd & respInd) = p_l_r(cond,c,unc,loc);
                
                respInd = trl.targetoriIdx == 1 & trl.response == -1;
                pvec(condInd & respInd) = p_r_l(cond,c,unc,loc);
                
                respInd = trl.targetoriIdx == 1 & trl.response == 1;
                pvec(condInd & respInd) = p_r_r(cond,c,unc,loc);
            end
        end
    end
end

pvec = max(pvec, eps);
nll = -sum(log(pvec));
%%

return

%%
% for cond = rcond
%     for unc = 1:nunc
%         for loc = 1:3
%             for c = 1:9
%                 condInd = trl.cond==cond & trl.unc == unc & trl.targetpos==loc & trl.contrastIdx==c;
%                 [~, dp(cond,c,unc,loc), ~, hit(cond,c,unc,loc), fa(cond,c,unc,loc)] = getdprime(condInd, trl.targetoriIdx==1, trl.response==1, 0);
%             end
%         end
%     end
% end
% 
% est_dprime = norminv(p_l_l) - norminv(p_r_l);
% 
% figure;
% plot(est_dprime(:,:,2,1)'); hold on;
% plot(dp(:,:,2,1)','o');
% 
% figure;
% plot(p_l_l(:,:,2,1)'); hold on;
% plot(hit(:,:,2,1)','o');

