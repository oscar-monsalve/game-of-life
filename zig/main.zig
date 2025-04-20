const std = @import("std");
const game = @import("game_of_life.zig");

const ROWS: u32 = 2;
const COLS: u32 = 2;
const RANDOMIZE: bool = true;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const current_gen = try game.create_grid(allocator, ROWS, COLS, RANDOMIZE);
    defer allocator.free(current_gen);

    game.print_grid(current_gen, ROWS, COLS);

    const next_gen = try game.update_grid(allocator, current_gen, ROWS, COLS);
    defer allocator.free(next_gen);

    game.print_grid(next_gen, ROWS, COLS);

}
