function [bodyState] = bodyState(whichBody, time)
%BODYSTATE Computes the state of a selected celestial body at a given epoch
%
% PROTOTYPE:
% bodyState = bodyState(whichBody, time)
%
% INPUT:
% whichBody [1x1] Identifier of the body to evaluate
% time      [1x1] Epoch time [T]
%
% OUTPUT:
% bodyState Structure containing the body position and velocity
%
% AUTHOR:
% Lorenzo Bonomi
%
% DESCRIPTION:
% Computes the Cartesian state of the selected celestial body at the
% specified time and returns position and velocity in the `bodyState`
% structure.

mu_sun = astroConstants(4);

switch whichBody
    case 'asteroid'

        [kepAst, ~, ~] = ephAsteroids(time, 1534);
        carAst = kep2car(kepAst, mu_sun);

        bodyState.r = carAst(1:3);
        bodyState.v = carAst(4:6);

    case 'mars'

        [kepMars, ~] = uplanet(time, 4);
        carMars = kep2car(kepMars, mu_sun);

        bodyState.r = carMars(1:3);
        bodyState.v = carMars(4:6);

    case 'venus'
         
        [kepMars, ~] = uplanet(time, 2);
        carVenus = kep2car(kepMars, mu_sun);

        bodyState.r = carVenus(1:3);
        bodyState.v = carVenus(4:6);


end