classdef body < handle
    %BODY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mu       = 1;               % [m^3/s^2] standard gravitational parameter
        position = [0; 0; 0];       % [m] x;y;z coordinates of body center
        velocity = [0; 0; 0];       % [m/s] 3x1 velocity vector 
        radius   = 1;               % [m] radius of graphical part
    end
    
    properties(Access=private)
        sphereX;
        sphereY;
        sphereZ;
        sphereGraphics;
    end
    
    methods
        function self = body(...
                mu,...          [m^3/s^2] standard gravitational parameter
                position,...    [m] x;y;z velocity vector
                velocity,...    [m/s] x;y;z velocity vector
                radius...       [m] radius of graphical part
                )
            self.mu       = mu;
            self.position = position;
            self.velocity = velocity;
            self.radius   = radius;
            [self.sphereX, self.sphereY, self.sphereZ] = sphere(8);
            self.sphereX = self.sphereX * radius + position(1);
            self.sphereY = self.sphereY * radius + position(2);
            self.sphereZ = self.sphereZ * radius + position(3);
        end
        
        function plot(self)
            self.sphereGraphics = ...
                surf(self.sphereX, self.sphereY, self.sphereZ);
        end
        
        function updatePosition(self, newPos)
            dr = newPos - self.position;
            self.sphereX = self.sphereX + dr(1);
            self.sphereY = self.sphereY + dr(2);
            self.sphereZ = self.sphereZ + dr(3);
            self.sphereGraphics.XData = self.sphereX;
            self.sphereGraphics.YData = self.sphereY;
            self.sphereGraphics.ZData = self.sphereZ;
        end
    end
    
end

