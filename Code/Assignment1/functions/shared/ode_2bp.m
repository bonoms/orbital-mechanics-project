function dydt = ode_2bp(~, y, mu)
%ODE_2BP Cartesian point-mass two-body dynamics.
% Authors: Lab team (add contributor names before submission).
% Usage: ode113(@(t,y) ode_2bp(t,y,mu), tspan, y0).
% Inputs: t [scalar, s], y [6-by-1, km and km/s], mu [scalar, km^3/s^2].
% Output: dydt [6-by-1, km/s and km/s^2].

r = y(1:3);
dydt = [y(4:6); -mu * r / norm(r)^3];
end
