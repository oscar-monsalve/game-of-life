from game_of_life import create_grid


def test_create_grid_2x3_zeros():
    ROW, COL = (2, 3)
    grid = create_grid(ROW, COL)

    assert len(grid) == ROW
    assert all(len(row) == COL for row in grid)

    for row in grid:
        assert len(row) == COL

    for row in grid:
        for cell in row:
            assert cell == 0
