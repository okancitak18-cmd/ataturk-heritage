#!/usr/bin/env node
import {readFileSync,existsSync} from 'node:fs';
import assert from 'node:assert/strict';
const root='ios/v31_draft/';
const file=name=>readFileSync(root+name,'utf8');
for(const path of [
'project.yml','App/AtaturkHeritageApp.swift','App/ContentView.swift',
'App/HeritageComponents.swift','Shared/ArchiveRepository.swift',
'Shared/HeritageWidgetNavigation.swift','Widgets/HeritageWidgets.swift',
'Widgets/HeritageWidgetIntents.swift'
])assert.ok(existsSync(root+path),path+' missing');
const app=file('App/ContentView.swift');
const widget=file('Widgets/HeritageWidgets.swift');
const shared=file('Shared/HeritageWidgetNavigation.swift');
const spec=file('project.yml');
for(const token of ['HeritageRootView','onOpenURL','HeritageDeepLink.entryID','ArchiveDetailView'])assert.ok(app.includes(token),'App route: '+token);
for(const token of ['Button(intent: HeritagePreviousEntryIntent())','Button(intent: HeritageNextEntryIntent())','widgetURL(','HeritageSharedState.currentEntry'])assert.ok(widget.includes(token),'Widget: '+token);
for(const token of ['group.ataturkheritage.shared','currentEntry','move','selectOnAppOpen'])assert.ok(shared.includes(token),'Shared: '+token);
assert.ok(spec.includes('ATATURKHeritageWidgets'));
assert.ok(spec.includes('CFBundleURLSchemes: [ataturkheritage]'));
assert.ok(spec.includes('group.ataturkheritage.shared'));
assert.ok(file('Shared/ArchiveRepository.swift').includes('Bundle.main.url(forResource: name, withExtension: "json")'));
console.log('V3.1 draft iOS source structure consistent. Native compilation not performed.');
