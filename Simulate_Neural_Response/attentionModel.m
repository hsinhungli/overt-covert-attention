function p = attentionModel_is(p, cond, attentionType)

ss = 1;
output_baseline = 0;

switch attentionType
    case 'NMA'
        
        % Stimuulus drive
        %p.Eraw = halfExp(conv2sepYcirc(p.i,p.ExKernel,p.EthetaKernel),p.p);
        p.Eraw = halfExp(conv2sepYcirc(p.i.^p.p, p.ExKernel, p.EthetaKernel), 1);
        p.E    = p.attnGain{cond}.* p.Eraw;
        
        % Suppressive drive
        %p.I = conv2(p.IKernel,[repmat(p.E,3,1)*0 repmat(p.E,3,1) repmat(p.E,3,1)*0],'same');
        p.I = conv2sepYcirc(p.E, p.IxKernel, p.IthetaKernel);
        
    case 'RG'
        
        % Stimuulus drive
        p.Eraw = halfExp(conv2sepYcirc(p.i.^p.p, p.ExKernel, p.EthetaKernel), 1);
        p.E    = p.attnGain{cond}.* p.Eraw;
        
        % Suppressive drive
        p.I = conv2sepYcirc(p.Eraw, p.IxKernel, p.IthetaKernel);
        
    case 'CG'
        
        % Stimuulus drive
        p.Eraw = halfExp(conv2sepYcirc(p.i.^p.p, p.ExKernel, p.EthetaKernel), 1);
        p.E = p.Eraw;
        
        % Suppressive drive
        p.I = conv2sepYcirc(p.Eraw, p.IxKernel, p.IthetaKernel);
        ss =  p.attnGain{cond};
        
    case 'IB'
        
        % Stimuulus drive
        p.Eraw = halfExp(conv2sepYcirc((p.i+(p.attnGain{cond}-1)).^p.p, p.ExKernel, p.EthetaKernel), 1);
        %p.Eraw = halfExp(conv2sepYcirc(p.i.^p.p, p.ExKernel, p.EthetaKernel) + (p.attnGain{cond}-1), 1);
        p.E    = p.Eraw;
        
        % Suppressive drive
        p.I = conv2sepYcirc(p.E, p.IxKernel, p.IthetaKernel);
        
    case 'OB'
        % Stimuulus drive
        p.Eraw = halfExp(conv2sepYcirc(p.i.^p.p, p.ExKernel, p.EthetaKernel), 1);
        p.E    = p.Eraw;
        
        % Suppressive drive
        p.I = conv2sepYcirc(p.E, p.IxKernel, p.IthetaKernel);
        output_baseline = p.attnGain{cond}-1;
end

p.R = p.E ./ ((p.I + halfExp(p.sigma./ss, p.p))) + output_baseline;
