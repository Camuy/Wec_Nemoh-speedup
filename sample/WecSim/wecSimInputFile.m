%% Simulation Data
simu = simulationClass();                       % Initialize simulationClass
simu.simMechanicsFile = 'RM3.slx';              % Simulink Model File
simu.startTime = 0;                             % Simulation Start Time [s]
simu.rampTime = 10;                            	% Wave Ramp Time [s]
simu.endTime = 10;                              % Simulation End Time [s]
simu.dt = 0.002;                                  % Simulation time-step [s]
simu.b2b = 1;
%simu.nonlinearDt = 3*simu.dt;


%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
waves = waveClass('noWaveCIC');        % Initialize Wave Class and Specify Type  

% % Regular Waves
%waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                
%waves.height = 0.3;                       % Wave Height [m]
%waves.period = 4.5;                       % Wave Period [s]
%waves.direction = 0;

% % Regular Waves with CIC
%waves = waveClass('regularCIC');          % Initialize Wave Class and Specify Type                                 
%waves.height = 2.5;                       % Wave Height [m]
%waves.period = 4;                         % Wave Period [s]

% % Irregular Waves using PM Spectrum 
%waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
%waves.height = 1;                         % Significant Wave Height [m]
%waves.period = 5;                         % Peak Period [s]
%waves.spectrumType = 'PM';                % Specify Wave Spectrum Type
%waves.direction=[0];

% % Irregular Waves using JS Spectrum with Equal Energy and Seeded Phase
% waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
% waves.height = 2.5;                       % Significant Wave Height [m]
% waves.period = 8;                         % Peak Period [s]
% waves.spectrumType = 'JS';                % Specify Wave Spectrum Type
% waves.bem.option = 'EqualEnergy';         % Uses 'EqualEnergy' bins (default) 
% waves.phaseSeed = 1;                      % Phase is seeded so eta is the same

% % Irregular Waves using PM Spectrum with Traditional and State Space 
%waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
%waves.height = 2.5;                       % Significant Wave Height [m]
%waves.period = 8;                         % Peak Period [s]
%waves.spectrumType = 'PM';                % Specify Wave Spectrum Type
%simu.stateSpace = 1;                      % Turn on State Space
%waves.bem.option = 'Traditional';         % Uses 1000 frequnecies

% % Irregular Waves with imported spectrum
%waves = waveClass('spectrumImport');      % Create the Wave Variable and Specify Type
%waves.spectrumFile = 'spectrumData.mat';  % Name of User-Defined Spectrum File [:,2] = [f, Sf]
%waves.spectrumFile = 'Trieste_spectrum.mat';

% % Waves with imported wave elevation time-history  !!! Not Working !!!
%waves = waveClass('elevationImport');          % Create the Wave Variable and Specify Type
%waves.elevationFile = 'elevationData.mat';     % Name of User-Defined Time-Series File [:,2] = [time, eta]


marker = 5;
distance = 1;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves.marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves.marker.style = 1; % 1: Sphere, 2: Cube, 3: Frame.
waves.marker.size = 10; % Marker Size in Pixels
waves.marker.graphicColor = [1,0,0];

%% Body Data
% Float
body(1) = bodyClass('hydroData/input_data.h5');      
    % Create the body(1) Variable, Set Location of Hydrodynamic Data File 
    % and Body Number Within this File.   
body(1).geometryFile = 'geometry/Float.stl';    % Location of Geomtry File
body(1).mass = 5.3026;                   
    % Body Mass. The 'equilibrium' Option Sets it to the Displaced Water 
    % Weight.
body(1).inertia = [0.0609 0.0609 0.1097];  % Moment of Inertia [kg*m^2]     
body(1).centerGravity = [0 0 0.0423];
body(1).volume = 0.0133;
body(1).initial.displacement = [0 0 0];
body(1).nonlinearHydro = 2;



% Spar/Plate
body(2) = bodyClass('hydroData/input_data.h5'); 
body(2).geometryFile = 'geometry/Spar.stl'; 
body(2).mass = 20.2679;        % volume*rho            
body(2).inertia = [3.0842 3.0842 0.6281];
body(2).centerGravity = [0 0 -1.2477];
body(2).volume = 0.0156;
body(2).initial.displacement = [0 0 0];
body(2).nonlinearHydro = 2;

if (body(1).mass + body(2).mass) > (body(1).volume + body(2).volume)*simu.rho
    warning("two body are not floating");
end

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];               % Constraint Location [m]
constraint(1).hardStops.upperLimitSpecify = 'off';
constraint(1).hardStops.lowerLimitSpecify = 'off';

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                           %PTO Stiffness [N/m]
pto(1).damping = 100;                          % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                      % PTO Location [m]
pto(1).equilibriumPosition = 0;                 % PTO Equilibrium Position [m]
pto(1).hardStops.upperLimitSpecify = 'on';
pto(1).hardStops.upperLimitBound = 0.2;
pto(1).hardStops.upperLimitDamping = 10000;
pto(1).hardStops.upperLimitStiffness = 50000;
pto(1).hardStops.lowerLimitSpecify = 'on';
pto(1).hardStops.lowerLimitBound = -0.2;
pto(1).hardStops.lowerLimitDamping = 10000;
pto(1).hardStops.lowerLimitStiffness = 50000;

%% Mooring constrain
mooring(1) = mooringClass('mooring1');
mooring(1).moorDyn = 1;
mooring(1).matrix.damping = [[100 0 0 0 0 0]; [0 100 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]];
mooring(1).matrix.stiffness = [[50 0 0 0 0 0]; [0 50 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0];[0 0 0 0 0 0]; [0 0 0 0 0 0]];

mooring(2) = mooringClass('mooring2');
mooring(2).moorDyn = 1;
mooring(2).matrix.damping = [[10 0 0 0 0 0]; [0 10 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]];
mooring(2).matrix.stiffness = [[10 0 0 0 0 0]; [0 10 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0];[0 0 0 0 0 0]; [0 0 0 0 0 0]];

mooring(3) = mooringClass('mooring3');
mooring(3).moorDyn = 1;
mooring(3).matrix.damping = [[10 0 0 0 0 0]; [0 10 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]];
mooring(3).matrix.stiffness = [[10 0 0 0 0 0]; [0 10 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0];[0 0 0 0 0 0]; [0 0 0 0 0 0]];

mooring(4) = mooringClass('mooring4');
mooring(4).moorDyn = 1;
mooring(4).matrix.damping = [[10 0 0 0 0 0]; [0 10 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]];
mooring(4).matrix.stiffness = [[0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0]; [0 0 0 0 0 0];[0 0 0 0 0 0]; [0 0 0 0 0 0]];
