import sys

last_color, max_number = None, -1
for line in sys.stdin:
    color, number = line.strip().split("\t")
    if last_color == color:
        max_number = max(max_number, int(number))
    else:
        if last_color is not None:
            print(f"{last_color}\t{max_number}")
        last_color, max_number = color, int(number)

if last_color is not None:
    print(f"{last_color}\t{max_number}")
