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

    Where:

    ID is the numerical id of the body in the solar system (0 = sun, 1 =
    mercury, 3 = earth...)
    X,Y,Z are the X,Y,Z coordinates of the body relative to the Solar System
    Barycenter.

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
    Note: the stray curly brackets you may find commented out, which aren't
    block quotes, are used for vim folding. This makes the file formatted
    nicely in vim, and can help break up the different parts of the file.
%}

    
%{ A NOTE TO THE DEVELOPER:
If you're getting errors, make sure you're not mixing up ON and BY in the
force array. That can be the confusing part.

NOTES: run program for 1 year, earth should be at starting point! or use
the website to find out where it should be exactly

TODO:
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
    

% Helpful Constants {

AU=149597870.691E3; % meters per Astronomical Unit
G=6.674E-11; % N-m^2/kg^2

% } end Helpful Constants

% Initial Data Setup {

NUM_BODIES = 3; %number of astronomical bodies to compute for.

% convert ending_time in days to seconds
ending_time = ending_time * 24 * 60 * 60; % how long to simulate (SECONDS)
time=0;

system = zero(NUM_BODIES, 11);
forces = zero(NUM_BODIES);

% Planetary Starting Values {

% NOTE: VALUES MUST BE ENTERED IN AU AND AU/DAY. They will be converted as
% such below.

% Body 1: Sun (SOL) {
    %ID
    system(1,1) = 0;

    % X
    system(1,2) = -4.173780072034275E-03; 

    % Y
    system(1,3) = 7.099593014214438E-04;

    % Z
    system(1,4) = 1.604504857505994E-05;

    % VX
    system(1,5) = 1.604504857505994E-05;

    % VY
    system(1,6) = -6.168298835870542E-06;

    % VZ
    system(1,7) = -8.099453361184341E-09;

    %MASS
    system(1,11) = 1.9891E30; % kg 

% } end Body 1: Sun

% Body 2: Earth {
    %ID
    system(2,1) = 3;

    % X
    system(2,2) = -1.757691570699245E-01; 

    % Y
    system(2,3) = 9.689784107710354E-01;

    % Z
    system(2,4) = -8.071357286641453E-06;

    % VX
    system(2,5) = -1.722543139856719E-02;

    % VY
    system(2,6) = -3.069797666532440E-03;

    % VZ
    system(2,7) = -4.254847485630660E-07;

    %MASS
    system(2,11) = 5.9736E24; % kg 

% } end Body 2: Earth

% Body 3: Jupiter {
    %ID
    system(3,1) = 5;

    % X
    system(3,2) = 4.901953649524238;

    % Y
    system(3,3) = 6.492361425410386E-01;

    % Z
    system(3,4) = -1.124667705413734E-01;

    % VX
    system(3,5) = -1.081844011900388E-03;

    % VY
    system(3,6) = 7.839399858800254E-03;

    % VZ
    system(3,7) = -8.404735693140495E-06;

    %MASS
    system(3,11) = 1898.13E24; % kg 

% } end Body 3: Jupiter

% Convert Units {

% positions in AU -> Meters
% AU * m/AU = m
system(:,[2:4]) = system(:,[2:4]) .* AU; 

% positions in AU/days -> meters/second
% AU/day * ( (m/AU) / (seconds/day) ) = m/s
system(:,[5:7]) = system(:,[5:7]) .* (AU / (24 * 60 * 60)); 

% }

% } end Planetary Starting Values

% } end Initial Data Setup

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

% vim:tw=76 fdm=marker fmr={,}
