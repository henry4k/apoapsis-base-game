#!/bin/sh

Gimp="$1"
Input="$2"
Output="$3"

$Gimp --new-instance --no-interface --no-fonts --no-data --batch-interpreter 'python-fu-eval' --batch - << EOF
image = pdb.gimp_file_load("$Input", "$Input")
pdb.gimp_image_convert_rgb(image)
layer = pdb.gimp_image_merge_visible_layers(image, CLIP_TO_IMAGE)
heightmap_filter = 3 # Prewitt 3x3
pdb.plug_in_normalmap(image,
                      layer, # drawable
                      heightmap_filter,
                      0.0, # minimum z
                      1.0, # scale
                      1, # wrap (0 or 1)
                      0, # 0 = average RGB, 1 = alpha channel
                      0, # 0 = unchanged, 1 = set to height, 2 = set to inverse height, 3 = set to 0, 4 = set to 1, 5 = invert, 6 = set to alpha map value
                      0, # 0 = normalize only, 1 = Biased RGB, 2 = Red, 3 = Green, 4 = Blue, 5 = Max RGB, 6 = Min RGB, 7 = Colorspace, 8 = Normalize only, 9 = Convert to height map
                      0, # options for DU/DV map conversion
                      0, # X invert (0 or 1)
                      1, # Y invert (0 or 1)
                      0, # swap RGB (0 or 1)
                      0.0, # contrast
                      layer)
pdb.gimp_file_save(image, layer, "$Output", "$Output")
pdb.gimp_image_delete(image)
pdb.gimp_quit(0)
EOF
