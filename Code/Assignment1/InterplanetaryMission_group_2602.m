%INTERPLANETARYMISSION_GROUP_2602 Main script for the interplanetary mission analysis
%
% DESCRIPTION:
% bla bla
%
% NOTE:
% The example dates are expressed in MJD2000 days, while the transfer
% computations inside the mission functions use relative time in seconds.



[dvMatrix, missionOptimal, dvOptimal] = missionOptimizer(40, 60, 510, 520, 1290, 1310, 50, 50, 50);

plotMission(missionOptimal);
