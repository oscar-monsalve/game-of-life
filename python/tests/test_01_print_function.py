from game_of_life import print_grid


def test_print_grid_2x2_with_alive_cells(capsys):
    test_grid = [
        [0, 1],
        [1, 0]
    ]

    print_grid(test_grid)
    captured = capsys.readouterr()

    expected_output = (
        "+⎯⎯⎯⎯⎯⎯+\n"
        "🭲    ■ 🭲\n"
        "🭲 ■    🭲\n"
        "+⎯⎯⎯⎯⎯⎯+\n"
    )

    assert captured.out == expected_output


def test_print_grid_2x2_no_alive_cells(capsys):
    test_grid = [
        [0, 0],
        [0, 0]
    ]

    print_grid(test_grid)
    captured = capsys.readouterr()

    expected_output = (
        "+⎯⎯⎯⎯⎯⎯+\n"
        "🭲      🭲\n"
        "🭲      🭲\n"
        "+⎯⎯⎯⎯⎯⎯+\n"
    )

    assert captured.out == expected_output
