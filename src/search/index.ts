import { timed } from "@thi.ng/bench/timed";
import { anchor, div, inputText, button } from "@thi.ng/hiccup-html";
import type { IComponent } from "@thi.ng/rdom";
import { Component, $text, $list, $compile } from "@thi.ng/rdom";
import type { ISubscription } from "@thi.ng/rstream";
import { reactive, Stream } from "@thi.ng/rstream";
import { map } from "@thi.ng/transducers";
import msgpack from "@ygoe/msgpack";
import { search } from "./search";
import { randomQuery, INITIAL_QUERY } from "./query";

const INDEX_URL = "assets/search.bin";

class PostSearch extends Component {
    wrapper!: IComponent;
    inner!: IComponent;
    query!: Stream<string>;
    queryResults!: ISubscription<string, string[][]>;

    updateQuery(e: InputEvent) {
        const term = (<HTMLInputElement>e.target).value;
        if (term.length > 0) {
            this.query.next(term.toLowerCase());
        }
    }

    async mount(parent: Element) {
        this.wrapper = $compile(div({ class: "" }, ["h1", {}, "Post search"]));
        this.el = await this.wrapper.mount(parent);

        // show preloader
        const loader = this.$el("div", {}, "Loading search index...", this.el);

        try {
            // load & decode msgpacked binary search index
            const resp = await fetch(INDEX_URL);
            if (resp.status >= 400)
                throw new Error("Failed to load search index");
            const buf = await resp.arrayBuffer();
            const index: any = timed(() => msgpack.deserialize(buf));

            // remove preloader
            this.$remove(loader);

            // init local state
            this.query = reactive(INITIAL_QUERY);
            // build results as transformation of query stream
            this.queryResults = this.query.transform(
                map(q => search(index, q) || [])
            );

            // compile inner component tree, including embedded reactive
            // values/streams and controlflow structures
            this.inner = $compile(
                div(
                    null,
                    div(
                        {
                            class: "container",
                        },
                        inputText({
                            class: "input",
                            type: "text",
                            autofocus: true,
                            onchange: this.updateQuery.bind(this),
                            value: this.query,
                        }),
                        button(
                            {
                                class: "button",
                                onclick: () => this.query.next(randomQuery()),
                            },
                            "Randomize"
                        )
                    ),
                    // query result & search index stats
                    div(
                        { class: "" },
                        // derived view of result stream to compute number of results
                        this.queryResults.transform(
                            map(results => results.length)
                        ),
                        " results",
                        div(null, `(total: ${index.length} posts)`)
                    ),
                    // reactive list component of paginated search results
                    $list(this.queryResults, "ul", {}, ([title, permalink]) => [
                        "li",
                        {},
                        anchor(
                            {
                                href: permalink,
                                target: "_new",
                            },
                            title
                        ),
                    ])
                )
            );
            this.inner.mount(this.el);
        } catch (e) {
            $text(<HTMLElement>loader, e);
        }
        return this.el;
    }

    // not needed here, just for reference...
    async unmount() {
        this.inner.unmount();
        this.wrapper.unmount();
    }
}

const createSearchApp = () => {
    const root = document.getElementById("search-app");
    if (!root) {
        return;
    }
    new PostSearch().mount(root);
};

export default createSearchApp;
