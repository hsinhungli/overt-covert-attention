function band = makeBand(space,center,width,height)

band = abs(space-center)<width/2; %modify this if one sets higher resolution.

if nargin==4
  band = band*height;
end

