#!/usr/bin/env python3
"""Exporta os SVGs da identidade e dos wireframes em PNG."""
from pathlib import Path
import cairosvg

ROOT = Path(__file__).resolve().parents[1]
for subdir in ("branding", "wireframes"):
    source_dir = ROOT / "assets" / subdir / "svg"
    target_dir = ROOT / "assets" / subdir / "png"
    target_dir.mkdir(parents=True, exist_ok=True)
    for source in sorted(source_dir.glob("*.svg")):
        output = target_dir / f"{source.stem}.png"
        cairosvg.svg2png(url=str(source), write_to=str(output), scale=2)
        print(f"{source.relative_to(ROOT)} -> {output.relative_to(ROOT)}")
