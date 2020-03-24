%  Advanced Satellite Positioning - Lab 3 Task 1

% Step 1: Compute PRN codes using generateCAcode()
CA_code_4 = generateCAcode(4);
CA_code_12 = generateCAcode(12);


% Step 2: Compute and plot circular auto correlation for PRN 12

auto_corr_12 = computeCorrelation(CA_code_12, CA_code_12);
figure(1);
plot(0:length(auto_corr_12)-1, auto_corr_12);
xlabel("Shift"); ylabel("correlation");
title("Auto correlation of PRN number 12");


% Step 3: Compute and plot circular cross correlation for PRN 12 and PRN 4

cross_corr_12_4 = computeCorrelation(CA_code_12, CA_code_4);
figure(2);
plot(0:length(cross_corr_12_4)-1, cross_corr_12_4);
xlabel("Shift"); ylabel("correlation");
title("Cross correlation of PRN number 12 and 4");