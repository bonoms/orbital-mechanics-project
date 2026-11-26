function plotMission(mission)
%PLOTMISSION Plot the body orbits and the two heliocentric transfer arcs.
% Usage: ax = plotMission(mission, tDep, tEnc, tArr).
% Inputs: mission [scalar struct] from legAssembler; tDep, tEnc, tArr
%         [scalar, MJD2000 days] are the dates passed to legAssembler.
% Output: none
% Authors: [Group member names]



assert(mission.ok, 'Both Lambert legs must be valid before plotting.');

muSun = astroConstants(4);
auKm = astroConstants(2);


tDep = mission.epochs(1);
tEnc = mission.epochs(2);
tArr = mission.epochs(3);

asteroid = bodyState('asteroid', tDep);
mars = bodyState('mars', tEnc);
venus = bodyState('venus', tArr);


fig = figure('Name', 'Asteroid 1534 - Mars - Venus');
ax = axes('Parent', fig);
hold(ax, 'on');

plotBodyOrbit(ax, 'asteroid', 'Asteroid 1534', tDep, asteroid, muSun, auKm);
plotBodyOrbit(ax, 'mars', 'Mars', tEnc, mars, muSun, auKm);
plotBodyOrbit(ax, 'venus', 'Venus', tArr, venus, muSun, auKm);

fun = @(~, y) [y(4:6); -muSun * y(1:3) / norm(y(1:3))^3];
opts = odeset('RelTol', 1e-11, 'AbsTol', 1e-12);

plotTransferArc(ax, asteroid.r, mission.leg1.v1, mission.tOf1, 'Asteroid to Mars', fun, opts, auKm);
plotTransferArc(ax, mars.r, mission.leg2.v1, mission.tOf2, 'Mars to Venus', fun, opts, auKm);

plot3(ax, 0, 0, 0, 'o', 'MarkerFaceColor', [1 0.7 0.1], 'DisplayName', 'Sun');

axis(ax, 'equal');
grid(ax, 'on');
view(ax, 3);
xlabel(ax, 'x [AU]');
ylabel(ax, 'y [AU]');
zlabel(ax, 'z [AU]');
legend(ax, 'Location', 'best');
end

function plotBodyOrbit(ax, key, name, epoch, state, muSun, auKm)
% Sample the body ephemeris over approximately one revolution.
a = 1 / (2/norm(state.r) - dot(state.v, state.v)/muSun);
periodDays = 2*pi*sqrt(a^3/muSun) / 86400;
sampleDates = epoch + linspace(-0.5, 0.5, 251)*periodDays;
orbit = zeros(numel(sampleDates), 3);

for k = 1:numel(sampleDates)
    sample = bodyState(key, sampleDates(k));
    orbit(k,:) = sample.r(:).' / auKm;
end

curve = plot3(ax, orbit(:,1), orbit(:,2), orbit(:,3), '--', 'DisplayName', name);

point = state.r(:) / auKm;
plot3(ax, point(1), point(2), point(3), 'o', 'Color', curve.Color, 'MarkerFaceColor', curve.Color);
end

function plotTransferArc(ax, r0, v0, tofSec, name, fun, opts, auKm)
% Propagate from the Lambert departure state for the leg's flight time.
y0 = [r0(:); v0(:)];
[~, y] = ode113(fun, linspace(0, tofSec, 300), y0, opts);

arc = y(:,1:3) / auKm;
plot3(ax, arc(:,1), arc(:,2), arc(:,3), 'LineWidth', 2, ...
    'DisplayName', name);
end