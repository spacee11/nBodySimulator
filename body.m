classdef body < handle
    %BODY describes the gravitational & graphical properties of a body
    % Huib Versteeg 2017-09-09
    
    properties(Access=public)
        mu;             % [m^3/s^2] standard gravitational parameter
        positionInit;   % [m] initial x;y;z coordinates of body center
        velocityInit;   % [m/s] initial 3x1 velocity vector 
        position;       % [m] x;y;z coordinates of body center
        velocity;       % [m/s] vx;vy;vz velocity vector
        radius;         % [m] radius of graphical part
        name;           % char array containing name of object
    end
    
    properties(Access=private)
        % coordinates for sphere graphics vertices
        sphereX;
        sphereY;
        sphereZ;
        % Graphics handles
        sphereGraphics;
        label;
        marker;
    end
    
    methods
        function self = body(...
                mu,...          [m^3/s^2] standard gravitational parameter
                position,...    [m] x;y;z velocity vector
                velocity,...    [m/s] x;y;z velocity vector
                radius,...      [m] radius of graphical part
                name...         char array containing name
                )
            self.mu       = mu;
            self.positionInit = position;
            self.velocityInit = velocity;
            self.position = position;
            self.velocity = velocity;
            self.radius   = radius;
            self.name     = name;
            % create initial coordinates for sphere graphics
            [self.sphereX, self.sphereY, self.sphereZ] = sphere(10);
            self.sphereX = self.sphereX * radius + position(1);
            self.sphereY = self.sphereY * radius + position(2);
            self.sphereZ = self.sphereZ * radius + position(3);
        end
        
        function plot(self)
            self.sphereGraphics = surf(...
                self.sphereX, self.sphereY, self.sphereZ,...
                'FaceLighting',     'gouraud',...
                'EdgeColor',        'none',...
                'FaceColor',        'interp',...
                'FaceAlpha',        0.2);
            self.label = text(...
                'String',           self.name,...
                'Position',         self.position + self.radius);
            self.marker = plot3(...
                self.position(1), self.position(2), self.position(3), 'ob');
               
        end
        
        function updatePosition(self, newPos)
            dr = newPos - self.position;
            self.position = newPos;
            self.sphereX = self.sphereX + dr(1);
            self.sphereY = self.sphereY + dr(2);
            self.sphereZ = self.sphereZ + dr(3);
            self.sphereGraphics.XData = self.sphereX;
            self.sphereGraphics.YData = self.sphereY;
            self.sphereGraphics.ZData = self.sphereZ;
            self.label.Position = self.position;
            self.marker.XData = self.position(1);
            self.marker.YData = self.position(2);
            self.marker.ZData = self.position(3);
            drawnow;
        end
    end
    
end

