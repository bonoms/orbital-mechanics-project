function drawer_2d(tracks, PLANET, OPTIONS)

    figure;
    hold on;

    image([-180, 180], [-90, 90], flipud(imread(PLANET.texture_name)));

    colors = lines(numel(tracks));

    for k = 1:numel(tracks)
        TRACK = tracks(k);
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
    xlim([-180, 180]);
    ylim([-90, 90]);

    xlabel('Longitude [deg]');
    ylabel('Latitude [deg]');
    grid on;

    legend();

end
