function [a, e, i, raan, aop, ta] = car2kep(r, v, mu)
    eps = 1e-12;

    r_norm = norm(r);
    v_norm = norm(v);
    v_r = dot(r, v) / r_norm;

    h = cross(r, v);
    h_norm = norm(h);

    i = acos(h(3) / h_norm);

    if (abs(i) > eps)
        N = cross([0; 0; 1], h);
        raan = atan2(N(2), N(1));
    else
        N = [1; 0; 0];
        raan = 0;
    end

    N_norm = norm(N);
    e_vector = 1 / mu * (cross(v, h) - mu * r / r_norm);
    e = norm(e_vector);

    if (e > eps)
        if (e_vector(3) >= 0)
            aop = acos(dot(N, e_vector) / (N_norm * e));
        else
            aop = 2 * pi - acos(dot(N, e_vector) / (N_norm * e));
        end
    else
        e_vector = [1; 0; 0];
        e = 1;
        aop = 0;
    end

    if (v_r >= 0)
        ta = acos(dot(e_vector, r) / (e * r_norm));
    else
        ta = 2 * pi - acos(dot(e_vector, r) / (e * r_norm));
    end

    a = 1 / (2 / r_norm - v_norm^2 / mu);

end