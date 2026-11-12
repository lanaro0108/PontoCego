"use client";

import { MotionConfig } from "motion/react";
import {
  Accessibility,
  ArrowRight,
  ArrowUp,
  ArrowUpRight,
  BarChart3,
  Building2,
  Check,
  CheckCheck,
  ChevronRight,
  Clock3,
  Eye,
  FilePlus2,
  Globe2,
  History,
  Keyboard,
  Layers3,
  MapPin,
  MessageSquareText,
  Monitor,
  ScanEye,
  Smartphone,
  Type,
  University,
  Users,
  type LucideIcon,
} from "lucide-react";
import type { ReactNode } from "react";
import { Header } from "./header";
import { Hero } from "./hero";
import { Problem } from "./problem";
import { Process } from "./process";
import { Brand, BrandSymbol, Eyebrow, RepositoryLink, Reveal } from "./shared";
import { DashboardMockup, FlatMap, MiniTimeline, PhoneMockup } from "./mockups";

function FeatureCard({
  icon: Icon,
  title,
  description,
  children,
  className = "",
  delay = 0,
}: {
  icon: LucideIcon;
  title: string;
  description: string;
  children: ReactNode;
  className?: string;
  delay?: number;
}) {
  return (
    <Reveal className={`feature-wrap ${className}`} delay={delay}>
      <article className="feature-card">
        <div className="feature-icon">
          <Icon size={22} aria-hidden="true" />
        </div>
        <h3>{title}</h3>
        <p>{description}</p>
        {children}
      </article>
    </Reveal>
  );
}

function Interfaces() {
  return (
    <section
      id="interfaces"
      className="section interfaces-section"
      aria-labelledby="interfaces-title"
    >
      <div className="container">
        <Reveal className="section-heading-row">
          <div>
            <Eyebrow>03 / CONEXÃO QUE TRANSFORMA</Eyebrow>
            <h2 id="interfaces-title">
              Duas interfaces.
              <br />
              <span className="text-muted">Um propósito.</span>
            </h2>
          </div>
          <div className="section-heading-aside">
            <p>
              A comunidade percebe. A instituição age.
              <br />O Ponto Cego conecta os dois lados.
            </p>
            <span className="planned-badge">
              <span />
              PRODUTOS PLANEJADOS PARA O MVP
            </span>
          </div>
        </Reveal>
        <div className="interfaces-grid">
          <Reveal className="interface-card interface-mobile">
            <div className="interface-card-copy">
              <span className="interface-type">
                <Smartphone size={16} aria-hidden="true" />
                APLICATIVO MOBILE
              </span>
              <h3>
                O poder de perceber.
                <br />
                Na palma da mão.
              </h3>
              <p>
                Um canal para a comunidade dar visibilidade às barreiras do dia
                a dia.
              </p>
              <ul>
                {[
                  "Cadastro e consulta de ocorrências",
                  "Fotos e identificação do local",
                  "Acompanhamento de solicitações",
                ].map((text) => (
                  <li key={text}>
                    <Check size={14} aria-hidden="true" />
                    {text}
                  </li>
                ))}
              </ul>
            </div>
            <div className="interface-mobile-visual">
              <div className="interface-orbit" />
              <PhoneMockup step={1} />
              <div className="community-tag">
                <Users size={15} />
                <span>Para quem vive o espaço.</span>
              </div>
            </div>
            <p className="interface-caption">
              Tela planejada · dados ilustrativos
            </p>
          </Reveal>
          <Reveal className="interface-card interface-web" delay={0.12}>
            <div className="interface-card-copy">
              <span className="interface-type">
                <Monitor size={16} aria-hidden="true" />
                PLATAFORMA WEB
              </span>
              <h3>
                Clareza para gerenciar.
                <br />
                Contexto para agir.
              </h3>
              <p>
                Uma visão organizada para a instituição transformar relatos em
                próximos passos.
              </p>
              <ul>
                {[
                  "Dashboard e organização de ocorrências",
                  "Prioridades e atribuição de responsáveis",
                  "Histórico de atualizações e indicadores",
                ].map((text) => (
                  <li key={text}>
                    <Check size={14} aria-hidden="true" />
                    {text}
                  </li>
                ))}
              </ul>
            </div>
            <div className="interface-web-visual">
              <DashboardMockup />
            </div>
            <p className="interface-caption">
              Interface planejada · dados ilustrativos
            </p>
          </Reveal>
        </div>
        <Reveal className="interface-connection">
          <span className="connection-node">
            <Smartphone size={17} aria-hidden="true" />
          </span>
          <span className="connection-rule" />
          <span>
            <span className="status-dot" />A informação aproxima. A colaboração
            transforma.
          </span>
          <span className="connection-rule" />
          <span className="connection-node">
            <Monitor size={17} aria-hidden="true" />
          </span>
        </Reveal>
      </div>
    </section>
  );
}

function Features() {
  return (
    <section
      className="section features-section"
      id="funcionalidades"
      aria-labelledby="features-title"
    >
      <div className="container">
        <Reveal className="features-heading">
          <Eyebrow>04 / O QUE ESTAMOS CONSTRUINDO</Eyebrow>
          <h2 id="features-title">
            Menos barreiras.
            <br />
            <span className="text-muted">Mais possibilidades.</span>
          </h2>
          <p>
            Recursos planejados para dar contexto a cada relato
            <br className="desktop-only" /> e continuidade a cada ação.
          </p>
        </Reveal>
        <div className="bento-grid">
          <FeatureCard
            className="feature-registration"
            icon={FilePlus2}
            title="Um relato. O começo da mudança."
            description="Registro inteligente de ocorrências com descrição, categoria, local e foto opcional."
          >
            <div className="registration-visual" aria-hidden="true">
              <div className="registration-fields">
                <div>
                  <span>ONDE ESTÁ A BARREIRA?</span>
                  <strong>
                    <MapPin size={13} />
                    Bloco A · Entrada
                    <ChevronRight size={13} />
                  </strong>
                </div>
                <div>
                  <span>O QUE VOCÊ PERCEBEU?</span>
                  <strong>Um desnível que dificulta o acesso.</strong>
                </div>
              </div>
              <div className="registration-tag">
                <CheckCheck size={14} />
                Informação que pode virar ação.
              </div>
            </div>
          </FeatureCard>
          <FeatureCard
            className="feature-location"
            icon={MapPin}
            title="Cada barreira, em seu lugar."
            description="Identificação de blocos e ambientes para contextualizar o problema."
            delay={0.07}
          >
            <div className="feature-map">
              <FlatMap />
            </div>
          </FeatureCard>
          <FeatureCard
            className="feature-tracking"
            icon={Eye}
            title="Visibilidade em cada etapa."
            description="Acompanhamento transparente, do registro ao retorno da instituição."
            delay={0.14}
          >
            <MiniTimeline />
          </FeatureCard>
          <FeatureCard
            className="feature-management"
            icon={Layers3}
            title="Uma gestão conectada."
            description="Ocorrências, prioridades e responsáveis em um espaço centralizado."
          >
            <div className="mini-kanban" aria-hidden="true">
              <div>
                <span>
                  EM ANÁLISE<i>02</i>
                </span>
                <div>
                  <i className="kanban-label" />
                  <strong>Sinalização do bloco</strong>
                  <small>
                    <MapPin size={10} />
                    Bloco B
                  </small>
                  <span className="kanban-avatar">G</span>
                </div>
              </div>
              <ArrowRight size={15} />
              <div>
                <span>
                  EM ANDAMENTO<i>04</i>
                </span>
                <div>
                  <i className="kanban-label green" />
                  <strong>Acesso à entrada</strong>
                  <small>
                    <MapPin size={10} />
                    Bloco A
                  </small>
                  <span className="kanban-avatar second">R</span>
                </div>
              </div>
            </div>
          </FeatureCard>
          <FeatureCard
            className="feature-history"
            icon={History}
            title="Toda mudança tem história."
            description="Atualizações organizadas para entender o que mudou, quando e por quê."
            delay={0.07}
          >
            <div className="history-visual" aria-hidden="true">
              <div>
                <span className="history-avatar">
                  <Users size={13} />
                </span>
                <div>
                  <strong>Responsável atribuído</strong>
                  <small>Equipe de manutenção · Exemplo</small>
                </div>
                <Check size={13} />
              </div>
              <div>
                <span className="history-avatar light">
                  <MessageSquareText size={13} />
                </span>
                <div>
                  <strong>Uma nova atualização</strong>
                  <small>Intervenção em planejamento</small>
                </div>
                <Clock3 size={13} />
              </div>
            </div>
          </FeatureCard>
          <FeatureCard
            className="feature-indicators"
            icon={BarChart3}
            title="Informação para decidir."
            description="Indicadores para apoiar a priorização e observar a evolução dos relatos."
            delay={0.14}
          >
            <div className="chart-visual" aria-hidden="true">
              <div className="chart-grid">
                <i />
                <i />
                <i />
              </div>
              <div className="chart-bars">
                {[35, 56, 43, 70, 60, 85, 76].map((height, i) => (
                  <div key={i} style={{ height: `${height}%` }}>
                    <span />
                  </div>
                ))}
              </div>
              <span>VISUALIZAÇÃO ILUSTRATIVA</span>
            </div>
          </FeatureCard>
        </div>
        <p className="features-note">
          O MVP está em planejamento. Os recursos apresentados ainda serão
          desenvolvidos e validados.
        </p>
      </div>
    </section>
  );
}

function AccessibilitySection() {
  const commitments = [
    {
      icon: Eye,
      title: "Contraste que facilita a leitura",
      sub: "Cores e hierarquia a serviço do conteúdo.",
    },
    {
      icon: Keyboard,
      title: "Navegação por teclado",
      sub: "Autonomia para percorrer cada interação.",
    },
    {
      icon: Accessibility,
      title: "Tecnologias assistivas",
      sub: "Semântica e contexto para leitores de tela.",
    },
    {
      icon: Type,
      title: "Comunicação clara",
      sub: "Informações diretas, com linguagem simples.",
    },
    {
      icon: Smartphone,
      title: "Design responsivo",
      sub: "Uma experiência que se adapta ao dispositivo.",
    },
  ];
  return (
    <section
      id="acessibilidade"
      className="section accessibility-section"
      aria-labelledby="accessibility-title"
    >
      <div className="a11y-decoration" aria-hidden="true" />
      <div className="container accessibility-grid">
        <Reveal className="accessibility-copy">
          <Eyebrow light>05 / DESDE O PRIMEIRO DETALHE</Eyebrow>
          <div className="a11y-mark" aria-hidden="true">
            <Accessibility size={38} strokeWidth={1.3} />
          </div>
          <h2 id="accessibility-title">
            Acessibilidade
            <br />
            não é um detalhe.
            <br />
            <span>
              É parte da
              <br />
              experiência.
            </span>
          </h2>
          <p>
            Não faz sentido falar de inclusão e deixar alguém de fora. Por isso,
            buscamos uma plataforma acessível, acolhedora e simples de usar.
          </p>
          <span className="commitment-note">
            Compromissos de desenvolvimento.
            <br />
            Não representam certificações já obtidas.
          </span>
        </Reveal>
        <Reveal className="commitments" delay={0.12}>
          {commitments.map(({ icon: Icon, title, sub }, i) => (
            <div className="commitment" key={title}>
              <span className="commitment-icon">
                <Icon size={22} aria-hidden="true" />
              </span>
              <div>
                <h3>{title}</h3>
                <p>{sub}</p>
              </div>
              <span className="commitment-index">0{i + 1}</span>
            </div>
          ))}
          <div className="commitments-bottom">
            <span className="status-dot" />
            Inclusão como ponto de partida.
          </div>
        </Reveal>
      </div>
    </section>
  );
}

function Vision() {
  return (
    <section
      id="nossa-visao"
      className="section vision-section"
      aria-labelledby="vision-title"
    >
      <div className="container">
        <Reveal className="section-heading-row">
          <div>
            <Eyebrow>06 / NOSSA VISÃO</Eyebrow>
            <h2 id="vision-title">
              Começamos em um lugar.
              <br />
              <span className="text-muted">Pensamos em todos.</span>
            </h2>
          </div>
          <p className="vision-intro">
            Um piloto para aprender.
            <br />
            Uma visão que vai além.
          </p>
        </Reveal>
        <div className="vision-timeline">
          <Reveal className="vision-phase phase-current">
            <div className="phase-line">
              <span />
              <span className="phase-status">AGORA · EM PLANEJAMENTO</span>
            </div>
            <span className="phase-number">FASE 01</span>
            <span className="phase-icon">
              <University size={26} aria-hidden="true" />
            </span>
            <h3>SENAI</h3>
            <p>
              O primeiro passo em um ambiente educacional. Um piloto previsto
              para conectar comunidade e gestão.
            </p>
            <div className="phase-bottom">
              Pesquisa e autorização institucional pendentes.
            </div>
          </Reveal>
          <Reveal className="vision-phase" delay={0.1}>
            <div className="phase-line">
              <span />
              <span className="phase-status">EXPANSÃO FUTURA</span>
            </div>
            <span className="phase-number">FASE 02</span>
            <span className="phase-icon">
              <Building2 size={26} aria-hidden="true" />
            </span>
            <h3>Instituições</h3>
            <p>
              Levar o aprendizado a universidades, escolas e empresas,
              respeitando a realidade de cada espaço.
            </p>
            <div className="phase-bottom">
              Possibilidade de evolução após validar o piloto.
            </div>
          </Reveal>
          <Reveal className="vision-phase" delay={0.2}>
            <div className="phase-line">
              <span />
              <span className="phase-status">VISÃO DE LONGO PRAZO</span>
            </div>
            <span className="phase-number">FASE 03</span>
            <span className="phase-icon">
              <Globe2 size={26} aria-hidden="true" />
            </span>
            <h3>Comunidades</h3>
            <p>
              Imaginar uma rede colaborativa que amplie a visibilidade das
              barreiras em espaços públicos e privados.
            </p>
            <div className="phase-bottom">
              Uma visão futura, além do escopo do MVP.
            </div>
          </Reveal>
        </div>
        <Reveal className="vision-principle">
          <ScanEye size={20} aria-hidden="true" />
          <p>
            A tecnologia é o meio.{" "}
            <strong>Espaços mais inclusivos são o propósito.</strong>
          </p>
          <ArrowUpRight size={18} aria-hidden="true" />
        </Reveal>
      </div>
    </section>
  );
}

function Closing() {
  return (
    <section
      id="sobre-o-projeto"
      className="closing-section"
      aria-labelledby="closing-title"
    >
      <div className="container">
        <Reveal className="closing-card">
          <div className="closing-grid" aria-hidden="true" />
          <BrandSymbol className="closing-symbol" />
          <div className="closing-glow" aria-hidden="true" />
          <div className="closing-content">
            <Eyebrow light>O PRÓXIMO PASSO É UM NOVO OLHAR</Eyebrow>
            <h2 id="closing-title">
              Um olhar diferente
              <br />
              transforma espaços.
            </h2>
            <p>
              O futuro da acessibilidade começa quando escolhemos enxergar o que
              antes passava despercebido.
            </p>
            <div className="closing-actions">
              <RepositoryLink className="button button-white" icon="arrow">
                Conheça o projeto
              </RepositoryLink>
              <a className="button button-outline-light" href="#inicio">
                Voltar ao início
                <ArrowUp size={17} aria-hidden="true" />
              </a>
            </div>
            <div className="closing-status">
              <span className="status-dot" />
              Projeto acadêmico · Em desenvolvimento
            </div>
          </div>
        </Reveal>
      </div>
    </section>
  );
}

function Footer() {
  return (
    <footer className="site-footer">
      <div className="container">
        <div className="footer-main">
          <div className="footer-brand">
            <a href="#inicio" aria-label="Ponto Cego — início">
              <Brand />
            </a>
            <p>
              Tornando visíveis as barreiras
              <br />
              que passam despercebidas.
            </p>
          </div>
          <nav aria-label="Navegação do rodapé">
            <span>EXPLORE O PROJETO</span>
            <a href="#problema">O problema</a>
            <a href="#como-funciona">Como funcionará</a>
            <a href="#funcionalidades">Funcionalidades planejadas</a>
          </nav>
          <nav aria-label="Saiba mais">
            <span>UM NOVO OLHAR</span>
            <a href="#acessibilidade">Nosso compromisso</a>
            <a href="#nossa-visao">Nossa visão</a>
            <RepositoryLink className="footer-repository" icon="arrow">
              Repositório no GitHub
            </RepositoryLink>
          </nav>
          <a
            href="#inicio"
            className="footer-back"
            aria-label="Voltar ao início"
          >
            <ArrowUp size={20} aria-hidden="true" />
          </a>
        </div>
        <div className="footer-bottom">
          <p>© 2026 Ponto Cego. Um projeto em construção.</p>
          <span>
            <span className="status-dot" />
            Desenvolvido com propósito.
          </span>
        </div>
      </div>
    </footer>
  );
}

export function Landing() {
  return (
    <MotionConfig reducedMotion="user">
      <Header />
      <main id="conteudo" tabIndex={-1}>
        <Hero />
        <Problem />
        <Process />
        <Interfaces />
        <Features />
        <AccessibilitySection />
        <Vision />
        <Closing />
      </main>
      <Footer />
    </MotionConfig>
  );
}
