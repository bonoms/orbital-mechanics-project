function leg = solveLambertLeg(r1, r2, tofSec, mu)
%SOLVELAMBERTLEG Solve a direct, zero-revolution transfer.
% Authors: Lab team (add contributor names before submission).
% Usage: leg = solveLambertLeg(r1, r2, tofSec, mu).
% Inputs: r1, r2 [3 components, km], tofSec [scalar, s],
%         mu [scalar, km^3/s^2]. Positions share an inertial frame.
% Output: leg [scalar struct] with status, success flag, a and p [km],
%         e [dimensionless], and v1 and v2 [3-by-1, km/s].

leg = struct('ok', false, 'status', NaN, 'a', NaN, 'p', NaN, 'e', NaN, ...
    'v1', nan(3,1), 'v2', nan(3,1));
if ~isfinite(tofSec) || tofSec <= 0
    return
end

[a, p, e, status, v1, v2] = lambertMR(r1(:).', r2(:).', tofSec, mu, 0, 0, 0, 0);
leg.status = status;
velocities = [v1(:); v2(:)];
if status == 0 && isreal(velocities) && all(isfinite(velocities))
    leg.ok = true;
    leg.a = a;
    leg.p = p;
    leg.e = e;
    leg.v1 = v1(:);
    leg.v2 = v2(:);
end
end
