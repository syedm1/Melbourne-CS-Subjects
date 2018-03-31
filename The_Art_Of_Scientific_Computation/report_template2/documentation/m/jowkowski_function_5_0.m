function final_panels = jowkowski_function_5_0(alpha_deg)

a = 1; c = 0.95; x_s = -0.04875; y_s = 0.05*1i; % Set Jowkowski conditions
n_steps = 64                                  ; % Set number of panels to use
alpha   = alpha_deg/180*pi                    ; % Angle of attack in radians
th      = linspace(0,2*pi,n_steps+1)          ; % Theta for circle definition

z   = a*(cos(th)+1i*sin(th)); % Define the cylinder in the flow
z_c = c*(cos(th)+1i*sin(th)); % Define the smaller transform circle (for visual display)

%% Transformation 0
%We shift the circle with radius a relative to a Jowkowski 
%circle of radius c by the amounts xs and ys, such that the two circles 
%intersect on the x axis (to obtain the sharp trailing edge cusp).

w0 =z + x_s +y_s;
%% Transformations 1 and 2 
%We apply the Joukowski transformation
%We add the angle of attack ?
w1=w0+c^2./w0;
w2=w1*exp(-alpha*1i);

%% Create clockwise set of start and endpoints
airfoil_panels=[real(w2);imag(w2)].';
clipped_panels=airfoil_panels(1:end-1,:); n=length(clipped_panels);
flipped_panels=flip(clipped_panels); 

all_panels = zeros(n,4); % Initialise start and endpoints matrix
for j=1:n                % Create the start and endpoints matrix
    if j==n % at the end, replace with the first ones
        all_panels(j,:) = [flipped_panels(j,:),flipped_panels(1,:)];
    else
        all_panels(j,:) = [flipped_panels(j,:),flipped_panels(j+1,:)];
    end
end

final_panels=circshift(all_panels,1,1); % Arrange panels correctly
end