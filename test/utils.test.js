import { expect } from "chai";

import { timestampToSeconds, getChapters } from "../src/utils.js";

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

describe("getChapters()", () => {
  const tests = [
    {
      args: `- 03:11 大森靖子「欺凌」事件始末
- 14:15 ZOC创团主旨`,
      expected: [
        { title: "大森靖子「欺凌」事件始末", startTime: 191, endTime: 192 },
        { title: "ZOC创团主旨", startTime: 855, endTime: 856 },
      ],
    },
    {
      args: `- 51:05  小泽健二曲项向天歌，红房哥哥无语泪两行
- 57:47 涩谷系和当下美国最流行音乐的交集`,
      expected: [
        {
          title: "小泽健二曲项向天歌，红房哥哥无语泪两行",
          startTime: 3065,
          endTime: 3066,
        },
        {
          title: "涩谷系和当下美国最流行音乐的交集",
          startTime: 3467,
          endTime: 3468,
        },
      ],
    },
  ];

  tests.forEach(({ args, expected }) => {
    it(`correctly parses ${args}`, () => {
      expect(getChapters(args)).to.eql(expected);
    });
  });
});
