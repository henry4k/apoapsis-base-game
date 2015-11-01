include config.mk

NAME = base-game

ARCHIVE_CONTENTS += README.md
ARCHIVE_CONTENTS += LICENSE
ARCHIVE_CONTENTS += $(wildcard *.lua **/*.lua)
ARCHIVE_CONTENTS += $(wildcard *.vert **/*.vert)
ARCHIVE_CONTENTS += $(wildcard *.frag **/*.frag)

GENERATED        += Planet/Scene.json
ARCHIVE_CONTENTS += Planet/Scene.json

GENERATED        += Planet/Specular.png
ARCHIVE_CONTENTS += Planet/Specular.png

GENERATED        += Planet/NormalMap.png
ARCHIVE_CONTENTS += Planet/NormalMap.png
Planet/NormalMap.png: Planet/Height.png
	$(BUILD_TOOLS)/gen-normalmap $< $@

GENERATED        += Planet/CloudNormalMap.png
ARCHIVE_CONTENTS += Planet/CloudNormalMap.png
Planet/CloudNormalMap.png: Planet/CloudDensity.png
	$(BUILD_TOOLS)/gen-normalmap $< $@

GENERATED        += Planet/Clouds.png
ARCHIVE_CONTENTS += Planet/Clouds.png
Planet/Clouds.png: Planet/CloudDensity.png Planet/CloudNormalMap.png
	$(BUILD_TOOLS)/gen-normalmap $^ $@

GENERATED        += Planet/Surface.png
ARCHIVE_CONTENTS += Planet/Surface.png
Planet/Surface.png: Planet/Height.png Planet/Climate.png Planet/NormalMap.png
	$(BUILD_TOOLS)/gen-planet-surface $^ $@

include $(BUILD_TOOLS)/rules.mk
