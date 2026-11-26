function kep = car2kep(state, mu)
    
    eps_tol = 1e-12;

    r = state(1:3);
    v = state(4:6);

    r_norm = norm(r);
    v_norm = norm(v);

    h = cross(r, v);
    h_norm = norm(h);
    inc = atan2(norm(h(1:2)), h(3));

    N = cross([0; 0; 1], h);
    N_norm = norm(N);
    if N_norm > eps_tol
        raan = atan2(N(2), N(1));
    else
        N = [1; 0; 0];
        N_norm = 1;
        raan = 0;
    end

    ecc_vec = cross(v, h) / mu - r / r_norm;
    ecc = norm(ecc_vec);
    if ecc > eps_tol
        aop = atan2(dot(cross(N, ecc_vec), h) / h_norm, dot(N, ecc_vec));
    else
        ecc_vec = N / N_norm;
        ecc = 0;
        aop = 0;
    end

    ta = atan2(dot(cross(ecc_vec, r), h) / h_norm, dot(ecc_vec, r));

    sma = 1 / (2 / r_norm - v_norm^2 / mu);

    kep = [sma, ecc, inc, raan, aop, ta];

end
