import "shikwasa/dist/style.css";
import { Chapter, Player } from "shikwasa";

import { getChapters } from "./utils";

const createPodcastPlayer = () => {
    Player.use(Chapter);

    const podcastPlayer = document.querySelector(".podcast-player");
    if (!podcastPlayer) {
        return;
    }

    const { title, cover, src, highlights } = podcastPlayer.dataset;
    const chapters = !!highlights ? getChapters(highlights) : null;

    const player = new Player({
        container: () => podcastPlayer,
        audio: {
            title: title,
            artist: "SUBJPOP",
            cover: cover,
            src: src,
            chapters: chapters,
        },
        themeColor: "#ff4e4e",
    });
};

export default createPodcastPlayer;
