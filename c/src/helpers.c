#include "helpers.h"
#include <SDL2/SDL.h>


int draw_grid (
    SDL_Renderer *renderer,
    int cols,
    int rows,
    int cell_width,
    int window_width,
    int window_height
) {
    for (int i=0; i<rows; i++){
        SDL_Rect line_horizontal = { 0, i*cell_width, window_width, 1 };
        if (SDL_RenderFillRect(renderer, &line_horizontal) != 0) {
            SDL_Log("Failed to create grid: %s\n", SDL_GetError());
            return -1;  // Failed
        }
    }

    for (int i=0; i<cols; i++){
        SDL_Rect line_vertical = { i*cell_width, 0, 1, window_height };
        if (SDL_RenderFillRect(renderer, &line_vertical) != 0) {
            SDL_Log("Failed to create grid: %s\n", SDL_GetError());
            return -1;  // Failed
        }
    }
    return 0;  // Succes
}
