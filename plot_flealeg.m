function plot_flealeg(x,y,l, th)
clf;
u = zeros(1,length(l));
v = zeros(1,length(l));
u(1)=x;
v(1)=y;
for i=1:length(l)
    u(i+1) = u(i) - l(i)*cos(th(i));
    v(i+1) = v(i) - l(i)*sin(th(i));
end
    link_plot(u,v)  
