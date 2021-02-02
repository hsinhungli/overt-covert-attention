function attnGain = getattnGain(x,theta,varargin)
%Generate attentional gain factors based on FS model in Li, Carrasco and Heeger, 2015 wPlos Computaitonl Biology.

for index = 1:2:length(varargin)
    field = varargin{index};
    val = varargin{index+1};
    switch field
        case 'Ax'
            Ax = val;
        case 'Atheta'
            Atheta = val;
        case 'AxWidth'
            AxWidth = val;
        case 'Abase'
            Abase = val;
        case 'AMag'
            AMag = val;
        case 'p'
            p = val;
        case 'k'
            k = val;
        case 'PlotAttn'
            PlotAttn = val;
        otherwise
            warning(['getattnGain: invalid parameter: ',field]);
    end
end

if notDefined('Ax')
    Ax = NaN;
end
if notDefined('Atheta')
    Atheta = NaN;
end
if notDefined('AxWidth')
    AxWidth = 4;
end
if notDefined('Abase')
    Abase = 1;
end
if notDefined('AMag')
    AMag = 1;
end
if notDefined('p')
    p = 1;
end
if notDefined('k')
    k = 1;
end
if notDefined('PlotAttn')
    PlotAttn = 0;
end

if isnan(Ax)
    attnGainX = zeros(size(x));
else
    attnGainX = (1/((AxWidth^p)*(2*pi)^.5))*exp(-(x-Ax).^2/(2*AxWidth^2));
end
if isnan(Atheta)
    attnGainTheta = zeros(size(theta))+ Abase;
    Atheta = 0;
else
    attnGainTheta = makeVM(theta, 0, k);
    attnGainTheta = attnGainTheta-.5;
end

impulse  = (theta == Atheta);
tmp      = impulse * attnGainX;
attnGain = conv2sepYcirc(tmp,1,attnGainTheta);
attnGain = attnGain*AMag + Abase;
attnGain = max(attnGain,0);

if PlotAttn ==1
    figure;
    subplot(4,4,1:3)
    plot(x,attnGainX);

    impulse = double(theta == Atheta);
    temp = conv2sepYcirc(impulse,[1],attnGainTheta);
    Idx = [8 12 16];
    subplot(4,4,Idx)
    %temp = attnGain(:,round(numel(x)/2));
    plot(temp,theta);
    set(gca,'YDir','reverse');
    ylim([min(theta) max(theta)]);
    %xlim([ceil(min(temp) ceil(max(temp))]);
    Idx = [5 6 7 9 10 11 13 14 15];

    subplot(4,4,Idx)
    imagesc(x,theta,attnGain,[0 2]);
    xlabel('Position');
    ylabel('Orientation');
    text(min(x),max(theta)*.9,[num2str(max(attnGain(:))) '  ' num2str(min(attnGain(:)))],'FontSize',16,'Color',[1 1 1]);
    set(gcf,'color','w');
end
end
