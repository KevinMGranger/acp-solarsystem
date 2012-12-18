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
GRAVITATION=6.674E-11; % N-m^2/kg^2

% Set up initial data

NUM_BODIES = 3; %number of astronomical bodies to compute for.

% convert ending_time in days to seconds
ending_time = ending_time * 24 * 60 * 60; % how long to simulate (SECONDS)
time=0;

system = zero(NUM_BODIES, 11);

% NOTE: CURRENT VALUES ARE IN ASTRONOMICAL UNITS AND AU/DAY. DECIDE UPON
% CHANGING SCHEME.
% Below the values are their expected final values after 300 years with
% stepsize 1 year
% Body 1: Sun (SOL)
    %ID
    system(1,1) = 0;

    % X
    system(1,2) = -4.173780072034275E-03; 
    % 4.012052324571806E-03

    % Y
    system(1,3) = 7.099593014214438E-04;
    % 2.671699098901946E-04

    % Z
    system(1,4) = 1.604504857505994E-05;
    % -1.548133498090957E-04

    % VX
    system(1,5) = 1.604504857505994E-05;
    % 4.836696226290300E-06

    % VY
    system(1,6) = -6.168298835870542E-06;
    % 3.605199673273765E-06

    % VZ
    system(1,7) = -8.099453361184341E-09;
    % -1.025046008492170E-07

    %MASS
    system(1,11) = 1.9891E30 % kg 
% Body 2: Earth
% Body 3: Jupiter


Main method of the program PSEUDOCODE:

START
tic
calc init energy
toc, step1time

tic
for time=0:timestep:ending_time
	for each planet: (i)
		for each planet: (j)
			if i = j
				SKIP
			else if i < j
				calculate forces
			else if i > j
				force = - negative of alread-calculated force!
			end
		end
		acceleration(s)
		velocitie(s)
		position(s)
		print new values
		graph array storage
	end
%for documentation later: moving a planet when others are depending upon it
%for calculation? GASP! No, actually! Since it checks if the force has
%already been calculated, the new values dont' come in to play until the
%next time step!
end
toc, step2time

tic
calc final energy
ouptut change in energy
toc, stage3time

END. DONSKIES.

% vim:tw=76
