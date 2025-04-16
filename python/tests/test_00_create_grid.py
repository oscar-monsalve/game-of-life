from game_of_life import create_grid


def test_create_grid_with_randomizer():
    ROW, COL = (5, 5)
    grid = create_grid(ROW, COL, randomize=True)

    assert len(grid) == ROW
    assert len(grid[0]) == COL

    for row in grid:
        for cell in row:
            assert cell in [0, 1]  # check if cells are dead (0) or alive (1)


def test_create_grid_no_randomizer():
    ROW, COL = (5, 5)
    grid = create_grid(ROW, COL, randomize=False)

    assert len(grid) == ROW
    assert len(grid[0]) == COL

    for row in grid:
        for cell in row:
            assert cell == 0  # all cells should contain zeros
