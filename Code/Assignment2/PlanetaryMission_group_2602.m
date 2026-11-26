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
N_orbits = 5;

mjd2000_final = mjd2000_initial + P_kep * N_orbits / 86400;
mjd2000s = linspace(mjd2000_initial, mjd2000_final, 1000 * N_orbits)';


%% Propagation

DATA_OPTIONS.is_input_kep = true;

PROPAGATOR_OPTIONS.use_J2 = false;
PROPAGATOR_OPTIONS.use_SRP = false;
ephemeris_2bp = propagate(kep, mjd2000s, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS);

PROPAGATOR_OPTIONS.use_J2 = true;
PROPAGATOR_OPTIONS.use_SRP = true;
ephemeris_pert = propagate(kep, mjd2000s, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS);


%% Visualization

ephemerides = cat(3, ephemeris_2bp, ephemeris_pert);
names = ["2BP" "J2 + SRP"];

DRAWER_ORBIT_OPTIONS.draw_sun_direction = true;
drawer_orbit(mjd2000s, ephemerides, names, PLANET, DRAWER_ORBIT_OPTIONS);

DRAWER_TRACK_OPTIONS.draw_end_points = true;
drawer_track(mjd2000s, ephemerides, names, PLANET, DRAWER_TRACK_OPTIONS);

PLOTTER_KEP_OPTIONS.relative = [2 1];
plotter_kep(mjd2000s, ephemerides, names, PLANET, PLOTTER_KEP_OPTIONS);

