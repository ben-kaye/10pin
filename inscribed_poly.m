function poly = inscribed_poly(n, r, phi)
    theta = 0:2*pi/n:2*pi;
    
    poly = r*[ cos(theta + phi); sin(theta + phi) ];    
end

