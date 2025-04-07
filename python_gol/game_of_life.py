
def create_grid(rows: int, cols: int) -> list[list[int]]:
    grid = []
    for _ in range(rows):
        row = []
        for _ in range(cols):
            row.append(0)
        grid.append(row)
    return grid


def print_grid(grid: list[list[int]]) -> None:
    for row in grid:
        line = ""
        for cell in row:
            line += str(cell) + " "
        print(line.strip())


def count_live_neighbors(grid: list[list[int]], rows: int, cols: int) -> int:
    neighbors = (
        (-1, 1),
        (0, 1),
        (1, 1),
        (-1, 0),
        (1, 0),
        (-1, -1),
        (0, -1),
        (1, -1),
    )

    for i, j in neighbors:
        print(i, j)
