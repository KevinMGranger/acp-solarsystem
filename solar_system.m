function solar_system(ending_time, time_step)

DESCRIPTION
    Simulate the motion of 3 bodies in a 3D solar system.
    
ARGUMENTS
    ending_time : the duration of the simulation, in DAYS

    timestep : the timestep used in the numerical integration, in SECONDS

MATHEMATICS
    The program uses ____ Euler's Method, first order. This means

VARIABLE NAMING

AUTHOR
    Kevin Granger <kmg2728@rit.edu>
    2012-12-21

    

    
    
    
    
% NOTES: run program for 1 year, earth should be at starting point! or use
% the website to find out where it should be exactly
    
    
% Helpful Constants

AU=149597870.691E3; % meters

% Set up initial data

NUM_BODIES = 3; %number of astronomical bodies to compute for.


% Body 1: Sun (SOL)
% Body 2: Earth
% Body 3: Jupiter
