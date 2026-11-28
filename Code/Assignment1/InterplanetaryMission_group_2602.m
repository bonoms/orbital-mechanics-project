%INTERPLANETARYMISSION_GROUP_2602 Main script for the interplanetary mission analysis
%
% DESCRIPTION:
% bla bla
%
% NOTE:
% The example dates are expressed in MJD2000 days, while the transfer
% computations inside the mission functions use relative time in seconds.


%% Constrains

depDateMin = date2mjd2000([2030, 1, 1, 0, 0, 0]);
depDateMax = date2mjd2000([2060, 1, 1, 0, 0, 0]);

encDateMin = date2mjd2000([2030, 1, 1, 0, 0, 0]);
encDateMax = date2mjd2000([2060, 1, 1, 0, 0, 0]);

arrDateMin = date2mjd2000([2030, 1, 1, 0, 0, 0]);
arrDateMax = date2mjd2000([2060, 1, 1, 0, 0, 0]);

tOfTotal = 2000; % maximum time of flight of the complete mission


%% Coarse mission search

tof1 = 550;
tof2 = 220;
tEnc = linspace(max(encDateMin, depDateMin + tof1), ...
    min(encDateMax, arrDateMax - tof2), 10).';

starts = [tEnc - tof1, tEnc, tEnc + tof2];


A = [ 1 -1  0;    % tEnc - tDep >= 250
    -1  1  0;    % tEnc - tDep <= 950
    0  1 -1;    % tArr - tEnc >= 90
    0 -1  1;    % tArr - tEnc <= 500
    -1  0  1];   % tArr - tDep <= tOfTotal
b = [-250; 950; -90; 500; tOfTotal];

lb = [depDateMin encDateMin arrDateMin];
ub = [depDateMax encDateMax arrDateMax];
opts = optimoptions('ga', 'MaxGenerations', 4000, ...
    'InitialPopulationMatrix', starts, 'PlotFcn', @gaplotbestf);

missionCost = @(x) legAssembler(x(1), x(2), x(3)); % x = [Asteroid dep , Mars enc, Venus arrival] epochs
[x, dvCoarse] = ga(missionCost, 3, A, b, [], [], lb, ub, [], opts);
[~, missionOptimalCoarse] = legAssembler(x(1), x(2), x(3));


%% Fine mission search

shift = 10; % shift in days to provide a second fine search 

depDateMin2 = missionOptimalCoarse.epochs(1) - 15*shift;
depDateMax2 = missionOptimalCoarse.epochs(1) + 15*shift;

encDateMin2 = missionOptimalCoarse.epochs(2) - shift;
encDateMax2 = missionOptimalCoarse.epochs(2) + shift;

arrDateMin2 = missionOptimalCoarse.epochs(3) - shift;
arrDateMax2 = missionOptimalCoarse.epochs(3) + shift;


[dvMatrix, dvPork, missionOptimal, dvOptimal] = missionOptimizer(depDateMin2, depDateMax2, encDateMin2,...
                                                encDateMax2, arrDateMin2, arrDateMax2, 50, 50, 50);


%% Plots

plotMission(missionOptimal);

porkChopPlot(dvPork, depDateMin2, depDateMax2, arrDateMin2, arrDateMax2);


