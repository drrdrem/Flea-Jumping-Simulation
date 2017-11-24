function linkshape(A,B,dd)
% Draw a link
% Inputs:
%      A,B:Initial & final coordinates of link
%        d:thickness of link(negative for line link)
if nargin==2,dd=1;end;
d=abs(dd);
AB=(B(1)+j*B(2))-(A(1)+j*A(2));
D=abs(AB);th=angle(AB);
t=linspace(pi/2,2.5*pi,20);
Cout=max(d/2,0.2)*exp(j*t');Cin=Cout/2;
if dd>0,
   P=[0;Cin;Cout(1:10);D+Cout(11:20);D+Cin;D+Cout(20);Cout(1)];
else
   P=[Cin;0;D;D+Cin];
end
xx=real(P);yy=imag(P);
x=xx*cos(th)-yy*sin(th)+A(1);
y=xx*sin(th)+yy*cos(th)+A(2);
line(x,y)
axis equal