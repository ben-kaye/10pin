function p = plot_shape(center, shape, c)
    cx = center(1,:);
    cy = center(2,:);
    shape_x = shape(1,:);
    shape_y = shape(2,:);
    
    p = plot(cx + shape_x, cy + shape_y, 'Color',c);
end