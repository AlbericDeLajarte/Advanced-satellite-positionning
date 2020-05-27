function rho = compute_range_sat(x_receiver, x_sat)

nb_of_sat = length(x_sat);
rho = zeros(nb_of_sat, 1);

for k = 1:nb_of_sat

    rho(k) = norm(x_receiver-x_sat(k, :));
end


end
