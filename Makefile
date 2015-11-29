include config.mk

NAME = base-game

ARCHIVE_CONTENTS += README.md
ARCHIVE_CONTENTS += LICENSE
ARCHIVE_CONTENTS += meta.json
ARCHIVE_CONTENTS += $(wildcard *.lua **/*.lua)
ARCHIVE_CONTENTS += $(wildcard *.vert **/*.vert)
ARCHIVE_CONTENTS += $(wildcard *.frag **/*.frag)

GENERATED_CONTENTS += $(patsubst %.xcf,%.png,$(wildcard *.xcf **/*.xcf))
GENERATED_CONTENTS += $(patsubst %.blend,%.json,$(wildcard *.blend **/*.blend))

GENERATED_CONTENTS += Planet/Surface.png
Planet/Surface.png: Planet/Height.png
	$(BUILD_TOOLS)/gen-planet-surface $^ $@

GENERATED_CONTENTS += voxel/ScaffoldStructure/Normal.png
voxel/ScaffoldStructure/Normal.png: voxel/ScaffoldStructure/Height.png
	$(BUILD_TOOLS)/gen-normalmap $^ $@

GENERATED        += $(GENERATED_CONTENTS)
ARCHIVE_CONTENTS += $(GENERATED_CONTENTS)

include $(BUILD_TOOLS)/rules.mk
