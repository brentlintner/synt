"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generate = void 0;
const generate = (arr, len = 1) => {
    if (len > arr.length)
        len = 1;
    if (len == 1)
        return arr;
    const sets = [];
    arr.forEach((token, index) => {
        const s_len = index + len;
        if (s_len <= arr.length) {
            sets.push(arr.slice(index, s_len).join(""));
        }
    });
    return sets;
};
exports.generate = generate;
