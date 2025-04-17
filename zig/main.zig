const std = @import("std");
const game = @import("game_of_life.zig");

const ROWS: u32 = 10;
const COLS: u32 = 10;
const RANDOMIZE: bool = true;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const grid = try game.create_grid(allocator, ROWS, COLS, RANDOMIZE);
    defer allocator.free(grid);

    game.print_grid(grid, ROWS, COLS);
}
