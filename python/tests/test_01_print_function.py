from game_of_life import print_grid


def test_print_grid_3x3(capsys):
    test_grid = [
        [0, 1, 0],
        [1, 0, 1],
        [0, 1, 0],
    ]

    print_grid(test_grid)

    captured = capsys.readouterr()
    expected_output = (
        "0 1 0\n"
        "1 0 1\n"
        "0 1 0\n"
    )

    assert captured.out == expected_output


def test_print_grid_5x5(capsys):
    test_grid = [
        [0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 1, 0, 1, 0],
        [0, 1, 1, 1, 0],
        [0, 0, 0, 0, 0],
    ]

    print_grid(test_grid)

    captured = capsys.readouterr()
    expected_output = (
        "0 0 0 0 0\n"
        "0 1 1 1 0\n"
        "0 1 0 1 0\n"
        "0 1 1 1 0\n"
        "0 0 0 0 0\n"
    )

    assert captured.out == expected_output
