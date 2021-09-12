import { expect } from "chai";

import { timestampToSeconds, parseHighlights } from "../src/utils.js";

describe("timestampToSeconds()", () => {
  const tests = [
    { args: "00:14", expected: 14 },
    { args: "12:00", expected: 720 },
    { args: "12:01", expected: 721 },
    { args: "12:42", expected: 762 },
    { args: "70:42", expected: 4242 },
  ];

  tests.forEach(({ args, expected }) => {
    it(`correctly converts ${args}`, () => {
      expect(timestampToSeconds(args)).to.equal(expected);
    });
  });
});

describe("parseHighlights()", () => {
  const tests = [
    {
      args: `- 03:11 大森靖子「欺凌」事件始末
- 14:15 ZOC创团主旨`,
      expected: [
        [191, "大森靖子「欺凌」事件始末"],
        [855, "ZOC创团主旨"],
      ],
    },
  ];

  tests.forEach(({ args, expected }) => {
    it(`correctly parses ${args}`, () => {
      expect(parseHighlights(args)).to.eql(expected);
    });
  });
});
