function [i] = plot_ionosphere_evolution(Iono_delay_matrix,i)

Lab6Params;

figure(i);
plot(Iono_delay_matrix');
legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
title("Ionosphere delay over time")
xlabel("Epoch")
ylabel("Ionosphere delay[m]")

i = i+1;
