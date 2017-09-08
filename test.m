function test
    %% constants
    G = 1; % [m^3/kg/s^2] gravitational constant

    %% Create bodies
    earth = body(3.986004418e14, [0;0;0], [0;0;0], 6378e3 *10);
    moon  = body(4.9048695e12, [0;385e6;0], [1022;0;0], 1737e3 * 10);
    bodies = [...
        earth,...
        moon];
    n = length(bodies);
    %% Create graphics
    ax1 = axes(...
        'DataAspectRatio', [1 1 1]);
    hold on
    for ii = 1:n
        bodies(ii).plot;
        disp(derivative(ii));
    end
    

    %% Simulate



    %calculate current acceleration of body with index N
    function D2x = derivative(N)
        D2x = 0;
        for qq = 1:n
            if qq ~= N
                relPos = bodies(qq).position - bodies(N).position;
                relDist = norm(relPos);
                D2x = D2x + bodies(qq).mu / relDist^3 * relPos;
            end
        end
    end
end


