include config.mk
include $(BUILD_TOOLS)/tools.mk

ARCHIVE_CONTENTS += README.md
ARCHIVE_CONTENTS += LICENSE
ARCHIVE_CONTENTS += package.json
ARCHIVE_CONTENTS += $(call rwildcard,'*.lua')
ARCHIVE_CONTENTS += $(call rwildcard,'*.vert')
ARCHIVE_CONTENTS += $(call rwildcard,'*.frag')

XCF_FILES = $(call rwildcard,'*.xcf')
GENERATED_CONTENTS += $(patsubst %.xcf,%.png,$(XCF_FILES))

BLEND_FILES = $(call rwildcard,'*.blend')
GENERATED_CONTENTS += $(patsubst %.blend,%.json,$(BLEND_FILES))

ARCHIVE_CONTENTS += $(wildcard Skybox/*.png)

ARCHIVE_CONTENTS += Planet/Clouds.png
GENERATED_CONTENTS += Planet/Surface.png
Planet/Surface.png: Planet/Height.png
	$(BUILD_TOOLS)/gen-planet-surface $^ $@

ARCHIVE_CONTENTS += voxel/Scaffold/Albedo.png
GENERATED_CONTENTS += voxel/Scaffold/Normal.png
voxel/Scaffold/Normal.png: voxel/Scaffold/Height.png
	$(BUILD_TOOLS)/gen-normalmap $^ $@

ARCHIVE_CONTENTS += voxel/FluidTank/Albedo.png
ARCHIVE_CONTENTS += voxel/FluidTank/Specular.png
GENERATED_CONTENTS += voxel/FluidTank/Normal.png
voxel/FluidTank/Normal.png: voxel/FluidTank/Height.png
	$(BUILD_TOOLS)/gen-normalmap $^ $@

GENERATED        += $(GENERATED_CONTENTS)
ARCHIVE_CONTENTS += $(GENERATED_CONTENTS)

include $(BUILD_TOOLS)/rules.mk
