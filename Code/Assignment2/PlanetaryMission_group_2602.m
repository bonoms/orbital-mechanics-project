%PLANETARYMISSION_GROUP_2602 Entry script for Assignment 2.
% Authors: Lab team (add contributor names before submission).
% Usage: Open om.prj and follow Code/README.md.
% Inputs and outputs: document when the analysis is implemented.

clear;
close all;
clc;

sma = 30.19115956e4;
ecc = 0.0431;
inc = deg2rad(87);
kep = [sma ecc inc 0 0 0];

PROPERTIES.cR = 1;
PROPERTIES.AM = 2.5392;
mjd2000_initial = date2mjd2000([2038 11 2 17 4 15]);

planet_id = 2;
PLANET = planetary_data(planet_id);

P_kep = 2 * pi * sqrt(sma^3 / PLANET.mu);

mjd2000_final = mjd2000_initial + P_kep * 5 / 86400;
mjd2000s = linspace(mjd2000_initial, mjd2000_final, 1000);

PROPAGATOR_OPTIONS.use_J2 = false;
PROPAGATOR_OPTIONS.use_SRP = true;

DATA_OPTIONS.is_input_kep = true;

states = propagate(kep, mjd2000s, PLANET, PROPERTIES, PROPAGATOR_OPTIONS, DATA_OPTIONS);

DRAW_OPTIONS.draw_planet = true;
DRAW_OPTIONS.draw_orbit = true;
DRAW_OPTIONS.draw_sun_direction = true;

orbit_drawer(mjd2000s, states, PLANET, DRAW_OPTIONS);
