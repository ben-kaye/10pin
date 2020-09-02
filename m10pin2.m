clear

%%% PARAMETERS %%% 

rball = 0.3;
rpin = 0.15;
max_length = 14;
max_dev = 2.2;
x_axis_lims = [ -max_dev+rball, max_dev-rball ];
dist_to_pins = 10;
ball_speed = 6;
direction_offset = 3; % {deg}

sim_time = 10;
step_size = 5e-4;
N = floor(sim_time/step_size);

fps = 30;
Ndraw = floor(N/sim_time/fps);

capture_state = cell(Ndraw,1);

pin_shape = inscribed_poly(7, rpin, 0);
ball = inscribed_poly(9, rball, 3/18*pi);

%%% INITIALISE STATE %%%

states = zeros(4,11);
states(3,1) = ball_speed;
states(4,1) = (90 + direction_offset) * pi/180;
pin_layout = [0; dist_to_pins] + [ 0, 0.5, 0, 1, 0.5, 1.5, -0.5, -1, -0.5, -1.5; 0, sqrt(3)/2, sqrt(3), sqrt(3), 3/2*sqrt(3), 3/2*sqrt(3), sqrt(3)/2, sqrt(3), 3/2*sqrt(3), 3/2*sqrt(3) ];
states([1,2],2:end) = pin_layout;

%%% SIMULATION %%%

tic;
for u = 1:N     
    states = update_state(states, step_size, rball, rpin);
    if mod(u,Ndraw) == 0
        capture_state{u/Ndraw} = states(1:3,:);
    end   
end
compute_time = toc;

fprintf('Simulated, completed in %fs\n',compute_time);

change = states([1,2],2:end)-pin_layout;
moved = (vecnorm(change,1) > 0);
score = sum(moved);

%%% RENDERING %%%

fig = figure('units','normalized','outerposition',[0 0 0.6 1]);
[ ball_plot, pin_plots ] = init_plot_points(capture_state{1}, ball, pin_shape, max_dev);
drawnow

tic;

upd = 1;
for f = 1:length(capture_state)

    current_state = capture_state{f};
    
    z_c = (current_state(2,:) > max_length);
    y_c = (abs(current_state(1,:)) > max_dev);
    
    cond = z_c | y_c;
    if cond(1)
        delete(ball_plot);
    end
    
    delete(pin_plots(cond(2:end)));
    [ ball_plot, pin_plots, upd ] = update_frame(current_state, ball, pin_shape, ball_plot, pin_plots);
    xlim(x_axis_lims);
    
    drawnow;
    
    frame_time = toc;
    
    if ~upd
        %no updates required
        break
    end
    
    if frame_time < 1/fps
        pause(1/fps - frame_time);
    end
    
    tic;
end









