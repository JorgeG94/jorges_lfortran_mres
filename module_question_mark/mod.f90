module test_mod
    implicit none
    private
    public :: grid_type, sub_a

    type :: grid_type
        integer :: n
    end type grid_type

contains

    subroutine sub_b(x, G)
        type(grid_type), intent(in) :: G
        real, dimension(G%n), intent(inout) :: x
        x = x + 1.0
    end subroutine sub_b

    subroutine sub_a(h, G)
        type(grid_type), intent(in) :: G
        real, dimension(G%n, G%n), intent(inout) :: h
        call sub_b(h(:, 1), G)
    end subroutine sub_a

end module test_mod
