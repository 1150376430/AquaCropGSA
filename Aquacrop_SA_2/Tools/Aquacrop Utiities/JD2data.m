function [dd,mm]=JD2data(JD,yy)


ansBis=bisestile(yy);

if ansBis==0; %anno non bisestile
   feb=28;
elseif ansBis==1
    feb=29;
end
if JD<=31
    mm='jan';
    dd=JD;
elseif JD>31 && JD<=31+feb
    mm='feb';
    dd=JD-31;
elseif JD>31+feb && JD<=31+feb+31
    mm='mar';
    dd=JD-31-feb;
elseif JD>31+feb+31 && JD<=31+feb+31+30
    mm='apr';
    dd=JD-31-feb-31;
elseif JD>31+feb+31+30 && JD<=31+feb+31+30+31
    mm='may';
    dd=JD-31-feb-31-30;
elseif JD>31+feb+31+30+31 && JD<=31+feb+31+30+31+30
    mm='jun';
    dd=JD-31-feb-31-30-31;
elseif JD>31+feb+31+30+31+30 && JD<=31+feb+31+30+31+30+31
    mm='jul';
    dd=JD-31-feb-31-30-31-30;
elseif JD>31+feb+31+30+31+30+31 && JD<=31+feb+31+30+31+30+31+31
    mm='aug';
    dd=JD-31-feb-31-30-31-30-31;
elseif JD>31+feb+31+30+31+30+31+31 && JD<=31+feb+31+30+31+30+31+31+30
    mm='sep';
    dd=JD-31-feb-31-30-31-30-31-31;
elseif JD>31+feb+31+30+31+30+31+31+30 && JD<=31+feb+31+30+31+30+31+31+30+31
    mm='oct';
    dd=JD-31-feb-31-30-31-30-31-31-30;
elseif JD>31+feb+31+30+31+30+31+31+30+31 && JD<=31+feb+31+30+31+30+31+31+30+31+30
    mm='nov';
    dd=JD-31-feb-31-30-31-30-31-31-30-31;
elseif JD>31+feb+31+30+31+30+31+31+30+31 && JD<=31+feb+31+30+31+30+31+31+30+31+30
    mm='nov';
    dd=JD-31-feb-31-30-31-30-31-31-30-31;
elseif JD>31+feb+31+30+31+30+31+31+30+31+30 && JD<=31+feb+31+30+31+30+31+31+30+31+30+31
    mm='dec';
    dd=JD-31-feb-31-30-31-30-31-31-30-31-30;
end
    


    
    
    
    
    
    
 