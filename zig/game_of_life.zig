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
    const CELL_WIDTH = 3;  // Each cell takes up 3 characters for alignment
    const HORIZONTAL = "━";
    const VERTICAL = "┃";
    const UPPER_LEFT_CORNER = "┏";
    const UPPER_RIGHT_CORNER = "┓";
    const BOTTOM_LEFT_CORNER = "┗";
    const BOTTOM_RIGHT_CORNER = "┛";

    // top border
    std.debug.print("{s}", .{UPPER_LEFT_CORNER});
    for (0..cols) |_| {
        std.debug.print("{s}", .{HORIZONTAL ** CELL_WIDTH});
    }
    std.debug.print("{s}\n", .{UPPER_RIGHT_CORNER});

    for (0..rows) |row| {
        std.debug.print("{s}", .{VERTICAL}); // vertical left borders
        for (0..cols) |col| {
            const index = row * cols + col; // Row-major order method
            const cell = grid[index];
            const symbol = if (cell == 1) LIVE_CELL else DEAD_CELL;
            std.debug.print(" {s} ", .{symbol}); // padding around cell
        }
        std.debug.print("{s}\n", .{VERTICAL}); // vertical right borders
    }

    // bottom border
    std.debug.print("{s}", .{BOTTOM_LEFT_CORNER});
    for (0..cols) |_| {
        std.debug.print("{s}", .{HORIZONTAL ** CELL_WIDTH});
    }
    std.debug.print("{s}\n", .{BOTTOM_RIGHT_CORNER});
}

pub fn count_live_neighbors(grid: []u32, rows: u32, cols: u32) void {
    // const neighbors_coordinates = [8][2]i2{
    //     .{-1, 1}, .{0, 1}, .{1 ,1},
    //     .{-1, 0}, .{1, 0},
    //     .{-1, -1}, .{0, -1}, .{1, -1},
    // };

    var live_cells = undefined;

}
