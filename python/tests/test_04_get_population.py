from game_of_life import get_population


def test_get_population_all_dead_cells():
    test_grid_dead_cells = [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
    ]

    assert get_population(test_grid_dead_cells) == 0


def test_get_population_all_alive_cells():
    test_grid_dead_cells = [
        [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1],
    ]

    assert get_population(test_grid_dead_cells) == 25


def test_get_population_some_alive_cells():
    test_grid_dead_cells = [
        [1, 1, 1, 0, 1],
        [1, 1, 0, 1, 1],
        [1, 1, 1, 1, 1],
        [0, 1, 1, 1, 1],
        [1, 1, 1, 0, 1],
    ]

    assert get_population(test_grid_dead_cells) == 21
