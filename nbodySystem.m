classdef nbodySystem < handle
    %SYSTEM n-body gravitational system with RK4 simulation
    % Huib Versteeg 2017-09-09
    
    properties(Access=private)
        %% internal values/objects
        bodies;
        x_0;
        x; % state matrix, each row is a state, each column a timestamp
        time;
        n_bodies;
        n_steps;
        
        %% graphics handles
        fig;
        ax;
        orbits;
    end
    %%
    methods(Access=public)
        
        function self = nbodySystem()
            self.bodies = [...
                body(3.986004418e14,     [0;0;0], [-12.58;0;0], 6378e3 * 1, 'earth');...
                body(  4.9048695e12, [0;385e6;0],   [1022;0;0], 1737e3 * 1,  'moon')];
            self.n_bodies = length(self.bodies);
            self.x_0 = reshape([self.bodies.position; self.bodies.velocity], [self.n_bodies * 6, 1]);
        end
        
        function simulate(self, t_end, h)
            self.time = 0:h:t_end;
            self.n_steps = length(self.time) - 1;
            self.x = [self.x_0, zeros(self.n_bodies * 6, self.n_steps)];
            
            % RK4 integration
            for i=1:self.n_steps    % calculation loop
                k_1 = self.derivative(self.x(:,i));
                k_2 = self.derivative(self.x(:,i) + 0.5*h * k_1);
                k_3 = self.derivative(self.x(:,i) + 0.5*h * k_2);
                k_4 = self.derivative(self.x(:,i) + h * k_3);
                self.x(:,i+1) = self.x(:,i) + (k_1 + 2*k_2 + 2*k_3 + k_4) * h/6;
            end
        end
        
        function Dy = derivative(self, y)
            Dy = zeros(6 * self.n_bodies, 1); % derivative of state vector
            for qq = 1:self.n_bodies % cycle over all the bodies
                ind1 = 6 * (qq - 1) + (1:3);   % indices for pos in x and vel in Dx
                ind2 = ind1 + 3;              % indices for vel in x and accel in Dx
                % calculate gravitational influence of all other bodies on the current body
                for rr = 1:self.n_bodies
                    if rr ~= qq
                        relPos = y(6*(rr-1)+(1:3)) - y(ind1);
                        relDist = norm(relPos);
                        Dy(ind2) = Dy(ind2) + self.bodies(rr).mu / relDist^3 * relPos;
                    end
                end
                Dy(ind1) = y(ind2);
            end
        end
        
        function plotInit(self)
            self.fig = figure();
            self.ax  = axes(...
                'DataAspectRatio', [1 1 1]);
            hold on
            for ii = 1:self.n_bodies
                self.bodies(ii).plot;
            end
            hold off
        end
        
        function plotOrbits(self)
            figure(self.fig)
            axes(self.ax)
            hold on
            self.orbits = gobjects(self.n_bodies, 1);
            for ii = 1:self.n_bodies
                ind = 6 * (ii - 1);
                self.orbits(ii) = plot3(...
                    self.x(ind+1, :), self.x(ind+2, :), self.x(ind+3, :));
            end
            hold off
        end
        
        function animate(self)
            for ii = 1:10:self.n_steps
                for jj = 1:self.n_bodies
                    ind = 6 * (jj - 1);
                    self.bodies(jj).updatePosition(self.x(ind+(1:3), ii));
                end
            end
        end
        
        function addBody(self)
        end
        
    end
    
end

