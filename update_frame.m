function [ball_plot, pins_plot, update_flag] = update_frame(states, ball, pinshape, ball_plot, pins_plot)
    update_flag = 0;
    hold on
    if isvalid(ball_plot)
        delete(ball_plot);
        ball_plot = plot_shape(states([1,2], 1), ball, 1/255*[33, 87, 173]);
        update_flag = 1;
    end
    
    for i = 1:10
        if (states(3,i+1) > 0) && isvalid(pins_plot(i))
            delete(pins_plot(i));
            pins_plot(i) = plot_shape(states([1,2],i+1), pinshape, [1,0,0]);
            update_flag = 1;
        end
    end
    hold off
    
end