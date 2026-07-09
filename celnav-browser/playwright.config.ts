import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  use: { baseURL: 'http://127.0.0.1:4174', browserName: 'chromium', headless: true },
  webServer: {
    command: 'node ../tools/serve-static.mjs .. 4174',
    url: 'http://127.0.0.1:4174/celnav-rs/wasm-smoke.html',
    reuseExistingServer: true,
  },
});
