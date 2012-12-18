function solar_system(ending_time, time_step)
%
%DESCRIPTION
%    Simulate the motion of 3 bodies in a 3D solar system.
%    
%ARGUMENTS
%    ending_time : the duration of the simulation, in DAYS
%
%    timestep : the timestep used in the numerical integration, in SECONDS
%
%MATHEMATICS
%    The program uses Symplectic Euler's Method, first order. This means that
%    all forces are found for a specified object, these values are used to
%    find an acceleration, which is used to find a new velocity. This new
%    velocity is used to determine the new position. Repeat ad infintium, or
%    until your specified conditions are met.
%
%AUTHOR
%    Kevin Granger <kmg2728@rit.edu>
%    2012-12-21


%{ Documentation not necessary for 'help'
VARIABLE NAMING
    All data about the simulated bodies' motion (aside from forces) will be
    kept in a single array, in order to make accessing the data in loops
    easier. Each row in the array is a different object. The values are
    then broken down as follows:

    1   2  3  4  5   6   7   8   9   10  11
    ID  x  y  z  vx  vy  vz  ax  ay  az  mass 

    Forces are kept in a separate array to make visualizing the
    calculations easier. Visualize it as such:

    force(ON,BY)

    Where ON and BY are body numbers.
    This means that we'll end up with a triangular-looking matrix! This is
    resolved when the force calculation loops detect that the force has
    already been calculated for the particular body pair. This is explained
    in greater detail near the relevant loop.

DESIGN GOALS
    Make the program scale flawlessly, clearly and concisely, no matter the
    number of bodies or their position in the solar system.
%}

    
%{
A NOTE TO THE DEVELOPER:
If you're getting errors, make sure you're not mixing up ON and BY in the
force array. That can be the confusing part.

TODO:
	DECIDE: do I want to convert seconds to au/day, or vice-versa?
	look up how to do operations on ranges (do all accelerations in 1
	step)
	or perhaps make it an array of arrays?
	make sure graphing is working properly! no squishies!
ASK: 	what do you mean by "view from above the earth's plane?" graph of
all planets relative to earth, from above?
	bells and whistles:
		5. how close am I to JPL values?
		4. jupiter modification
		2. do analysis on change in momentums
ASK:	over course of simulation? beginning and end, or for each timestep?
		1. extend for all planets (including dwarf ones)
		3. convert for more accurate method, increase sim time

%}
    
    
    
% NOTES: run program for 1 year, earth should be at starting point! or use
% the website to find out where it should be exactly
    
    
% Helpful Constants

AU=149597870.691E3; % meters

% Set up initial data

NUM_BODIES = 3; %number of astronomical bodies to compute for.


% Body 1: Sun (SOL)
% Body 2: Earth
% Body 3: Jupiter
