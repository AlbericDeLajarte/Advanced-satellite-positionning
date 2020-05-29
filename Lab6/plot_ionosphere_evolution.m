function [fig_nb] = plot_ionosphere_evolution(Iono_delay_matrix,sats_nb,base_sat_nb,fig_nb)

Lab6Params;

for k = 1:length(sats_nb)
    figure(fig_nb);
    plot(Iono_delay_matrix(k,:)', 'o');
    %legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
    title(strcat("Ionosphere delay over time for PRNs ",string(base_sat_nb+"-"+sats_nb(k))))
    xlabel("Epoch")
    ylabel("Ionosphere delay[m]")
    grid on;
    fig_nb = fig_nb+1;
end
