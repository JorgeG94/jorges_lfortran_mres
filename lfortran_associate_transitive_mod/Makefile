# lfortran MRE — `associate` on a transitively-imported derived-type component.
# Run inside the lf conda env:
#   source ~/install/activate_conda.sh && conda activate lf
#
#   make        # build the deps, then show bad.f90 (hangs/errors) vs good.f90
#   make bad    # reproduce the bug (hangs -> killed by timeout, exit 124)
#   make good   # the working variant (compiles)
#   make clean  # remove generated .mod / .o

FC      := lfortran
TIMEOUT := 30

.PHONY: all bad good clean

all: bad good

# Shared dependency modules (define inner_t, then carry it in outer_t).
inner_mod.mod: a_inner.f90
	$(FC) -c a_inner.f90

outer_mod.mod: b_outer.f90 inner_mod.mod
	$(FC) -c b_outer.f90

# Reproduces the bug: inner_t reached only transitively via outer_mod.
# lfortran 0.63.0 hangs here, so we bound it with `timeout`.
bad: bad.f90 outer_mod.mod
	@echo "== bad.f90 (expect hang -> exit 124, or a semantic error) =="
	-timeout $(TIMEOUT) $(FC) -c bad.f90; echo "  exit=$$? (124 = hung)"

# The working variant: identical except it also `use`s inner_mod explicitly.
good: good.f90 outer_mod.mod
	@echo "== good.f90 (expect success) =="
	$(FC) -c good.f90 && echo "  exit=0"

clean:
	rm -f ./*.mod ./*.o
