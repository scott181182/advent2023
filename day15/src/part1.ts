import { parseArgs } from "util";




async function main() {
    const { positionals } = parseArgs({
        args: Bun.argv.slice(2),
        strict: true,
        allowPositionals: true
    });
    
    const filepath = positionals.shift();
    if(!filepath) { throw new Error("Expected filename as first argument"); }

    console.log(filepath);
}

main()
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });