"use client";

import {
  motion,
  useReducedMotion,
  useScroll,
  useTransform,
} from "motion/react";
import {
  ArrowDown,
  ArrowRight,
  ArrowUpRight,
  Check,
  MapPin,
  ScanEye,
} from "lucide-react";
import { BrandSymbol, RepositoryLink } from "./shared";
import { IsometricCampus } from "./mockups";

function HeroVisual() {
  const reduced = useReducedMotion();
  const { scrollY } = useScroll();
  const y = useTransform(scrollY, [0, 900], [0, 32]);
  const entrance = (delay: number) => ({
    duration: reduced ? 0 : 0.8,
    delay: reduced ? 0 : delay,
    ease: [0.22, 1, 0.36, 1] as [number, number, number, number],
  });

  return (
    <motion.figure
      className="hero-visual"
      style={{ y: reduced ? 0 : y }}
      aria-label="Ilustração conceitual: uma barreira é identificada, registrada e encaminhada para resolução em um ambiente institucional."
    >
      <div className="hero-glow" />
      <div className="visual-corner corner-tl" />
      <div className="visual-corner corner-br" />
      <span className="visual-coordinate coordinate-top">
        UM NOVO OLHAR SOBRE O MESMO ESPAÇO
      </span>
      <div className="hero-orbit orbit-one" />
      <div className="hero-orbit orbit-two" />
      <motion.div
        className="hero-initial-point"
        initial={false}
        animate={{ scale: 1, opacity: 1 }}
        transition={entrance(0.15)}
      />
      <motion.div
        className="hero-campus"
        initial={false}
        animate={{ opacity: 1, y: 0 }}
        transition={entrance(0.35)}
      >
        <IsometricCampus />
      </motion.div>
      <svg
        className="hero-connectors"
        viewBox="0 0 600 600"
        fill="none"
        aria-hidden="true"
      >
        <motion.path
          d="M176 406 C176 450 230 460 293 460 H394 Q425 460 425 422"
          stroke="#9370EE"
          strokeWidth="1.5"
          strokeDasharray="5 5"
          initial={false}
          animate={{ pathLength: 1, opacity: 1 }}
          transition={entrance(1.55)}
        />
        <motion.path
          d="M414 249 V184 Q414 166 434 166 H469"
          stroke="#C6B6E8"
          strokeWidth="1.2"
          initial={false}
          animate={{ pathLength: 1 }}
          transition={entrance(1.35)}
        />
      </svg>
      <motion.div
        className="hero-symbol-wrap"
        initial={false}
        animate={{ opacity: 1, y: 0, scale: 1 }}
        transition={entrance(0.65)}
      >
        <div className="symbol-floor" />
        <div className="hero-symbol-float">
          <BrandSymbol className="hero-symbol" />
        </div>
      </motion.div>
      <motion.div
        className="location-bubble"
        initial={false}
        animate={{ opacity: 1, scale: 1 }}
        transition={entrance(0.95)}
      >
        <span className="location-bubble-icon">
          <MapPin size={14} />
        </span>
        Bloco A · Entrada
        <span className="bubble-dot" />
      </motion.div>
      <motion.div
        className="floating-issue"
        initial={false}
        animate={{ opacity: 1, y: 0 }}
        transition={entrance(1.15)}
      >
        <div className="floating-card-top">
          <span className="card-category">
            <ScanEye size={12} />
            BARREIRA IDENTIFICADA
          </span>
          <span className="issue-id">#001</span>
        </div>
        <div className="floating-issue-main">
          <div className="issue-thumbnail">
            <span />
            <span />
            <span />
            <i />
          </div>
          <div>
            <strong>Um acesso. Uma barreira.</strong>
            <p>Desnível na entrada do bloco</p>
            <span className="issue-pill">
              <span />
              Aberta
            </span>
          </div>
        </div>
        <div className="issue-card-bottom">
          <MapPin size={11} />
          Ambiente de demonstração
          <ArrowUpRight size={12} />
        </div>
      </motion.div>
      <motion.div
        className="hero-mini-dashboard"
        initial={false}
        animate={{ opacity: 1, y: 0 }}
        transition={entrance(1.9)}
      >
        <div className="mini-dashboard-head">
          <span className="tiny-logo">
            <BrandSymbol />
          </span>
          <strong>Painel de gestão</strong>
          <span className="mini-window-dots">···</span>
        </div>
        <div className="mini-dashboard-label">
          CADA RELATO, UM PRÓXIMO PASSO
        </div>
        <div className="mini-dashboard-row">
          <span className="mini-dashboard-check">
            <Check size={12} />
          </span>
          <div>
            <strong>Ocorrência recebida</strong>
            <span>Encaminhada à instituição</span>
          </div>
        </div>
        <div className="mini-dashboard-bars">
          <i />
          <i />
          <i />
          <i />
          <i />
          <i />
          <i />
        </div>
      </motion.div>
      <motion.div
        className="floating-solution"
        initial={false}
        animate={{ opacity: 1, x: 0 }}
        transition={entrance(2.2)}
      >
        <span className="solution-icon">
          <Check size={15} />
        </span>
        <div>
          <strong>Um caminho para a solução.</strong>
          <span>Do relato ao acompanhamento</span>
        </div>
      </motion.div>
      <figcaption className="demo-caption hero-demo-caption">
        <span />
        Prévia conceitual · dados ilustrativos
      </figcaption>
    </motion.figure>
  );
}

export function Hero() {
  return (
    <section className="hero" id="inicio" aria-labelledby="hero-title">
      <div className="hero-grain" aria-hidden="true" />
      <div className="container hero-grid">
        <div className="hero-copy">
          <div className="project-status">
            <span className="status-dot" />
            Projeto em desenvolvimento
            <span className="status-divider" />
            <span>Um novo olhar.</span>
          </div>
          <h1 id="hero-title">
            O que passa
            {" "}
            <br />
            despercebido
            {" "}
            <br />
            também 
            <span>
              precisa
              {" "}
              <br className="hero-line-break" />
              ser visto.
            </span>
          </h1>
          <p className="hero-description">
            Uma plataforma que transforma barreiras de acessibilidade em
            oportunidades de mudança, conectando pessoas, espaços e soluções.
          </p>
          <div className="hero-actions">
            <a className="button button-primary" href="#como-funciona">
              Descubra como funciona
              <ArrowRight size={18} aria-hidden="true" />
            </a>
            <RepositoryLink />
          </div>
          <p className="hero-footnote">
            <span className="small-line" />
            Pensado para pessoas. Construído para transformar.
          </p>
        </div>
        <HeroVisual />
      </div>
      <div className="container hero-baseline">
        <a href="#problema" className="discover-link">
          <ArrowDown size={14} aria-hidden="true" />
          UM OLHAR ALÉM DO ÓBVIO
        </a>
        <span>
          Ver. Registrar. <strong>Transformar.</strong>
        </span>
        <span className="baseline-index">01 — 09</span>
      </div>
    </section>
  );
}
