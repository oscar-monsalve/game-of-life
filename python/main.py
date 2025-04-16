# -----Input description:------
# ROWS, COLS  : Define the size of the grid rows x cols
# GENERATIONS : Define for how many generations the simulation will run
# RANDOMIZE   : Define whether to start with a random grid (True) or with a grid filled with zeros (False)
# UPDATE_TIME : Define how fast the generations will pass (in seconds)
# -----Input description:------

# from os import system
from time import sleep
import game_of_life as gl

# -----Inputs:------
ROWS, COLS = (20, 20)
GENERATIONS:   int = 100
RANDOMIZE:    bool = True
UPDATE_TIME: float = 0.1
# -----Inputs:------


def main() -> None:
    current_gen = gl.create_grid(ROWS, COLS, RANDOMIZE)

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
        sleep(UPDATE_TIME)


if __name__ == "__main__":
    main()
