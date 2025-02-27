import sys
import re
from collections import defaultdict

result = defaultdict(int)
errors = 0
for line in sys.stdin:
    year = line.strip().split("\t")[0]
    if re.fullmatch(r"\d{4}", year) is None:
        errors += 1
    else:
        result[year] += 1

for year, count in result.items():
    print(f"{year}: {count}")

print(f"Errors: {errors}")