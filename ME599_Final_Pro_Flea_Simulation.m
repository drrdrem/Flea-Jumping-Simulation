clear all;
close all;
clc;
% Flea jumping motion simulation
% Final Project in ME599 k Biology Inspired Control
% Author: Shao-An,Yin, Tian-Xiang,Gao, NOV2017

global DT  P Lp L th0 TFINAL
TFINAL = 0.35; % time duration of simulation
PLOT = 1; % whether to plot trajectory results
UPDATE_RATE_HZ = 500; 
DT = 1/UPDATE_RATE_HZ; 

% P = [Mcom Mcoxa Mfemur Mtibia Icom Icoxa Ifemur Itibia  Ksriing]
P = [0.2 0.004 0.04 0.004 0.144 5.3*10^(-5) 5.3*10^(-5) 1.2*10^(-4) 5500];

%Lp = [Lm L0]
Lp = [0.055 0.35];

% L = [Lcoxa Lfemur Ltibia]
L = [0.4 0.4 0.6];

% th0 = [th0coxa th0femur th0tibia]
th0 = [(80*pi/180);0;-pi/2;0;pi/6;0];

% flea_parameters_calculation
tspan = 0:DT:TFINAL; 
[t,y1] = ode45(@(t,y) fleamotion(y),tspan,th0);


%Mechanism restriction
Np = fix(TFINAL*UPDATE_RATE_HZ+1);
for  n=1:Np
thCoxaFemur = pi + y1(n,3) - y1(n,1);
 if (thCoxaFemur > pi)
      y1(n,3) = y1(n-1,3); 
     break;
 end
end
i = n;
for n = i:Np
    y1(n,3) = y1(i,3)+y1(n,1);
end

for  n=1:Np
thFemurTibia = pi + y1(n,3) - y1(n,5);
 if (thFemurTibia > pi)
      y1(n,5) = y1(n-1,5); 
     break;
 end
end
 j = n;
for n = j:Np
        y1(n,5) = y1(j,5);
        y1(n,1) = y1(j,1);
        y1(n,3) = y1(j,3);
end

thCoxaFemur = pi + y1(:,3) - y1(:,1);
thFemurTibia = pi + y1(:,3) - y1(:,5);
thcheck = [thCoxaFemur, thFemurTibia];

Ls=(L(1)^2+Lp(1)^2-2*L(1)*Lp(1)*cos(y1(:,1)-y1(:,3))).^(.5)-Lp(2); % delta spring length
Ls0=(L(1)^2+Lp(1)^2-2*L(1)*Lp(1)*cos(th0(1)-th0(3))).^(.5)-Lp(2); % energy

%V = [Vcoxa Vfemur Vtibia]
V = [L(1)*y1(:,2).^2 L(2)*y1(:,4).^2 L(3)*y1(:,6).^2];
%Vcom = (-((P(1)^(-1))*(P(1)*y1(:,1).^2+P(2)*y1(:,1).^2+P(3)*y1(:,3).^2+P(4)*y1(:,5).^2+P(6)*V(:,1).^2+P(7)*V(:,2).^2+P(8)*V(:,3).^2)-P(9)*((L(3)^2+Lp(1)^2-2*L(3)*Lp(1)*cos(y1(:,3)-y1(:,5))).^0.5-Lp(2)))).^0.5;
% P = [Mcom Mcoxa Mfemur Mtibia Icom Icoxa Ifemur Itibia  Ksriin
Vcom=(P(1).^(-1)*(P(9)*Ls0^2-P(9)*Ls.^2-P(2)*V(1).^2-P(3)*V(2).^2-P(4)*V(3).^2-P(5)*y1(:,2).^2-P(6)*y1(:,2).^2-P(7)*y1(:,4).^2-P(8)*y1(:,6).^2)).^0.5;

H = figure(1)
set(gcf,'Units','centimeters','position',[5 5 20 12]);
clf()
axis tight manual % this ensures that getframe() returns a consistent sizeclf()
filename = 'testAnimated.gif';
n = 1;     
for t=0:DT:TFINAL
    S = Vcom(1:n).*DT; %path in each delta t (DT)
    y = real(sum(S))*sin(y1(n,1));
    x = real(sum(S))*cos(y1(n,3));
    th = [y1(n,1), y1(n,3), y1(n,5)];
    h(n,1) = y;
    h(n,2) = x;
    plot_flealeg(x,y,L,th)
    hold on
    plot(h(:,2),h(:,1),'r','LineWidth',3);
    ylim([-0.5, 4.5])
    xlim([-1, 7])  
    hold off
    xlabel('Displacement (mm)');ylabel('Hight (mm)');title('Flea Jumping Simulation Animation');
    drawnow
    
      % Capture the plot as an image 
      frame = getframe(H); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 

      % Write to the GIF File 
      if n == 1 
          imwrite(imind,cm,filename,'gif', 'WriteMode', 'overwrite', 'DelayTime', 0, 'LoopCount', Inf ); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 

    n = n+1;
end


Time = tspan';

figure(2)
plot(Time, real(Vcom),'LineWidth',4);
xlabel('Time (s)');ylabel('Velocity (mm/s)');title('Flea Jumping Velocity');

figure(3)
plot(Time, h(:,1),'r','LineWidth',4)
xlabel('Time (s)');ylabel('Displacement (mm)');title('Flea Jumping Path')

figure(4)
plot(Time, thcheck(:,1),Time, thcheck(:,2),'r','LineWidth',4)
xlabel('Time (s)');ylabel('Angle (rad)');title('Joint Angle')
legend('Angle between Coxa and Femur', 'Angle between Femur and Tibia','Location','SouthEast')

figure(5)
plot(Time, y1(:,1),Time, y1(:,3),'r',Time, y1(:,5), 'g', 'LineWidth',4)
xlabel('Time (s)');ylabel('Angle (rad)');title('Global Angle of Each Rod')
legend('Angle of Coxa', 'Angle of Femur','Angle of Tibia','Location','SouthEast')
