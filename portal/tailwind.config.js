/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
    "./context/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        tanna: {
          platform: "var(--tanna-shell-platform-bg)",
          "platform-fg": "var(--tanna-shell-platform-text)",
          workspace: "var(--tanna-shell-workspace-bg)",
          "workspace-fg": "var(--tanna-shell-workspace-text)",
          header: "var(--tanna-shell-header)",
          "header-border": "var(--tanna-shell-header-border)",
          panel: "var(--tanna-shell-panel-bg)",
          "panel-border": "var(--tanna-shell-panel-border)",
          accent: "var(--tanna-accent-primary)",
          "accent-hover": "var(--tanna-accent-primary-hover)",
          "accent-fg": "var(--tanna-accent-primary-fg)",
          "nav-active": "var(--tanna-nav-active)",
          "nav-link": "var(--tanna-nav-link)",
          "nav-link-hover": "var(--tanna-nav-link-hover)",
          "nav-breadcrumb": "var(--tanna-nav-breadcrumb)",
          "nav-breadcrumb-hover": "var(--tanna-nav-breadcrumb-hover)",
          "nav-separator": "var(--tanna-nav-separator)",
          link: "var(--tanna-semantic-link)",
          muted: "var(--tanna-semantic-muted)",
          success: "var(--tanna-semantic-success)",
          "success-fg": "var(--tanna-semantic-success-fg)",
          warning: "var(--tanna-semantic-warning)",
          "warning-fg": "var(--tanna-semantic-warning-fg)",
          error: "var(--tanna-semantic-error)",
          chart: "var(--tanna-chart-series-primary)",
        },
        bhalo: {
          footer: "var(--bhalo-footer-bg)",
          "footer-text": "var(--bhalo-footer-text)",
          "footer-link": "var(--bhalo-footer-link)",
          "footer-link-hover": "var(--bhalo-footer-link-hover)",
        },
      },
    },
  },
  plugins: [],
};
