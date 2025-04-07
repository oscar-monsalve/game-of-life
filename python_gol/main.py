import game_of_life as gl

ROWS = 10
COLS = 10


def main() -> None:
    grid = gl.create_grid(ROWS, COLS)
    gl.print_grid(grid)

    gl.count_live_neighbors(grid, ROWS, COLS)


if __name__ == "__main__":
    main()
