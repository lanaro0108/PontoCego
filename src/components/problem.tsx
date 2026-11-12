"use client";

import { useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import {
  ArrowRight,
  Check,
  CircleHelp,
  Eye,
  EyeOff,
  Files,
  ListChecks,
  MessageSquare,
  ScanLine,
  Waypoints,
} from "lucide-react";
import { Eyebrow, Reveal } from "./shared";

const before = [
  {
    icon: EyeOff,
    title: "Problemas pouco visíveis",
    text: "O obstáculo faz parte do caminho. O relato, nem sempre.",
  },
  {
    icon: MessageSquare,
    title: "Relatos dispersos",
    text: "Informações em conversas que podem se perder.",
  },
  {
    icon: CircleHelp,
    title: "Falta de acompanhamento",
    text: "Sem clareza sobre quem cuida ou o que acontece depois.",
  },
];
const after = [
  {
    icon: ScanLine,
    title: "Barreiras identificadas",
    text: "Um local, uma descrição e a perspectiva de quem vive o espaço.",
  },
  {
    icon: Files,
    title: "Ocorrências centralizadas",
    text: "Os relatos chegam a um espaço de gestão institucional.",
  },
  {
    icon: ListChecks,
    title: "Resoluções acompanhadas",
    text: "Prioridade, responsáveis e histórico em um só fluxo.",
  },
];

export function Problem() {
  const [transformed, setTransformed] = useState(true);
  const reduced = useReducedMotion();
  return (
    <section
      id="problema"
      className="section problem-section"
      aria-labelledby="problem-title"
    >
      <div className="container problem-grid">
        <Reveal className="problem-copy">
          <Eyebrow>01 / O PROBLEMA</Eyebrow>
          <h2 id="problem-title">
            Nem toda barreira
            <br />é percebida.
            <br />
            <span className="text-muted">
              Mas toda barreira
              <br />
              importa.
            </span>
          </h2>
          <p>
            Um degrau no caminho. Uma passagem obstruída. Uma sinalização que
            não orienta. Para algumas pessoas, detalhes. Para outras, limites.
          </p>
          <p>
            O Ponto Cego nasce de uma pergunta:{" "}
            <strong>
              e se identificar uma barreira também fosse o primeiro passo para
              transformá-la?
            </strong>
          </p>
          <p className="research-note">
            Essa hipótese orienta o projeto. A pesquisa de campo no
            ambiente-piloto ainda será realizada.
          </p>
        </Reveal>
        <Reveal className="comparison" delay={0.12}>
          <div
            className="comparison-tabs"
            role="group"
            aria-label="Comparar o cenário antes e a proposta do Ponto Cego"
          >
            <button
              type="button"
              aria-pressed={!transformed}
              onClick={() => setTransformed(false)}
            >
              <EyeOff size={16} aria-hidden="true" />
              Antes
            </button>
            <button
              type="button"
              aria-pressed={transformed}
              onClick={() => setTransformed(true)}
            >
              <Eye size={16} aria-hidden="true" />
              Com Ponto Cego
            </button>
          </div>
          <div
            className={`comparison-board ${transformed ? "is-transformed" : ""}`}
          >
            <div className="comparison-board-top">
              <span className="board-label">
                {transformed
                  ? "UM FLUXO PARA MUDAR ESSA HISTÓRIA"
                  : "QUANDO A INFORMAÇÃO NÃO ENCONTRA UM CAMINHO"}
              </span>
              <Waypoints size={19} aria-hidden="true" />
            </div>
            <div
              className="comparison-items"
              aria-live="polite"
              aria-atomic="true"
            >
              <AnimatePresence mode="wait" initial={false}>
                <motion.div
                  key={String(transformed)}
                  initial={{ opacity: 0, y: reduced ? 0 : 8 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: reduced ? 0 : -8 }}
                  transition={{ duration: reduced ? 0 : 0.2 }}
                >
                  {(transformed ? after : before).map(
                    ({ icon: Icon, title, text }, i) => (
                      <div className="comparison-row" key={title}>
                        <span className="comparison-icon">
                          <Icon size={21} aria-hidden="true" />
                        </span>
                        <div>
                          <h3>{title}</h3>
                          <p>{text}</p>
                        </div>
                        <span className="comparison-state">
                          {transformed ? (
                            <Check size={14} aria-hidden="true" />
                          ) : (
                            <span>0{i + 1}</span>
                          )}
                        </span>
                      </div>
                    ),
                  )}
                </motion.div>
              </AnimatePresence>
            </div>
            <div className="comparison-summary">
              <span className="summary-dot" />
              {transformed
                ? "Da percepção à possibilidade de ação."
                : "Uma barreira também pode ser a falta de informação."}
              <ArrowRight size={16} aria-hidden="true" />
            </div>
          </div>
          <div className="comparison-caption">
            <span>UMA MUDANÇA DE PERSPECTIVA</span>
            <p>Explore os dois cenários acima.</p>
          </div>
        </Reveal>
      </div>
    </section>
  );
}
