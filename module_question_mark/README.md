# LFortran Compiler Segfault MRE

Minimal reproducer for an LFortran compiler crash (segfault) when compiling a program that imports a module from a separately compiled unit.

## LFortran Version

```
LFortran version: 0.59.0
Platform: macOS ARM
LLVM: 19.1.1
```

## Bug Description

LFortran crashes with a segmentation fault when compiling `main.f90` which `use`s a module from a separately compiled `mod.f90`. The crash occurs during compilation, not at runtime.

The bug is triggered when:
1. A module contains a derived type with an integer field used for array bounds
2. A subroutine (`sub_a`) passes an array slice (e.g., `h(:, 1)`) to another subroutine (`sub_b`)
3. Both subroutines use the derived type for array dimension specification
4. The module is compiled separately and linked as a library

## Files

- `mod.f90` - Module with derived type and two subroutines
- `main.f90` - Program that just imports the module (doesn't even call anything)
- `Makefile` - Build script

## To Reproduce

```bash
# Fails with segfault
FC=lfortran make

# Works fine
FC=gfortran make
```

## Expected Behavior

Compilation should succeed (as it does with gfortran).

## Actual Behavior

```
lfortran -c mod.f90 -o mod.o
ar rcs libmod.a mod.o
lfortran -c main.f90 -o main.o
make: *** [main.o] Segmentation fault: 11
```

## Workarounds That Make It Compile

1. Compile both files together: `lfortran mod.f90 main.f90 -o test`
2. Remove the array slice (pass whole array instead of `h(:, 1)`)
3. Remove the call to `sub_b` entirely
4. Use plain integers instead of type fields for array dimensions

## Minimal Code

**mod.f90:**
```fortran
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
```

**main.f90:**
```fortran
program main
    use test_mod, only: grid_type, sub_a
    implicit none
end program main
```
