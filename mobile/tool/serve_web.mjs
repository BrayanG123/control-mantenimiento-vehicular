import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..", "build", "web");
const port = 8090;
const types = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".json": "application/json",
  ".wasm": "application/wasm",
  ".png": "image/png",
  ".woff": "font/woff",
  ".woff2": "font/woff2",
  ".css": "text/css",
  ".txt": "text/plain; charset=utf-8",
  ".map": "application/json",
  ".otf": "font/otf",
  ".ttf": "font/ttf",
};

const longCache = new Set([".js", ".mjs", ".wasm", ".woff", ".woff2", ".png", ".json", ".css", ".otf", ".ttf"]);

http
  .createServer((req, res) => {
    const urlPath = decodeURIComponent((req.url || "/").split("?")[0]);
    let file = path.join(root, urlPath === "/" ? "index.html" : urlPath);
    if (!file.startsWith(root)) {
      res.writeHead(403);
      res.end();
      return;
    }
    if (fs.existsSync(file) && fs.statSync(file).isDirectory()) {
      file = path.join(file, "index.html");
    }
    const ext = path.extname(file);
    const headers = {
      "X-Content-Type-Options": "nosniff",
      "Cross-Origin-Opener-Policy": "same-origin",
      "Cross-Origin-Embedder-Policy": "require-corp",
      "Cross-Origin-Resource-Policy": "same-origin",
      "Content-Type": types[ext] || "application/octet-stream",
    };
    const esMotorFlutter =
      /main\.dart|flutter\.js|flutter_bootstrap|flutter_service_worker/.test(urlPath);
    if (ext === ".html" || urlPath === "/" || ext === ".txt" || esMotorFlutter) {
      headers["Cache-Control"] = "no-cache";
    } else if (longCache.has(ext)) {
      headers["Cache-Control"] = "public, max-age=31536000, immutable";
    } else {
      headers["Cache-Control"] = "no-cache";
    }
    fs.readFile(file, (err, data) => {
      if (err) {
        res.writeHead(404, headers);
        res.end();
        return;
      }
      res.writeHead(200, headers);
      res.end(data);
    });
  })
  .listen(port, "127.0.0.1", () => {
    console.log(`Sirviendo ${root} en http://127.0.0.1:${port}`);
  });
