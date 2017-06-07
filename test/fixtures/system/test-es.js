import { readFile } from "fs"
import * as path from "path";

export const sqrt = Math.sqrt;

export function square(x) {
    return x * x;
}
export function diag(x, y) {
    return sqrt(square(x) + square(y));
}

export function dude(x, y) {
    return sqrt(square(x^2) + square(y));
}
