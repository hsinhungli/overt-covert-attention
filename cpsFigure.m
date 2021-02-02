function h = cpsFigure(width,height,num)
%cpsFigure(widthscale, heightscale)
Idx = exist('num','var');
if Idx
    h = figure(num);
else
    h = figure;
end

%set(h,'DefaultAxesLooseInset',[0,0,0,0]);
Position = get(h,'Position');
Position(3) = width*Position(3);
Position(4) = height*Position(4);
set(h,'Position', Position,'color','w');
set(h,'PaperPosition', [0 0 width height]*10,'color','w');

% cm =[0.0498    0.4586    0.8641
%     0.0343    0.5966    0.8199
%     0.0843    0.6928    0.7062
%     0.3482    0.7424    0.5473
%     0.6834    0.7435    0.4044
%     0.9450    0.7261    0.2886];
    
%co = get(gca,'ColorOrder'); % Initial
% Change to new colors.
%set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
%co = get(gca,'ColorOrder'); % Verify it changed

%h=fig('units','inches','width',7,'height',2,'font','Helvetica','fontsize',16)
%set(h,'DefaultAxesLooseInset',[0,0,0,0]);
