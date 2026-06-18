! BROKEN: inner_t is reached only transitively (via outer_mod).
! lfortran 0.63.0 cannot resolve e%enable through the associate.
module run_bad
   use outer_mod, only: outer_t
   implicit none
   private
   public :: run
contains
   subroutine run(o)
      type(outer_t), intent(inout) :: o
      associate (e => o%epbl)
         e%enable = .true.
      end associate
   end subroutine run
end module run_bad
