/**
 * SoundControl
 * A better workflow for developers and sound designers in AS3 projects
 * Copyright (c) 2009 Andreas Zecher, http://www.pixelate.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package de.pixelate.pelikan.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
		
	public class SoundControl extends EventDispatcher
	{		
		public const VERSION:String = "1.0.1-grapefrukt";
		
		private var _sounds				:Dictionary;
		private var _groups				:Object;
		
		private var _xml_config			:XML;
		private var _xml_config_loader	:URLLoader;
		
		private var _sounds_total		:int = 0;
		private var _sounds_loaded		:int = 0;
		
		private var _bytes_total		:int = 0;
		private var _bytes_loaded		:int = 0;
		
		private var _embed_class		:Class;
		private var _basePath			:String = "";
		
		private var _mute				:Boolean = false;
		
		public function SoundControl():void	{
			_sounds = new Dictionary();
			_groups = new Object();
		}
		
		public function loadXMLConfig(url:String):void	{
			_xml_config_loader = new URLLoader();
			_xml_config_loader.addEventListener(Event.COMPLETE, onXMLConfigLoaded);
			_xml_config_loader.load( new URLRequest(_basePath + url) );			
		}
		
		public function play(id:String):void {
			if (_mute || !loaded) return;
			var group:Array = _groups[id];
			if (group) id = group[int(Math.random() * group.length)].id;
			
			var sound:SoundObject = getSound(id);
			sound.play();
		}

		public function playSoundId(id:String, sound_id:int ):void {
			if (_mute || !loaded) return;
			var group:Array = _groups[id];
			if (group) id = group[int(sound_id % group.length)].id;
			
			var sound:SoundObject = getSound(id);
			sound.play();
		}
		
		public function stopSound(id:String):void {
			var sound:SoundObject = getSound(id);
			sound.stop();
		}
		
		private function parseXML():void {				
			if (_xml_config.@embedSounds == "false") _embed_class = null;
			//for each (var sound:XML in _xml_config.sound) registerSound(sound.@id, sound.file, sound);
			for each (var group:XML in _xml_config.sound) registerGroup(group);
		}
		
		private function registerSound(id:String, file:String, data:XML):SoundObject	{
			var volume:Number = data.volume 	|| 1;
			var pan:Number = 	data.pan 		|| 0;
			var startTime:int =	data.startTime 	|| 0;
			var loops:int = 	data.loops 		|| 0;
			
			var soundObject:SoundObject = new SoundObject(id, file, volume, pan, startTime, loops, _embed_class);
			
			_sounds[soundObject.id] = soundObject;
			
			soundObject.addEventListener(Event.COMPLETE, handleSoundLoaded);
			soundObject.addEventListener(ProgressEvent.PROGRESS, handleSoundLoadProgress);
			soundObject.load(_basePath);
			
			_sounds_total++;
			
			return soundObject;
		}
		
		private function registerGroup(group:XML):void {
			var i:int = 0;
			for each (var file:XML in group.file) {
				var soundObject:SoundObject = registerSound(group.@id + "-" + i.toString(), file, group);
				
				if (_groups[group.@id] == null) _groups[group.@id] = [];
				_groups[group.@id].push(soundObject);
				
				i++;
			}
		}
		
		public function getSound(id:String):SoundObject {
			if (_sounds[id] == null) throw new Error("Sound with id \"" + id + "\" does not exist.");
			return SoundObject(_sounds[id]);
		}

		private function onXMLConfigLoaded(event:Event):void {			
			_xml_config_loader.removeEventListener(Event.COMPLETE, onXMLConfigLoaded);
			_xml_config = new XML(event.target.data);
			parseXML();
		}
		
		private function handleSoundLoadProgress(e:ProgressEvent):void {
			_bytes_loaded = 0;
			_bytes_total = 0;
			
			for each (var so:SoundObject in _sounds) {
				_bytes_loaded += so.bytesLoaded;
				_bytes_total += so.bytesTotal;
			}
		}

		private function handleSoundLoaded(event:Event):void {
			_sounds_loaded++;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _sounds_loaded, _sounds_total));
			if(_sounds_loaded == _sounds_total) dispatchEvent( new Event(Event.INIT) );
		}
		
		public function setXMLConfig(xml:XML):void {
			_xml_config = xml;
			parseXML();
		}

		//public function get XMLConfig():XML	{ return _xml_config; }
		
		public function get soundsLoaded():int { return _sounds_loaded; }
		public function get soundsTotal():int { return _sounds_total; }
		
		public function set basePath(path:String):void { _basePath = path; }
		public function get basePath():String { return _basePath; }
		
		public function set embedSoundsClass(value:Class):void { _embed_class = value; }
		public function get embedSoundsClass():Class { return _embed_class; }
		
		public function get bytesTotal():int { return _bytes_total; }
		public function get bytesLoaded():int { return _bytes_loaded; }
		
		public function get loaded():Boolean { return _bytes_loaded == _bytes_total; }
		
		public function get mute():Boolean { return _mute; }
		
		public function set mute(value:Boolean):void {
			_mute = value;
		}
	}
}