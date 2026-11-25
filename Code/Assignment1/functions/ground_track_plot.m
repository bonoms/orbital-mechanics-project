function ground_track_plot(groundTrack)
%GROUND_TRACK_PLOT Display ground-track samples over an Earth map.
%   ground_track_plot(groundTrack)
%
% INPUT
%   groundTrack : N-by-4 matrix [alpha delta longitude latitude].
%                 alpha/delta are in radians (unused by this function);
%                 longitude/latitude must be in degrees.
%
% EXAMPLE
%   [alpha,delta,lon,lat] = ground_track(y(:,1:3), 0, 0, t);
%   figure;
%   ground_track_plot([alpha delta lon lat]);
%
% BEHAVIOR / DEPENDENCIES
%   Draws on the current axes; use figure first for a separate window.
%   Requires EarthTexture.jpg in the same folder as this function;
%   use an equirectangular map with north at the top.
%   Displays magenta dots rather than connected lines, avoiding artificial
%   segments across the +/-180-degree longitude boundary.
%   Sets degree labels, grid, longitude limits [-180,180], and latitude
%   limits [-90,90]. Leaves hold on enabled; returns no outputs.
%   See also ground_track.

longitude = groundTrack(:,3);
latitude = groundTrack(:,4);

% Find the texture beside this function, independent of the current folder.
functionFolder = fileparts(mfilename('fullpath'));
imagePath = fullfile(functionFolder, 'EarthTexture.jpg');
earthTexture = imread(imagePath);

image('XData',[-180 180], ...
    'YData',[90 -90], ...
    'CData',earthTexture);

set(gca,'YDir','normal')
hold on

plot(longitude, latitude, 'm-', 'LineWidth', 2, 'LineStyle', 'none', 'Marker','.');
plot(longitude(1), latitude(1), 'go', ...
    'MarkerFaceColor', 'g', 'MarkerSize', 8, ...
    'DisplayName', 'Start');

plot(longitude(end), latitude(end), 'rs', ...
    'MarkerFaceColor', 'r', 'MarkerSize', 8, ...
    'DisplayName', 'End');

grid on

ax = gca;
ax.Layer = 'top';       % Draw grid above the image
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridColor = 'w';     % White grid
ax.GridAlpha = 0.6;     % Visibility: 0 transparent, 1 opaque

ax = gca;                                 % get current axis               
ax.XLim = [-180 180];                        % set x limits
ax.YLim = [-90 90];                       % set y limits
ax.XTick = [-180 -120 -60 0 60 120 180];    % define x ticks
ax.YTick = [-90 -60 -30 0 30 60 90];      % define y ticks

xlabel('Longitude [deg]')
ylabel('Latitude [deg]')

end