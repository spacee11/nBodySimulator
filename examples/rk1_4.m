function [...
    t_out,...            column vector of times at which y was evaluated
    y_out]...            a matrix, each row of which contains the components of y
  = rk1_4(...
    ode_function,...    handle for user M-function in which the derivatives f are computed
    tspan,...           the vector [t0 tf] giving the time interval for the solution
    y0,...              column vector of initial values of the vector y
    h,...               time step
    rk...               = 1 for RK1; = 2 for RK2; = 3 for RK3; = 4 for RK4
    )
%{
This function uses a selected Runge-Kutta procedure to integrate
a system of first-order differential equations dy/dt = f(t,y).
f - 
t_inner - 
y_inner - 
%}
    tic
%% ..Determine which of the four Runge-Kutta methods is to be used:
% n_stages - the number of points within a time interval that the derivatives are to be computed
% a - coefficients for locating the solution points within each time interval
% b - coefficients for computing the derivatives at each interior point
% c - coefficients for the computing solution at the end of the time step
    switch rk
        case 1
            n_stages = 1;
            a = 0;
            b = 0;
            c = 1;
        case 2
            n_stages = 2;
            a = [0 1];
            b = [0 1]';
            c = [1/2 1/2];
        case 3
            n_stages = 3;
            a = [0 1/2 1];
            b = [  0 0
                 1/2 0
                  -1 2];
            c = [1/6 2/3 1/6];
        case 4
            n_stages = 4;
            a = [0 1/2 1/2 1];
            b = [ 0   0 0
                1/2   0 0
                  0 1/2 0
                  0   0 1];
            c = [1/6 1/3 1/3 1/6];
        otherwise
        error('The parameter rk must have the value 1, 2, 3 or 4.')
    end
    t_out = (tspan(1):h:tspan(2))';
    n_steps = length(t_out) - 1; % number of integration steps to be taken
    y = y0;         % column vector of solutions
    y_out = [y' ; zeros(n_steps, length(y))];
    for ii=1:n_steps
        ti = t_out(ii);     % time at the beginning of a time step
        yi = y;     % values of y at the beginning of a time step
        %...Evaluate the time derivative(s) at the 'n_stages' points within the
        % current interval:
        for i = 1:n_stages
            t_inner = ti + a(i)*h;  % time within a given time step
            y_inner = yi;           % values of y within a given time step
            for j = 1:i-1
                y_inner = y_inner + h*b(i,j)*f(:,j);
            end
            % column vector of the derivatives dy/dt evaluated at the corresponding time in tout
            f(:,i) = feval(ode_function, t_inner, y_inner);
        end
        y = yi + h*f*c';
        y_out(ii+1, :) = y'; % adds y' to the correct index of y_out
    end
    disp(toc)
    disp(f)
end
