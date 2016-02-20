include config.mk

NAME = base-game

ARCHIVE_CONTENTS += README.md
ARCHIVE_CONTENTS += LICENSE
ARCHIVE_CONTENTS += meta.json
ARCHIVE_CONTENTS += $(wildcard *.lua **/*.lua)
ARCHIVE_CONTENTS += $(wildcard *.vert **/*.vert)
ARCHIVE_CONTENTS += $(wildcard *.frag **/*.frag)

XCF_FILES = $(shell find . -name '*.xcf')
GENERATED_CONTENTS += $(patsubst %.xcf,%.png,$(XCF_FILES))

BLEND_FILES = $(shell find . -name '*.blend')
GENERATED_CONTENTS += $(patsubst %.blend,%.json,$(BLEND_FILES))

GENERATED_CONTENTS += Planet/Surface.png
Planet/Surface.png: Planet/Height.png
	$(BUILD_TOOLS)/gen-planet-surface $^ $@

GENERATED_CONTENTS += voxel/Scaffold/Normal.png
voxel/Scaffold/Normal.png: voxel/Scaffold/Height.png
	$(BUILD_TOOLS)/gen-normalmap $^ $@

GENERATED_CONTENTS += voxel/FluidTank/Normal.png
voxel/FluidTank/Normal.png: voxel/FluidTank/Height.png
	$(BUILD_TOOLS)/gen-normalmap $^ $@

GENERATED        += $(GENERATED_CONTENTS)
ARCHIVE_CONTENTS += $(GENERATED_CONTENTS)

include $(BUILD_TOOLS)/rules.mk
