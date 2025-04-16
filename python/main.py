# from os import system
from time import sleep
import game_of_life as gl

ROWS, COLS = (20, 20)
GENERATIONS = 30
RANDOMIZE = True


def main() -> None:
    current_gen = gl.create_grid(ROWS, COLS, RANDOMIZE)
    # current_gen = [
    #     [0, 0, 0, 0, 0],
    #     [0, 0, 0, 0, 0],
    #     [0, 1, 1, 1, 0],
    #     [0, 0, 0, 0, 0],
    #     [0, 0, 0, 0, 0],
    # ]

    gen_count = 0
    while gen_count <= GENERATIONS:
        # system("clear")
        print("\033[H\033[J", end="")  # same function as "system("clear") but smoother.

        gl.print_grid(current_gen)

        population = gl.get_population(current_gen)
        print(f"\nGeneration: {gen_count}")
        print(f"Population: {population}")

        new_gen_grid = gl.update_grid(current_gen)

        current_gen = new_gen_grid

        gen_count += 1
        sleep(0.5)


if __name__ == "__main__":
    main()
