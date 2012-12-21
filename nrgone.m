function nrgone


timestep = 24*60*60;
upper_timestep = timestep;
lower_timestep = 0;

tries = 0;
while (tries < 20)
    frac = solar_system(365*300,timestep)
    fprintf('With timestep %f, fractional error = %f\n', timestep, frac);
    if (frac > 0.01)
        upper_timestep = timestep;
        timestep = (upper_timestep + lower_timestep) / 2;
    elseif (frac < 0.01)
        lower_timestep = timestep;
        timestep = (upper_timestep + lower_timestep) / 2;
    end
    tries = tries + 1
end
