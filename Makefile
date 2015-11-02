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

GENERATED_CONTENTS += Planet/NormalMap.png
Planet/NormalMap.png: Planet/Height.png
	$(BUILD_TOOLS)/gen-normalmap $< $@

GENERATED_CONTENTS += Planet/CloudNormalMap.png
Planet/CloudNormalMap.png: Planet/CloudDensity.png
	$(BUILD_TOOLS)/gen-normalmap $< $@

GENERATED_CONTENTS += Planet/CloudDensity.png
Planet/Clouds.png: Planet/CloudDensity.png Planet/CloudNormalMap.png
	$(BUILD_TOOLS)/gen-normalmap $^ $@

GENERATED_CONTENTS += Planet/Surface.png
Planet/Surface.png: Planet/Height.png Planet/Climate.png Planet/NormalMap.png
	$(BUILD_TOOLS)/gen-planet-surface $^ $@

GENERATED        += $(GENERATED_CONTENTS)
ARCHIVE_CONTENTS += $(GENERATED_CONTENTS)

include $(BUILD_TOOLS)/rules.mk
