function drawer_3d(mjd2000s, states, PLANET, OPTIONS)

    [X_planet, Y_planet, Z_planet] = ellipsoid(0, 0, 0, PLANET.R_eq, PLANET.R_eq, PLANET.R_p);
    texture = flipud(imread(PLANET.texture_name));

    figure();
    hold on;

    if OPTIONS.draw_planet
        surf(X_planet, Y_planet, Z_planet, ...
            'FaceColor', 'texturemap', 'CData', texture, 'EdgeColor', 'none', 'FaceAlpha', 1);
    end

    if OPTIONS.draw_orbit
        plot3(states(:, 1), states(:, 2), states(:, 3), '-', 'LineWidth', 2.5);
    end

    if OPTIONS.draw_sun_direction
        r_sun = sun_position(mjd2000s(1), PLANET);
        dir_sun = r_sun / norm(r_sun);

        scale = PLANET.R_mean * 25;
        dir_sun = dir_sun * scale;
        
        quiver3(0, 0, 0, ...
            dir_sun(1), dir_sun(2), dir_sun(3), ...
            0, 'Color', [1 0.8 0], 'LineWidth', 2, 'MaxHeadSize', 0.2, ...
            'DisplayName', 'Sun Direction');
    end

    hold off;
    set(gca, 'FontSize', 14);

    axis equal;
    grid on;

    max_val = max(abs(states(:, 1:3)), [], 'all') * 1.1; 
    xlim([-max_val, max_val]);
    ylim([-max_val, max_val]);
    zlim([-max_val, max_val]);

    xlabel('X [km]'); ylabel('Y [km]'); zlabel('Z [km]');

    view(3);

end