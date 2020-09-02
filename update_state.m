function state = update_state(state, time_step, rball, rpin)
    phi = state(4,:);
    c = cos(phi);
    s = sin(phi);
    
    e = 0.3;
    Mratio = 10;
    
    xy_dot = state(3,:).*[ c; s ];
    [state, xy_dot] = check_collisions(state, xy_dot, time_step, rball, rpin, e, Mratio);
    state([1,2],:) = state([1,2],:) + time_step*xy_dot;    
end