function plotter_kep(mjd2000s, keps, names, PLANET, OPTIONS)

    n = size(keps, 3);
    colors = lines(n);

    n_states = size(mjd2000s, 2);
    days = mjd2000s - mjd2000s(1);

    labels = {'Semi-Major Axis [km]', 'Eccentricity', 'Inclination [deg]', ...
              'RAAN [deg]', 'Argument of Periapsis [deg]', 'True Anomaly [deg]'};

    figure;
    tl = tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(tl, 'Keplerian Elements');

    ax = gobjects(1, 6);
    for idx = 1:6
        ax(idx) = nexttile(tl);
        hold(ax(idx), 'on');
        grid(ax(idx), 'on');
        ylabel(ax(idx), labels{idx});
        xlabel(ax(idx), 'Time since initial date [days]');
    end

    for k = 1:n
        kep = keps(:, :, k);
        kep(:, 3:6) = rad2deg(kep(:, 3:6));

        for i = 1:6
            plot(ax(i), days, kep(:, i), 'Color', colors(k, :), ...
                 'DisplayName', names(k), 'LineWidth', 1.2);
        end
    end

    lgd = legend(ax(1));
    lgd.Layout.Tile = 'north';

    if size(OPTIONS.relative, 2) == 2
        i1 = OPTIONS.relative(1);
        i2 = OPTIONS.relative(2);

        diff_kep = keps(:, :, i1) - keps(:, :, i2);
        diff_kep(:, 3:6) = mod(diff_kep(:, 3:6) + 180, 360) - 180;

        diff_labels = {'\Delta a [km]', '\Delta e', '\Delta i [deg]', ...
                       '\Delta \Omega [deg]', '\Delta \omega [deg]', '\Delta \theta [deg]'};

        figure;
        tl_rel = tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
        title(tl_rel, sprintf('Difference: [%s] - [%s]', names(i1), names(i2)));

        for idx = 1:6
            ax_rel = nexttile(tl_rel);
            plot(ax_rel, days, diff_kep(:, idx), 'LineWidth', 1.2);
            grid(ax_rel, 'on');
            ylabel(ax_rel, diff_labels{idx});
            xlabel(ax_rel, 'Time since initial date [days]');
        end
    end

end
