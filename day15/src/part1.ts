import { readFile } from "fs/promises";
import { parseArgs } from "util";
import { hash } from "./hash";



function parseInitiationSequence(data: string): string[] {
    return data.split(/[\r\n,]+/)
}

async function main() {
    const { positionals } = parseArgs({
        args: Bun.argv.slice(2),
        strict: true,
        allowPositionals: true
    });
    
    const filepath = positionals.shift();
    if(!filepath) { throw new Error("Expected filename as first argument"); }

    const filedata = await readFile(filepath, "utf8");
    const initSeq = parseInitiationSequence(filedata);

    const answer = initSeq.map(hash).reduce((acc, val) => acc + val, 0);
    console.log(`Answer: ${answer}`);
}

main()
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });