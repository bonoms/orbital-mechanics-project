function [dv, mission] = legAssembler(tDep, tEnc, tArr)
%LEGASSEMBLER Computes the total delta-v for a two-leg transfer sequence
%
% PROTOTYPE:
% dv = legAssembler(tDep, tEnc, tArr)
%
% INPUT:
% tDep [1x1] Departure epoch [T]
% tEnc [1x1] Encounter epoch [T]
% tArr [1x1] Arrival epoch [T]
%
% OUTPUT:
% dv [1x1] Total delta-v required for the transfer [L/T]
%
% AUTHOR:
% Lorenzo Bonomi
%
% DESCRIPTION:
% Computes the total delta-v for a two-leg interplanetary transfer by
% solving two Lambert legs between the selected bodies butat the specified
% epochs and summing the velocity mismatches at departure, encounter, and
% arrival. For future development: add the fly-by phase, with delta v and
% sum it to the total, add also status in teh mission to evaluate
% performace 

% leg 1

tOf1 = 86400*(tEnc-tDep);

asteroid = bodyState('asteroid', tDep);
mars = bodyState('mars', tEnc);

[leg1] = legSolver(asteroid.r, mars.r, tOf1);

dv1 = norm(leg1.v1 - asteroid.v) + norm(leg1.v2 - mars.v) ;

% leg 2

tOf2 = 86400*(tArr-tEnc);

venus = bodyState('venus', tArr);

[leg2] = legSolver(mars.r, venus.r, tOf2);

dv2 = norm(leg2.v1 - mars.v) + norm(leg2.v2 - venus.v);

% total dv

dv = dv1 + dv2;

% mission parameters

mission.ok = ((leg1.error == 0) & (leg2.error == 0));

mission.tOf1 = tOf1;
mission.tOf2 = tOf2;

mission.leg1 = leg1;
mission.leg2 = leg2;

mission.dv1 = dv1;
mission.dv2 = dv2;

mission.epochs = [tDep, tEnc, tArr];

end