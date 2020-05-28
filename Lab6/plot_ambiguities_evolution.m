function [i] = plot_ambiguities_evolution(int_ambiguity_matrix, WL_IF_ambiguity_matrix,i)
%% Load parameters
Lab6Params;

figure(i);
plot(reshape(int_ambiguity_matrix(:,1,:), [7,137])');
legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
title("Integer ambiguity of double differenced over time for E1 frequency")
xlabel("Epoch")
ylabel("Ambiguity")

i = i+1;
figure(i);
plot(reshape(int_ambiguity_matrix(:,2,:), [7,137])');
legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
title("Integer ambiguity of double differenced over time for E2 frequency")
xlabel("Epoch")
ylabel("Ambiguity")

i = i+1;

figure(i);
reshaped_matrix(:,1,1) = (reshape(WL_IF_ambiguity_matrix(6,1,:), [1,137])').*(F2/c);
plot(reshaped_matrix, 'o');
%plot(reshape(WL_IF_ambiguity_matrix(6,1,:), [1,137])');
%legend(string(all_sats_nb(find(all_sats_nb~=base_sat_nb))))
title("Wide Lane ambiguity evolution")
xlabel("Epoch")
ylabel("Wide Lane ambiguity[cycles]")

i = i+1;

