function state = bodyState(ephemFcn, epoch, muSun)
%BODYSTATE Evaluate one heliocentric body state.
% Authors: Lab team (add contributor names before submission).
% Usage: earth = bodyState(@(t) uplanet(t,3), epoch, muSun).
% Inputs: ephemFcn [function handle] returns six heliocentric elements;
%         epoch [scalar, MJD2000 days]; muSun [scalar, km^3/s^2].
% Output: state [scalar struct], r and v [3-by-1, km and km/s].

elements = ephemFcn(epoch);
y = kep2car(elements(:).', muSun);
state = struct('r', y(1:3).', 'v', y(4:6).');
end
