set(0,'DefaultLineLineWidth',2);

dataFolder = 'plotdata';

subjPool = {'S1', 'S2', 'S3', 'S4'};
contrasts = [0.0500 0.1000 0.1414 0.2000 0.2731 0.3730 0.5094 0.6956 0.9500];
nunc = 3;

modelName = 'OB_B_NT_NL'; %Specific model to plot. Should be those in the pdata folders (RG_B_NT_NL, NMA_B_NT_NL, CG_B_NT_NL, IB_B_NT_NL or OB_B_NT_NL)
numContrast = length(contrasts);

dt_behav = nan(3, numContrast, nunc, 4); %cond, contrast, unc, subj
dt_neural = nan(3, numContrast, nunc, 4);

for ss = 1:4
    
    subj = subjPool{ss};
    fn = sprintf('plotdata/%s_%s',subj,modelName);
    load(fn);
    
    dt_behav(:,:,:,ss) = dp_behav;
    dt_neural(:,:,:,ss) = dp_neural;
    
end

%%
colmat = [0 0 0;  1 .3 .1; .1 .3 1];
cpsFigure(1.5,.5);
for unc = 1:nunc
    subplot(1,3,unc);
    for cond = 1:3
        
        thisdata = squeeze(dt_neural(cond,:,unc,:));
        thisy = mean(thisdata,2);
        thiserr = std(thisdata,[],2) / sqrt(4);
        
        thisx = [contrasts fliplr(contrasts)];
        thisy = [thisy+thiserr; flipud(thisy-thiserr)];
        ff = fill(thisx, thisy, colmat(cond,:));
        ff.FaceAlpha = .2;
        ff.LineStyle = 'none';
        hold on;
        
    end
    for cond = 1:3
        thisdata = squeeze(dt_behav(cond,:,unc,:));
        thisy = mean(thisdata,2);
        thiserr = std(thisdata,[],2) / sqrt(4);
        myerrorbar(contrasts, thisy, thiserr, 0, colmat(cond,:), 1, 5); hold on;
    end
    
    set(gca, 'XScale', 'log');
    set(gca,'xScale','log','xTick',[0.1 1],'xTickLabel',{'0.1', '1'});
    axis([.04 1 -.5 4]);
    box off;
    
    ax = gca; % get the current axis
    ax.Clipping = 'off';
    ax.FontSize = 12;
    xlabel('log Contrast');
    ylabel('dprime');
end
title(modelName);
