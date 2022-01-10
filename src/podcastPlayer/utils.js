import * as tx from "@thi.ng/transducers";

const timestampToSeconds = timestamp => {
    const [minutes, seconds] = timestamp.split(":");
    return parseInt(minutes) * 60 + parseInt(seconds);
};

const getChapters = highlights => {
    const chapters = tx.transduce(
        tx.comp(
            // split into rows
            tx.mapcat(x => x.split("\n")),
            // split each row
            tx.map(x => x.split(" ")),
            // dummy endTime = startTime + 1
            tx.map(x => [
                x.slice(2).join(""),
                timestampToSeconds(x[1]),
                timestampToSeconds(x[1]) + 1,
            ]),
            // convert each row into object
            tx.rename({ title: 0, startTime: 1, endTime: 2 })
        ),
        tx.push(),
        [highlights]
    );
    return chapters;
};

export { timestampToSeconds, getChapters };
