


export function hash(str: string): number {
    return str.split("").reduce((acc, val) => (acc + val.charCodeAt(0)) * 17 % 256, 0);
}