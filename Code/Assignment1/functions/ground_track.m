function [alpha, delta, longitude, latitude] = ground_track(r, thetaG0, t0, t_span)
%GROUND_TRACK Convert Earth inertial positions to ground-track coordinates.
%   [alpha,delta,longitude,latitude] = ground_track(r,thetaG0,t0,t_span)
%
% INPUTS
%   r       : N-by-3 Earth-centered inertial positions [km], one per time.
%             A full N-by-6 state history also works (only columns 1:3 used).
%   thetaG0 : Greenwich sidereal angle at reference time t0 [rad].
%   t0      : Scalar reference time [s].
%   t_span  : N-element row or column vector of sample times [s]; each
%             time corresponds to the same row of r. Use returned ODE times.
%
% OUTPUTS (N-by-1)
%   alpha     : Inertial right ascension [rad], from atan2(y,x).
%   delta     : Inertial declination [rad], from asin(z/norm(r)).
%   longitude : Earth-fixed longitude [deg], wrapped to [-180,180].
%   latitude  : Geocentric latitude [deg], equal to rad2deg(delta).
%
% EXAMPLE
%   [t,y] = orbit_solver(y0, 2);
%   [alpha,delta,lon,lat] = ground_track(y(:,1:3), 0, 0, t);
%   figure; ground_track_plot([alpha delta lon lat]);
%
% ASSUMPTIONS / DEPENDENCIES
%   Inertial z is Earth's spin axis; x defines the origin for thetaG0.
%   Uses a spherical Earth and constant spin: 2*pi/86164 [rad/s].
%   For an exercise prescribing 15.04 deg/hour exactly, replace the local
%   w_e expression with deg2rad(15.04)/3600. A caller's w_e does not override it.
%   Latitude is geocentric, not ellipsoidal/geodetic. Position must be nonzero;
%   at the poles longitude is undefined. Row counts must match the times.
%   wrapTo180 requires Mapping Toolbox. Without it, longitude can instead
%   be calculated as mod(rad2deg(alpha-thetaG)+180,360)-180.
%   This function computes coordinates; it does not create a plot.
%   See also orbit_solver, ground_track_plot.

w_e = 2*pi/(23*60*60+56*60+4);

% Greenwich angle at every sample; force times into a column.

thetaG = thetaG0 + w_e*(t_span(:)-t0);

% -- position definition

x = r(:,1);

y = r(:,2);

z = r(:,3);

r_norm = vecnorm(r,2,2); % Position magnitude for each row [km].

% -- angles for ground track

delta = asin(z./r_norm) % Declination at each time [rad]. 

alpha = atan2(y,x);

%% longitude and latitude

longitude = wrapTo180(rad2deg(alpha - thetaG));

latitude = rad2deg(delta);

end