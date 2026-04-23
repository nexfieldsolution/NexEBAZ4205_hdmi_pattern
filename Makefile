VIVADO = vivado

all: build

build:
	$(VIVADO) -mode batch -source build.tcl

program:
	$(VIVADO) -mode batch -source program.tcl

program_xsdb:
	xsdb program_xsdb.tcl

clean:
	rm -rf vivado*.log vivado*.jou .Xil
	rm -rf project_1/project_1.runs project_1/project_1.cache project_1/project_1.gen

.PHONY: all build program clean
