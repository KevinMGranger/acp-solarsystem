function [frac_nrg] = solar_system(ending_time, time_step)
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

% Additional Documentation (not maintained in an info page) {
%{
Documentation not necessary for 'help'
VARIABLE NAMING
    All data about the simulated bodies' motion (aside from forces) will be
    kept in a single array, in order to make accessing the data in loops
    easier. Each row in the array is a different object. The values are
    then broken down as follows:

    1   2  3  4  5   6   7   8   9   10  11    12  13  14
    ID  x  y  z  vx  vy  vz  ax  ay  az  mass  fx  fy  fz

    Where:

    ID is the numerical id of the body in the solar system (0 = sun, 1 =
    mercury, 3 = earth...)
    X,Y,Z are the X,Y,Z coordinates of the body relative to the Solar
    System Barycenter.
    VX,VY,VZ are the X,Y,Z, components of the velocity vector of the body
    in question.
    AX,AY,AZ are the X,Y,Z, components of the acceleration vector of the
    body in question.
    FX,FY,FZ are the X,Y,Z, components of the net force on the body in
    question.


    The main net forces(s) are kept in a separate array to make calculating
    and visualizing these forces easier. They are they translated into the
    components in the next step.
    
    The main net force array is composed as such:

    forces(ON,BY)

    Where ON and BY are body numbers.
    
    Force calculations are explained in greater detail near the relevant
    loop.


    Arrays for graphing are descriptively named. For example, earthy is the
    array of the earth's Y positions over the course of the simulation.

DESIGN GOALS
    Make the program scale flawlessly, clearly and concisely, no matter the
    number of bodies or their position in the solar system.
    
    Note: the stray curly brackets you may find commented out, which aren't
    block quotes, are used for vim folding. This makes the file formatted
    nicely in vim, and can help break up the different parts of the file.
%}
% }

    
%{
TODO:
	make sure graphing is working properly! no squishies!
ASK: 	what do you mean by "view from above the earth's plane?" graph of
all planets relative to earth, from above?
	bells and whistles:
		5. how close am I to JPL values?
		4. jupiter modification
		2. do analysis on change in momentums
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

% declare some variables and pre-allocate some for size
forces = zeros(NUM_BODIES);
solarsys = zeros(NUM_BODIES,14);
sunx = [];
suny = [];
sunz = [];
sunvel = [];
earthx = [];
earthy = [];
earthz = [];
jupx = [];
jupy = [];
jupz = [];

    
% Planetary Starting Values {

% All values below are in AU for positions, and AU/day for velocities.
% Masses are in kg.

% Body 1: Sun (SOL) {
    %ID
    solarsys(1,1) = 0;

    % X
    solarsys(1,2) = -4.173780072034275E-03; 

    % Y
    solarsys(1,3) = 7.099593014214438E-04;

    % Z
    solarsys(1,4) = 1.604504857505994E-05;

    % VX
    solarsys(1,5) = 8.230492550577723E-07;

    % VY
    solarsys(1,6) = -6.168298835870542E-06;

    % VZ
    solarsys(1,7) = -8.099453361184341E-09;

    %MASS
    solarsys(1,11) = 1.9891E30; % kg 

% } end Body 1: Sun

% Body 2: Earth {
    %ID
    solarsys(2,1) = 3;

    % X
    solarsys(2,2) = -1.757691570699245E-01; 

    % Y
    solarsys(2,3) = 9.689784107710354E-01;

    % Z
    solarsys(2,4) = -8.071357286641453E-06;

    % VX
    solarsys(2,5) = -1.722543139856719E-02;

    % VY
    solarsys(2,6) = -3.069797666532440E-03;

    % VZ
    solarsys(2,7) = -4.254847485630660E-07;

    %MASS
    solarsys(2,11) = 5.9736E24; % kg 

% } end Body 2: Earth

% Body 3: Jupiter {
    %ID
    solarsys(3,1) = 5;

    % X
    solarsys(3,2) = 4.901953649524238;

    % Y
    solarsys(3,3) = 6.492361425410386E-01;

    % Z
    solarsys(3,4) = -1.124667705413734E-01;

    % VX
    solarsys(3,5) = -1.081844011900388E-03;

    % VY
    solarsys(3,6) = 7.839399858800254E-03;

    % VZ
    solarsys(3,7) = -8.404735693140495E-06;

    %MASS
    solarsys(3,11) = 1898.13E24; % kg 

% } end Body 3: Jupiter


% Convert Units {

% positions in AU -> Meters
% AU * m/AU = m
solarsys(:,[2:4]) = solarsys(:,[2:4]) .* AU; 

% positions in AU/days -> meters/second
% AU/day * ( (m/AU) / (seconds/day) ) = m/s
solarsys(:,[5:7]) = solarsys(:,[5:7]) .* (AU / (24 * 60 * 60)); 

% } end Convert Units

% } end Planetary Starting Values

% } end Initial Data Setup


% Print initial values
% for i=1:NUM_BODIES
%     fprintf(1, 'ID   %d   t  %+5.4E  ', solarsys(i,1), time);
%     fprintf(1, 'x  %+5.4E  y  %+5.4E  z  %+5.4E  ', solarsys(i,2), solarsys(i,3), solarsys(i,4));
%     fprintf(1, 'vx  %+5.4E  vy  %+5.4E  vz  %+5.4E \n', solarsys(i,5), solarsys(i,6), solarsys(i,7));
% 
% end

sunx(end+1) = solarsys(1,2);
suny(end+1) = solarsys(1,3);
sunz(end+1) = solarsys(1,4);
sunvel(end+1) = sqrt(sum(solarsys(1,5:7).^2));
sunvel(end)
earthx(end+1) = solarsys(2,2);
earthy(end+1) = solarsys(2,3);
earthz(end+1) = solarsys(2,4);
jupx(end+1) = solarsys(3,2);
jupy(end+1) = solarsys(3,3);
jupz(end+1) = solarsys(3,4);

tic;


init_energy = 0;
for i=1:NUM_BODIES
    init_energy = init_energy + 0.5 * solarsys(i,11) * sum((solarsys(i,(5:7)) .^2));
    
    for j=1:NUM_BODIES
        if i < j
            radius = sqrt( sum( diff( solarsys([i j], (2:4)) ) .^2 ) );
            init_energy = init_energy + -(G * solarsys(i,11) * solarsys(j,11)) / radius;
        end
    end
end
    

% for each time step...
for time=time_step:time_step:ending_time
    
    % figure out, for each planet i, the force on/by each other planet j.
    for i=1:NUM_BODIES
        
        % reset forces for this planet for this timestep until we've
        % calculated them
        solarsys(i,(12:14)) = 0;
        
        for j=1:NUM_BODIES
            
            if i == j
                % same planet! skip.
                continue;
                
            elseif i < j
                % this relation has not been calculated before. Do it.
                % r = sqrt of the sum of the squares of the differences of
                % the positions of both planets
                radius = sqrt( sum( diff( solarsys([i j], (2:4)) ) .^2 ) );
                % using r^3 so that it can be broken into components merely
                % by multiplying by the coordinate
                forces(i,j) = -(G * solarsys(i,11) * solarsys(j,11)) / radius^3;
                
            elseif i > j
                % this relation *has* been calculated already. Don't
                % negate, the operation which takes care of breaking it
                % into components will take care of that.
                forces(i,j) = forces(j,i);
            end
            
            % net force has been calculated. break into components
            % force components  = forces so far + net force vector * x/y/z
            solarsys(i,(12:14)) = solarsys(i,(12:14)) + forces(i,j) .* ...
                diff(solarsys([j i],(2:4)));
       
        end
        
    end
    
    % now that all of the forces for this timestep are calculated, actually
    % change position, velocity, etc.
    for i=1:NUM_BODIES
        % accelerations    =   forces          / mass
        solarsys(i,(8:10)) = solarsys(i,(12:14)) ./ solarsys(i,11);
        % velocities      = old velocities    + accelerations * timestep
        solarsys(i,(5:7)) = solarsys(i,(5:7)) + solarsys(i,(8:10)) .* time_step;
        % positions       = old positions     + new velocities * timestep
        solarsys(i,(2:4)) = solarsys(i,(2:4)) + solarsys(i,(5:7)) .* time_step;
%         fprintf(1, 'ID   %d   t  %+5.4E  ', solarsys(i,1), time);
%         fprintf(1, 'x  %+5.4E  y  %+5.4E  z  %+5.4E  ', solarsys(i,2), solarsys(i,3), solarsys(i,4));
%         fprintf(1, 'vx  %+5.4E  vy  %+5.4E  vz  %+5.4E \n', solarsys(i,5), solarsys(i,6), solarsys(i,7));
       
    end
    
    sunx(end+1) = solarsys(1,2);
    suny(end+1) = solarsys(1,3);
    sunz(end+1) = solarsys(1,4);
    sunvel(end+1) = sqrt(sum(solarsys(1,5:7).^2));
    earthx(end+1) = solarsys(2,2);
    earthy(end+1) = solarsys(2,3);
    earthz(end+1) = solarsys(2,4);
    jupx(end+1) = solarsys(3,2);
    jupy(end+1) = solarsys(3,3);
    jupz(end+1) = solarsys(3,4);


end

final_energy = 0;
for i=1:NUM_BODIES
    final_energy = final_energy + 0.5 * solarsys(i,11) * sum((solarsys(i,(5:7)) .^2));
    
    for j=1:NUM_BODIES
        if i < j
            radius = sqrt( sum( diff( solarsys([i j], (2:4)) ) .^2 ) );
            final_energy = final_energy + -(G * solarsys(i,11) * solarsys(j,11)) / radius;
        end
    end
end

frac_nrg = abs((final_energy - init_energy) / init_energy)

fprintf('Sun max vel:\t%f', max(sunvel));


fprintf('\ninit values:\n\n');

for i=1:NUM_BODIES
    fprintf('%u\n%+5.4E %+5.4E %+5.4E\n%+5.4E %+5.4E %+5.4E\n', solarsys(i,1), solarsys(i,2), solarsys(i,3), solarsys(i,4), solarsys(i,5), solarsys(i,6), solarsys(i,7));
end

pbaspect([1 1 1]);

%Sun
%plot(sunx,suny,'*');
%plot(sunx,sunz,'*');
%Sun + Earth
%plot(sunx,suny,'*',earthx,earthy,'s')
%plot(sunx,sunz,'*',earthx,earthz,'s')
%Alla dem
%plot(sunx,suny,'*',earthx,earthy,'s',jupx,jupy,'o');
plot(sunx,sunz,'*',earthx,earthz,'s',jupx,jupz,'o');


fprintf('Total time: ');
toc;


% vim:tw=76 fdm=marker fmr={,}
