import "shikwasa/dist/shikwasa.min.css";
import Shikwasa from "shikwasa";
import * as Chapter from "shikwasa/dist/shikwasa.chapter.cjs";
import "shikwasa/dist/shikwasa.chapter.css";

import { getChapters } from "./utils";

const createPodcastPlayer = () => {
  Shikwasa.use(Chapter);

  const podcastPlayer = document.querySelector(".podcast-player");

  const { title, cover, src, highlights } = podcastPlayer.dataset;
  const chapters = !!highlights ? getChapters(highlights) : null;

  const player = new Shikwasa({
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
