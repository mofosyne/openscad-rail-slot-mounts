CORECOUNT := `nproc`

default:
    just --list

make:
	make -C tslot -f makefile -j{{CORECOUNT}}
	make -C screw/screw_mountable_wire_holder -f makefile -j{{CORECOUNT}}

corecount:
    @echo {{CORECOUNT}}
