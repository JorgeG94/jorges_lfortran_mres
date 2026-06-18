module outer_mod
   use inner_mod, only: inner_t
   implicit none
   private
   public :: outer_t
   type :: outer_t
      type(inner_t) :: epbl
   end type outer_t
end module outer_mod
