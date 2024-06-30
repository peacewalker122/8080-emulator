const std = @import("std");
const root = @import("./root.zig");

pub fn main() !void {
    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    // const stdout_file = std.io.getStdOut().writer();
    // var bw = std.io.bufferedWriter(stdout_file);
    // const stdout = bw.writer();

    const file = try std.fs.cwd().openFile("invaders", .{});
    defer file.close();

    const contents = try file.readToEndAlloc(std.heap.page_allocator, 1000000);
    defer std.heap.page_allocator.free(contents);

    std.debug.print("Hello, World!\n", .{});
}

// test "simple test" {
//     const codebuffer = [_]u8{ 0x01, 0x05, 0x3e, 0xc3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
//     var pc: usize = 0;
//     while (pc < codebuffer.len) {
//         pc += try root.disassemble8080Op(&codebuffer, pc);
//     }
// }
