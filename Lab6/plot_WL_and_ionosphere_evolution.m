function [fig_nb] = plot_WL_and_ionosphere_evolution(WL_IF_ambiguity_matrix,Iono_delay_matrix,sats_nb,base_sat_nb,fig_nb)
%{
    This function plots the evolutions of the Wide Lane ambiguities, and
    the Ionospheric delay, for each pair of satellite b-k, over all epochs.
%}
for k = 1:length(sats_nb)
    figure(fig_nb);
    subplot(2,1,1);
    reshaped_matrix(:,1,1) = (reshape(WL_IF_ambiguity_matrix(k,2,:), [1,137])');%.*(F2/c);
    plot(reshaped_matrix, 'o');
    title(strcat("Wide Line ambiguity evolution for PRNs ", string(base_sat_nb+"-"+sats_nb(k))))
    xlabel("Epoch")
    ylabel("Wide Lane ambiguity[m]") % [cycles]
    
    subplot(2,1,2);
    plot(Iono_delay_matrix(k,:)', 'o');
    %legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
    title(strcat("Ionosphere delay over time for PRNs ",string(base_sat_nb+"-"+sats_nb(k))))
    xlabel("Epoch")
    ylabel("Ionosphere delay[m]")
    grid on;
    fig_nb = fig_nb+1;
    hold all
end