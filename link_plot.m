function link_plot(x,y,w) 
%link_plot.m will call links.m 
%draw connecting linkshape function %Input:(x,y)are serial coordinates 
% w:width of links 
%Revised from :DSFon, BIME,NTU. Date:Jan. 25, 2007 
clf; 
if nargin==2,w=0;end 
for i=1:length(x)-1 
linkshape([x(i) y(i)],[x(i+1) y(i+1)],w); 
end 