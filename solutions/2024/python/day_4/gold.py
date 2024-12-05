import sys

input = sys.argv[1]
grid = list(map(list, input.strip().split("\n")))

n, m = len(grid), len(grid[0])

count = 0
for i in range(1, n - 1):
    for j in range(1, m - 1):
        diag_1 = ''.join(grid[i + d][j + d] for d in [-1, 0, 1])
        diag_2 = ''.join(grid[i + d][j - d] for d in [-1, 0, 1])

        if (diag_1 == "MAS" or diag_1 == "SAM") and (diag_2 == "MAS" or diag_2 == "SAM"):
            count += 1

print(count)
