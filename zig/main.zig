// -----Input description:------
// ROWS, COLS  : Define the size of the grid rows x cols
// GENERATIONS : Define for how many generations the simulation will run
// RANDOMIZE   : Define whether to start with a random grid (True) or with a grid filled with zeros (False)
// UPDATE_TIME : Define how fast the generations will pass (in seconds)
// -----Input description:------

const std = @import("std");
const game = @import("game_of_life.zig");

// -----Inputs:------
const ROWS: u32 = 30;
const COLS: u32 = 30;
const GENERATIONS: u32 = 100;
const UPDATE_TIME: f32 = 0.1;
const RANDOMIZE: bool = true;
// -----Inputs:------

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var current_gen = try game.create_grid(allocator, ROWS, COLS, RANDOMIZE);

    const SEC_IN_NANO_SEC: u64 = 1_000_000_000; // 1 sec = 1_000_000_000 nsec
    const DELAY_IN_NSEC = @as(u64, @intFromFloat(UPDATE_TIME * SEC_IN_NANO_SEC));

    var gen_count: u32 = 0;

    while (gen_count <= GENERATIONS) : (gen_count += 1) {
        std.debug.print("\x1B[2J\x1B[H", .{}); // Clear and reset cursor
        // std.debug.print("\x1B[H", .{}); // Just reset cursor
        game.print_grid(current_gen, ROWS, COLS);

        const population = game.get_population(current_gen, ROWS, COLS);
        std.debug.print("Generation: {d}\n", .{gen_count});
        std.debug.print("Population: {d}\n", .{population});

        const next_gen = try game.update_grid(allocator, current_gen, ROWS, COLS);
        allocator.free(current_gen);

        current_gen = next_gen;

        std.Thread.sleep(DELAY_IN_NSEC);
    }

    allocator.free(current_gen);
}
