function plotter_sens(smas, incs, decc, dinc)

    incs_deg = rad2deg(incs);
    dinc_deg = rad2deg(dinc);

    figure;
    tl = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(tl, 'Orbital stability map');

    ax1 = nexttile(tl);
    im1 = imagesc(ax1, smas, incs_deg, decc);
    set(ax1, 'YDir', 'normal');
    set(im1, 'AlphaData', ~isnan(decc));
    colormap(ax1, parula);
    colorbar(ax1);
    title(ax1, '\Delta e');
    xlabel(ax1, 'Initial semi-major axis [km]');
    ylabel(ax1, 'Initial inclination [deg]');

    ax2 = nexttile(tl);
    im2 = imagesc(ax2, smas, incs_deg, dinc_deg);
    set(ax2, 'YDir', 'normal');
    set(im2, 'AlphaData', ~isnan(dinc_deg));
    colormap(ax2, parula);
    colorbar(ax2);
    title(ax2, '\Delta i [deg]');
    xlabel(ax2, 'Initial semi-major axis [km]');
    ylabel(ax2, 'Initial inclination [deg]');

end
