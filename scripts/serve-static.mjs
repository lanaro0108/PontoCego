import { createServer } from "node:http";
import { createReadStream } from "node:fs";
import { stat } from "node:fs/promises";
import { resolve, extname, sep } from "node:path";

const root = resolve("out");
const port = Number(process.env.PORT || 3000);
const types = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json",
  ".txt": "text/plain; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".woff2": "font/woff2",
  ".xml": "application/xml; charset=utf-8",
};

try {
  await stat(resolve(root, "index.html"));
} catch {
  console.error("Execute npm run build antes de npm start.");
  process.exit(1);
}

createServer(async (req, res) => {
  if (req.method !== "GET" && req.method !== "HEAD") {
    res.writeHead(405, { Allow: "GET, HEAD" }).end();
    return;
  }
  try {
    const url = new URL(req.url || "/", "http://localhost");
    let file = resolve(root, `.${decodeURIComponent(url.pathname)}`);
    if (file !== root && !file.startsWith(`${root}${sep}`)) {
      res.writeHead(403).end();
      return;
    }
    let details;
    let status = 200;
    try {
      details = await stat(file);
      if (details.isDirectory()) {
        file = resolve(file, "index.html");
        details = await stat(file);
      }
      if (!details.isFile()) throw new Error("Not a file");
    } catch {
      file = resolve(root, "404.html");
      details = await stat(file);
      status = 404;
    }
    res.writeHead(status, {
      "Content-Type": types[extname(file)] || "application/octet-stream",
      "Content-Length": details.size,
      "X-Content-Type-Options": "nosniff",
      "Cache-Control": file.includes(`${sep}_next${sep}static${sep}`)
        ? "public, max-age=31536000, immutable"
        : "no-cache",
    });
    if (req.method === "HEAD") res.end();
    else
      createReadStream(file)
        .on("error", () => res.destroy())
        .pipe(res);
  } catch {
    res.writeHead(400).end();
  }
}).listen(port, "0.0.0.0", () =>
  console.log(`Ponto Cego · http://localhost:${port}`),
);
