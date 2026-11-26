function r_sun = sun_position(mjd2000, PLANET)

    % Retrieving planet position in Sun-centred ecliptic inertial frame 
    [kep_planet, mu_Sun] = uplanet(mjd2000, PLANET.id);
    state_planet = kep2car(kep_planet, mu_Sun);
    r_sun_planet_ecl = state_planet(1:3);

    % Rotation matrix to planet-centered equatorial inertial frame
    R_ecl2eq = [1  0                 0
                0  cos(PLANET.tilt) -sin(PLANET.tilt)
                0  sin(PLANET.tilt)  cos(PLANET.tilt)];

    % Position of Sun in planet-centered equatorial inertial frame
    r_sun_planet = R_ecl2eq * r_sun_planet_ecl;

    % Negation to get direction from the center of planet to Sun
    r_sun = -r_sun_planet;
    
end