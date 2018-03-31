% make an tuna
function tuna = its_not_a_tuna % Makes a tuna

[NUM,TXT,RAW]=xlsread('tunapoints_excel.xls'); % Read data points, exported from solidworks
tuna = zeros(length(NUM),4); % Pre-allocate array

for j=1:length(NUM) % For every co-ordinate, add the 
    if j==length(NUM) ; tuna(j,:) = [NUM(j,:),NUM(1,:)  ]; % Last endpoint == 1st startpoint 
    else                tuna(j,:) = [NUM(j,:),NUM(j+1,:)]; % Add an endpoint
    end ; end % Close if and for loops
tuna = tuna/100; % Dimensionalise to match the velocity evaluation meshgrid