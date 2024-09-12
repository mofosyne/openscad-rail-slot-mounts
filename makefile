

all:
	@make -C tslot -f makefile
	@make -C screw/screw_mountable_wire_holder -f makefile

render-trail-example:
	docker run \
		-it \
		--rm \
		--init \
		-v $(shell pwd):/openscad \
		-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
		openscad/openscad:latest \
		xvfb-run -a openscad -m make --render -o TRailExample.png TRailExample.scad
