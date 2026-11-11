#!/usr/bin/env node
// Produces version-pinned offline JSON resources from the only editorial sources.
// Does NOT fetch GitHub or remote archives at application runtime.
import {readFileSync,mkdirSync,writeFileSync} from 'node:fs';
import {createHash} from 'node:crypto';
import path from 'node:path';
const outOption=process.argv.indexOf('--out');
const out=outOption>=0?process.argv[outOption+1]:'.build/ios-resources';
if(!out||out.startsWith('-'))throw new Error('Output directory required');
mkdirSync(out,{recursive:true});
const sources=['entries_v2.json','photos_v2.json'], manifest={schemaVersion:1,appContentMode:'bundled-offline-no-auto-sync',generatedAtUTC:new Date().toISOString(),files:[]};
for(const file of sources){
 const input=readFileSync(path.join('data',file));
 const parsed=JSON.parse(input.toString('utf8'));
 if(!Array.isArray(parsed))throw Error('Expected array: '+file);
 const sha=createHash('sha256').update(input).digest('hex');
 writeFileSync(path.join(out,file),input);
 manifest.files.push({name:file,source:'data/'+file,bytes:input.length,sha256:sha,count:parsed.length});
}
const bytes=manifest.files.reduce((sum,x)=>sum+x.bytes,0);
manifest.totalJSONBytes=bytes;
if(bytes>512*1024)throw Error('Text/metadata bundle exceeds 512 KiB budget: '+bytes);
writeFileSync(path.join(out,'content-manifest.json'),JSON.stringify(manifest,null,2)+'\n');
process.stdout.write(JSON.stringify({output:out,totalJSONBytes:bytes,files:manifest.files.map(({name,count,sha256})=>({name,count,sha256}))},null,2)+'\n');
