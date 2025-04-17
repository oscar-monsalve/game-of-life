const std = @import("std");

const Errors = error{
    InvalidGridSize,
};

pub fn create_grid(allocator: std.mem.Allocator, rows: u32, cols: u32, randomize: bool) ![]u32 {
    if (rows <= 0 or cols <= 0) {
        return Errors.InvalidGridSize;
    }

    const grid = try allocator.alloc(u32, rows * cols);

    if (randomize == false) {
        for (grid) |*cell| {
            cell.* = 0;
        }
    }
    if (randomize == true) {
        // Using entropy to generate a truly random seed
        var seed: u64 = undefined;
        std.crypto.random.bytes(std.mem.asBytes(&seed));

        // Initializing the PRNG with the random seed
        var prng = std.Random.DefaultPrng.init(seed);
        const rng = prng.random();

        for (grid) |*cell| {
            cell.* = rng.uintLessThan(u32, 2);
        }
    }

    return grid;
}

pub fn print_grid(grid: []u32, rows: u32, cols: u32) void {
    const LIVE_CELL = "■";
    const DEAD_CELL = " ";
    const HORIZONTAL = "⎯";
    const VERTICAL = "🭲";
    const CORNER = "+";

    for (0..rows) |row| {
        for (0..cols) |col| {
            const index = row * cols + col;
            const cell = grid[index];
            const symbol = if (cell == 1) " ■ " else " ";
            std.debug.print("{s}", .{symbol});
        }
        std.debug.print("\n", .{});
    }
}
