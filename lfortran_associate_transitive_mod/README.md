# lfortran MRE — `associate` on a transitively-imported derived-type component

LFortran 0.63.0. Mirrors my app's build error:

```
semantic error: Variable 'epbl' doesn't have any member named, 'enable'.
  --> src/core/ocean/state/rki_ocean_setup.F90:674:10
674 |    epbl%enable = ecfg%enable
```

## Trigger (all three must hold)

1. A derived type (`inner_t`, ~ `ocean_epbl_t`) defined in module A.
2. The compilation unit reaches that type **only transitively** — it `use`s
   module B (which has a component of that type), but does NOT directly
   `use` module A for the type itself.
3. An `associate` name is bound to that component, and a member is accessed
   through the associate name (`e%enable`).

Direct member access (`o%epbl%enable`, no associate) works.
Importing the type explicitly (`use inner_mod, only: inner_t`) works.
Same-file (no `.mod` round-trip) works. It is the transitive `.mod`
import + `associate` combination that breaks.


## Map to my app

`rki_ocean_setup.F90` does:
```fortran
use rki_ocean_state, only: ocean_state_t          ! brings ocean_epbl_t in transitively
use rki_ocean_epbl,  only: parse_epbl_mstar_scheme, ...   ! NOT ocean_epbl_t
...
associate (epbl => ocean_state%epbl, ecfg => cfg%ocean%epbl)
   epbl%enable = ecfg%enable      ! <-- breaks
```

## Run

```bash
source ~/install/activate_conda.sh && conda activate lf
make         # builds deps, then bad.f90 (hangs -> exit 124) vs good.f90 (exit 0)
make bad     # just reproduce the bug
make good    # just the working variant
make clean   # remove generated .mod / .o
```

