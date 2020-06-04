#!/usr/bin/python3
#
# Helper script to generate images of all layers.
# Note that the svg file contain all layers, but they
# are hidden.
#

import os
import os.path
import sys

SIZE = r"-resize 2000\!x"  # Fixed width
INPUT_SVG = "tastatur_neo_alle_Ebenen.svg"
CONVERT_ARGS = "-background transparent"

LAYER_NAMES = "Ebene 1|Ebene 2|Ebene 3|Ebene 4|Ebene 5|Ebene 6".split("|")

def gen_pngs():
    try:
        if not os.path.isdir("out"):
            os.mkdir("out")
    except Exception as e:
        print(e)


    for layer_name in LAYER_NAMES:
        print(layer_name)
        cmd1 = r'''\
                sed "/inkscape:label=\"{layer_name}\"/ {{ \
                N; s/display:none/display:inline/ }} " \
                "{input_svg}" > tmp.svg'''.format(
                    layer_name=layer_name,
                    input_svg=INPUT_SVG,
                )

        print(cmd1)
        os.system(cmd1)

        cmd2 = r'''\
                convert {convert_args} "tmp.svg" {size} \
                "out/tastatur_neo_{l}.png"'''.format(
                    convert_args=CONVERT_ARGS,
                    size=SIZE,
                    l=layer_name.replace(" ", ""),
                )

        print(cmd2)
        os.system(cmd2)

        break

def update_pngs():
    # Put symbols on cursor keys and block above cursors
    # Use keys from layer 3/4 with the same character/function.
    for layer_name in LAYER_NAMES:


        break

    # TODO Hm, im map_viewer schauen, wie man Bilder zusammensetzt.



def clean():
    if os.path.isfile("tmp.svg"):
        os.unlink("tmp.svg")


if __name__ == "__main__":
    # gen_pngs()
    update_pngs()
    clean()
