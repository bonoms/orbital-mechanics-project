%CHECKMARSEXPRESS Verify the Lambert leg at the Chapter 3 reference dates.
% Authors: Lab team.
% Usage: Run from the Project shortcut or run this file directly.
% Inputs: Chapter 3 reference epochs [MJD2000 days] and course functions.
% Outputs: prints transfer cost [km/s] and arrival position error [km].

addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'Code'));
setupOrbitalMechanics("Assignment1");
muSun = astroConstants(4);
tDep = date2mjd2000([2003 6 7 22 27 34.14]);
tArr = date2mjd2000([2003 12 28 14 26 8.25]);
dep = bodyState(@(t) uplanet(t,3), tDep, muSun);
arr = bodyState(@(t) uplanet(t,4), tArr, muSun);

tofSec = 86400 * (tArr-tDep);
leg = solveLambertLeg(dep.r, arr.r, tofSec, muSun);
assert(leg.ok, 'Mars Express Lambert solve failed.');
cost = norm(leg.v1-dep.v) + norm(arr.v-leg.v2);
assert(abs(cost-5.6696) < 0.01, 'Unexpected Mars Express transfer cost.');
[~, y] = ode113(@(t,s) ode_2bp(t,s,muSun), [0 tofSec], [dep.r; leg.v1], ...
    odeset('RelTol',1e-12,'AbsTol',1e-12));
missKm = norm(y(end,1:3).'-arr.r);
assert(missKm < 1, 'Lambert leg failed the endpoint check.');
fprintf('Mars Express: %.5f km/s, endpoint error %.6f km.\n', cost, missKm);
