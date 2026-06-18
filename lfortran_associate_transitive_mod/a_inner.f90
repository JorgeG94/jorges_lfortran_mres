module inner_mod
   implicit none
   private
   public :: inner_t
   type :: inner_t
      logical :: enable = .false.
   end type inner_t
end module inner_mod
