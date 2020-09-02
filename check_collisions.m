function [state, xy_dot] = check_collisions(state, xy_dot, time_step, rball, rpin, e, Mratio) 
    xy = state([1,2],:);
    
    for i = 1:10
        for j = i+1:11
            p1 = xy(:,i);
            p2 = xy(:,j);
            
            v1 = xy_dot(:,i);
            v2 = xy_dot(:,j);
            
            p_rel = p2 - p1;
            v_rel = v2 - v1;
            
            if i == 1
                r_sqr = (rball + rpin)^2;
            else
                r_sqr = 4*rpin^2;
            end
            
            % iff collision will happen, consider sqrts (big efficiency
            % boost)
            if (p_rel + v_rel*time_step)'*(p_rel + v_rel*time_step) <= r_sqr
                %%% collision %%%                
                
                % unit vector in collision axis
                dir_p_rel = p_rel / norm(p_rel,2);

                % project velocities along collision axis
                w = dir_p_rel'*v1;
                u = dir_p_rel'*v2;
                
                % get tangent velocities
                a = v1 - w*dir_p_rel;
                b = v2 - u*dir_p_rel;
                
                if i == 1
                    p = u*(1 - e)/(1 + Mratio) + w*(Mratio + e)/(1 + Mratio);
                    q = p + e*(u - w);
                else
                    p = u*(1 - e)/2 + w*(1 + e)/2;
                    q = e*(u - w) + p;
                end
                
                v1new = a + p*dir_p_rel;
                v2new = b + q*dir_p_rel;
                
                v1abs = norm(v1new,2);
                v2abs = norm(v2new,2);
                
                phi1new = atan2(v1new(2),v1new(1));
                phi2new = atan2(v2new(2),v2new(1));
                               
                % update states
                state(3,i) = v1abs;
                state(4,i) = phi1new;
                state(3,j) = v2abs;
                state(4,j) = phi2new;
                
                xy_dot(:,i) = v1new;
                xy_dot(:,j) = v2new;
            end
        end
    end
end