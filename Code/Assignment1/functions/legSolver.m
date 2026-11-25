function [leg] = legSolver(r1, r2, tOf)
%LEGSOLVER Solves Lambert's problem for an elliptical transfer orbit
%
% PROTOTYPE:
% leg = legElliptical(r1, r2, tOf)
%
% INPUT:
% r1[1x3] Initial position vector [L]
% r2[1x3] Final position vector [L]
% tOf[1x1] Time of flight [T]
%
% OUTPUT:
% leg Structure containing the elliptical transfer-orbit parameters
%
% AUTHOR:
% Lorenzo Bonomi
%
% DESCRIPTION:
% Solves Lambert's problem for an elliptical transfer orbit between two
% position vectors and a specified time of flight.

arguments
    r1 (1,3)
    r2 (1,3)
    tOf (1,1) 
end

mu_sun = astroConstants(3);

[A, P, E, ERROR, VI, VF, TPAR, THETA] = lambertMR(r1, r2, tOf, mu_sun, 0, 0, 0);

leg.a = A;
leg.p = P;
leg.e = E;
leg.error = ERROR;
leg.v1 = VI;
leg.v2 = VF;
leg.tpar = TPAR;
leg.theta = THETA;

end