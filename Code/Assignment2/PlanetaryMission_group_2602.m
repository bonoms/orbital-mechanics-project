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

kep2 = car2kep(kep2car(kep, PLANET.mu), PLANET.mu);


%% Simulation Duration

P_kep = 2 * pi * sqrt(sma^3 / PLANET.mu);

mjd2000_final = mjd2000_initial + P_kep * 50 / 86400;
mjd2000s = [mjd2000_initial, mjd2000_final];


%% Propagation

DATA_OPTIONS.is_input_kep = true;

PROPAGATOR_OPTIONS.use_J2 = false;
PROPAGATOR_OPTIONS.use_SRP = false;
eph_2bp = propagate(kep, mjd2000s, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS);

PROPAGATOR_OPTIONS.use_J2 = true;
PROPAGATOR_OPTIONS.use_SRP = true;
eph_pert = propagate(kep, mjd2000s, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS);


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


%% Visualization

ephs = [eph_2bp, eph_pert];
names = ["2BP" "J2 + SRP"];

DRAWER_ORBIT_OPTIONS.draw_sun_direction = true;
drawer_orbit(ephs, names, PLANET, DRAWER_ORBIT_OPTIONS);

DRAWER_TRACK_OPTIONS.draw_end_points = true;
drawer_track(ephs, names, PLANET, DRAWER_TRACK_OPTIONS);

PLOTTER_KEP_OPTIONS.relative = [2 1];
plotter_kep(ephs, names, PLANET, PLOTTER_KEP_OPTIONS);

plotter_sens(smas, incs, decc, dinc);

