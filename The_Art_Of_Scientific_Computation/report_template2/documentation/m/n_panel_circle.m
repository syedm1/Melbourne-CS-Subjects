% William Page (587000) - Kevin Rassool (xxxxxx) ;
% Semester 2 2015 - University of Melbourne        ; Started:     21/4/17
% MCEN90018 - Advanced Fluid Dynamics              ; Last Edited: 29/4/17
% Assignment 2 : Panel Methods - 'n' Panel Cylinder
%
% Creates an equivilant circle using 'n' panels

function all_panels = n_panel_circle(n)

t = linspace(0,2*pi,n+1);
x = cos(t+pi/n);
y = sin(t+pi/n);
% x = cos(t+pi);
% y = sin(t+pi);

panels= [x.',y.']
new_order = circshift(flip(1:n),floor(n/2)+1,2);
new_panels = panels(new_order,:);
all_panels = zeros(n,4);

% Create end-points
for i=1:n
    if i==n % at the end, replace with the first ones
        all_panels(i,:) = [new_panels(i,:),new_panels(1,:)];
    else
        all_panels(i,:) = [new_panels(i,:),new_panels(i+1,:)];
    end
end
% 
% figure ; hold on ; axis([-1 1 -1 1])
% for i=1:n
%    Xj = [all_panels(i,1),all_panels(i,3)]
%    Yj = [all_panels(i,2),all_panels(i,4)]
%    plot(Xj,Yj,'-b','LineWidth', 2.5)
%    axis([-1 1 -1 1])
%    pause
% end

end