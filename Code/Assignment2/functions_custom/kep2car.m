function state = kep2car(kep, mu)

    sma = kep(1); ecc = kep(2); inc = kep(3);
    raan = kep(4); aop = kep(5); ta = kep(6);

    c_i = cos(inc); s_i = sin(inc);
    c_raan = cos(raan); s_raan = sin(raan);
    c_aop = cos(aop); s_aop = sin(aop);
    c_ta = cos(ta); s_ta = sin(ta);

    p = sma * (1 - ecc^2);
    r_norm = p / (1 + ecc * c_ta);
    rp = r_norm * [c_ta; s_ta; 0];
    vp = sqrt(mu / p) * [-s_ta; ecc + c_ta; 0];

    P = [c_raan * c_aop - s_raan * s_aop * c_i, ...
         -c_raan * s_aop - s_raan * c_aop * c_i, ...
         s_raan * s_i;
         s_raan * c_aop + c_raan * s_aop * c_i, ...
         -s_raan * s_aop + c_raan * c_aop * c_i, ...
         -c_raan * s_i;
         s_aop * s_i, ...
         c_aop * s_i, ...
         c_i];
    r = P * rp;
    v = P * vp;

    state = [r; v];
    
end