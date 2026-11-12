import { copyFile, mkdir } from "node:fs/promises";
import { fileURLToPath } from "node:url";

// Public copies are generated; the original brand assets remain untouched.
const root = new URL("../", import.meta.url);
const destination = new URL("public/branding/", root);
await mkdir(destination, { recursive: true });
for (const name of [
  "icon-transparent.svg",
  "logo-horizontal-transparent.svg",
  "logo-horizontal-white-transparent.svg",
]) {
  await copyFile(
    fileURLToPath(new URL(`assets/branding/svg/${name}`, root)),
    fileURLToPath(new URL(name, destination)),
  );
}
