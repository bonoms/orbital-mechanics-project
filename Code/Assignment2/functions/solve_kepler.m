function [ta] = solve_kepler(t, sma, ecc, mu, t0, ta0, tol)
    n = sqrt(mu / sma^3);
    
    E0 = atan2(sqrt(1 - ecc^2) * sin(ta0), ecc + cos(ta0));

    M0 = E0 - ecc * sin(E0);
    M = M0 + n * (t - t0);
    
    k = floor(M / (2 * pi));
    M_bar = mod(M, 2 * pi);

    if (nargin < 7)
        tol = 1e-6;
    end

    E_guess = M_bar + (ecc * sin(M_bar)) ./ (1 - sin(M_bar + ecc) + sin(M_bar));
    options = optimset('TolX', tol);

    ta = zeros(size(t));
    for i = 1:numel(t)
        f = @(x) x - ecc * sin(x) - M_bar(i);
        E_bar = fzero(f, E_guess(i), options);
        ta_bar = wrapTo2Pi(atan2(sqrt(1 - ecc^2) * sin(E_bar), cos(E_bar) - ecc));
        ta(i) = 2 * pi * k(i) + ta_bar;
    end
end
