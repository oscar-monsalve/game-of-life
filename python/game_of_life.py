
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


def count_live_neighbors(grid: list[list[int]], row: int, col: int) -> int:
    neighbors_coordinates = (
        (-1, 1), (0, 1), (1, 1),
        (-1, 0), (1, 0),
        (-1, -1), (0, -1), (1, -1),
    )

    live_cells = 0
    for dx, dy in neighbors_coordinates:
        neighbor_row = row + dx
        neighbor_col = col + dy

        if neighbor_row < 0 or neighbor_row > len(grid) - 1:
            continue
        elif neighbor_col < 0 or neighbor_col > len(grid[0]) - 1:
            continue
        elif grid[neighbor_row][neighbor_col] == 1:
            live_cells += 1

    return live_cells


# Any live cell with fewer than two live neighbours dies, as if by underpopulation.
# Any live cell with two or three live neighbours lives on to the next generation.
# Any live cell with more than three live neighbours dies, as if by overpopulation.
# Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
def update_grid(grid: list[list[int]]) -> list[list[int]]:
    new_grid = []
    for row, _ in enumerate(grid):
        new_row = []
        for col, _ in enumerate(grid[0]):
            cell = grid[row][col]
            live_cells = count_live_neighbors(grid, row, col)
            if cell == 0 and live_cells == 3:
                new_row.append(1)
            elif cell == 0 and live_cells != 3:
                new_row.append(0)
            elif cell == 1:
                if live_cells not in (2, 3):
                    new_row.append(0)
                elif live_cells in (2, 3):
                    new_row.append(1)
        new_grid.append(new_row)
    return new_grid
