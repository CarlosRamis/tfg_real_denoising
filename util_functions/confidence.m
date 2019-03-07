function [IC_low, IC_high] = confidence (sample ,mean, std, alpha)

    z = norminv(1 - alpha/2);
    N = length(sample);

    IC_low = mean - std*z/sqrt(N-1);
    IC_high = mean + std*z/sqrt(N-1);

end