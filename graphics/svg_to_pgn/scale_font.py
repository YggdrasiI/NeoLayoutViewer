#!/usr/bin/python3
# -*- coding: utf-8 -*-
#
# Search float numbers and scaling them.
#

import re
import sys

def scale(filename, scale_factor, filename_out):
    print(f"File: {filename}")
    print(f"Scale factor: {scale_factor}")

    pattern = re.compile("font-size:([^;]*)px")

    text = open(filename, "r").read(-1)

    match = pattern.search(text)
    while match:
        spixel = text[match.span(1)[0]:match.span(1)[1]]
        try: 
            fpixel = float(spixel)
            #print(f"Replace {fpixel}")

            # Replace number, but add extra XXX before ':'
            text = "{}{}{}".format(
                text[:match.span(1)[0] - 1],
                "XXX:{:.6}".format(fpixel * scale_factor),
                text[match.span(1)[1]:])
        except Exception as e :
            raise(e)
            break

        match = pattern.search(text)

    # Restore property name(s)
    text = text.replace("XXX", "")

    with open(filename_out, "w") as text_out:
        text_out.write(text)

if __name__ == "__main__":

    scale(sys.argv[1], float(sys.argv[2]),
        sys.argv[3] if len(sys.argv) > 3 else sys.argv[1] +".out");
