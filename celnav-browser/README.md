# Browser app scaffold

This Vite/React/TypeScript project is the future browser celestial-navigation calculator. It currently proves that Astronomy Engine loads and that the production build works; it does not yet implement sight reduction.

```bash
npm install
npm run dev
npm run build
npm test
npm run test:e2e
```

The first `npm run test:e2e` requires the Playwright Chromium download:

```bash
npx playwright install chromium
```

The browser route uses Astronomy Engine for compact local calculations and must be validated against the Skyfield reference corpus before it is relied upon.

For scope and known limits, see [`../docs/development-status.md`](../docs/development-status.md).
