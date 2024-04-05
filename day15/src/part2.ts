import { readFile } from "fs/promises";
import { parseArgs } from "util";
import { hash } from "./hash";



interface Lens { label: string; focus: number }

type InitializationStep = { label: string; } | Lens;



function parseInitiationSequence(data: string): InitializationStep[] {
    return data.split(/[\r\n,]+/)
        .map((step) => {
            if(step.endsWith("-")) {
                return {
                    label: step.substring(0, step.length - 1),
                };
            } else {
                const [label, focusStr] = step.split("=");
                const focus = parseInt(focusStr);
                return { label, focus };
            }
        });
}

type Box = Lens[]
function executeInitiationSequence(steps: InitializationStep[]): Box[] {
    const boxes: Box[] = new Array(256).fill(undefined).map(() => []);

    for(const step of steps) {
        const bIdx = hash(step.label);
        if("focus" in step) {
            // Check for lens in box.
            const lensIdx = boxes[bIdx].findIndex((l) => l.label === step.label);
            if(lensIdx < 0) {
                // New lens, who dis?
                boxes[bIdx].push(step);
            } else {
                boxes[bIdx].splice(lensIdx, 1, step);
            }
        } else {
            // Remove lens with label, if it exists.
            const lensIdx = boxes[bIdx].findIndex((l) => l.label === step.label);
            if(lensIdx >= 0) {
                boxes[bIdx].splice(lensIdx, 1);
            }
        }
    }

    return boxes;
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

    const boxes = executeInitiationSequence(initSeq);
    const answer = boxes.map((box, bno) => 
        box.reduce((acc, lens, sno) => acc + (bno + 1) * (sno + 1) * lens.focus, 0)
    ).reduce((acc, val) => acc + val);
    console.log(`Answer: ${answer}`);
}

main()
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });