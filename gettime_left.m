function gettime_left(tstampstr)
    
    global time_left
    
    [hour_left, temp1] = strtok(tstampstr,':');
    [min_left, temp2] = strtok(temp1,':');
    [sec_left] = strtok(temp2,':');
    
    time_lft = ((3600 .* hour_left) + (60 .* min_left) + sec_left) * 1000
    time_left = [time_left , time_lft];