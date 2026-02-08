module mre_nan
  use, intrinsic :: ieee_arithmetic, only: ieee_quiet_nan, ieee_value, ieee_is_nan
  implicit none
contains
  function get_quiet_nan() result(nan_val)
    real(kind=8) :: nan_val
    nan_val = ieee_value(nan_val, ieee_quiet_nan)
  end function get_quiet_nan
  
  function check_is_nan(x) result(is_nan)
    real(kind=8), intent(in) :: x
    logical :: is_nan
    is_nan = ieee_is_nan(x)
  end function check_is_nan
end module mre_nan 

program main
  use mre_nan
  !use, intrinsic :: ieee_arithmetic, only: ieee_quiet_nan
  implicit none
  real(kind=8) :: x
  
  x = get_quiet_nan()
  print *, "NaN value:", x
  print *, "Is NaN?", check_is_nan(x)
end program main
