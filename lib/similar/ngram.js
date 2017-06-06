"use strict";
var generate = function (arr, len) {
    if (len === void 0) { len = 1; }
    if (len > arr.length)
        len = 1;
    if (len == 1)
        return arr;
    var sets = [];
    arr.forEach(function (token, index) {
        var s_len = index + len;
        if (s_len <= arr.length) {
            sets.push(arr.slice(index, s_len).join(""));
        }
    });
    return sets;
};
module.exports = { generate: generate };
