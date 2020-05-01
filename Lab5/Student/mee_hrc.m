

%--------------------------------------------------------------------------
% Multipath error envelope
% spacing : early-late spacing in chips
%--------------------------------------------------------------------------

%% initialize multipath delay and error
delay = 0:0.01:2;
multipath_error_c = zeros(1,length(delay));
multipath_error_d = zeros(1,length(delay));

%% compute the discriminator function
for jj = 1:length(delay)
    
    discr_c = hrc_discriminator(settings,delay(jj),0);       % constructive multipath
    discr_d = hrc_discriminator(settings,delay(jj),pi); % destructive multipath
    multipath_error_c(jj) = compute_multipath_error(settings,discr_c);
    multipath_error_d(jj) = compute_multipath_error(settings,discr_d);

end

%% plot the multipath error envelope

lambda_L1 = 3e8/1.023e6;

plot(delay*lambda_L1,multipath_error_c,'LineWidth',2)
hold on;
plot(delay*lambda_L1,multipath_error_d, 'LineWidth',2)
grid on;
% Create axes labels
xlabel('Multipath Delay [m]');
ylabel('Multipath Code Error [m]');

        