import { div, h2 } from "@thi.ng/hiccup-html";
import { $compile } from "@thi.ng/rdom";

const createSearchApp = () => {
    const root = document.getElementById("search-app");
    if (!root) {
        return;
    }
    $compile(div(null, h2(null, "Search App"))).mount(root);
};

export default createSearchApp;
