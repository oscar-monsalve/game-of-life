import game_of_life as gl

ROWS, COLS = (0, 0)


def main() -> None:
    # grid = gl.create_grid(ROWS, COLS)
    test_count_live_neighbors = [
            [0, 0, 0, 0, 0],
            [0, 1, 1, 1, 0],
            [0, 1, 0, 1, 0],
            [0, 1, 1, 1, 0],
            [0, 0, 0, 0, 0],
    ]

    test_update_grid = [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 1, 1, 1, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
    ]

    print("Generation 0:")
    gl.print_grid(test_update_grid)

    new_grid = gl.update_grid(test_update_grid)
    print("\nGeneration 1:")
    gl.print_grid(new_grid)


if __name__ == "__main__":
    main()
