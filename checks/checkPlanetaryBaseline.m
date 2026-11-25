%CHECKPLANETARYBASELINE Verify the unperturbed Earth-orbit building blocks.
% Authors: Lab team.
% Usage: Run from the Project shortcut or run this file directly.
% Input: built-in example orbit [km and rad], official Earth mu [km^3/s^2].
% Output: prints distance [km] between the initial and final position.

addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'Code'));
setupOrbitalMechanics("Assignment2");
muEarth = astroConstants(13);
kep = [8350 0.1976 deg2rad([60 270 45 230])];
y0 = kep2car(kep, muEarth).';
periodSec = 2*pi*sqrt(kep(1)^3/muEarth);
[t, y] = ode113(@(time,s) ode_2bp(time,s,muEarth), ...
    linspace(0,periodSec,101), y0, odeset('RelTol',1e-11,'AbsTol',1e-12));
closureKm = norm(y(end,1:3).'-y0(1:3));
assert(closureKm < 0.01, 'Two-body orbital period check failed.');
[lon, lat] = ground_track(y(:,1:3), t, 0, 2*pi/86164);
assert(all(lon >= -180 & lon < 180) && all(abs(lat) <= 90), ...
    'Ground track coordinates outside expected range.');
fprintf('Planetary baseline: one-period endpoint error %.6f km.\n', closureKm);
