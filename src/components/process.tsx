"use client";

import { useEffect, useRef, useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import {
  ArrowRight,
  Check,
  ScanEye,
  Send,
  Settings2,
  Sparkles,
} from "lucide-react";
import { Eyebrow, Reveal } from "./shared";
import { DashboardMockup, PhoneMockup } from "./mockups";

const steps = [
  {
    title: "Identifique",
    description:
      "Encontre uma barreira em um ambiente. Um novo olhar é o começo de toda mudança.",
    icon: ScanEye,
    label: "Tudo começa com a sua percepção.",
  },
  {
    title: "Registre",
    description:
      "Informe o local, descreva o problema e, se puder, adicione uma foto para contextualizar.",
    icon: Send,
    label: "Um relato com contexto pode ir mais longe.",
  },
  {
    title: "Acompanhe",
    description:
      "A instituição recebe o relato, analisa a prioridade e organiza os próximos passos.",
    icon: Settings2,
    label: "Informação para quem pode agir.",
  },
  {
    title: "Transforme",
    description:
      "Acompanhe o andamento até a resolução. Cada atualização torna o processo mais transparente.",
    icon: Sparkles,
    label: "Uma ação concreta. Um espaço melhor.",
  },
];

export function Process() {
  const [active, setActive] = useState(0);
  const cards = useRef<(HTMLDivElement | null)[]>([]);
  const reduced = useReducedMotion();

  useEffect(() => {
    const media = window.matchMedia("(min-width: 960px)");
    let observer: IntersectionObserver;
    function observeSteps() {
      observer?.disconnect();
      // Pixel margins follow viewport height; percentage IO margins follow width.
      const inset = Math.round(window.innerHeight * 0.45);
      observer = new IntersectionObserver(
        () => {
          if (!media.matches) return;
          const guide = window.innerHeight / 2;
          const index = cards.current.findIndex((card) => {
            const bounds = card?.getBoundingClientRect();
            return bounds && bounds.top <= guide && bounds.bottom >= guide;
          });
          if (index >= 0) setActive(index);
        },
        { rootMargin: `-${inset}px 0px -${inset}px 0px`, threshold: 0 },
      );
      cards.current.forEach((card) => {
        if (card) observer.observe(card);
      });
    }
    observeSteps();
    window.addEventListener("resize", observeSteps);
    return () => {
      observer.disconnect();
      window.removeEventListener("resize", observeSteps);
    };
  }, []);

  function selectStep(index: number) {
    setActive(index);
    if (window.matchMedia("(min-width: 960px)").matches)
      cards.current[index]?.scrollIntoView({
        behavior: reduced ? "instant" : "smooth",
        block: "center",
      });
  }

  return (
    <section
      id="como-funciona"
      className="section process-section"
      aria-labelledby="process-title"
    >
      <div className="container">
        <Reveal className="process-heading">
          <div>
            <Eyebrow light>02 / COMO FUNCIONARÁ</Eyebrow>
            <h2 id="process-title">
              Da identificação
              <br />à transformação.
            </h2>
          </div>
          <p>
            Uma conexão entre quem percebe
            <br className="desktop-only" /> a barreira e quem pode ajudar a
            resolvê-la.
          </p>
        </Reveal>
        <div className="process-grid">
          <div className="process-steps">
            {steps.map(({ title, description, icon: Icon }, i) => (
              <div
                className={`process-step ${active === i ? "active" : ""}`}
                key={title}
                data-step={i}
                ref={(node) => {
                  cards.current[i] = node;
                }}
              >
                <button
                  type="button"
                  className="step-button"
                  onClick={() => selectStep(i)}
                  aria-pressed={active === i}
                  aria-controls="process-preview"
                >
                  <span className="step-number">0{i + 1}</span>
                  <span className="step-text">
                    <span className="step-title">
                      {title}
                      <Icon size={21} aria-hidden="true" />
                    </span>
                    <span className="step-description">{description}</span>
                  </span>
                </button>
                <div className="step-track" aria-hidden="true">
                  <span />
                </div>
              </div>
            ))}
          </div>
          <div className="process-preview-wrap">
            <div
              id="process-preview"
              className="process-preview"
              role="region"
              aria-label={`Prévia conceitual da etapa: ${steps[active].title}`}
            >
              <div className="process-spotlight" />
              <div className="process-orbit" aria-hidden="true" />
              <div className="process-phone-stage">
                <AnimatePresence mode="wait" initial={false}>
                  <motion.div
                    key={active}
                    initial={{ opacity: 0, y: reduced ? 0 : 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0 }}
                    transition={{ duration: reduced ? 0 : 0.22 }}
                  >
                    <PhoneMockup step={active} />
                  </motion.div>
                </AnimatePresence>
              </div>
              <motion.div
                className="process-dashboard"
                animate={{
                  opacity: active >= 2 ? 1 : 0,
                  y: active >= 2 ? 0 : 10,
                }}
                transition={{ duration: reduced ? 0 : 0.5 }}
              >
                <DashboardMockup compact />
              </motion.div>
              <div
                className={`process-notification ${active === 3 ? "notification-resolved" : ""}`}
              >
                <span>
                  {active === 3 ? (
                    <Check size={17} />
                  ) : (
                    <ArrowRight size={17} />
                  )}
                </span>
                <div>
                  <strong>{steps[active].label}</strong>
                  <small>Fluxo planejado do Ponto Cego</small>
                </div>
              </div>
              <p className="demo-caption">
                Prévia conceitual · telas planejadas · dados ilustrativos
              </p>
            </div>
          </div>
        </div>
        <div className="process-bottom">
          <span className="status-dot" />
          <p>
            Do primeiro relato à resolução, um histórico que conecta todas as
            etapas.
          </p>
          <span>UM FLUXO. MUITAS POSSIBILIDADES.</span>
        </div>
      </div>
    </section>
  );
}
