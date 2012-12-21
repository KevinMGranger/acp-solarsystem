function nrghalf

timestep = 24*60*60*365;
timesteps(1) = timestep;

errors(1) = solar_system(365*300,timestep)

while (timestep > 24*60*30)
	timestep = timestep / 2
    timesteps(end+1) = timestep;
	errors(end+1) = solar_system(365*300,timestep);
	fprintf('Fractional error = %f\n', errors(end));
	frac_error_change = (errors(end) / errors(end-1));
	fprintf('Change in Frac Error = %f\n', frac_error_change);
end

plot(timesteps,errors);