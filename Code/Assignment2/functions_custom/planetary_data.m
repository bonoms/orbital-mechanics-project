function PLANET = planetary_data(planet_id)

    PLANET.id = planet_id;

    PLANET.mu = astroConstants(10 + planet_id);
    PLANET.R_mean = astroConstants(20 + planet_id);
    PLANET.J2 = astroConstants(30 + planet_id);
    PLANET.f = astroConstants(40 + planet_id);
    PLANET.P_sidereal = astroConstants(50 + planet_id) * 3600.0;
    PLANET.tilt = deg2rad(astroConstants(60 + planet_id));
    PLANET.E_solar = astroConstants(70 + planet_id);

    PLANET.R_eq = PLANET.R_mean / (1 - PLANET.f)^(1 / 3);
    PLANET.R_p = PLANET.R_mean * (1 - PLANET.f)^(2 / 3);
    PLANET.omega = 2 * pi / PLANET.P_sidereal;

    textures = ["", "VenusTexture.jpg", "EarthTexture.jpg"];
    PLANET.texture_name = textures(planet_id);

end