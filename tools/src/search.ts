interface SearchIndex {
    filename: string;
    title: string;
    date: string;
    category: string;
    keywords: string[];
}

export const build = (
    filename: string,
    title: string,
    date: string,
    category: string,
    keywords: string[]
): SearchIndex => ({
    filename,
    title,
    date,
    category,
    keywords,
});
