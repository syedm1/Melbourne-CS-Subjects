% William Page (587000) - Kevin Rassool (540773) ;
% Semester 2 2017 - University of Melbourne        ; Started:     21/4/17
% MCEN90018 - Advanced Fluid Dynamics              ; Last Edited: 29/4/17
% Assignment 2 : Panel Methods snippet, finding CP
%
%% Snippet which shows the calculation of CP

% Midpoint matrix
panels_points = n_panel_circle(n_pan) 
Xmj           = 0.5*(panels_points(:,1) + panels_points(:,3)) ;
Ymj           = 0.5*(panels_points(:,2) + panels_points(:,4)) ;

mesh_res = 0.01 ; [xp, yp] = meshgrid( -2:mesh_res:2 , -2:mesh_res:2 ) ;
[u_hat,v_hat] = deal(zeros(size(xp))) ;          % Initialise cartesian velocity directions 
[u_hat_surf,v_hat_surf]=deal(zeros(size(Xmj))) ; % Initialise midpoint velocity directions 

% This next loop runs through each of the panels and sums the velocity
% contribution at each point in space as a result of the panels.   

for n=1:n_pan  % for each panel
    
    Xj=[panels(n,1),panels(n,3)];
    Yj=[panels(n,2),panels(n,4)];
    
    [u,v] = flow_field_cyl_1_0( Xj , Yj , q(n) , xp , yp );
    
    u_hat=u_hat + u; % Solve the full flow
    v_hat=v_hat + v;
    
    [u_surf,v_surf] = flow_field_cyl_1_0( Xj , Yj , q(n) , Xmj , Ymj );
    
    u_hat_surf=u_hat_surf + u_surf ; % Solve velocities at the edges of the circle 
    v_hat_surf=v_hat_surf + v_surf ;
end

u_hat_inf = u_hat + U_inf;
time_pattern = toc

%% Calculate Cp

U_c_u = u_hat_surf + U_inf ; % Find total U component of velocity at edges of panels
U_c_v = v_hat_surf ;         % Find total V component of velocity at edges of panels
U_c   = sqrt(U_c_u.^2+U_c_v.^2) ; % Velocity magnitude 

Cp=1-(U_c/U_inf).^2 ; % Cp opbtained from panel methods

% Obtain Cp from potential flow theory
theta2 = 0:.1:2*pi ; th = 0:2*pi/n_pan:2*pi ; Cp_th=(1-4*sin(theta2).^2).' ;

save('CP_data_64pan','th','theta2','Cp','Cp_th')

figure ; hold on ; plot(theta2,Cp_th,'r--'); plot(th,[Cp;1],'bx');
axis equal; axis([0 2*pi -3 1]);
xlabel('\theta (rad)'); ylabel('C_{p} (-)');
title('Qn2 : Pressure Coefficient around cylinder (w.page, k.rassool) ') ;
legend('Theoretical Cp','Panel Method Cp')