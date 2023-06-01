const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.testing.expect(gpa.deinit() == .ok) catch @panic("leak");
    const allocator = gpa.allocator();

    var map = std.StringHashMap(u32).init(allocator);
    defer map.deinit();

    for (0..10000) |i| {
        const key = try std.fmt.allocPrint(allocator, "{}", .{i});
        defer allocator.free(key);
        try map.put(key, 0);
    }

    std.debug.print("{any}\n", .{map});
}
