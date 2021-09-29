import Chaffle from "chaffle";

const scrambleAuthor = () => {
    const elements = document.querySelectorAll("[data-chaffle]");
    elements.forEach(el => {
        const chaffle = new Chaffle(el, {
            speed: 10,
            delay: 20,
        });
        el.addEventListener("mouseover", () => {
            chaffle.init();
        });
    });
};

export { scrambleAuthor };
