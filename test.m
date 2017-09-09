function test

    %% Create bodies
    bodies = [...
        body(3.986004418e14,     [0;0;0], [-12.58;0;0], 6378e3 * 1, 'earth');...
        body(  4.9048695e12, [0;385e6;0],   [1022;0;0], 1737e3 * 1,  'moon')];
    n = length(bodies);
    %% Create graphics
    clf;
    axes(...
        'DataAspectRatio', [1 1 1]);
    hold on
    x_0 = reshape([bodies.position; bodies.velocity], [n * 6, 1]);
    for ii = 1:n
        bodies(ii).plot;
    end

    %% Simulate
    t_0 = 0;
    t_end = 3600*24*60;
    h = 100;
    time = t_0:h:t_end;
    n_steps = length(time) - 1;
    x = [x_0, zeros(n * 6, n_steps)];
    tic
    rk4();
    toc
    CoM = (x(1:3, :) * bodies(1).mu + x(7:9, :) * bodies(2).mu) / sum([bodies.mu]);
    plot3(x(1,:), x(2,:), x(3,:))
    plot3(x(7,:), x(8,:), x(9,:))
    plot3(CoM(1,:), CoM(2,:), CoM(3,:))
    hold off

    % calculate current acceleration of body with index N
    % x: state column vector, position and velocity of each body in the same order as bodies vector
    % [x1 y1 z1, vx1 vy1 vz1, x2 y2 ....]' 
    function Dy = derivative(y)
        Dy = zeros(6 * n, 1); % derivative of state vector
        for qq = 1:n % cycle over all the bodies
            ind1 = 6 * (qq - 1) + (1:3);   % indices for pos in x and vel in Dx
            ind2 = ind1 + 3;              % indices for vel in x and accel in Dx
            % calculate gravitational influence of all other bodies on the current body
            for rr = 1:n
                if rr ~= qq
                    relPos = y(6*(rr-1)+(1:3)) - y(ind1);
                    relDist = norm(relPos);
                    Dy(ind2) = Dy(ind2) + bodies(rr).mu / relDist^3 * relPos;
                end
            end
            Dy(ind1) = y(ind2);
        end
    end

    function rk4()
        for i=1:n_steps                              % calculation loop
            k_1 = derivative(x(:,i));
            k_2 = derivative(x(:,i) + 0.5*h * k_1);
            k_3 = derivative(x(:,i) + 0.5*h * k_2);
            k_4 = derivative(x(:,i) + h * k_3);
            x(:,i+1) = x(:,i) + (k_1 + 2*k_2 + 2*k_3 + k_4) * h/6;  % main equation
        end
    end
end


