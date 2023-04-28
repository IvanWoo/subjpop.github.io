import fs from "fs";

async function downloadImage(url: string, filepath: string): Promise<void> {
    const response = await fetch(url);
    if (!response.ok) {
        throw new Error(`Failed to fetch ${url}: ${response.status}`);
    }
    const arrayBuffer = await response.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);
    fs.writeFileSync(filepath, buffer);
}

function extractFileNameFromUrl(url: string): string {
    const urlObj = new URL(url);
    const pathname = urlObj.pathname;
    const parts = pathname.split("/");
    const fileName = parts[parts.length - 1];
    return fileName;
}

async function downloadImages(urls: string[], dirpath: string): Promise<void> {
    const promises = urls.map((url, _) => {
        const filename = extractFileNameFromUrl(url);
        const filepath = `${dirpath}/${filename}`;
        return downloadImage(url, filepath);
    });
    await Promise.all(promises);
}

function extractImageUrls(markdown: string): string[] {
    const regex = /!\[[^\]]*\]\((.*?)\)/g;
    const matches = markdown.matchAll(regex);
    const urls: string[] = [];
    for (const match of matches) {
        urls.push(match[1]);
    }
    return urls;
}

function readMarkdownFiles(dirpath: string): string[] {
    const filenames = fs.readdirSync(dirpath);
    const markdownFiles = filenames.filter(filename =>
        filename.endsWith(".md")
    );
    const markdownContents: string[] = [];
    for (const filename of markdownFiles) {
        const filepath = `${dirpath}/${filename}`;
        const contents = fs.readFileSync(filepath, "utf-8");
        markdownContents.push(contents);
    }
    return markdownContents;
}

function extractImageUrlsFromDir(dirpath: string): string[] {
    const markdownContents = readMarkdownFiles(dirpath);
    const allImageUrls: string[] = [];
    for (const markdown of markdownContents) {
        const imageUrls = extractImageUrls(markdown);
        allImageUrls.push(...imageUrls);
    }
    return allImageUrls;
}

const main = () => {
    const urls = extractImageUrlsFromDir("_posts");
    const dirpath = "images/posts";
    downloadImages(urls, dirpath)
        .then(() => console.log(`Downloaded content saved to ${dirpath}`))
        .catch(error => console.error(error));
};

main();
