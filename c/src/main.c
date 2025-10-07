#include <SDL2/SDL.h>
#include "helpers.h"


int main() {
    SDL_Init(SDL_INIT_VIDEO);

    const char *WINDOW_TITLE = "No RenderPresent Example";
    const int WINDOW_WIDTH = 800;
    const int WINDOW_HEIGHT = 600;

    const int CELL_WIDTH = 10;
    const int COLS = WINDOW_WIDTH / CELL_WIDTH;
    const int ROWS = WINDOW_HEIGHT / CELL_WIDTH;

    SDL_Window *window = SDL_CreateWindow(
        WINDOW_TITLE,
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        0
    );

    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, 0);

    // Background color
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);

    // Draw grid and check for errors
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    if (draw_grid(renderer, COLS, ROWS, CELL_WIDTH, WINDOW_WIDTH, WINDOW_HEIGHT) != 0) {
        SDL_Log("Error drawing grid: %s", SDL_GetError());
    }

    SDL_RenderPresent(renderer);

    // Main loop
    SDL_Event e;
    int running = 1;
    while (running) {
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) {
                running = 0;
            }
        }
        SDL_Delay(16);
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
