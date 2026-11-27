%INTERPLANETARYMISSION_GROUP_2602 Main script for the interplanetary mission analysis
%
% DESCRIPTION:
% bla bla
%
% NOTE:
% The example dates are expressed in MJD2000 days, while the transfer
% computations inside the mission functions use relative time in seconds.

depDateMin = date2mjd2000([2030, 1, 1, 0, 0, 0]);
depDateMax = date2mjd2000([2050, 1, 1, 0, 0, 0]);

encDateMin = date2mjd2000([2030, 1, 1, 0, 0, 0]);
encDateMax = date2mjd2000([2060, 1, 1, 0, 0, 0]);

arrDateMin = date2mjd2000([2050, 1, 1, 0, 0, 0]);
arrDateMax = date2mjd2000([2060, 1, 1, 0, 0, 0]);

degreeSample = 30;

n1 = round((depDateMax-depDateMin)*360/(degreeSample*1648));
n2 = round((encDateMax-encDateMin)*360/(degreeSample*687));
n3 = round((arrDateMax-arrDateMin)*360/(degreeSample*224));


%%
profile on 

[dvMatrix, dvPork, missionOptimal, dvOptimal] = missionOptimizer(depDateMin, depDateMax, encDateMin,...
                                                encDateMax, arrDateMin, arrDateMax, n1, n2, n3);


profile off
profile viewer

%% Plots

clf('reset')

figure(1)

plotMission(missionOptimal);

figure(2)

porkChopPlot(dvPork, depDateMin, depDateMax, arrDateMin, arrDateMax);