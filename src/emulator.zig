const std = @import("std");

const ConditionCodes = struct {
    z: bool,
    s: bool,
    p: bool,
    cy: bool,
    ac: bool,
    pad: u8, // Pad the remaining 3 bits
};

const State8080 = struct {
    a: u8,
    b: u8,
    c: u8,
    d: u8,
    e: u8,
    h: u8,
    l: u8,
    sp: u16,
    pc: u16,
    memory: *u8,
    cc: ConditionCodes,
    int_enable: u8,
};
