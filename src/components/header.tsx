"use client";

import { useEffect, useRef, useState } from "react";
import { Menu, X, ArrowUpRight } from "lucide-react";
import { Brand } from "./shared";

const links = [
  ["O problema", "#problema"],
  ["Como funciona", "#como-funciona"],
  ["Funcionalidades", "#funcionalidades"],
  ["Nossa visão", "#nossa-visao"],
];

export function Header() {
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);
  const dialog = useRef<HTMLDialogElement>(null);
  const trigger = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    const update = () => setScrolled(window.scrollY > 16);
    update();
    window.addEventListener("scroll", update, { passive: true });
    return () => window.removeEventListener("scroll", update);
  }, []);

  useEffect(() => {
    if (!open) {
      dialog.current?.close();
      return;
    }
    dialog.current?.showModal();
    const previous = document.body.style.overflow;
    const triggerButton = trigger.current;
    document.body.style.overflow = "hidden";
    const media = window.matchMedia("(min-width: 960px)");
    const closeOnDesktop = () => {
      if (media.matches) setOpen(false);
    };
    media.addEventListener("change", closeOnDesktop);
    return () => {
      document.body.style.overflow = previous;
      media.removeEventListener("change", closeOnDesktop);
      triggerButton?.focus({ preventScroll: true });
    };
  }, [open]);

  return (
    <>
      <a className="skip-link" href="#conteudo">
        Pular para o conteúdo
      </a>
      <header className={`site-header ${scrolled ? "is-scrolled" : ""}`}>
        <div className="container header-inner">
          <a
            href="#inicio"
            aria-label="Ponto Cego — início"
            className="brand-link"
          >
            <Brand />
          </a>
          <nav className="desktop-nav" aria-label="Navegação principal">
            {links.map(([label, href]) => (
              <a key={href} href={href}>
                {label}
              </a>
            ))}
          </nav>
          <a className="button header-cta" href="#sobre-o-projeto">
            Conhecer o projeto
            <ArrowUpRight size={16} aria-hidden="true" />
          </a>
          <button
            ref={trigger}
            className="menu-trigger"
            type="button"
            aria-label="Abrir menu de navegação"
            aria-expanded={open}
            aria-controls="mobile-menu"
            onClick={() => setOpen(true)}
          >
            <Menu size={24} />
          </button>
        </div>
      </header>
      <dialog
        ref={dialog}
        id="mobile-menu"
        className="mobile-dialog"
        aria-labelledby="menu-title"
        onCancel={() => setOpen(false)}
        onClose={() => setOpen(false)}
        onKeyDown={(event) => {
          if (event.key !== "Tab") return;
          const items = event.currentTarget.querySelectorAll<HTMLElement>(
            'a[href], button:not([disabled])',
          );
          const first = items[0];
          const last = items[items.length - 1];
          if (event.shiftKey && document.activeElement === first) {
            event.preventDefault();
            last?.focus();
          } else if (!event.shiftKey && document.activeElement === last) {
            event.preventDefault();
            first?.focus();
          }
        }}
        onClick={(event) => {
          if (event.target === dialog.current) setOpen(false);
        }}
      >
        <div className="mobile-menu-panel">
          <div className="mobile-menu-top">
            <span id="menu-title" className="sr-only">
              Navegação principal
            </span>
            <Brand />
            <button
              type="button"
              onClick={() => setOpen(false)}
              className="menu-trigger"
              aria-label="Fechar menu"
            >
              <X size={24} />
            </button>
          </div>
          <nav aria-label="Navegação mobile">
            {links.map(([label, href], i) => (
              <a href={href} key={href} onClick={() => setOpen(false)}>
                <span className="menu-index">0{i + 1}</span>
                {label}
                <ArrowUpRight size={20} aria-hidden="true" />
              </a>
            ))}
          </nav>
          <a
            href="#sobre-o-projeto"
            className="button button-primary"
            onClick={() => setOpen(false)}
          >
            Conhecer o projeto
            <ArrowUpRight size={18} aria-hidden="true" />
          </a>
          <p className="mobile-menu-note">
            <span className="status-dot" />
            Projeto em desenvolvimento
          </p>
        </div>
      </dialog>
    </>
  );
}
