#!/usr/bin/env node
// Only checks bookkeeping completeness; it does not verify copyright or source truth.
import {readFileSync} from 'node:fs';
import assert from 'node:assert/strict';
const read=p=>JSON.parse(readFileSync(p,'utf8'));
const ledger=read('data/photo_audit_v31.json');
const photos=read('data/photos_v2.json');
const entries=read('data/entries_v2.json');
assert.equal(ledger.photos.length,photos.length);
assert.equal(new Set(ledger.photos.map(p=>p.photoId)).size,photos.length);
const IDs=new Set(photos.map(p=>p.id));
for(const p of ledger.photos){
 assert.ok(IDs.has(p.photoId),p.photoId);
 assert.equal(p.linkedEntryCount,entries.filter(e=>e.photoId===p.photoId).length,p.photoId);
 assert.ok(['a_verifier','valide','refuse'].includes(p.status),p.photoId);
 if(p.status==='valide'){
   assert.equal(p.rightsReview,'verifiee',p.photoId+' droits non contrôlés');
   assert.equal(p.visualAuthenticity,'verifiee',p.photoId+' authenticité non contrôlée');
 }
}
console.log('Inventaire photographique complet : '+photos.length+' documents ; droits non présumés.');
