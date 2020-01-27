function index = tm2ix(h,m,s,fr)
index = floor((3600*h + 60 * m + s)*fr);