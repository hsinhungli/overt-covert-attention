function patch = makePatch(space,center,width,height)

patch = abs(space-center) - width/2 <.5; %modify this if one sets higher resolution.

if nargin==4
  patch = patch*height;
end


end
