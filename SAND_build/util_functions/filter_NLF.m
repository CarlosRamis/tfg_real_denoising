function NLF_f = filter_NLF(NLF, fc, fs)
    % fc --> Cut off frequency
    % fs --> Sampling rate
    NLF(isnan(NLF))=0;

    [B,A] = butter(1,fc/(fs/2)); % designs a lowpass filter.
    NLF_f = filter(B,A,NLF);

end