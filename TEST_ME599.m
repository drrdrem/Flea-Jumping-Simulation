clear all;
close all;
% Flea jumping motion simulation
% Author: Shao-An,Yin
global DT  P Lp L th0 TFINAL
TFINAL = 0.5; % time duration of simulation
PLOT = 1; % whether to plot trajectory results
UPDATE_RATE_HZ = 500; 
DT = 1/UPDATE_RATE_HZ; 

% P = [Icom Icoxa Ifemur Itibia Mcom Mcoxa Mfemur Mtibia Ksriing]
P = [0.2 0.004 0.004 0.004 0.144 5.3*10^(-5) 5.3*10^(-5) 1.2*10^(-4) 55];

%Lp = [Lm L0]
Lp = [0.055 0.35];

% L = [Lcoxa Lfemur Ltibia]
L = [0.4 0.4 0.4];

% th0 = [th0coxa th0femur th0tibia]
th0 = [(80*pi/180);0;-pi/2;0;pi/3;0];

% flea_parameters_calculation
tspan = [0:DT:TFINAL]; 
[t,y1] = ode45(@(t,y) fleamotion(y),tspan,th0);

%V = [Vcoxa Vfemur Vtibia]
V = [L(1)*y1(:,2).^2 L(2)*y1(:,4).^2 L(3)*y1(:,6).^2];
Vcom = ((P(5)^(-1))*(P(1)*y1(:,1).^2+P(2)*y1(:,1).^2+P(3)*y1(:,3).^2+P(4)*y1(:,5).^2+P(6)*V(:,1).^2+P(7)*V(:,2).^2+P(8)*V(:,3).^2)-P(9)*((L(3)^2+Lp(1)^2-2*L(3)*Lp(1)*cos(y1(:,3)-y1(:,5))).^0.5-Lp(2))).^0.5;

figure(1)
clf()
for t=0:DT:TFINAL
    n = fix(t*UPDATE_RATE_HZ+1);
    y = Vcom(n,1)*sin(th0(5));
    x = Vcom(n,1)*cos(th0(5));
    th = [y1(n,1), y1(n,3), y1(n,5)];
    plot_flealeg(x,y,L,th)
    ylim([-0.5, 3])
    xlim([-1, 7])
    drawnow
end
