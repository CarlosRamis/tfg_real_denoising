function plot_NLF(NLF, filter)
    
    if filter
        fc = 0.03;
        fs = 3;
        NLF = filter_NLF(NLF, fc, fs);
    end
    
    figure, 
%     plot(NLF(1:256),'r','LineWidth',3), hold on, grid on
%     plot(NLF(257:512),'g','LineWidth',3), hold on 
    plot(NLF(513:768),'b','LineWidth',3), grid on

end