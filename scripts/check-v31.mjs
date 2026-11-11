#!/usr/bin/env node
// ATATÜRK Heritage — V3.1 integrity and UI-static smoke tests.
import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';
import vm from 'node:vm';

const loadJSON=p=>JSON.parse(readFileSync(p,'utf8'));
const expectedEntries=loadJSON('data/entries_v2.json');
const expectedPhotos=loadJSON('data/photos_v2.json');
const uniq=values=>new Set(values).size===values.length;
const https=url=>typeof url==='string'&&/^https:\/\/[^\s]+$/i.test(url);
const errors=[];
const check=(name,fn)=>{try{fn();process.stdout.write('PASS '+name+'\n')}catch(e){errors.push({name,error:e.message});process.stderr.write('FAIL '+name+': '+e.message+'\n')}};

check('235 fiches, 24 références photographiques',()=>{
 assert.equal(expectedEntries.length,235);
 assert.equal(expectedPhotos.length,24);
 assert.equal(expectedEntries.filter(x=>x.kind==='quote').length,48);
 assert.equal(expectedEntries.filter(x=>x.kind==='event').length,187);
});
check('Identifiants uniques et liens photoId cohérents',()=>{
 assert.ok(uniq(expectedEntries.map(x=>x.id)));
 assert.ok(uniq(expectedPhotos.map(x=>x.id)));
 const ids=new Set(expectedPhotos.map(x=>x.id));
 for(const x of expectedEntries)assert.ok(!x.photoId||ids.has(x.photoId),x.id+' photoId introuvable');
});
check('Datation contrôlée sans invention de jour',()=>{
 for(const x of expectedEntries){
  assert.ok(x.precision==='year'||x.precision==='day',x.id);
  assert.match(x.date,x.precision==='year'?/^\d{4}$/:/^\d{4}-\d{2}-\d{2}$/,x.id);
  if(x.precision==='day'){const dt=new Date(x.date+'T12:00:00Z');assert.ok(!Number.isNaN(dt.valueOf())&&dt.toISOString().startsWith(x.date),x.id)}
 }
});
check('Provenance documentaire présente et liens sécurisés',()=>{
 for(const x of expectedEntries){assert.ok(x.sourceTitle&&https(x.sourceURL),x.id)}
 for(const p of expectedPhotos){assert.ok(p.label&&p.institution&&p.license&&https(p.url)&&https(p.sourceUrl),p.id)}
});
const extract=(html,name)=>{
 const m=html.match(new RegExp('(?:^|\\n)const '+name+'=(\\[[^\\n]*\\]);'));
 assert.ok(m,name+' absent du fichier HTML');
 return JSON.parse(m[1]);
};
for(const path of ['index.html','laboratoire.html']){
 const html=readFileSync(path,'utf8');
 check(path+' embarque le référentiel source exact',()=>{
  assert.deepEqual(extract(html,'ARCHIVE'),expectedEntries);
  assert.deepEqual(extract(html,'PHOTOS'),expectedPhotos);
 });
 check(path+' JavaScript syntaxiquement valide',()=>{
  const match=html.match(/<script>([\s\S]*?)<\/script>/);
  assert.ok(match,'Bloc JS absent');
  new vm.Script(match[1],{filename:path});
 });
 check(path+' a les commandes requises sans libellés permanents',()=>{
  for(const token of ['data-photo-back','data-photo-filter','photoZoomToggle','data-context','widgetText','widget-excerpt','stylePrefs']){
   assert.ok(html.includes(token),path+' '+token+' manquant');
  }
  assert.ok(!html.includes('En bas de la fiche, glissez encore vers le haut pour ouvrir le dossier.'));
  assert.ok(!html.includes('Références du jour, puis autres fiches en chronologie historique.'));
 });
}
check('Laboratoire de simulation conservé',()=>{
 const html=readFileSync('laboratoire.html','utf8');
 assert.ok(html.includes('id="testdate"'));
 assert.ok(html.includes('id="lab-appearance"'));
 assert.ok(html.includes('id="lab-style-controls"'));
});
check('Application publique sans page de simulation accessible',()=>{
 const html=readFileSync('index.html','utf8');
 assert.ok(html.includes('data-surface="application"'));
 assert.ok(html.includes("state.mode='app';state.size='standard'"));
 assert.ok(html.includes('Contrôle')||html.includes('app-settings-button'));
});
if(errors.length){process.stderr.write('\n'+errors.length+' test(s) en erreur\n');process.exit(1)}
process.stdout.write('\nTous les contrôles statiques ont réussi.\n');
