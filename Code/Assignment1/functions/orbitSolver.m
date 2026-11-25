function [t,y] = orbitSolver(y0, orbit_to_calculate, days, integrationStep)
%ORBIT_SOLVER Propagate a bound Earth orbit and plot its conserved quantities.
%   [t,y] = orbit_solver(y0, numberOfPeriods)
%
% INPUTS
%   y0              : 6-by-1 column [rx; ry; rz; vx; vy; vz], in an
%                     Earth-centered inertial frame, [km] and [km/s].
%   numberOfPeriods : Positive scalar number of orbital periods to integrate.
%                     Fractional values are allowed.
%
% OUTPUTS
%   t : 1000-by-1 requested output times [s], starting at zero.
%   y : 1000-by-6 states [rx ry rz vx vy vz], [km] and [km/s].
%
% EXAMPLE
%   mu = astroConstants(13);
%   el = [8350, 0.1976, deg2rad([60,270,45,230])];
%   s = kep2car(el, mu);
%   [t,y] = orbit_solver(s(1,:).', 2);
%   [alpha,delta,lon,lat] = ground_track(y(:,1:3), 0, 0, t);
%   figure; ground_track_plot([alpha delta lon lat]);
%
% MODEL / SIDE EFFECTS
%   Uses astroConstants(13) and ode113 for point-mass Earth gravity only.
%   No J2, drag, third bodies, or collision detection are included.
%   Requires a bound non-colliding orbit with finite positive semimajor axis;
%   hyperbolic/parabolic trajectories have no orbital period.
%   Uses 1000 output samples; the integrator chooses its own internal steps.
%   Creates/uses figures 1, 2, 3 for the orbit, specific mechanical energy
%   [km^2/s^2], and specific angular momentum components/norm [km^2/s].
%   Energy and angular momentum should remain constant up to numerical error.
%   See also kep2car, ground_track, ground_track_plot, astroConstants.

mu_e=astroConstants(13);

s_in_day = 60*60*23+56*60+4;

%initial conditions

r0 = y0(1:3); % [km]
v0 = y0(4:6); % [km/s]

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

tspan = unique([0:integrationStep:s_to_compute, s_to_compute]); %% future improvement put auto integration itnervals based on time scale factor and general speed 


% function definition

% ODE_2BP returns [velocity; acceleration] for the six-state column.
% The time argument is unused because the two-body model is autonomous.
    function dy = ode_2bp(~,y,mu_e)

        r = y(1:3);
        v = y(4:6);

        dy=[
            v;
            -r*mu_e/(norm(r)^3);
            ];

    end

% gets the solution for the ode

options=odeset('RelTol',1e-13,'AbsTol',1e-14);

[t,y] = ode113(@(t,y) ode_2bp(t,y,mu_e),tspan,y0,options);

%% plots 

% orbit and earth

figure(1)

plot3(y(:,1), y(:,2), y(:,3), 'b-', 0, 0, 0, 'wo');

xlabel('x [km]');
ylabel('y [km]');
zlabel('z [km]');
legend('Orbit', 'earth');
grid on 
axis equal
hold on

% energy plot

figure(2)

epsilon = 0.5*vecnorm(y(:,4:6),2,2).^2 - mu_e./vecnorm(y(:,1:3),2,2);

plot(t,epsilon,'r-');
xlabel('time [s]');
ylabel('Specific energy [km^2/s^2]');

% angular moment vector plot

figure(3)

h = cross(y(:,1:3),y(:,4:6),2);

plot(t, h(:,1), 'r--', ...
    t, h(:,2), 'b--', ...
    t, h(:,3), 'g--', ...
    t, vecnorm(h,2,2), 'w--', ...
    'LineWidth', 2.5)
grid on

end