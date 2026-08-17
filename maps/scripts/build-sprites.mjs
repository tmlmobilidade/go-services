import { execFileSync } from 'node:child_process';
import { cpSync, mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const repositoryRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const sourceRoot = join(repositoryRoot, 'assets', 'sprites');
const outputRoot = join(repositoryRoot, 'tileserver', 'styles');
const spreet = process.env.SPREET_BIN ?? 'spreet';

const categories = {
  transport: new Set(['airport', 'bicycle-share', 'bus', 'charging-station', 'ferry', 'harbor', 'rail', 'rail-light', 'rail-metro']),
  nature: new Set(['beach', 'park', 'playground', 'swimming', 'viewpoint', 'zoo']),
  health: new Set(['hospital', 'pharmacy']),
  civic: new Set(['art-gallery', 'attraction', 'castle', 'cinema', 'college', 'fire-station', 'library', 'museum', 'police', 'school', 'stadium', 'theatre', 'town-hall']),
  food: new Set(['cafe', 'fast-food', 'grocery', 'restaurant']),
};

const palettes = {
  light: { transport: '#0066cc', nature: '#238734', health: '#c43d4b', civic: '#6756a4', food: '#b75c14', default: '#536274' },
  dark: { transport: '#69aaff', nature: '#72d184', health: '#ff7f8b', civic: '#b8a8ff', food: '#ffb36b', default: '#c7d0dc' },
};

function colorFor(icon, palette) {
  return Object.entries(categories).find(([, icons]) => icons.has(icon))?.[0] ?? 'default';
}

for (const [mode, palette] of Object.entries(palettes)) {
  const workingDirectory = mkdtempSync(join(tmpdir(), `go-map-sprites-${mode}-`));

  cpSync(join(sourceRoot, 'custom'), workingDirectory, { recursive: true });

  for (const icon of Object.values(categories).flatMap((icons) => [...icons]).concat(['bank', 'drinking-water', 'fuel', 'lodging', 'toilet'])) {
    const source = join(sourceRoot, 'maki', `${icon}.svg`);
    const destination = join(workingDirectory, `${icon}.svg`);
    const color = palette[colorFor(icon, palette)];
    const svg = readFileSync(source, 'utf8').replace('<svg ', `<svg fill="${color}" `);
    writeFileSync(destination, svg);
  }

  const destination = join(outputRoot, mode, 'sprite');
  mkdirSync(dirname(destination), { recursive: true });
  execFileSync(spreet, [workingDirectory, destination, '--unique', '--minify-index-file'], { stdio: 'inherit' });
  execFileSync(spreet, ['--retina', workingDirectory, `${destination}@2x`, '--unique', '--minify-index-file'], { stdio: 'inherit' });
  rmSync(workingDirectory, { recursive: true, force: true });
}
