const stage = document.getElementById("stage");
const screenName = document.body.dataset.screen;

const candidates = [
  { type: "video", ext: "mp4" },
  { type: "video", ext: "webm" },
  { type: "image", ext: "jpg" },
  { type: "image", ext: "jpeg" },
  { type: "image", ext: "png" },
  { type: "image", ext: "webp" },
  { type: "image", ext: "gif" },
];

function showMissing() {
  stage.innerHTML = "";
  const panel = document.createElement("div");
  panel.id = "message";
  panel.innerHTML = [
    `Для <code>${screenName}</code> пока нет файла.`,
    "Положите в папку <code>assets</code> один из файлов:",
    `<code>${screenName}.jpg</code>, <code>${screenName}.png</code> или <code>${screenName}.mp4</code>.`
  ].join("<br>");
  stage.appendChild(panel);
}

function renderMedia(file) {
  stage.innerHTML = "";

  if (file.type === "video") {
    const video = document.createElement("video");
    video.src = `./assets/${screenName}.${file.ext}?t=${Date.now()}`;
    video.autoplay = true;
    video.loop = true;
    video.muted = true;
    video.playsInline = true;
    stage.appendChild(video);
    return;
  }

  const img = document.createElement("img");
  img.src = `./assets/${screenName}.${file.ext}?t=${Date.now()}`;
  img.alt = screenName;
  stage.appendChild(img);
}

async function fileExists(url) {
  try {
    const response = await fetch(url, { method: "HEAD", cache: "no-store" });
    return response.ok;
  } catch {
    return false;
  }
}

async function loadMedia() {
  for (const file of candidates) {
    const url = `./assets/${screenName}.${file.ext}?t=${Date.now()}`;
    if (await fileExists(url)) {
      renderMedia(file);
      return;
    }
  }

  showMissing();
}

loadMedia();
setInterval(loadMedia, 15000);
