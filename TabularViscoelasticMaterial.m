function [ViscoelasticTable, Young]=TabularViscoelasticMaterial(freq, youngs_cplx, shift, left_broadening, right_broadening, poisson, targetFrequency)
    % freq # excitation freq in Hz
    % youngs_cplx  # complex youngs modulus
    % shift = 0.0  # frequency shift induced relative to nominal properties
    % left_broadening = 1.0  # 1 is no broadening
    % right_broadening = 1.0  # 1 is no broadening

    % Apply shift and broadening factors to frequency
    freq = log10(freq) - log10(shift);
    [~, i] = max(imag(youngs_cplx) ./ real(youngs_cplx));
    f = freq(i);
    freq(1:i) = left_broadening * (freq(1:i) - f) + f;
    freq(i:end) = right_broadening * (freq(i:end) - f) + f;
    freq = 10.^freq;

    % Normalize modulus
    shear_cplx = youngs_cplx / (2 * (1 + poisson));
    bulk_cplx = youngs_cplx / (3 * (1 - 2 * poisson));
    shear_inf = real(shear_cplx(1));
    bulk_inf = real(bulk_cplx(1));

    wgstar = complex(imag(shear_cplx) / shear_inf, 1 - real(shear_cplx) / shear_inf);
    wkstar = complex(imag(bulk_cplx) / bulk_inf, 1 - real(bulk_cplx) / bulk_inf);

    ViscoelasticTable=[real(wgstar), imag(wgstar), real(wkstar), imag(wkstar), freq];
    
    % % Find the index of the frequency closest to 1 Hz (or targetFrequency)
    % [~, idx] = min(abs(freq - targetFrequency));
    % 
    % % Get the corresponding Young's modulus at that frequency
    % Young = real(youngs_cplx(idx));
    Young = real(youngs_cplx(1));

end
