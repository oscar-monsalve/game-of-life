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

pub fn count_live_neighbors(grid: []u32, rows: u32, cols: u32, row_cell: u32, col_cell: u32) u32 {
    const neighbors_coordinates = [8][2]i2{
        .{-1, 1}, .{0, 1}, .{1 ,1},
        .{-1, 0}, .{1, 0},
        .{-1, -1}, .{0, -1}, .{1, -1},
    };

    var live_cells: u32 = 0;

    for (neighbors_coordinates) |xy| {
        const dx = xy[0];
        const dy = xy[1];

        const row_neighbor: i32 = @as(i32, @intCast(row_cell)) + dx;
        const col_neighbor: i32 = @as(i32, @intCast(col_cell)) + dy;

        if (row_neighbor < 0 or row_neighbor >= @as(i32, @intCast(rows))) continue;
        if (col_neighbor < 0 or col_neighbor >= @as(i32, @intCast(cols))) continue;

        const index_1d_grid = @as(u32, @intCast(row_neighbor)) * cols + @as(u32, @intCast(col_neighbor));
        if (grid[index_1d_grid] == 1) {
            live_cells += 1;
        }

    }

    return live_cells;
}

pub fn update_grid(allocator: std.mem.Allocator, grid: []u32, rows: u32, cols: u32) ![]u32 {
    const new_grid = try allocator.alloc(u32, rows * cols);

    for (0..rows) |row| {
        for (0..cols) |col| {
            const index_1d_grid = row * cols + col;
            const cell = grid[index_1d_grid];
            const live_neighbors = count_live_neighbors(grid, rows, cols, @as(u32, @intCast(row)), @as(u32, @intCast(col)));

            // Game of life rules
            if (cell == 0 and live_neighbors == 3) {
                new_grid[index_1d_grid] = 1;
            }
            if (cell == 1 and (live_neighbors < 2 or live_neighbors > 3)) {
                new_grid[index_1d_grid] = 0;
            }
            if (cell == 1 and (live_neighbors >= 2 and live_neighbors <= 3)) {
                new_grid[index_1d_grid] = 1;
            }
        }
    }

    return new_grid;
}

