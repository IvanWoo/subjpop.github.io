// for jekyll-lazy-load-image
import lazySizes from "lazysizes";

import { openInNewTab, markLatest } from "./patches";
import { scrambleAuthor } from "./animations";
import createPodcastPlayer from "./podcastPlayer";

const main = () => {
  openInNewTab();
  markLatest();
  scrambleAuthor();
  createPodcastPlayer();
};

document.addEventListener("DOMContentLoaded", () => {
  main();
});
