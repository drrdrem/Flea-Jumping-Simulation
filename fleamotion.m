% Flea jumping model revised from "doi:10.1242/jeb.052399"
% Author: Shao-An,Yin, Tian-Xiang,Gao, NOV2017

function dy = fleamotion(y)
global P L Lp
dy = [y(2);
      P(9)*((L(1)^2+Lp(1)^2-2*L(1)*Lp(1)*cos(y(1)-y(3)))^0.5-Lp(2))*(L(1)*Lp(1)*(L(1)^2+Lp(1)^2-2*L(1)*Lp(1)*cos(y(1)-y(3)))^(-.5))*sin(y(3)-y(1))*(P(1)+P(2))^(-1);
      y(4);
      -P(9)*((L(1)^2+Lp(1)^2-2*L(1)*Lp(1)*cos(y(1)-y(3)))^0.5-Lp(2))*(L(1)*Lp(1)*(L(1)^2+Lp(1)^2-2*L(1)*Lp(1)*cos(y(1)-y(3)))^(-.5))*sin(y(3)-y(1))*(P(3))^(-1);
      y(6);
      0];
end