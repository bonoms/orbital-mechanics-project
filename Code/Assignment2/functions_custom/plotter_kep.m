function plotter_kep(ephemerides, names, PLANET, OPTIONS)

    n = size(ephemerides, 2);
    colors = lines(n);

    n_states = 1000;
    mjd2000s = linspace(ephemerides(1).x(1), ephemerides(1).x(end), n_states);
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

    kep_all = zeros(n_states, 6, n);

    for k = 1:n
        kep = cell2mat(arrayfun(@(mjd2000) car2kep(deval(ephemerides(k), mjd2000), PLANET.mu), ...
              mjd2000s(:), 'UniformOutput', false));

        kep(:, 3:6) = rad2deg(kep(:, 3:6));
        kep_all(:, :, k) = kep;

        for i = 1:6
            plot(ax(i), days, kep(:, i), 'Color', colors(k, :), ...
                 'DisplayName', names(k), 'LineWidth', 1.2);
        end
    end

    lgd = legend(ax(1));
    lgd.Layout.Tile = 'north';

    if isfield(OPTIONS, 'relative') && numel(OPTIONS.relative) == 2
        i1 = OPTIONS.relative(1);
        i2 = OPTIONS.relative(2);

        diff_kep = kep_all(:, :, i1) - kep_all(:, :, i2);
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
