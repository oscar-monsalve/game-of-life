const std = @import("std");
const game = @import("game_of_life.zig");

pub fn main() !void {
    try game.hello();
}
