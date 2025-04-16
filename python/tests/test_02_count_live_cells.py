from game_of_life import count_live_neighbors


def test_count_live_neighbors_8():
    ROW, COL = (2, 2)

    test_count_live_neighbors = [
        [0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 1, 0, 1, 0],
        [0, 1, 1, 1, 0],
        [0, 0, 0, 0, 0],
    ]

    assert count_live_neighbors(test_count_live_neighbors, ROW, COL) == 8


def test_count_live_neighbors_2():
    ROW, COL = (1, 0)

    test_count_live_neighbors = [
        [0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 1, 0, 1, 0],
        [0, 1, 1, 1, 0],
        [0, 0, 0, 0, 0],
    ]

    assert count_live_neighbors(test_count_live_neighbors, ROW, COL) == 2
