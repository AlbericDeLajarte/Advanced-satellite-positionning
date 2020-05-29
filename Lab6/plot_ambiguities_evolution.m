function [fig_nb] = plot_ambiguities_evolution(WL_IF_ambiguity_matrix, sats_nb, base_sat_nb, fig_nb)
%% Load parameters
Lab6Params;

%{
figure(fig_nb);
plot(reshape(int_ambiguity_matrix(:,1,:), [7,137])');
legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
title("Integer ambiguity of double differenced over time for E1 frequency")
xlabel("Epoch")
ylabel("Ambiguity")

fig_nb = fig_nb+1;
figure(fig_nb);
plot(reshape(int_ambiguity_matrix(:,2,:), [7,137])');
legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
title("Integer ambiguity of double differenced over time for E2 frequency")
xlabel("Epoch")
ylabel("Ambiguity")

fig_nb = fig_nb+1;
%}
%for k = 1:length(sats_nb)
k = 6; % sat 24
    figure(fig_nb);
    reshaped_matrix(:,1,1) = (reshape(WL_IF_ambiguity_matrix(k,2,:), [1,137])');%.*(F2/c);
    plot(reshaped_matrix, 'o');
    %plot(reshape(WL_IF_ambiguity_matrix(6,1,:), [1,137])');
    %legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
    title(strcat("Wide Line ambiguity evolution for PRNs ", string(base_sat_nb+"-"+sats_nb(k))))
    xlabel("Epoch")
    ylabel("Wide Lane ambiguity[m]") % [cycles]
    grid on;
    fig_nb = fig_nb+1;
%end

