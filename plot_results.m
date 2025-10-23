%% ===================== VE BIEU DO =====================
% Ve cot so sanh cac phuong phap theo EQM va STD

function plot_results(STD_all, EQM_all)
    figure;
    bar(STD_all);
    set(gca,'XTickLabel',[ 'CC    '; 'ROTH  '; 'SCOT  '; 'Eckart'; 'PHAT  '; 'HT    ']);
    xlabel('Phuong phap'); ylabel('STD (mau)');
    title('So sanh do on dinh STD giua cac phuong phap');

    figure;
    bar(EQM_all);
    set(gca,'XTickLabel',[ 'CC    '; 'ROTH  '; 'SCOT  '; 'Eckart'; 'PHAT  '; 'HT    ']);
    xlabel('Phuong phap'); ylabel('EQM (mau^2)');
    title('So sanh sai so binh phuong EQM giua cac phuong phap');
end
