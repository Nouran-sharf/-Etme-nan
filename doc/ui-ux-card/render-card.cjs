const fs = require('node:fs');
const path = require('node:path');
const {pathToFileURL} = require('node:url');
const {chromium} = require('playwright');

async function main() {
  const dir = __dirname;
  const fontPath = path.join(dir, 'ElMessiri.ttf');
  if (!fs.existsSync(fontPath)) {
    const response = await fetch('https://raw.githubusercontent.com/google/fonts/main/ofl/elmessiri/ElMessiri%5Bwght%5D.ttf');
    if (!response.ok) throw new Error(`Font download: ${response.status}`);
    fs.writeFileSync(fontPath, Buffer.from(await response.arrayBuffer()));
    const license = await fetch('https://raw.githubusercontent.com/google/fonts/main/ofl/elmessiri/OFL.txt');
    if (!license.ok) throw new Error(`Font license: ${license.status}`);
    fs.writeFileSync(path.join(dir, 'FONT-LICENSE.txt'), await license.text());
  }
  const font = fs.readFileSync(fontPath).toString('base64');
  const logo = fs.readFileSync(path.resolve(dir, '../../assets/etmaenan_icon_neon.png')).toString('base64');
  const source = fs.readFileSync(path.join(dir, 'card-template.html'), 'utf8')
    .replace('__FONT__', `data:font/ttf;base64,${font}`)
    .replace('__LOGO__', `data:image/png;base64,${logo}`);
  const htmlPath = path.join(dir, 'etmaenan-ui-ux-card.html');
  fs.writeFileSync(htmlPath, source);
  const browser = await chromium.launch({headless:true, executablePath:'C:/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe'});
  try {
    const page = await browser.newPage({viewport:{width:1600,height:1000}, deviceScaleFactor:2});
    await page.goto(pathToFileURL(htmlPath).href);
    await page.evaluate(async () => { await document.fonts.ready; await Promise.all([...document.images].map(i => i.decode())); });
    const checks = await page.evaluate(() => ({
      fontLoaded: document.fonts.check('700 116px "El Messiri"'),
      logoLoaded: document.querySelector('.logo').naturalWidth,
      dimensions: [document.documentElement.scrollWidth, document.documentElement.scrollHeight],
      copy: document.querySelector('.copy').getBoundingClientRect().toJSON(),
      services: document.querySelector('.services').getBoundingClientRect().toJSON(),
      accent: document.querySelector('.accent').getBoundingClientRect().toJSON(),
      textOverflow: [...document.querySelectorAll('.description,.service,.tagline,h1')].some(e=>e.scrollWidth>e.clientWidth+1)
    }));
    if (!checks.fontLoaded || checks.logoLoaded!==1254 || checks.textOverflow || checks.accent.bottom>checks.services.top) throw new Error(JSON.stringify(checks));
    await page.screenshot({path:path.join(dir, 'etmaenan-ui-ux-card.png'), fullPage:true});
    console.log(JSON.stringify(checks));
  } finally { await browser.close(); }
}
main().catch(error=>{console.error(error);process.exitCode=1;});
