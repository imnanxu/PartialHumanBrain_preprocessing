function [ data_reg] = regressor( data, reg )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[n_vox, n_time] = size(data);
data_reg = zeros(size(data));

for i = 1:n_vox
   data_i = data(i,:);
   b = glmfit(data_i, reg);
   data_reg(i,:) =  data_i - b(1)*reg;
end



end

