import type { Metadata, Viewport } from "next";
import localFont from "next/font/local";
import { siteDescription, siteTitle, siteUrl } from "@/lib/site";
import "./globals.css";

const jakarta = localFont({
  src: "./fonts/plus-jakarta-sans-latin-wght-normal.woff2",
  variable: "--font-jakarta",
  display: "swap",
  weight: "200 800",
});

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: siteTitle,
  description: siteDescription,
  applicationName: "Ponto Cego",
  keywords: [
    "Ponto Cego",
    "acessibilidade",
    "barreiras de acessibilidade",
    "inclusão",
    "gestão institucional",
  ],
  alternates: { canonical: "/" },
  openGraph: {
    type: "website",
    locale: "pt_BR",
    url: siteUrl,
    siteName: "Ponto Cego",
    title: siteTitle,
    description: siteDescription,
  },
  twitter: {
    card: "summary_large_image",
    title: siteTitle,
    description: siteDescription,
  },
  icons: { icon: "/branding/icon-transparent.svg", apple: "/apple-icon.png" },
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  themeColor: "#5421EB",
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="pt-BR">
      <body className={jakarta.variable}>
        {children}
        <noscript>
          <style>{`[data-reveal] { opacity: 1 !important; transform: none !important; } .hero-visual, .hero-visual * { opacity: 1 !important; transform: none !important; }`}</style>
        </noscript>
      </body>
    </html>
  );
}
