#ifndef HELPERS_H
#define HELPERS_H

#include <SDL2/SDL.h>

int draw_grid(
    SDL_Renderer *renderer,
    // int COLS,
    int rows,
    int cell_width,
    int window_width
);

#endif // HELPERS_H
