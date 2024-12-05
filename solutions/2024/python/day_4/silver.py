import sys

input = sys.argv[1]
grid = list(map(list, input.strip().split("\n")))

n, m = len(grid), len(grid[0])

candidates = []

for i in range(n):
    for j in range(m - 3):
        candidate = [grid[i][j + dj] for dj in range(4)]
        candidates.append(candidate)

for i in range(n - 3):
    for j in range(m):
        candidate = [grid[i + di][j] for di in range(4)]
        candidates.append(candidate)

for i in range(n - 3):
    for j in range(m - 3):
        candidate = [grid[i + d][j + d] for d in range(4)]
        candidates.append(candidate)

for i in range(n - 3):
    for j in range(3, m):
        candidate = [grid[i + d][j - d] for d in range(4)]
        candidates.append(candidate)

candidates = [''.join(c) for c in candidates]

count = 0
for candidate in candidates:
    if candidate == "XMAS" or candidate == "SAMX":
        count += 1

print(count)
