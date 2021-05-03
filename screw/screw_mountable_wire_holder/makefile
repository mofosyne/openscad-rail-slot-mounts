# match "module foobar() { // `make` me"
TARGETS= \
		screwMountableScrewdriverHolder.stl \
		screwMountableWireHolder.stl \

all: ${TARGETS}

# auto-generated .scad files with .deps make make re-build always. keeping the
# scad files solves this problem. (explanations are welcome.)
#.SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.scad/g')

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

#%.scad:
#	echo "use <ttgo_20191212_t22_V1_1_case.scad>\n$*();" > $@

%.stl: %.scad
	openscad -m make -o ./stl/$@ -d $@.deps $<
	openscad -m make --render -o ./png/$@.png $<
 
clean:
	rm *.deps
	rm stl/*.stl

	