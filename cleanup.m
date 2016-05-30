% This function will cleanup variables and close the window
function cleanup(src, callbackdata)
global arduino;

fclose(instrfindall);
delete(src)
clear all