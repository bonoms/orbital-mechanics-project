function [dv] = legAssembler(tDep, tEnc, tArr)
%LEGASSEMBLER Summary of this function goes here
%   Detailed explanation goes here

% leg 1

tOf1 = 3600*(tEnc-tDep);

asteroid = bodyState('asteroid', tDep);
mars = bodyState('mars', tDep+tOf1);

[leg1] = legSolver(asteroid.r, mars.r, tOf1);

dv1 = abs(leg1.v1 - asteroid.v) + abs(leg1.v2 - mars.v) ;

% leg 2

tOf2 = 3600*(tArr-tEnc);

venus = bodyState('venus', tDep+tOf1+tOf2);

[leg2] = legSolver(mars.r, venus.r, tOf2);

dv2 = abs(leg2.v1 - mars.v) + abs(leg2.v2 - venus.v);

% total dv

dv = dv1 + dv2;


end