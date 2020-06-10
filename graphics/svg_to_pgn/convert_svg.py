#!/usr/bin/python3
#
# Helper script to generate images of all layers.
# Note that the svg file contain all layers, but they
# are hidden.
#

import os
import os.path
import sys

# INPUT_SVG = "../Tastatur_NEO2_alle_Ebenen.svg"
INPUT_SVG = "../Neo_impr.svg"
OUTPUT_NAMES = "tastatur_neo_{layer_name}"
CONVERT_ARGS = "-background transparent"

DIMX=2090
DIMY1=458  # ohne Funktionstasten-Reihe
DIMY2=529  # incl Funktionstasten-Reihe

X=1000  # Neue Zielbreite

# SIZE = r"-resize 1000\!x"  # Fixed width
SIZE1 = r"-resize {x}\!x{y}".format(
    x=X, y=int(X*DIMY1/DIMX))
SIZE2 = r"-resize {x}\!x{y}".format(
    x=X, y=int(X*DIMY2/DIMX))

LAYER_NAMES = "Ebene 1|Ebene 2|Ebene 3|Ebene 4|Ebene 5|Ebene 6".split("|")

FONT_CHAR_SCALE=1.0
ADD_FUNC_KEY_ROWS = True

def gen_pngs(input_svg, output_names):
    try:
        if not os.path.isdir("out"):
            os.mkdir("out")
    except Exception as e:
        print(e)

    if output_names.endswith(".png"):
        output_names = output_names[:-4]
    if "{layer_name}" not in output_names:
        output_names = output_names + "_{layer_name}"


    if FONT_CHAR_SCALE and FONT_CHAR_SCALE != 1.0:
        cmd2 = r'''\
                python3 scale_font.py "{input_svg}" {factor} "tmp.scaled.svg" \
                '''.format(input_svg=input_svg,
                           factor=FONT_CHAR_SCALE)
        print(cmd2)
        os.system(cmd2)
        input_svg="tmp.scaled.svg"

    # Prepare image with extra infos (Fx row, cursor labeling)
    if not os.path.isfile("tmp.extra.png"):
        cmd_extra_infos = r'''\
                convert {convert_args} "../Extra_Layers.svg" {size} \
                "tmp.extra.png"'''.format(
                    convert_args=CONVERT_ARGS,
                    size=SIZE2,
                )

        print(cmd_extra_infos)
        os.system(cmd_extra_infos)


    for layer_name in LAYER_NAMES:
        print(layer_name)
        # First regex hides 'Ebene 1', second shows 'Ebene N'.
        # Thrid changes font for font-famlity and -inkscape-font-specification
        cmd1 = r'''\
                sed \
                -e "/inkscape:label=\"Ebene 1\"/ {{ \
                N; s/display:inline/display:none/ }} " \
                -e "/inkscape:label=\"{layer_name}\"/ {{ \
                N; s/display:none/display:inline/ }} " \
                "{input_svg}" > tmp.svg'''.format(
                    layer_name=layer_name,
                    input_svg=input_svg,
                )
                # -e "s/:'DejaVu Sans'/:'Liberation Sans'/g" \

        print(cmd1)
        os.system(cmd1)

        output_name = output_names.format(
            layer_name=layer_name.replace(" ", ""))

        if not ADD_FUNC_KEY_ROWS:
            cmd3 = r'''\
                    convert {convert_args} "tmp.svg" {size} \
                    "out/{output_name}.png"'''.format(
                        convert_args=CONVERT_ARGS,
                        size=SIZE1,
                        output_name=output_name,
                    )
            print(cmd3)
            os.system(cmd3)
  
        else:
            cmd3 = r'''\
                    convert {convert_args} "tmp.svg" {size} \
                    "tmp.png"'''.format(
                        convert_args=CONVERT_ARGS,
                        size=SIZE1,
                        l=layer_name.replace(" ", ""),
                    )
            print(cmd3)
            os.system(cmd3)
  
            # Merge layer (main) with function keys image (extra)
            #   This chain reads the geometry of the bigger image (extra)
            #   first and then compose the bigger on the smaller one.
            #   Without the geometry, set the (smaler) dimensions of
            #   the first image would be used.
            cmd4 = r'''\
                    convert -gravity SouthWest \
                    -size `convert {extra} -format "%wx%h" info:` \
                    xc:transparent {main} -composite {extra} -composite \
                    "out/{output_name}.png"'''.format(
                        main="tmp.png",
                        extra="tmp.extra.png",
                        output_name=output_name,
                    )
            print(cmd4)
            os.system(cmd4)
    


def clean():
    for f in ["tmp.extra.png", "tmp.extra.svg", "tmp.scaled.svg",
              "tmp.svg", "tmp.png"]:
        if os.path.isfile(f):
            os.unlink(f)


if __name__ == "__main__":
    gen_pngs(
        sys.argv[1] if len(sys.argv)>1 else INPUT_SVG,
        sys.argv[2] if len(sys.argv)>2 else OUTPUT_NAMES,
    )
    clean()
