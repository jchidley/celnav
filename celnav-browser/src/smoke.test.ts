import { describe, expect, it } from 'vitest';
import * as Astronomy from 'astronomy-engine';

describe('browser calculation dependencies', () => {
  it('loads Astronomy Engine', () => {
    expect(Astronomy).toBeTruthy();
    expect(typeof Astronomy.MakeTime).toBe('function');
  });
});
