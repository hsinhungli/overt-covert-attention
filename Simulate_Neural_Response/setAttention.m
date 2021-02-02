function p = setAttention(cond,p)

PlotAttn = 0;
p.Atheta  = [];
p.Ax = 0;

switch cond
    
    case 1 %Neutral
        %p.Ax = -8;
        
        %attnGain_end_left = getattnGain(p.x,p.theta,'Ax',p.Ax,'AxWidth',p.AxWidth,'Atheta',p.Atheta,...
        %    'k',p.ak,'AMag',p.wa_neutral,'p',p.ap,'PlotAttn',PlotAttn);
        attnGain_end_right = getattnGain(p.x,p.theta,'Ax',p.Ax,'AxWidth',p.AxWidth,'Atheta',p.Atheta,...
            'k',p.ak,'AMag',p.wa_neutral,'p',p.ap,'PlotAttn',PlotAttn);
        
        %p.attnGain_end{cond} = attnGain_end_right + attnGain_end_left - 1;
        p.attnGain_end{cond} = attnGain_end_right;
        
    case 2 %Saccade Toward
        attnGain_end_toward = getattnGain(p.x,p.theta,'Ax',p.Ax,'AxWidth',p.AxWidth,'Atheta',p.Atheta,...
            'k',p.ak,'AMag',p.wa_toward,'p',p.ap,'PlotAttn',PlotAttn);
        
        %p.Ax = -8;
        %p.Atheta  = [];
        %attnGain_end_away = getattnGain(p.x,p.theta,'Ax',p.Ax,'AxWidth',p.AxWidth,'Atheta',p.Atheta,...
        %    'k',p.ak,'AMag',p.wa_away,'p',p.ap,'PlotAttn',PlotAttn);
        
        %p.attnGain_end{cond} = attnGain_end_toward + attnGain_end_away - 1;
        p.attnGain_end{cond} = attnGain_end_toward;
        
    case 3 %Saccade Away
        attnGain_end_away = getattnGain(p.x,p.theta,'Ax',p.Ax,'AxWidth',p.AxWidth,'Atheta',p.Atheta,...
            'k',p.ak,'AMag',p.wa_away,'p',p.ap,'PlotAttn',PlotAttn);
        
        p.attnGain_end{cond} = attnGain_end_away;
end

p.attnGain{cond} = p.attnGain_end{cond};

end