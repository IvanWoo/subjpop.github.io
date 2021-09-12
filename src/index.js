import Chaffle from "chaffle";
import lazySizes from "lazysizes";
import "shikwasa/dist/shikwasa.min.css";
import Shikwasa from "shikwasa";

document.addEventListener("DOMContentLoaded", () => {
  openInNewTab();
  markLatest();
  scrambleAuthor();
  createPodcastPlayer();
});

// open external link in a new tab
const openInNewTab = () => {
  document.querySelectorAll("a").forEach((a) => {
    if (!a.href.startsWith(document.location.origin)) {
      a.setAttribute("target", "_blank");
      a.setAttribute("rel", "noopener");
    }
  });
};

const markLatest = () => {
  const allDates = document.querySelectorAll("time");
  const days = 30;
  // days => ms
  const criteria = days * 24 * 60 * 60 * 1000;
  allDates.forEach((element) => {
    if (Date.now() - Date.parse(element.dateTime) < criteria) {
      element.parentElement.parentElement.classList.add("latest");
    }
  });
};

const scrambleAuthor = () => {
  const elements = document.querySelectorAll("[data-chaffle]");
  Array.prototype.forEach.call(elements, (el) => {
    const chaffle = new Chaffle(el, {
      speed: 10,
      delay: 20,
    });
    el.addEventListener("mouseover", () => {
      chaffle.init();
    });
  });
};

const createPodcastPlayer = () => {
  const podcastPlayer = document.querySelector(".podcast-player");

  const { title, cover, src } = podcastPlayer.dataset;

  const player = new Shikwasa({
    container: () => podcastPlayer,
    audio: {
      title: title,
      artist: "SUBJPOP",
      cover: cover,
      src: src,
    },
    themeColor: "#ff4e4e",
  });
};
