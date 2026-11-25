function [a, e, i, omegaBig, omegaSmall, theta] = cartesian2keplerian(stateVector, mu)
%CARTESIAN2KEPLERIAN Convert inertial states to classical orbital elements.
% Authors: Lab team (replace with contributor names before submission).
%   [a,e,i,Omega,omega,theta] = cartesian2keplerian(stateVector, mu)
%
% INPUTS
%   stateVector : N-by-6 real finite matrix [rx ry rz vx vy vz].
%                 One state per row; positions [km], velocities [km/s].
%   mu          : Positive scalar gravitational parameter [km^3/s^2].
%
% OUTPUTS (each is N-by-1)
%   a           : Semimajor axis [km]; negative for hyperbolic states.
%   e           : Eccentricity [-].
%   i           : Inclination [rad], between 0 and pi.
%   omegaBig    : RAAN, Omega [rad].
%   omegaSmall  : Argument of periapsis, omega [rad].
%   theta       : True anomaly [rad]. Defined azimuthal angles use 0..2*pi.
%
% EXAMPLE
%   mu = astroConstants(13);
%   s = [-4578.219 -801.084 -7929.708 0.800 -6.037 1.385];
%   [a,e,i,O,w,f] = cartesian2keplerian(s, mu);
%   elements = [a e i O w f];
%   anglesDeg = rad2deg([i O w f]);
%
% LIMITATIONS / CONVENTIONS
%   A single column state y0 must be transposed: y0(:).'.
%   Circular means e <= 1e-12: omega = 0 by convention, theta = NaN.
%   Equatorial means norm(node)/norm(h) <= 1e-12: Omega = 0;
%   for eccentric equatorial orbits omega = NaN.
%   These NaN results cannot be passed directly to kep2car; a separate
%   argument-of-latitude/longitude convention is needed to retain position.
%   Zero position and exactly radial motion are rejected. Near-parabolic
%   states have an ill-conditioned semimajor axis (possibly infinite).
%   Other consistent units also work. Angles describe the input frame.
%   See also kep2car.

validateattributes(stateVector, {'numeric'}, ...
    {'real','finite','2d','ncols',6});
validateattributes(mu, {'numeric'}, ...
    {'real','finite','scalar','positive'});

r = stateVector(:,1:3);
v = stateVector(:,4:6);

n = size(stateVector,1);
tol = 1e-12;

% Protect acos against floating-point rounding
clamp = @(x) max(-1,min(1,x));

% 1: Position magnitude
r_norm = vecnorm(r,2,2);

if any(r_norm == 0)
    error('Position must be nonzero for every state.');
end

% 2: Velocity magnitude
v_norm = vecnorm(v,2,2);

% 3: Specific angular momentum
h = cross(r,v,2);

% 4: Angular momentum magnitude
h_norm = vecnorm(h,2,2);

if any(h_norm == 0)
    error('Classical orbital elements are undefined for radial motion.');
end

% 5: Inclination
i = acos(clamp(h(:,3) ./ h_norm));

% 6: Node vector
k = repmat([0,0,1],n,1);
N = cross(k,h,2);

% 7: Node magnitude
N_norm = vecnorm(N,2,2);

equatorial = (N_norm ./ h_norm) <= tol;
hasNode = ~equatorial;

% Normalize only rows with a defined node. Explicit column indexing keeps
% empty selections 0-by-1 for a single equatorial or circular state.
N_hat = zeros(n,3);
N_hat(hasNode,:) = N(hasNode,:) ./ N_norm(hasNode,1);

% 8: RAAN
omegaBig = zeros(n,1);

idx = hasNode & (N_hat(:,2) >= 0);
omegaBig(idx) = acos(clamp(N_hat(idx,1)));

idx = hasNode & (N_hat(:,2) < 0);
omegaBig(idx) = 2*pi - acos(clamp(N_hat(idx,1)));

% Equatorial convention: omegaBig = 0

% 9: Eccentricity vector
e_vec = cross(v,h,2) / mu - r ./ r_norm;

% 10: Eccentricity magnitude
e = vecnorm(e_vec,2,2);

circular = e <= tol;
hasPeriapsis = ~circular;

% 11: Argument of periapsis
omegaSmall = zeros(n,1);

valid = hasNode & hasPeriapsis;

cosOmega = sum(N(valid,:) .* e_vec(valid,:),2) ...
           ./ (N_norm(valid,1) .* e(valid,1));

omegaSmall(valid) = acos(clamp(cosOmega));

idx = valid & (e_vec(:,3) < 0);
omegaSmall(idx) = 2*pi - omegaSmall(idx);

% Undefined node: separate convention needed for these orbits
omegaSmall(equatorial & hasPeriapsis) = NaN;

% Circular convention: omegaSmall = 0

% 12: True anomaly
theta = NaN(n,1);

valid = hasPeriapsis;

cosTheta = sum(e_vec(valid,:) .* r(valid,:),2) ...
           ./ (e(valid,1) .* r_norm(valid,1));

theta(valid) = acos(clamp(cosTheta));

vr = sum(r .* v,2) ./ r_norm;

idx = valid & (vr < 0);
theta(idx) = 2*pi - theta(idx);

% Circular orbits: true anomaly is undefined, so retain NaN.

% 13: Semimajor axis
a = 1 ./ (2 ./ r_norm - v_norm.^2 ./ mu);

end