function [states] = propagate(state0, mjd2000s, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS)

    if DATA_OPTIONS.is_input_kep
        [r, v] = kep2car(state0, PLANET.mu);
        state0 = [r; v];
    end

    integrator_options = odeset('RelTol', 1e-13, 'AbsTol', 1e-14);
    [~, states] = ode113(@(t, y) rhs(t, y, PLANET, PROPERTIES, PROPAGATOR_OPTIONS), mjd2000s, state0, integrator_options);

end

function state_dot = rhs(mjd2000, state, PLANET, PROPERTIES, OPTIONS)

    % State is defined in planet-centered equatorial inertial frame
    % x-axis along Earth-Sun gamma-line
    % z-axis perpendicular to planet's equatorial plane
    r = state(1:3);
    v = state(4:6);
    r_norm = norm(r);

    a_total = zeros(3, 1);

    a_kepler = -PLANET.mu / r_norm^3 * r;
    a_total = a_total + a_kepler;

    if OPTIONS.use_J2
        j2_fac = 1.5 * PLANET.J2 * PLANET.mu * PLANET.R_eq^2 / r_norm^5;
        j2_term = 5 * (r(3) / r_norm)^2 - 1;
        j2_vec = [r(1) * j2_term 
                  r(2) * j2_term
                  r(3) * (j2_term - 2)];
        
        a_j2 = j2_fac * j2_vec;
        a_total = a_total + a_j2;
    end

    if OPTIONS.use_SRP
        c = 299792458;
        R_sun = 695700;

        r_planet_sun = sun_position(mjd2000, PLANET);
        r_sun_planet = -r_planet_sun;
        r_sun_sc = r_sun_planet + r;
        r_sun_sc_norm = norm(r_sun_sc);

        % Directions to the center of Sun and planet
        dir_Sun = -r_sun_sc / r_sun_sc_norm;
        dir_planet = -r / r_norm;

        sun_size = asin(R_sun / r_sun_sc_norm);
        planet_size = asin(PLANET.R_mean / r_norm);
        planet_sun_angle = acos(clip(dot(dir_planet, dir_Sun), -1, 1));

        nu = shadowFraction(planet_size, sun_size, planet_sun_angle);

        a_SRP = nu * PLANET.E_solar / c * PROPERTIES.cR * PROPERTIES.AM * (-dir_Sun) * 1e-3;
        a_total = a_total + a_SRP;
    end
    
    state_dot = [v; a_total];

    % Converting derivatives dx/dmjd2000 -> dx/ds
    state_dot = state_dot * 86400;
end

function nu = shadowFraction(a, b, c)
    if c >= a + b
        nu = 1;
    elseif c <= a - b
        nu = 0;
    elseif c <= b - a
        nu = 1 - (a / b)^2;
    else
        x = (c^2 + a^2 - b^2) / (2 * c);
        y = sqrt(max(a^2 - x^2, 0));
        A = a^2 * acos(clip(x / a, -1, 1)) ...
            + b^2 * acos(clip((c - x) / b, -1, 1)) - c * y;
        nu = 1 - A / (pi * b^2);
    end
end