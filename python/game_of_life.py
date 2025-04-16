from random import randint


def create_grid(rows: int, cols: int, randomize: bool) -> list[list[int]]:
    grid = []
    if randomize is False:
        for _ in range(rows):
            row = []
            for _ in range(cols):
                row.append(0)
            grid.append(row)
        return grid
    elif randomize is True:
        for _ in range(rows):
            row = []
            for _ in range(cols):
                row.append(randint(0, 1))
            grid.append(row)
        return grid


def print_grid(grid: list[list[int]]) -> None:
    LIVE_CELL = "■"
    DEAD_CELL = " "
    CELL_WIDTH = 3  # Each cell takes up 3 characters for alignment
    HORIZONTAL = "⎯" * CELL_WIDTH
    VERTICAL = "🭲"
    CORNER = "+"

    num_cols = len(grid[0])

    # Top border
    print(CORNER + (HORIZONTAL * num_cols) + CORNER)

    for row in grid:
        print(VERTICAL, end="")
        for cell in row:
            symbol = LIVE_CELL if cell == 1 else DEAD_CELL
            print(f" {symbol} ", end="")  # Adds padding around symbol
        print(VERTICAL)

    # Bottom border
    print(CORNER + (HORIZONTAL * num_cols) + CORNER)


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


def get_population(grid: list[list[int]]) -> int:
    pop_count = 0
    for row in grid:
        for cell in row:
            if cell == 1:
                pop_count += 1
    return pop_count
