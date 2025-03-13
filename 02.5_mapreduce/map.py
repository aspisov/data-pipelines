#! /usr/bin/env python3

import sys

for line in sys.stdin:
    color, number = line.strip().split("\t")
    if "-" not in number:
        print(f"{color}\t{number}")
