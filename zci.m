function ret = zci( v )

ret = find( v(:).*circshift(v(:), [-1 0]) <= 0 & v(:) <= 0);
if v(1)*v(end) == -1
    ret = ret(1:end-1);
end

%最初と最後の符号が違うとき
%最後を取り除く必要がある