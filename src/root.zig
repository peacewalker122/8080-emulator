const std = @import("std");
const emu = @import("emulator.zig");
const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn read_words(state: *emu.State8080) u16 {
    const result = @as(u16, state.memory[state.pc]) << 8 | state.memory[state.pc + 1];
    state.pc += 2;
    return result;
}

fn next_byte(state: *emu.State8080) u8 {
    const result = state.memory[state.pc];
    state.pc += 1;
    return result;
}

fn get_bc(state: *emu.State8080) u16 {
    return @as(u16, state.b) << 8 | state.c;
}

fn get_de(state: *emu.State8080) u16 {
    return @as(u16, state.d) << 8 | state.e;
}

fn get_hl(state: *emu.State8080) u16 {
    return @as(u16, state.h) << 8 | state.l;
}

pub fn disassemble8080Op(state: *emu.State8080) !void {
    const char = state.memory[state.pc];
    switch (char) {
        // MOV instructions
        0x7f => state.a = state.a, // MOV A,A
        0x78 => state.a = state.b, // MOV A,B
        0x79 => state.a = state.c, // MOV A,C
        0x7a => state.a = state.d, // MOV A,D
        0x7b => state.a = state.e, // MOV A,E
        0x7c => state.a = state.h, // MOV A,H
        0x7d => state.a = state.l, // MOV A,L
        0x7e => state.a = state.memory[get_hl(state)], // MOV A,M

        0x0a => state.a = state.memory[get_bc(state)], // LDAX B
        0x1a => state.a = state.memory[get_de(state)], // LDAX D
        0x3a => state.a = state.memory[read_words(state)], // LDA word

        0x47 => state.b = state.a, // MOV B,A
        0x40 => state.b = state.b, // MOV B,B
        0x41 => state.b = state.c, // MOV B,C
        0x42 => state.b = state.d, // MOV B,D
        0x43 => state.b = state.e, // MOV B,E
        0x44 => state.b = state.h, // MOV B,H
        0x45 => state.b = state.l, // MOV B,L
        0x46 => state.b = state.memory[get_hl(state)], // MOV B,M

        0x4f => state.c = state.a, // MOV C,A
        0x48 => state.c = state.b, // MOV C,B
        0x49 => state.c = state.c, // MOV C,C
        0x4a => state.c = state.d, // MOV C,D
        0x4b => state.c = state.e, // MOV C,E
        0x4c => state.c = state.h, // MOV C,H
        0x4d => state.c = state.l, // MOV C,L
        0x4e => state.c = state.memory[get_hl(state)], // MOV C,M

        0x57 => state.d = state.a, // MOV D,A
        0x50 => state.d = state.b, // MOV D,B
        0x51 => state.d = state.c, // MOV D,C
        0x52 => state.d = state.d, // MOV D,D
        0x53 => state.d = state.e, // MOV D,E
        0x54 => state.d = state.h, // MOV D,H
        0x55 => state.d = state.l, // MOV D,L
        0x56 => state.d = state.memory[get_hl(state)], // MOV D,M

        0x5f => state.e = state.a, // MOV E,A
        0x58 => state.e = state.b, // MOV E,B
        0x59 => state.e = state.c, // MOV E,C
        0x5a => state.e = state.d, // MOV E,D
        0x5b => state.e = state.e, // MOV E,E
        0x5c => state.e = state.h, // MOV E,H
        0x5d => state.e = state.l, // MOV E,L
        0x5e => state.e = state.memory[get_hl(state)], // MOV E,M

        0x67 => state.h = state.a, // MOV H,A
        0x60 => state.h = state.b, // MOV H,B
        0x61 => state.h = state.c, // MOV H,C
        0x62 => state.h = state.d, // MOV H,D
        0x63 => state.h = state.e, // MOV H,E
        0x64 => state.h = state.h, // MOV H,H
        0x65 => state.h = state.l, // MOV H,L
        0x66 => state.h = state.memory[get_hl(state)], // MOV H,M

        0x6f => state.l = state.a, // MOV L,A
        0x68 => state.l = state.b, // MOV L,B
        0x69 => state.l = state.c, // MOV L,C
        0x6a => state.l = state.d, // MOV L,D
        0x6b => state.l = state.e, // MOV L,E
        0x6c => state.l = state.h, // MOV L,H
        0x6d => state.l = state.l, // MOV L,L
        0x6e => state.l = state.memory[get_hl(state)], // MOV L,M

        0x77 => state.memory[get_hl(state)] = state.a, // MOV M,A
        0x70 => state.memory[get_hl(state)] = state.b, // MOV M,B
        0x71 => state.memory[get_hl(state)] = state.c, // MOV M,C
        0x72 => state.memory[get_hl(state)] = state.d, // MOV M,D
        0x73 => state.memory[get_hl(state)] = state.e, // MOV M,E
        0x74 => state.memory[get_hl(state)] = state.h, // MOV M,H
        0x75 => state.memory[get_hl(state)] = state.l, // MOV M,L

        // MVI instructions (Move Immediate)
        0x3e => state.a = next_byte(state), // MVI A, data
        0x06 => state.b = next_byte(state), // MVI B, data
        0x0e => state.c = next_byte(state), // MVI C, data
        0x16 => state.d = next_byte(state), // MVI D, data
        0x1e => state.e = next_byte(state), // MVI E, data
        0x26 => state.h = next_byte(state), // MVI H, data
        0x2e => state.l = next_byte(state), // MVI L, data
        0x36 => state.memory[get_hl(state)] = next_byte(state), // MVI M, data
    }
}

test "basic add functionality" {
    // const codebuffer = [_]u8{ 0x01, 0x05, 0x3e, 0xc3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    // std.debug.print("Test", .{});
    // var pc: usize = 0;
    // while (pc < codebuffer.len) {
    //     pc += try disassemble8080Op(&codebuffer, pc);
    // }
}
