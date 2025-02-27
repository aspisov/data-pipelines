import csv
import sys
from io import StringIO

for line in sys.stdin:
    csvreader = csv.reader(StringIO(line), delimiter=",", quotechar='"')
    for row in csvreader:
        print(f"{row[1][:4]}\t{row[1]}\t{row[27]}\t{row[26]}")
