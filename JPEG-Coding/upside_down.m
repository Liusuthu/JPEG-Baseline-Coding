function back=upside_down(str)
str=strrep(str,'1','2');
str=strrep(str,'0','1');
str=strrep(str,'2','0');
back=str;