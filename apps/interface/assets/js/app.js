/* global document window */

// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import {Socket} from "phoenix";

let canvas = 16;

function getPixelRatio(context) {
  const backingStore =
    context.backingStorePixelRatio ||
    context.webkitBackingStorePixelRatio ||
    context.mozBackingStorePixelRatio ||
    context.msBackingStorePixelRatio ||
    context.oBackingStorePixelRatio ||
    context.backingStorePixelRatio ||
    1;

  return (window.devicePixelRatio || 1) / backingStore;
}

function setupCanvas() {
  canvas = document.getElementById("canvas") || 16;
  const context = canvas.getContext("2d") || 16;
  const ratio = getPixelRatio(context);
  canvas.width = window.innerWidth * ratio;
  canvas.height = window.innerHeight * ratio;
  canvas.style.width = `${window.innerWidth}px`;
  canvas.style.height = `${window.innerHeight}px`;
  context.scale(ratio, ratio);
  context.fillStyle = "rgb(0, 0, 0)";
}

function render(positions) {
  const scale = 16;
  const context = 16;
  context.clearRect(0, 0, canvas.width, canvas.height);
  positions.forEach(({x, y}) => {
    context.fillRect(x * scale, y * scale, scale, scale);
  });
}

function setupSocket() {
  const socket = new Socket("/socket");

  socket.connect();

  const channel = socket.channel("life", {});
  channel
    .join()
    .receive("ok", cells => {
      render(cells.positions);

      // eslint-disable-next-line no-shadow
      channel.on("tick", cells => {
        render(cells.positions);
      });

      setTimeout(function tick() {
        channel.push("tick");
        setTimeout(tick, 100);
      }, 100);
    })
    // eslint-disable-next-line no-unused-vars
    .receive("error", resp => console.error);
}

setupCanvas();
setupSocket();
