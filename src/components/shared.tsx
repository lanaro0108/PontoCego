"use client";

import Image from "next/image";
import { motion, useReducedMotion } from "motion/react";
import { ArrowUpRight } from "lucide-react";
import type { ReactNode } from "react";

export const REPOSITORY = "https://github.com/lanaro0108/PontoCego";

function GitHubMark() {
  return (
    <svg
      width="17"
      height="17"
      viewBox="0 0 24 24"
      fill="currentColor"
      aria-hidden="true"
    >
      <path d="M12 .8a11.2 11.2 0 0 0-3.54 21.83c.56.1.76-.24.76-.54v-2.1c-3.12.68-3.78-1.33-3.78-1.33-.51-1.3-1.24-1.65-1.24-1.65-1.02-.7.08-.68.08-.68 1.12.08 1.71 1.15 1.71 1.15 1 1.7 2.62 1.21 3.26.93.1-.72.39-1.21.71-1.49-2.49-.28-5.11-1.25-5.11-5.54 0-1.22.44-2.22 1.15-3-.12-.28-.5-1.42.11-2.96 0 0 .94-.3 3.08 1.15A10.7 10.7 0 0 1 12 6.2c.95 0 1.9.13 2.8.37 2.14-1.45 3.08-1.15 3.08-1.15.61 1.54.23 2.68.11 2.96.72.78 1.15 1.78 1.15 3 0 4.3-2.62 5.26-5.12 5.54.4.35.76 1.03.76 2.08v3.09c0 .3.2.65.77.54A11.2 11.2 0 0 0 12 .8Z" />
    </svg>
  );
}

export function Brand({
  light = false,
  className = "",
}: {
  light?: boolean;
  className?: string;
}) {
  return (
    <Image
      className={`brand ${className}`}
      src={`/branding/logo-horizontal-${light ? "white-transparent" : "transparent"}.svg`}
      alt="Ponto Cego"
      width={188}
      height={50}
      priority
    />
  );
}

export function BrandSymbol({ className = "" }: { className?: string }) {
  return (
    <Image
      className={className}
      src="/branding/icon-transparent.svg"
      alt=""
      width={240}
      height={240}
      aria-hidden="true"
    />
  );
}

export function Reveal({
  children,
  className = "",
  delay = 0,
}: {
  children: ReactNode;
  className?: string;
  delay?: number;
}) {
  const reduced = useReducedMotion();
  return (
    <motion.div
      data-reveal
      className={className}
      initial={{ opacity: 0, y: 22 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount: 0.12 }}
      transition={{
        duration: reduced ? 0 : 0.65,
        delay: reduced ? 0 : delay,
        ease: [0.22, 1, 0.36, 1],
      }}
    >
      {children}
    </motion.div>
  );
}

export function Eyebrow({
  children,
  light = false,
}: {
  children: ReactNode;
  light?: boolean;
}) {
  return (
    <div className={`eyebrow ${light ? "eyebrow-light" : ""}`}>
      <span aria-hidden="true" />
      {children}
    </div>
  );
}

export function RepositoryLink({
  children = "Explorar o projeto",
  className = "button button-secondary",
  icon = "github",
}: {
  children?: ReactNode;
  className?: string;
  icon?: "github" | "arrow";
}) {
  return (
    <a
      href={REPOSITORY}
      target="_blank"
      rel="noopener noreferrer"
      className={className}
    >
      {icon === "github" && <GitHubMark />}
      {children}
      <ArrowUpRight size={17} aria-hidden="true" />
      <span className="sr-only"> (GitHub, abre em uma nova aba)</span>
    </a>
  );
}
