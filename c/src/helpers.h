#ifndef HELPERS_H
#define HELPERS_H

#include <SDL2/SDL.h>

int draw_grid(
    SDL_Renderer *renderer,
    int cols,
    int rows,
    int cell_width,
    int window_width,
    int window_height
);

#endif // HELPERS_H
