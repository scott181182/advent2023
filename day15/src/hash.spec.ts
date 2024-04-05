import { expect, test } from "bun:test";
import { hash } from "./hash";

test("hash", () => {
    expect(hash("HASH")).toBe(52);
});