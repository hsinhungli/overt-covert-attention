function Kernel = makeSKernel(x,theta,IxWidth,ytau,plotKernel)

if nargin<4
    plotKernel=0;
end

[X,Y] = meshgrid(x,theta);
X = X-mean(X(:));
Y = Y-mean(Y(:));

Y = exp(-abs(Y)/ytau)*IxWidth;
wX = normpdf(X,zeros(size(X)),Y);
Kernel = wX./repmat(max(wX,[],2),[1 numel(x)]);
Kernel = Kernel/sum(Kernel(:));

if plotKernel == 1
    figure;
    imagesc(x,theta,Kernel);
    set(gcf,'color','w');
end

end

% Test
% theta = -90:90;
% x = -30:30;
% ytau = 20;
% IxWidth = 10;