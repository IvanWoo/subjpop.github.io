import { pickRandom } from "@thi.ng/random";

const QUERIES = [
    "mimida",
    "stwind",
    "dvc",
    "大胃麒麟",
    "赵老师",
    "南瓜",
    "kitashin",
    "您好",
    "小水",
    "kohh",
    "zombie",
    "ayano",
    "tofu",
    "rap",
    "乐曲",
    "偶像",
];

export const randomQuery = () => {
    return pickRandom(QUERIES);
};

export const INITIAL_QUERY = randomQuery();
