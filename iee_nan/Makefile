# --- Config ---
FC       ?= gfortran
FFLAGS   ?= -O2 -Wall -Wextra
LDFLAGS  ?=
EXE      ?= mre 
EXE_SINGLE ?= single

# Sources
MOD_SRC     := mre_nan.f90
MAIN_SRC    := main.f90
SINGLE_SRC  := single.f90

# Objects
MOD_OBJ       := $(MOD_SRC:.f90=.o)
MAIN_OBJ      := $(MAIN_SRC:.f90=.o)
SINGLE_OBJ    := $(SINGLE_SRC:.f90=.o)

MAIN_OBJS     := $(MOD_OBJ) $(MAIN_OBJ)
SINGLE_OBJS   := $(SINGLE_OBJ)

# --- Targets ---
.PHONY: all clean debug

# Build both executables by default
all: $(EXE) $(EXE_SINGLE)

# Link executables
$(EXE): $(MAIN_OBJS)
	$(FC) $(LDFLAGS) -o $@ $(MAIN_OBJS)

$(EXE_SINGLE): $(SINGLE_OBJS)
	$(FC) $(LDFLAGS) -o $@ $(SINGLE_OBJS)

# Compile rules
# Build module first (creates .o and .mod)
$(MOD_OBJ): $(MOD_SRC)
	$(FC) $(FFLAGS) -c $<

# Ensure programs compile after the module so .mod files exist
$(MAIN_OBJ): $(MAIN_SRC) $(MOD_OBJ)
	$(FC) $(FFLAGS) -c $<

$(SINGLE_OBJ): $(SINGLE_SRC) 
	$(FC) $(FFLAGS) -c $<

clean:
	rm -f $(EXE) $(EXE_SINGLE) *.o *.mod

# Rebuild with debug flags
debug: FFLAGS := -g -O0 -Wall -Wextra
debug: clean all

