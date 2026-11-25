%PLANETARYMISSION_GROUP_N Entry script for Assignment 2.
% Authors: Lab team (add contributor names before submission).
% Usage: Enter the group orbit, epoch, and planetary mu; run this script.
% Inputs: elements [1-by-6, km and rad], epoch [scalar, MJD2000 days],
%         muPlanet [scalar, km^3/s^2].
% Outputs: t [N-by-1, s] and y [N-by-6, km and km/s] for one 2BP period.

addpath(fileparts(fileparts(mfilename('fullpath'))));
setupOrbitalMechanics("Assignment2");

groupId = [];
elements = [];  % [a e i RAAN omega trueAnomaly]; initial true anomaly is zero.
epoch = [];
muPlanet = [];

if isempty(groupId) || isempty(elements) || isempty(epoch) || isempty(muPlanet)
    disp('Assignment 2 setup is ready. Enter your group inputs or run checkPlanetaryBaseline.');
    return
end

y0 = kep2car(elements, muPlanet).';
periodSec = 2*pi*sqrt(elements(1)^3/muPlanet);
[t, y] = ode113(@(time,state) ode_2bp(time,state,muPlanet), ...
    linspace(0, periodSec, 301), y0, odeset('RelTol',1e-11,'AbsTol',1e-12));
