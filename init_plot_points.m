function [ball_plot, pins_plot] = init_plot_points(states, ball, pin_shape, max_dev)
    xy = states([1,2],:);

    ball_center = xy(:,1);
    pin_centers = xy(:,2:end);
    
    ball_plot = plot_shape(ball_center, ball, 1/255*[33, 87, 173]);
    pins_plot = gobjects(10,1);
    hold on
    xline(-max_dev);
    xline(max_dev);
    for i = 1:10
        pins_plot(i) = plot_shape(pin_centers(:,i), pin_shape, [1,0,0]);
    end
    hold off
    axis equal
end