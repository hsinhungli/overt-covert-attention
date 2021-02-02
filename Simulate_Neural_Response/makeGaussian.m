function gaussian = makeGaussian(space,center,width,height)
%
% gaussian = makeGaussian(space,center,width,[height])
%
% This is a function creates gaussian centered at "center", 
% over the values defined by vector "space".  
%
% width is the standard deviation of the gaussian
%
% height, if specified is the height of the peak of the gaussian.
% Otherwise, it is scaled to unit volume

plot_figure = 0;

if numel(center) ==1
gaussian = normpdf(space,center,width); %original code
else %code for superimposed stimuli
    gaussian = zeros(size(space));
    for i = 1:numel(center)
        temp = normpdf(space,center(i),width); 
        gaussian = gaussian + temp;
    end
end

if nargin == 4
  gaussian = height * width * sqrt(2*pi) * gaussian;
end

if plot_figure == 1
    figure; plot (space,gaussian)
end
