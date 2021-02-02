function y = makeVM(input, cCenter, k)

input = input/180*pi;
cCenter = cCenter/180*pi;
y = exp(k*(cos(2*(input-cCenter))-1));