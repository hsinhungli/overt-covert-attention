function [pc, dprime, c, hitrate, farate, ntrl, condIdx] = getdprime(condIdx,triallabel,response,doBootStrapp)
% condIdx: trial to included
% triallabel: present or absent trial (1 present; 0 absent)
% response: observer said yes or no (1 yes; 0 no)

if ~exist('doBootStrapp','var')
    doBootStrapp = 0;
end

if doBootStrapp==1
    condIdx   = find(condIdx);
    ntrl      = length(condIdx);
    randomIdx = randi([1 ntrl],ntrl,1);
    condIdx   = condIdx(randomIdx);
else
    ntrl     = sum(condIdx);
end
%keyboard;
npresent = sum(triallabel(condIdx) == 1);
nabsent  = sum(triallabel(condIdx) == 0);
nhit     = sum(triallabel(condIdx) == 1 & response(condIdx) == 1);
nfa      = sum(triallabel(condIdx) == 0 & response(condIdx) == 1);

pc = sum(triallabel(condIdx)==response(condIdx)) / ntrl;

if npresent==0
    dprime  = NaN; 
    hitrate = NaN;
    farate  = NaN;
    c = NaN;
    if doBootStrapp==0
        %fprintf('!! no present trials !!\n');
    end
end
if nabsent==0
    dprime  = NaN; 
    farate  = NaN;
    hitrate = NaN;
    c = NaN;
    if doBootStrapp==0
        %fprintf('!! no absent trials !!\n');
    end
end
if npresent~=0 && nabsent~=0
    hitrate = nhit / npresent;
    farate  = nfa / nabsent;
    
    nhit = min(max(nhit,0.5), npresent-.5);
    nfa = min(max(nfa,0.5), nabsent-.5);
    
    temp_hitrate = nhit / npresent;
    temp_farate  = nfa / nabsent;
    dprime = norminv(temp_hitrate)-norminv(temp_farate);
    c = -.5*(norminv(temp_hitrate)+norminv(temp_farate));
end