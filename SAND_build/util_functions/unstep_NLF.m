function NLF_nostep = unstep_NLF(NLF_step, step)
    
    for i = 1:length(NLF_step)
        NLF_nostep(i*step-step + 1:i*step) = NLF_step(i);
    end
end