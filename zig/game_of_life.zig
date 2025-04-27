const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;

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

pub fn assert_valid_grid(grid: []const u32) void {
    for (grid) |cell| {
        assert(cell == 0 or cell == 1);
    }
}

pub fn print_grid(grid: []const u32, rows: u32, cols: u32) void {
    const LIVE_CELL = "■";
    const DEAD_CELL = " ";
    const CELL_WIDTH = 3;  // Each cell takes up 3 characters for alignment
    const HORIZONTAL = "━";
    const VERTICAL = "┃";
    const UPPER_LEFT_CORNER = "┏";
    const UPPER_RIGHT_CORNER = "┓";
    const BOTTOM_LEFT_CORNER = "┗";
    const BOTTOM_RIGHT_CORNER = "┛";

    assert_valid_grid(grid);

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

pub fn count_live_neighbors(grid: []const u32, rows: u32, cols: u32, row_cell: u32, col_cell: u32) u32 {
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

    assert(live_cells <= 8);

    return live_cells;
}

pub fn update_grid(allocator: std.mem.Allocator, grid: []const u32, rows: u32, cols: u32) ![]u32 {
    assert_valid_grid(grid);

    const new_grid = try allocator.alloc(u32, rows * cols);

    for (0..rows) |row| {
        for (0..cols) |col| {
            const index_1d_grid = row * cols + col;
            const cell = grid[index_1d_grid];
            const live_neighbors = count_live_neighbors(
                grid,
                rows,
                cols,
                @as(u32, @intCast(row)),
                @as(u32, @intCast(col))
            );

            // Game of life rules
            if (cell == 0 and live_neighbors == 3) {
                new_grid[index_1d_grid] = 1;
            }
            if (cell == 0 and live_neighbors != 3) {
                new_grid[index_1d_grid] = cell;
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

pub fn get_population(grid: []const u32, rows: u32, cols: u32) u32 {
    assert(grid.len == rows * cols);
    assert_valid_grid(grid);

    var pop_count: u32 = 0;

    for (0..rows) |row| {
        for (0..cols) |col| {
            const index_1d_grid = row * cols + col;
            const cell = grid[index_1d_grid];

            if (cell == 1) {
                pop_count += 1;
            }
        }
    }

    return pop_count;
}

test "create_grid with randomizer" {
    const ROWS = 5;
    const COLS = 5;
    const RANDOMIZE = true;
    const allocator = std.testing.allocator;

    const grid = try create_grid(allocator, ROWS, COLS , RANDOMIZE);
    defer allocator.free(grid);

    try testing.expectEqual(ROWS * COLS, grid.len);

    for (grid) |cell| {
        try testing.expect(cell == 0 or cell == 1);
    }
}

test "create_grid without randomizer" {
    const ROWS = 5;
    const COLS = 5;
    const RANDOMIZE = false;
    const allocator = std.testing.allocator;

    const grid = try create_grid(allocator, ROWS, COLS , RANDOMIZE);
    defer allocator.free(grid);

    try testing.expectEqual(ROWS * COLS, grid.len);

    for (grid) |cell| {
        try testing.expect(cell == 0);
    }
 }

test "count_live_neighbors 8 live neighbors" {
    const ROWS = 5;
    const COLS = 5;

    const row_cell: u32 = 2;
    const col_cell: u32 = 2;

    const test_grid = [25]u32{
         0, 0, 0, 0, 0,
         0, 1, 1, 1, 0,
         0, 1, 0, 1, 0,
         0, 1, 1, 1, 0,
         0, 0, 0, 0, 0,
    };

    const live_cells = count_live_neighbors(&test_grid, ROWS, COLS, row_cell, col_cell);

    try testing.expect(live_cells == 8);
}

test "count_live_neighbors 2 live neighbors" {
    const ROWS = 5;
    const COLS = 5;

    const row_cell: u32 = 1;
    const col_cell: u32 = 0;

    const test_grid = [25]u32{
         0, 0, 0, 0, 0,
         0, 1, 1, 1, 0,
         0, 1, 0, 1, 0,
         0, 1, 1, 1, 0,
         0, 0, 0, 0, 0,
    };

    const live_cells = count_live_neighbors(&test_grid, ROWS, COLS, row_cell, col_cell);

    try testing.expect(live_cells == 2);
}

test "update_grid with blinker" {
    const allocator = std.testing.allocator;

    const ROWS = 3;
    const COLS = 3;

    const gen_0 = [9]u32{
        0, 0, 0,
        1, 1, 1,
        0, 0, 0,
    };

    const gen_1 = [9]u32{
        0, 1, 0,
        0, 1, 0,
        0, 1, 0,
    };

    const nex_gen = try update_grid(allocator, &gen_0, ROWS, COLS);
    defer allocator.free(nex_gen);

    try testing.expectEqualSlices(u32, &gen_1, nex_gen);
}

test "update_grid 'still life'" {
    const allocator = std.testing.allocator;

    const ROWS = 4;
    const COLS = 4;

    const gen_0 = [16]u32{
        0, 0, 0, 0,
        0, 1, 1, 0,
        0, 1, 1, 0,
        0, 0, 0, 0,
    };

    const gen_1 = [16]u32{
        0, 0, 0, 0,
        0, 1, 1, 0,
        0, 1, 1, 0,
        0, 0, 0, 0,
    };

    const nex_gen = try update_grid(allocator, &gen_0, ROWS, COLS);
    defer allocator.free(nex_gen);

    try testing.expectEqualSlices(u32, &gen_1, nex_gen);
}

test "get_population all zeros" {
    const ROWS = 5;
    const COLS = 5;

    const test_grid_dead_cells = [25]u32{
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
    };

    const live_cells = get_population(&test_grid_dead_cells, ROWS, COLS);

    try testing.expect(live_cells == 0);
}

test "get_population all alive" {
    const ROWS = 5;
    const COLS = 5;

    const test_grid_dead_cells = [25]u32{
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
    };

    const live_cells = get_population(&test_grid_dead_cells, ROWS, COLS);

    try testing.expect(live_cells == 25);
}

test "get_population some alive" {
    const ROWS = 5;
    const COLS = 5;

    const test_grid_dead_cells = [25]u32{
        0, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
        1, 0, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
    };

    const live_cells = get_population(&test_grid_dead_cells, ROWS, COLS);

    try testing.expect(live_cells == 20);
}

test "get_population large grid" {
    const ROWS = 20;
    const COLS = 20;

    const test_grid_large = [400]u32{
        1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1,
        0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1,
        0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1,
        1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1,
        0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1,
        1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1,
        0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1,
        1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1,
        0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1,
        1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0,
        0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1,
        0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1,
        0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1,
        1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0,
        1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0,
        1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1,
        1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1,
        1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1,
        1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0,
        0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
    };

    const live_cells = get_population(&test_grid_large, ROWS, COLS);

    try testing.expect(test_grid_large.len == ROWS * COLS);
    try testing.expect(live_cells == 246);
}
