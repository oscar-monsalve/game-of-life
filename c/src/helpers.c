#include "helpers.h"
#include <SDL2/SDL.h>


int draw_grid (
    SDL_Renderer *renderer,
    // int COLS,
    int rows,
    int cell_width,
    int window_width
) {
    for (int i=0; i<rows; i++){
        SDL_Rect line = { 0, i*cell_width, window_width, 1 };
        if (SDL_RenderFillRect(renderer, &line) != 0) {
            SDL_Log("Failed to create grid: %s\n", SDL_GetError());
            return -1;  // Failed
        }
    }
    return 0;  // Succes
}
