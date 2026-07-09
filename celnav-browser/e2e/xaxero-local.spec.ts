import { expect, test } from '@playwright/test';

test('the locally captured Xaxero app starts without external executable scripts', async ({ page }) => {
  const externalRequests: string[] = [];
  page.on('request', request => {
    const url = new URL(request.url());
    if (!['127.0.0.1', 'localhost'].includes(url.hostname)) externalRequests.push(request.url());
  });

  await page.route(/^https?:\/\/(?!127\.0\.0\.1|localhost)/, route => route.abort());
  await page.goto('/third_party/xaxero/cnavj-local.html');

  await expect(page).toHaveTitle('HO-229 Sight Reduction & Plotter');
  await expect(page.locator('#root')).toContainText('SIGHT REDUCTION FORM');
  await expect(page.locator('#root')).toContainText('OPEN ALMANAC');
  expect(await page.evaluate(() => Boolean(window.Astronomy))).toBe(true);
  expect(externalRequests).toEqual([]);
});
