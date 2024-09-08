# match "module foobar() { // `make` me"
TARGETS= \
		tslot.stl \
		tslot_cable_hook.stl \
		tslot_cable_loop.stl \
		tslot_ethernet_cable_clip.stl \
		tslot_headphone_mount.stl \
		tslot_hook.stl \
		tslot_paper_holder.stl \
		tslot_screwdriver_mount.stl \
		tslot_tape_holderwCatch.stl \
		tslot_smd_feeder.stl \
		tslot_paper_holder_mini.stl \
		tslot_screwdriver_mount.stl \

bold="\\033[1m"
normal="\\033[0m"

all: ${TARGETS}

# auto-generated .scad files with .deps make make re-build always. keeping the
# scad files solves this problem. (explanations are welcome.)
#.SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.scad/g')

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

#%.scad:
#	echo "use <ttgo_20191212_t22_V1_1_case.scad>\n$*();" > $@

%.stl: %.scad
	@echo "## ${bold}Generating For $@ ${normal}"
#	openscad -m make -o ./stl/$@ -d $@.deps $<
	docker run \
		-it \
		--rm \
		-v $(shell pwd):/openscad \
		-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
		openscad/openscad:latest \
		openscad -m make -o ./stl/$@ -d $@.deps $<

	@echo "## ${bold}Rendering Preview For $@ ${normal}"
#	openscad -m make --render -o ./png/$@.png $<
	docker run \
		-it \
		--rm \
		--init \
		-v $(shell pwd):/openscad \
		-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
		openscad/openscad:latest \
		xvfb-run -a openscad -m make --render -o ./png/$@.png $<

clean:
	rm *.deps
	rm stl/*.stl

