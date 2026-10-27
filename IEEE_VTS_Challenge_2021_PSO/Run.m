%% IEEE VTS Motor Vehicles Challenge 2021
% Energy Management of A Dual-Motor All-Wheel Drive Electric Vehicle

% Bao-Huy Nguyen 
% Université de Sherbrooke, QC, Canada

% Run the simulation
% Just choose the driving cycle and run

%% Simulation setup
clear; clc; close all;
addpath(genpath(pwd)) ; % To add all the folders to this current path

% Load driving cycle
% Choose the driving cycle you want to test
% 1: NEDC
% 2: WLTC class 2
Driving_cycle = 1;

% Initialization
Init ;      % System parameters initalization. NOT to change
Strategy ;  % EMS parameters initialization. To be developed by the participants

% Run the simulation
disp('IEEE VTS MOTOR VEHICLE CHALLENGE 2021')
disp('Energy Management of A Dual-Motor All-Wheel Drive Electric Vehicle')
disp('Simulation is running. It may take time. Please wait ...')
sim('VTS_challenge_2021.slx') ; % Run the Simulink file. It may take time.

% Report
Report ;