function [t_J2,y_J2] = orbitSolverJ2(y0, orbit_to_calculate, days, integrationStep)

%constants

mu_e=astroConstants(13);
Re = astroConstants(23);

s_in_day = 60*60*24;

%initial conditions

r0 = y0(:,1:3); % [km]
v0 = y0(:,4:6); % [km/s]

% orbit parameters

a = 1/( 2/norm(r0) - dot(v0,v0)/mu_e );
T = 2*pi*sqrt( a^3/mu_e);

% time integration interval

if nargin < 2 || isempty(orbit_to_calculate)
    orbit_to_calculate = 1;
end

if nargin < 3 || isempty(days)
    s_to_compute = T*orbit_to_calculate;
else
    s_to_compute = days*s_in_day; 
end

if nargin < 4 || isempty(integrationStep)
    integrationStep = 60;
end

tspan_J2 = [0:integrationStep:s_to_compute, s_to_compute]; %% future improvement put auto integration itnervals based on time scale factor and general speed 


% gets the solution for the ode with J2

options=odeset('RelTol',1e-13,'AbsTol',1e-14);

[t_J2,y_J2] = ode113(@(t,y) ode_2bp_J2(t,y,mu_e),tspan_J2,y0,options);


%% plots section

% comparison plot

figure(4)
clf
hold on
grid on
axis equal
view(3)

imagePath = fullfile(fileparts(mfilename('fullpath')), 'EarthTexture.jpg');
earthTexture = imread(imagePath);

% sphere ceration

[X,Y,Z] = sphere(100);

surf(Re*X, Re*Y, Re*Z, ...
    'CData',flipud(earthTexture), ...
    'FaceColor','texturemap', ...
    'EdgeColor','none', ...
    'HandleVisibility','off');


plot3(0, 0, 0, 'wo', 'MarkerFaceColor', 'b');

% Continuous color gradient along time
surface([y_J2(:,1) y_J2(:,1)], ...
    [y_J2(:,2) y_J2(:,2)], ...
    [y_J2(:,3) y_J2(:,3)], ...
    [t_J2/86400 t_J2/86400], ...
    'FaceColor', 'none', ...
    'EdgeColor', 'interp', ...
    'LineWidth', 1.5);

colormap(turbo)
cb = colorbar;
cb.Label.String = 'Time [days]';

xlabel('x [km]');
ylabel('y [km]');
zlabel('z [km]');
legend('Earth', 'J2 trajectory');


%% energy plot

figure(5)
clf

epsilon_J2=0.5*vecnorm(y_J2(:,4:6),2,2).^2-mu_e./vecnorm(y_J2(:,1:3),2,2);

hold on
plot(t_J2,epsilon_J2,'r-','DisplayName','Energy J2 perturbation');
xlabel('time [s]');
ylabel('Specific two-body energy [km^2/s^2]');;
hold off

%% angular moment vector plot

figure(6)

h = cross(y_J2(:,1:3),y_J2(:,4:6),2);

plot(t_J2, h(:,1), 'r--', ...
    t_J2, h(:,2), 'b--', ...
    t_J2, h(:,3), 'g--', ...
    t_J2, vecnorm(h,2,2), 'w--', ...
    'LineWidth', 2.5)
grid on

%% eccentricity vector plot

%% Eccentricity vectors definition

h_J2 = cross(y_J2(:,1:3), y_J2(:,4:6), 2);

e_J2 = cross(y_J2(:,4:6), h_J2, 2)/mu_e ...
    - y_J2(:,1:3)./vecnorm(y_J2(:,1:3),2,2);

e_J2_norm = vecnorm(e_J2,2,2);


%% Plot eccentrifcity


figure(7)
clf
tiledlayout(2,1,'TileSpacing','compact','Padding','compact');


% Eccentricity vector components

nexttile
colors = lines(3);
hold on

for j = 1:3
    plot(t_J2, e_J2(:,j), '-', ...
        'Color',colors(j,:), 'LineWidth',1.4);
end

hold off
grid on
xlabel('Time [s]')
ylabel('Eccentricity component')
title('Eccentricity vector components')
legend({'e_x','e_y','e_z'}, 'Location','best');

% Eccentricity magnitude
nexttile
plot(t_J2, e_J2_norm, 'r-', 'LineWidth',1.5);

grid on
xlabel('Time [s]')
ylabel('Eccentricity, ||e||')
title('Eccentricity magnitude')

sgtitle('Eccentricity under J_2 perturbation')


%% function definition

function dy = ode_2bp_J2(~,y,mu_e)

r = y(1:3);
r_norm = norm(r);
v = y(4:6);

J2 = 0.00108263;
Re=astroConstants(23);

dy=[
    v;
    -r*mu_e/(r_norm^3) + (3*J2*mu_e*Re^2)/(2*r_norm^4) * ...
    [y(1)/r_norm * (5*y(3).^2/r_norm^2 - 1);
    y(2)/r_norm * (5*y(3).^2/r_norm^2 - 1);
    y(3)/r_norm * (5*y(3)^2/r_norm^2 - 3)];
    ];

end

end