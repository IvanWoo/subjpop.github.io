// for jekyll-lazy-load-image
import lazySizes from "lazysizes";

import { openInNewTab, markLatest } from "./patches";
import { scrambleAuthor } from "./animations";
import createPodcastPlayer from "./podcastPlayer";
import createSearchApp from "./search";

const main = () => {
    openInNewTab();
    markLatest();
    scrambleAuthor();
    createPodcastPlayer();
    createSearchApp();
};

document.addEventListener("DOMContentLoaded", () => {
    main();
});
