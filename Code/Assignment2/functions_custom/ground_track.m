function TRACK = ground_track(mjd2000s, states, PLANET, name)

    r = states(:, 1:3);

    alpha = atan2(r(:, 2), r(:, 1));
    delta = pi / 2 - acos(r(:, 3) ./ vecnorm(r, 2, 2));
    lon = alpha - (PLANET.omega * mjd2000s(:) * 86400);
    lat = delta;

    lon_deg = wrapTo180(rad2deg(lon));
    lat_deg = rad2deg(lat);

    wrap_idx = find(abs(diff(lon_deg)) > 180);
    for i = length(wrap_idx):-1:1
        idx = wrap_idx(i);
        lon_deg = [lon_deg(1:idx); NaN; lon_deg(idx + 1:end)];
        lat_deg = [lat_deg(1:idx); NaN; lat_deg(idx + 1:end)];
    end

    TRACK.name = name;
    TRACK.lon_deg = lon_deg;
    TRACK.lat_deg = lat_deg;

end