import { expect, test } from '@playwright/test';

test('the Rust WebAssembly wrapper initializes in Chromium', async ({ page }) => {
  await page.goto('/celnav-rs/wasm-smoke.html');
  await expect(page.locator('#status')).toHaveText(
    'celnav-rs WebAssembly backend is available; navigation calculations are not implemented yet.',
  );
});
