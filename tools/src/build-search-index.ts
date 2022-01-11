import { readFileSync, readdirSync, writeFileSync } from "fs";
import msgpack from "@ygoe/msgpack";
import { execSync } from "child_process";
import * as path from "path";
const { load, loadDict, extract } = require("@node-rs/jieba");
const fm = require("front-matter");
import { readJSON, readText } from "./io";
import { build } from "./search";

interface PostAttributes {
    title: string;
    date: string;
    dj: string;
    categories: string[];
    featured_image: string;
    stream_url: string;
    hosts?: string;
    guests?: string;
    playlist?: string;
    albums?: string;
    highlights?: string;
}

interface ExtractOutput {
    keyword: string;
    weight: number;
}

const REPO_DIR = path.join(__dirname, "../../");
const POSTS_DIR = path.join(REPO_DIR, "_posts");
const ASSETS_DIR = path.join(REPO_DIR, "assets");
const SEARCH_INDEX_JSON_PATH = `${ASSETS_DIR}/search.json`;
const SEARCH_INDEX_BIN_PATH = `${ASSETS_DIR}/search.bin`;
const DATE_REGEX = /^(\d{4})-(\d{2})-(\d{2})-/;

const ignore = new Set(readJSON("./tools/ignore-words.json"));
const userDict = Buffer.from(readText("./tools/user-dict.txt"));

function* files(
    dir: string,
    ext: string,
    validator: RegExp
): IterableIterator<string> {
    for (let f of readdirSync(dir)) {
        const curr = dir + "/" + f;
        if (f.endsWith(ext) && validator.test(f)) {
            yield curr;
        }
    }
}

const isDigit = (c: string) => /\d/.test(c);

const flatten = (arr: any[]) => arr.reduce((a, b) => new Set([...a, ...b]), []);

const extractKeywordsOne = (s: string) => {
    const keywords = extract(s, 20);
    return keywords
        .map((one: ExtractOutput) => one.keyword.toLowerCase())
        .filter((one: string) => !isDigit(one) && !ignore.has(one));
};

const extractKeywordsMany = (sl: string[]) => {
    const keywords = sl.map(extractKeywordsOne);
    const allKeywords = flatten(keywords);
    return allKeywords;
};

const main = () => {
    // load();
    loadDict(userDict);
    let index: any = [];
    for (let f of files(POSTS_DIR, ".md", DATE_REGEX)) {
        console.log(f);
        const filename = f.split("/").slice(-1)[0];
        const src = readFileSync(f, "utf8").toString();
        const content = fm(src);
        const attributes = content.attributes as PostAttributes;
        const body = content.body;
        const keywords = [
            attributes.title.split(" "),
            attributes.dj.split(" "),
            attributes.categories,
            attributes.hosts?.split("\n") || [],
            attributes.guests?.split("\n") || [],
            attributes.albums?.split("\n") || [],
            attributes.playlist?.split("\n") || [],
            attributes.highlights?.split("\n") || [],
            body
                .split("\n")
                .filter(
                    (s: string) => !s.startsWith("{%") && !s.startsWith("!")
                ),
        ].map((attr: string[]) => extractKeywordsMany(attr));
        // console.log(keywords[8]);
        // console.log(flatten(keywords));
        index = [
            ...index,
            build(
                filename,
                attributes.title,
                attributes.date,
                attributes.categories[0],
                Array.from(flatten(keywords))
            ),
        ];
    }

    writeFileSync(SEARCH_INDEX_JSON_PATH, JSON.stringify(index));
    // msgpack'd binary version
    writeFileSync(SEARCH_INDEX_BIN_PATH, msgpack.serialize(index));

    // execSync(`gzip -9 -f ${SEARCH_INDEX_JSON_PATH}`);
    // execSync(`gzip -9 -f ${SEARCH_INDEX_BIN_PATH}`);
};

main();
