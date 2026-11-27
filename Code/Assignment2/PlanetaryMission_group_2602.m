%PLANETARYMISSION_GROUP_2602 Entry script for Assignment 2.
% Authors: Lab team (add contributor names before submission).
% Usage: Open om.prj and follow Code/README.md.
% Inputs and outputs: document when the analysis is implemented.

clear;
close all;
clc;
addpath(genpath("Code/Assignment2"))

%% Initial Conditions

sma = 30.19115956e4;
ecc = 0.0431;
inc = deg2rad(87);
kep = [sma ecc inc 0 0 0];

PROPERTIES.cR = 1;
PROPERTIES.AM = 2.5392;
mjd2000_initial = date2mjd2000([2038 11 2 17 4 15]);

planet_id = 2;
PLANET = planetary_data(planet_id);


%% Propagation

mjd2000s_full = [mjd2000_initial, mjd2000_initial + 365];

DATA_OPTIONS.is_input_kep = true;

PROPAGATOR_OPTIONS.use_J2 = false;
PROPAGATOR_OPTIONS.use_SRP = false;
eph_2bp = propagate(kep, mjd2000s_full, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS);

PROPAGATOR_OPTIONS.use_J2 = true;
PROPAGATOR_OPTIONS.use_SRP = true;
eph_pert = propagate(kep, mjd2000s_full, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS);


%% Keplerian Elements

step = 1;
mjd2000s_step = mjd2000_initial:step:(mjd2000_initial + 365);

kep_2bp = cell2mat(arrayfun(@(mjd2000) car2kep(deval(eph_2bp, mjd2000), PLANET.mu), ...
             mjd2000s_step(:), 'UniformOutput', false));
kep_pert = cell2mat(arrayfun(@(mjd2000) car2kep(deval(eph_pert, mjd2000), PLANET.mu), ...
             mjd2000s_step(:), 'UniformOutput', false));


%% Sensitivity Analysis

n_sma = 10; n_inc = 5;
smas = linspace(sma * 0.5, sma * 1.5, n_sma);
incs = linspace(inc * 0.5, inc * 1.5, n_inc);

decc = NaN(n_inc, n_sma);
dinc = NaN(n_inc, n_sma);

mjd2000s_var = [mjd2000_initial mjd2000_initial + 365];

PROPAGATOR_OPTIONS.use_J2 = true;
PROPAGATOR_OPTIONS.use_SRP = true;

for i = 1:n_inc
    for j = 1:n_sma
        kep_var_initial = kep;
        kep_var_initial(1) = smas(j);
        kep_var_initial(3) = incs(i);

        eph_var = propagate(kep_var_initial, mjd2000s_var, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS);
        kep_var_final = car2kep(eph_var.y(:, end), PLANET.mu);

        decc(i, j) = kep_var_final(2) - kep_var_initial(2);
        dinc(i, j) = kep_var_final(3) - kep_var_initial(3);
    end
end


%% Filtering

step = 1;
mjd2000s_step = mjd2000_initial:step:(mjd2000_initial + 365);

kep_unfilt = cell2mat(arrayfun(@(mjd2000) car2kep(deval(eph_pert, mjd2000), PLANET.mu), ...
             mjd2000s_step(:), 'UniformOutput', false));

P_kep = 2 * pi * sqrt(sma^3 / PLANET.mu);
k_filt_P = P_kep / step / 86400;

kep_filt_1P = movmean(kep_unfilt, k_filt_P);  
kep_filt_4P = movmean(kep_unfilt, k_filt_P * 4);    


%% Visualization

ephs = [eph_2bp, eph_pert];
names = ["2BP" "J2 + SRP"];

DRAWER_ORBIT_OPTIONS.draw_sun_direction = true;
drawer_orbit(ephs, names, PLANET, DRAWER_ORBIT_OPTIONS);

DRAWER_TRACK_OPTIONS.draw_end_points = true;
drawer_track(ephs, names, PLANET, DRAWER_TRACK_OPTIONS);

keps = cat(3, kep_2bp, kep_pert);

PLOTTER_KEP_OPTIONS.relative = [2 1];
plotter_kep(mjd2000s_step, keps, names, PLANET, PLOTTER_KEP_OPTIONS);

plotter_sens(smas, incs, decc, dinc);

keps = cat(3, kep_pert, kep_filt_1P, kep_filt_4P);
names = ["Unfiltered", "Filtered - k = 1 Period", "Filtered - k = 4 Periods"];

PLOTTER_KEP_OPTIONS.relative = [];
plotter_kep(mjd2000s_step, keps, names, PLANET, PLOTTER_KEP_OPTIONS);

