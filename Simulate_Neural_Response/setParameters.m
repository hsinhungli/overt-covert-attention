function p = setParameters

p.x             = -10:.5:10;             %sampling of space (rel to the target)
p.nx            = numel(p.x);
p.theta         = (-90:90)';             %sampling of orientation
p.ntheta        = numel(p.theta); 
p.ExWidth       = 1;                     %width of spatial excitatory field
p.EthetaWidth   = 20;                    %width of orientation excitatory field
p.IxWidth       = p.ExWidth*4;           %width of local spatial suppressive field
%p.IKernel_exp   = 20;                    %orientation-dependent decay of spatial suppressive field 
                 

% Stimuli
p.c              = 9;   
p.stimCenter     = 0;
p.stimthetaWidth = 2;
p.stimWidth = 1;

p.stimCenter_distractor     = 3.5;
p.stimWidth_distractor = .2;
p.stimOrientation_distractor = 30;

% Attention-related parameters
p.ak          = nan; %Width of FBA

% Excitatory field and Supressive field
p.ExKernel     = makeGaussian(p.x,0,p.ExWidth);
p.IxKernel     = makeGaussian(p.x,0,p.IxWidth);
p.IthetaKernel = makeGaussian(p.theta,0,360);
p.EthetaKernel = makeGaussian(p.theta,0,p.EthetaWidth);
%p.IKernel      = makeSKernel(p.x,p.theta,p.IxWidth,p.IKernel_exp,0);
%p.IKernel      = repmat(p.IxKernel,p.ntheta,1);

end