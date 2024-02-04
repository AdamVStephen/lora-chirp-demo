% LoRa Chirp demo ref https://www.youtube.com/watch?v=jHWepP1ZWTk&t=1178s
SF=7; % Spreading Factor
BW=1000; % BandWidth
Fs = 1000; %Sampling Frequency
%s = 33 ; %send symbol '10'
s = 33;
SNR = -12; % Signal to Noise Ratio

% Generate a data symbol
num_samples = (2^SF)*Fs/BW;
k = s; % add s to k to start
lora_symbol = zeros(1,num_samples);
for n=1:num_samples
if k>=(2^SF)
    k = k - 2^SF;
end
k =k + 1;
lora_symbol(n) = (1/(sqrt(2^SF)))*exp(1i*2*pi*(k)*(k/(2^SF*2)));
end

for j=1:100000
    % Add noise
    lora_symbol_noisy = awgn(lora_symbol, SNR, 'measured');

    % Generate the base down chirp
    base_down_chirp = zeros(1,num_samples);
    k=0;
    for n=1:num_samples
        if k>= (2^SF)
            k = k - 2^SF;
        end
        k = k +1;
        base_down_chirp(n) = (1/(sqrt(2^SF)))*exp(-1i*2*pi*(k)*(k/(2^SF*2)));
    end

    dechirped = lora_symbol_noisy.*(base_down_chirp);
    corrs = (abs(fft(dechirped)).^2);
    %plot(corrs);
    [~,ind] = max(corrs);
    ind2(j) = ind;
    %pause(0.01);
end
histogram(ind2,2^SF);
symbol_error_rate = sum(ind2~=s+1)/j;
