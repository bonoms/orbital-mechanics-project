function [lonDeg, latDeg] = ground_track(r, tSec, theta0, spinRate)
%GROUND_TRACK Compute geocentric coordinates for a uniformly rotating planet.
% Authors: Lab team (add contributor names before submission).
% Usage: [lon,lat] = ground_track(y(:,1:3),t,theta0,spinRate).
% Inputs: r [N-by-3, km] in the equatorial inertial frame, tSec [N, s]
%         relative to the reference epoch, theta0 [scalar, rad] at that
%         epoch, spinRate [scalar, rad/s] with sign in the inertial frame.
% Outputs: lonDeg, latDeg [N-by-1, deg]; longitude in [-180,180).

longitude = atan2(r(:,2), r(:,1)) - (theta0 + spinRate*tSec(:));
lonDeg = mod(rad2deg(longitude) + 180, 360) - 180;
latDeg = rad2deg(atan2(r(:,3), hypot(r(:,1), r(:,2))));
end
