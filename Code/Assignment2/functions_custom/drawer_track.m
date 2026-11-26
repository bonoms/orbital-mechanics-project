function drawer_track(ephemerides, names, PLANET, OPTIONS)

    figure;
    title('Ground Tracks');

    hold on;

    image([-180 180], [-90 90], flipud(imread(PLANET.texture_name)));

    n = size(ephemerides, 2);
    colors = lines(n);
    for k = 1:n
        TRACK = ground_track(ephemerides(k), names(k), PLANET);
        c = colors(k, :);

        plot(TRACK.lon_deg, TRACK.lat_deg, '-', 'Color', c, 'LineWidth', 2, 'DisplayName', TRACK.name);

        if OPTIONS.draw_end_points
            plot(TRACK.lon_deg(1), TRACK.lat_deg(1), 'o', 'MarkerSize', 7, ...
                'MarkerFaceColor', c, 'MarkerEdgeColor', 'k', ...
                'DisplayName', TRACK.name + ' (Start)');
            plot(TRACK.lon_deg(end), TRACK.lat_deg(end), 's', 'MarkerSize', 7, ...
                'MarkerFaceColor', c, 'MarkerEdgeColor', 'w', ...
                'DisplayName', TRACK.name + ' (Finish)');
        end
    end

    hold off;
    set(gca, 'Layer', 'top');

    axis equal;
    grid on;

    xlim([-180 180]);
    ylim([-90 90]);

    xlabel('Longitude [deg]');
    ylabel('Latitude [deg]');

    legend();

end

function TRACK = ground_track(ephemeris, name, PLANET)

    r = ephemeris.y(1:3, :);

    alpha = atan2(r(2, :), r(1, :));
    delta = pi / 2 - acos(r(3, :) ./ vecnorm(r, 2, 1));
    lon = alpha - (PLANET.omega * ephemeris.x * 86400);
    lat = delta;

    lon_deg = wrapTo180(rad2deg(lon));
    lat_deg = rad2deg(lat);

    wrap_idx = find(abs(diff(lon_deg)) > 180);
    for i = length(wrap_idx):-1:1
        idx = wrap_idx(i);
        lon_deg = [lon_deg(1:idx) NaN lon_deg(idx + 1:end)];
        lat_deg = [lat_deg(1:idx) NaN lat_deg(idx + 1:end)];
    end

    TRACK.name = name;
    TRACK.lon_deg = lon_deg;
    TRACK.lat_deg = lat_deg;

end
