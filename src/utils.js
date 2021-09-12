const timestampToSeconds = (timestamp) => {
  const [minutes, seconds] = timestamp.split(":");
  return parseInt(minutes) * 60 + parseInt(seconds);
};

const parseHighlights = (highlights) => {
  return highlights.split("\n").map((row) => {
    const [_, timestamp, content] = row.split(" ");
    return [timestampToSeconds(timestamp), content];
  });
};

export { timestampToSeconds, parseHighlights };
