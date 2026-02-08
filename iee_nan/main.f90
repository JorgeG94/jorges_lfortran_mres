program main
  use mre_nan
  implicit none
  real(kind=8) :: x
  
  x = get_quiet_nan()
  print *, "NaN value:", x
  print *, "Is NaN?", check_is_nan(x)
end program main
