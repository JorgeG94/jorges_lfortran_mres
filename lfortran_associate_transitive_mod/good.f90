! WORKS: same code, but inner_t is imported explicitly.
module run_good
   use outer_mod, only: outer_t
   use inner_mod, only: inner_t   ! <-- the only difference vs bad.f90
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
end module run_good
