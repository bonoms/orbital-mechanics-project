function state = kep2car(elements,mu)
%KEP2CAR Convert Keplerian elements to inertial Cartesian states.
%   state = kep2car(elements, mu)
%
% INPUTS
%   elements : N-by-6 double matrix; one orbit/state per row:
%              [a, e, i, Omega, omega, theta].
%   a        : Semimajor axis [km]; negative for hyperbolic orbits.
%   e        : Eccentricity [-]; 0 <= e < 1 for an ellipse, e > 1
%              for a hyperbola. Parabolic orbits (e = 1) are excluded.
%   i        : Inclination [rad], normally between 0 and pi.
%   Omega    : Right ascension of ascending node (RAAN) [rad].
%   omega    : Argument of periapsis [rad].
%   theta    : True anomaly [rad], also commonly called f.
%   mu       : Positive scalar double gravitational parameter [km^3/s^2].
%
% OUTPUT
%   state    : N-by-6 matrix [rx ry rz vx vy vz], in [km] and [km/s],
%              expressed in the inertial frame used to define the elements.
%
% EXAMPLE
%   mu = astroConstants(13);
%   elements = [8350, 0.1976, deg2rad([60, 270, 45, 230])];
%   state = kep2car(elements, mu);
%   y0 = state(1,:).'; % Column initial state for orbit_solver.
%
% NOTES
%   Other consistent units also work. Convert degree inputs with deg2rad.
%   Requires p = a*(1-e^2) > 0 and 1+e*cos(theta) > 0.
%   For circular orbits, omega and theta separately are arbitrary: their
%   sum specifies the position relative to the node. For equatorial orbits,
%   choose a consistent node convention (often Omega = 0).
%   The current declaration says keplerian2cartesian, but the file is
%   kep2car.m; call by the filename. Align these names before renaming calls.
%   See also cartesian2keplerian, orbit_solver.

validateattributes(elements,{'double'}, ...
    {'real','finite','2d','ncols',6});
validateattributes(mu,{'double'}, ...
    {'real','finite','scalar','positive'});

a     = elements(:,1);
e     = elements(:,2);
i     = elements(:,3);
Omega = elements(:,4);
omega = elements(:,5);
theta = elements(:,6);

% Semilatus rectum
p = a .* (1-e.^2);
denominator = 1 + e.*cos(theta);

if any(e < 0) || any(p <= 0) || any(denominator <= 0)
    error('Invalid orbital elements or true anomaly outside the physical orbit.');
end

% Position and velocity in the perifocal frame
radius = p ./ denominator;

xp = radius .* cos(theta);
yp = radius .* sin(theta);

speedFactor = sqrt(mu ./ p);
vxp = -speedFactor .* sin(theta);
vyp =  speedFactor .* (e + cos(theta));

% Perifocal basis vectors expressed in the inertial frame
cO = cos(Omega);
sO = sin(Omega);
co = cos(omega);
so = sin(omega);
ci = cos(i);
si = sin(i);

P = [cO.*co - sO.*so.*ci, ...
    sO.*co + cO.*so.*ci, ...
    so.*si];

Q = [-cO.*so - sO.*co.*ci, ...
    -sO.*so + cO.*co.*ci, ...
    co.*si];

% Rotate position and velocity into the inertial frame
r = xp.*P + yp.*Q;
v = vxp.*P + vyp.*Q;

state = [r v];

end