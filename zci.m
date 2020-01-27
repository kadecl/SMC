function ret = zci( v )

ret = find( v(:).*circshift(v(:), [-1 0]) <= 0 & v(:) <= 0);
if v(1)*v(end) == -1
    ret = ret(1:end-1);
end

%Å‰‚ÆÅŒã‚Ì•„†‚ªˆá‚¤‚Æ‚«
%ÅŒã‚ðŽæ‚èœ‚­•K—v‚ª‚ ‚é