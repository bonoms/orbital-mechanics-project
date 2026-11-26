function y_dot = ode_2bp(~, y, mu, J2, R)
    r = y(1:3);
    v = y(4:6);
    r_norm = norm(r);

    a_kepler = -mu / r_norm^3 * r;
    
    j2_fac = 1.5 * J2 * mu * R^2 / r_norm ^ 5;
    j2_term = 5 * (r(3) / r_norm) ^ 2 - 1;
    j2_vec = [r(1) * j2_term 
        r(2) * j2_term
        r(3) * (j2_term - 2)];
    a_j2 = j2_fac * j2_vec;

    a = a_kepler + a_j2;
    y_dot = [v; a];
end