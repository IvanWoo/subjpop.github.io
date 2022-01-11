interface SearchIndex {
    filename: string;
    title: string;
    date: string;
    category: string;
    keywords: string[];
}

export const search = (index: SearchIndex[], key: string) => {
    return index
        .filter(x => x.keywords.some(kw => kw.startsWith(key)))
        .map(x => [x.title, compilePermalink(x)]);
};

const compilePermalink = ({ filename, category }: SearchIndex) => {
    // remove .md then split by /
    const [yyyy, mm, dd, ...title] = filename.split(".")[0].split("-");
    return `/${category}/${yyyy}/${mm}/${dd}/${title.join("-")}.html`;
};
