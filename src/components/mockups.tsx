"use client";

import { useId } from "react";
import {
  ArrowDownLeft,
  ArrowUpRight,
  Bell,
  Camera,
  Check,
  CheckCheck,
  ChevronDown,
  ChevronRight,
  Circle,
  Clock3,
  FileText,
  LayoutDashboard,
  ListFilter,
  MapPin,
  Plus,
  Settings2,
  Signal,
  UserRound,
  Wifi,
} from "lucide-react";
import { BrandSymbol } from "./shared";

function point(x: number, y: number, z = 0) {
  return `${300 + (x - y) * 0.82},${76 + (x + y) * 0.42 - z}`;
}
function block(
  x: number,
  y: number,
  w: number,
  d: number,
  h: number,
  purple = false,
) {
  return (
    <g key={`${x}-${y}`}>
      <polygon
        points={`${point(x, y, h)} ${point(x + w, y, h)} ${point(x + w, y + d, h)} ${point(x, y + d, h)}`}
        fill={purple ? "#E1D6FF" : "#fff"}
        stroke={purple ? "#B49AF7" : "#DCDCE9"}
      />
      <polygon
        points={`${point(x, y + d, h)} ${point(x + w, y + d, h)} ${point(x + w, y + d)} ${point(x, y + d)}`}
        fill={purple ? "#BDA6FA" : "#E7E6EF"}
        stroke={purple ? "#A98DF2" : "#DCDCE9"}
      />
      <polygon
        points={`${point(x + w, y, h)} ${point(x + w, y + d, h)} ${point(x + w, y + d)} ${point(x + w, y)}`}
        fill={purple ? "#9270E8" : "#D9D8E6"}
        stroke={purple ? "#A98DF2" : "#DCDCE9"}
      />
      <path
        d={`M${point(x + 10, y + 10, h + 1)} L${point(x + w - 10, y + 10, h + 1)}`}
        stroke={purple ? "#C0A7FF" : "#ECEBF4"}
        strokeWidth="3"
      />
    </g>
  );
}

export function IsometricCampus() {
  const id = useId().replace(/:/g, "");
  return (
    <svg
      viewBox="0 0 600 450"
      className="isometric-campus"
      fill="none"
      aria-hidden="true"
    >
      <defs>
        <linearGradient
          id={`plane-${id}`}
          x1="300"
          y1="75"
          x2="300"
          y2="400"
          gradientUnits="userSpaceOnUse"
        >
          <stop stopColor="#FDFBFF" />
          <stop offset="1" stopColor="#ECE6FA" />
        </linearGradient>
        <filter
          id={`shadow-${id}`}
          x="-30%"
          y="-30%"
          width="160%"
          height="180%"
        >
          <feDropShadow
            dx="0"
            dy="22"
            stdDeviation="15"
            floodColor="#5A329E"
            floodOpacity=".12"
          />
        </filter>
      </defs>
      <g filter={`url(#shadow-${id})`}>
        <polygon
          points={`${point(0, 0)} ${point(350, 0)} ${point(350, 320)} ${point(0, 320)}`}
          fill={`url(#plane-${id})`}
          stroke="#DCD3F2"
        />
        <polygon
          points={`${point(0, 320)} ${point(350, 320)} ${point(350, 320, -12)} ${point(0, 320, -12)}`}
          fill="#DBD0F2"
        />
        <polygon
          points={`${point(350, 0)} ${point(350, 320)} ${point(350, 320, -12)} ${point(350, 0, -12)}`}
          fill="#C9BCE8"
        />
        {Array.from({ length: 8 }, (_, i) => (
          <g key={i} stroke="#D9D1E9" strokeWidth=".7">
            <path d={`M${point(0, i * 40)} L${point(350, i * 40)}`} />
            <path d={`M${point(i * 45, 0)} L${point(i * 45, 320)}`} />
          </g>
        ))}
        <path
          d={`M${point(0, 174)} L${point(350, 174)} M${point(181, 0)} L${point(181, 320)}`}
          stroke="white"
          strokeWidth="26"
        />
        <path
          d={`M${point(0, 174)} L${point(350, 174)} M${point(181, 0)} L${point(181, 320)}`}
          stroke="#DDD4EF"
          strokeDasharray="4 5"
          strokeWidth="1"
        />
        {block(31, 27, 94, 81, 25)}
        {block(219, 29, 85, 82, 35)}
        {block(29, 227, 98, 55, 20)}
        {block(223, 224, 92, 55, 29, true)}
        <path
          d={`M${point(99, 150, 2)} L${point(181, 150, 2)} L${point(181, 208, 2)} L${point(267, 208, 2)}`}
          stroke="#8654EE"
          strokeWidth="3"
          strokeDasharray="5 4"
        />
        {[
          [28, 135],
          [320, 137],
          [142, 282],
          [220, 300],
          [332, 300],
          [143, 30],
        ].map(([x, y]) => (
          <g key={`${x}-${y}`}>
            <path
              d={`M${point(x, y)} L${point(x, y, 15)}`}
              stroke="#A1B1A6"
              strokeWidth="3"
            />
            <ellipse
              cx={300 + (x - y) * 0.82}
              cy={76 + (x + y) * 0.42 - 18}
              rx="9"
              ry="12"
              fill="#CADBCF"
            />
            <ellipse
              cx={297 + (x - y) * 0.82}
              cy={73 + (x + y) * 0.42 - 18}
              rx="5"
              ry="8"
              fill="#DCE9DD"
            />
          </g>
        ))}
        <ellipse cx="418" cy="275" rx="9" ry="4" fill="#5421EB" opacity=".2" />
        <circle cx="419" cy="270" r="4" fill="#5421EB" />
      </g>
    </svg>
  );
}

export function FlatMap({ showPin = true }: { showPin?: boolean }) {
  return (
    <div className="flat-map" aria-hidden="true">
      <svg viewBox="0 0 360 260" fill="none">
        <rect width="360" height="260" fill="#F0EEF7" />
        <path
          d="M-20 70L380 165M85-20L28 280M270-20L195 280"
          stroke="white"
          strokeWidth="27"
        />
        <path
          d="M-20 70L380 165M85-20L28 280M270-20L195 280"
          stroke="#DBD6E9"
          strokeWidth="1"
          strokeDasharray="4 5"
        />
        <g fill="#E1DCEB" stroke="#D0C7E1">
          <rect
            x="99"
            y="22"
            width="111"
            height="52"
            rx="7"
            transform="rotate(14 99 22)"
          />
          <rect
            x="94"
            y="133"
            width="91"
            height="70"
            rx="7"
            transform="rotate(14 94 133)"
          />
          <rect
            x="277"
            y="64"
            width="79"
            height="60"
            rx="7"
            transform="rotate(14 277 64)"
          />
          <rect
            x="257"
            y="177"
            width="80"
            height="50"
            rx="7"
            transform="rotate(14 257 177)"
          />
        </g>
        <path
          d="M111 175L84 169L97 114L215 142"
          stroke="#8B64E8"
          strokeWidth="3"
          strokeDasharray="4 6"
        />
        <g fill="#CBDBD2">
          <circle cx="302" cy="27" r="13" />
          <circle cx="316" cy="39" r="9" />
          <circle cx="25" cy="193" r="15" />
          <circle cx="35" cy="220" r="11" />
        </g>
        <text
          x="132"
          y="60"
          fontSize="12"
          fill="#8C829C"
          fontFamily="sans-serif"
          transform="rotate(14 132 60)"
        >
          BLOCO A
        </text>
      </svg>
      {showPin && (
        <div className="map-marker">
          <MapPin
            size={25}
            fill="currentColor"
            stroke="white"
            strokeWidth={1.5}
          />
        </div>
      )}
      <div className="map-location">
        <span />
        Ambiente de demonstração
      </div>
    </div>
  );
}

const phoneSteps = [
  {
    title: "Um novo olhar",
    sub: "Identifique o que precisa mudar.",
    status: "Barreira identificada",
  },
  {
    title: "Novo relato",
    sub: "Cada detalhe ajuda a transformar.",
    status: "Informações da ocorrência",
  },
  {
    title: "Meus relatos",
    sub: "Sua voz tem acompanhamento.",
    status: "Em andamento",
  },
  {
    title: "Uma mudança real",
    sub: "Um espaço melhor para todos.",
    status: "Resolvida",
  },
];

export function PhoneMockup({
  step = 0,
  className = "",
}: {
  step?: number;
  className?: string;
}) {
  const content = phoneSteps[step];
  return (
    <div className={`phone-mockup ${className}`} aria-hidden="true">
      <div className="phone-status">
        <span>9:41</span>
        <div className="phone-island" />
        <div>
          <Signal size={11} />
          <Wifi size={11} />
          <span className="battery" />
        </div>
      </div>
      <div className="phone-brand">
        <BrandSymbol />
        <span>Ponto Cego</span>
        <Bell size={15} />
      </div>
      <div className="phone-content">
        <div className="phone-greeting">COMUNIDADE · PRÉVIA</div>
        <h4>{content.title}</h4>
        <p>{content.sub}</p>
        {step < 2 ? (
          <>
            <div className="phone-map">
              <FlatMap />
            </div>
            {step === 0 ? (
              <div className="phone-report">
                <span className="mini-icon">
                  <MapPin size={17} />
                </span>
                <div>
                  <strong>Um ponto de atenção</strong>
                  <span>Acesso ao bloco A</span>
                </div>
                <ChevronRight size={15} />
              </div>
            ) : (
              <div className="mock-form">
                <div>
                  <span>Local</span>
                  <strong>
                    Bloco A · Entrada
                    <ChevronDown size={11} />
                  </strong>
                </div>
                <div>
                  <span>Descrição</span>
                  <strong>Desnível no acesso ao bloco</strong>
                </div>
                <div className="mock-photo">
                  <Camera size={15} />
                  Adicionar foto (opcional)
                </div>
              </div>
            )}
            <div className="phone-main-action">
              {step === 0 ? (
                <>
                  <Plus size={15} />
                  Registrar uma barreira
                </>
              ) : (
                <>
                  Revisar relato
                  <ArrowUpRight size={14} />
                </>
              )}
            </div>
          </>
        ) : (
          <div className="phone-tracking">
            <div className={`tracking-status ${step === 3 ? "resolved" : ""}`}>
              {step === 3 ? <CheckCheck size={15} /> : <Clock3 size={15} />}
              {content.status}
            </div>
            <h5>Desnível no acesso</h5>
            <p>
              <MapPin size={12} />
              Bloco A · Entrada
            </p>
            <div className="phone-timeline">
              {[
                "Relato registrado",
                "Em análise",
                "Em andamento",
                "Resolvida",
              ].map((item, i) => (
                <div className={`${i <= step ? "complete" : ""}`} key={item}>
                  <span>{i <= step ? <Check size={9} /> : null}</span>
                  <div>
                    <strong>{item}</strong>
                    <small>
                      {i === 3 && step === 3
                        ? "Acesso ajustado pela equipe"
                        : [
                            "Sua contribuição foi recebida",
                            "Triagem pela instituição",
                            "Equipe responsável atribuída",
                            "Próxima etapa",
                          ][i]}
                    </small>
                  </div>
                </div>
              ))}
            </div>
            <div className="phone-update">
              {step === 3
                ? "Pequenas ações. Novas possibilidades."
                : "Você poderá acompanhar cada atualização por aqui."}
            </div>
          </div>
        )}
      </div>
      <div className="phone-nav">
        <div className="selected">
          <MapPin size={17} />
          <span>Explorar</span>
        </div>
        <div>
          <FileText size={17} />
          <span>Relatos</span>
        </div>
        <div>
          <UserRound size={17} />
          <span>Perfil</span>
        </div>
      </div>
      <div className="phone-home-line" />
    </div>
  );
}

export function DashboardMockup({
  compact = false,
  className = "",
}: {
  compact?: boolean;
  className?: string;
}) {
  return (
    <div
      className={`dashboard-mockup ${compact ? "dashboard-compact" : ""} ${className}`}
      aria-hidden="true"
    >
      <div className="dashboard-browser">
        <div className="window-dots">
          <i />
          <i />
          <i />
        </div>
        <span>pontocego · gestão institucional</span>
        <ArrowUpRight size={11} />
      </div>
      <div className="dashboard-layout">
        <aside className="dashboard-sidebar">
          <div className="dashboard-logo">
            <BrandSymbol />
            <b>Ponto Cego</b>
          </div>
          <span className="sidebar-label">ESPAÇO DE TRABALHO</span>
          <div className="sidebar-active">
            <LayoutDashboard size={13} />
            <span>Visão geral</span>
          </div>
          <div>
            <FileText size={13} />
            <span>Ocorrências</span>
          </div>
          <div>
            <MapPin size={13} />
            <span>Ambientes</span>
          </div>
          <div>
            <Settings2 size={13} />
            <span>Configurações</span>
          </div>
          <div className="sidebar-bottom">
            <span className="user-avatar">G</span>
            <span>
              Gestão
              <br />
              <small>Unidade ilustrativa</small>
            </span>
          </div>
        </aside>
        <div className="dashboard-main">
          <div className="dashboard-top">
            <span>
              Visão geral <ChevronRight size={10} /> Dashboard
            </span>
            <Bell size={13} />
          </div>
          <div className="dashboard-heading">
            <div>
              <span>UM PANORAMA DO SEU ESPAÇO</span>
              <h4>Da informação à ação.</h4>
            </div>
            <span className="dashboard-period">
              Este mês
              <ChevronDown size={9} />
            </span>
          </div>
          <div className="dashboard-stats">
            {[
              ["Ocorrências", "12", "purple"],
              ["Em andamento", "04", "amber"],
              ["Resolvidas", "03", "green"],
            ].map(([label, count, color]) => (
              <div key={label}>
                <span>
                  <i className={color} />
                  {label}
                </span>
                <strong>
                  {count}
                  <ArrowDownLeft size={15} />
                </strong>
                <small>Dados de demonstração</small>
              </div>
            ))}
          </div>
          <div className="dashboard-table">
            <div className="table-heading">
              <strong>Ocorrências recentes</strong>
              <ListFilter size={12} />
            </div>
            <div className="table-labels">
              <span>OCORRÊNCIA</span>
              <span>STATUS</span>
              <span>PRIORIDADE</span>
            </div>
            {[
              [
                "Desnível no acesso",
                "Bloco A · Entrada",
                "Em andamento",
                "Alta",
              ],
              [
                "Sinalização ausente",
                "Bloco B · Corredor",
                "Em análise",
                "Média",
              ],
              [
                "Passagem obstruída",
                "Bloco A · Área comum",
                "Resolvida",
                "Média",
              ],
            ].map(([title, location, status, priority], i) => (
              <div className="table-row" key={title}>
                <div>
                  <span className={`table-icon table-icon-${i}`}>
                    <MapPin size={12} />
                  </span>
                  <span>
                    <strong>{title}</strong>
                    <small>{location}</small>
                  </span>
                </div>
                <span className={`table-status status-${i}`}>
                  <i />
                  {status}
                </span>
                <span className="priority">
                  <i className={i === 0 ? "high" : "medium"} />
                  {priority}
                </span>
              </div>
            ))}
          </div>
          {!compact && (
            <div className="dashboard-bottom-note">
              <Circle size={9} />
              Exemplo de organização. Nenhum registro real.
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export function MiniTimeline() {
  return (
    <div className="mini-timeline" aria-hidden="true">
      {["Aberta", "Em análise", "Em andamento", "Resolvida"].map((label, i) => (
        <div key={label}>
          <span className={i === 3 ? "timeline-last" : ""}>
            <Check size={10} />
          </span>
          <p>{label}</p>
          {i < 3 && <i />}
        </div>
      ))}
    </div>
  );
}
