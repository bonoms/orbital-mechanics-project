function drawer_orbit(ephemerides, names, PLANET, OPTIONS)

    [X_planet, Y_planet, Z_planet] = ellipsoid(0, 0, 0, PLANET.R_eq, PLANET.R_eq, PLANET.R_p);
    texture = flipud(imread(PLANET.texture_name));

    figure;
    title('Trajectories');

    hold on;

    surf(X_planet, Y_planet, Z_planet, ...
        'FaceColor', 'texturemap', 'CData', texture, 'EdgeColor', 'none', 'FaceAlpha', 1, ...
        'HandleVisibility', 'off');


    n = size(ephemerides, 2);
    colors = lines(n);
    for k = 1:n
        ephemeris = ephemerides(k);
        plot3(ephemeris.y(1, :), ephemeris.y(2, :), ephemeris.y(3, :), ...
        '-', 'LineWidth', 2.5, 'Color', colors(k, :), 'DisplayName', names(k));
    end

    if OPTIONS.draw_sun_direction
        r_sun = sun_position(ephemerides(1).x(1), PLANET);
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

    max_val = max(arrayfun(@(s) max(abs(s.y(1:3, :)), [], 'all'), ephemerides)) * 1.1;
    xlim([-max_val max_val]);
    ylim([-max_val max_val]);
    zlim([-max_val max_val]);

    xlabel('X [km]'); ylabel('Y [km]'); zlabel('Z [km]');

    legend();
    view(3);

end