from game_of_life import update_grid


def test_update_grid_blinker():
    gen_0 = [
        [0, 0, 0],
        [1, 1, 1],
        [0, 0, 0],
    ]

    expected_gen_1 = [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
    ]

    result = update_grid(gen_0)
    assert result == expected_gen_1


def test_update_grid_block_still_life():
    block = [
        [0, 0, 0, 0],
        [0, 1, 1, 0],
        [0, 1, 1, 0],
        [0, 0, 0, 0],
    ]

    result = update_grid(block)
    assert result == block
