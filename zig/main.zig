const std = @import("std");
const game = @import("game_of_life.zig");

const ROWS: u32 = 5;
const COLS: u32 = 5;
const RANDOMIZE: bool = true;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const grid = try game.create_grid(allocator, ROWS, COLS, RANDOMIZE);
    defer allocator.free(grid);

    game.print_grid(grid, ROWS, COLS);

    const row_cell = 1;
    const col_cell = 1;

    const live_cells = game.count_live_neighbors(grid, ROWS, COLS, row_cell, col_cell);

    std.debug.print("Live cells: {d}\n", .{live_cells});

}
