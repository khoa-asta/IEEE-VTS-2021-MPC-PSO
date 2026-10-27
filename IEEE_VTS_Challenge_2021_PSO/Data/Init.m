%% IEEE VTS Motor Vehicles Challenge 2021
% Energy Management of A Dual-Motor All-Wheel Drive Electric Vehicle

% Bao-Huy Nguyen 
% Université de Sherbrooke, QC, Canada

% Initialization

% Do NOT change anything in this file

%% Simulation setup
switch Driving_cycle
    case 1
        load NEDC ;
    case 2
        load WLTCclasse2 ;
end
load EMs ;
% Simulation configuration
SIMULPARAM.Ts = 1e-2 ;                      % [s] Fixed time step
SIMULPARAM.T_end = max(CYCL.time);          % [s] Simulation time = time of the used driving cycle
SIMULPARAM.Decimation = 1/SIMULPARAM.Ts ;	% Record data after n calculation steps

%% Batteries model
load Battery_cell_data ;
BAT.Q_cell = 12 ;           	% Cell nominal capacity [Ah]
BAT.C_cell = 3600*BAT.Q_cell ;	% Cell equivalent capacity [F]
BAT.v_cell_nom = 4.0744 ;   	% Cell nominal voltage [V]
% Pack
BAT.n_se = 90 ;             	% Number of cells in series
BAT.n_pa = 6 ;              	% Number of branches in parallel
BAT.SoC_init = 90 ;         	% Initial SoC [%]
% Thermal model
BAT.Temp_0 = 44 + 273.15 ;   	% Battery cell initial temperature [oF]
BAT.T_air = 44 + 273.15;      	% Battery air temperature [oF]
BAT.T_cell_max = 50 + 273.15 ;  % Battery cell maximum temperature [oF]
BAT.T_cell_min = -20 + 273.15 ;	% Battery cell minimum temperature [oF]

%% Mechanical Transmission parameters            
MTp.Gear_eff = 0.95;                        % Transmission efficiency
MTp.K_gear = 3;                             % Gearbox ratio
MTp.K_gear_f = 3;                           % Gearbox ratio front axis
MTp.K_gear_r = 4;                           % Gearbox ratio rear axis
MTp.R_wheel = 0.38;                         % Wheel radius (m)
MTp.k_tran_f = MTp.K_gear_f/MTp.R_wheel;	% Transmission gain
MTp.k_tran_r = MTp.K_gear_r/MTp.R_wheel;	% Transmission gain

%% Chassis
CHAp.M_eq = 795 + 75;       % Equivalent mass (chassis + driver)
CHAp.K_eq = 1/CHAp.M_eq; 	% Velocity gain

%% Environment               
RDp.g = 9.81;                      	% gravity (m/s^2)
RDp.A = 2.4;                    	% Frontal aera (m^2)
RDp.Cx = 0.35;                   	% Drag coefficient
RDp.ro = 1.223;                    	% Density of the air with 20°C under 1013 mbar (kg/m^3)
RDp.f = 0.02;
RDp.Kaero = RDp.ro*RDp.Cx*RDp.A/2;	% Constant for the resistance force to aerodynamics
RDp.F_sec = RDp.f*RDp.g*CHAp.M_eq;	% Static friction force (N)

%% Vehicle speed controller
SPEEDCONTROL.Tres = 1 ;     % [s] Response time
SPEEDCONTROL.xi = 1 ;       % Damping factor
SPEEDCONTROL.wn = 2*pi/SPEEDCONTROL.Tres ; % [rad/s] Natural frequency
% Controller selection
% 1: PI controller
% 2: IP controller
Speed_control = 2 ;
% PI controller
SPEEDCONTROL.Kp_pi = 2*SPEEDCONTROL.xi*SPEEDCONTROL.wn*CHAp.M_eq ;
SPEEDCONTROL.Ki_pi = SPEEDCONTROL.wn^2*CHAp.M_eq;
% IP controller
SPEEDCONTROL.Kp_ip = 2*SPEEDCONTROL.xi*SPEEDCONTROL.wn*CHAp.M_eq ;
SPEEDCONTROL.Ki_ip = SPEEDCONTROL.wn^2*CHAp.M_eq;
