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

package de.pixelate.pelikan.sound {
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound; 
	import flash.media.SoundChannel; 
	import flash.media.SoundTransform; 
	import flash.net.URLRequest;
	import flash.utils.Timer;
		
	public class SoundObject extends EventDispatcher {
		
		private var _sound				:Sound;
		private var _sound_channel		:SoundChannel;
		private var _sound_transform	:SoundTransform;
		private var _id					:String;
		private var _file				:String;
		private var _volume				:Number;
		private var _pan				:Number;
		private var _startTime			:int;
		private var _loops				:int;
		private var _embed_class		:Class;
				
		public function SoundObject(id:String, file:String, volume:Number, pan:Number, startTime:int, loops:int, embedClass:Class = null):void {
			_id = 			id;
			_file = 		file;
			_volume = 		volume;
			_pan = 			pan ;
			_startTime = 	startTime;
			_loops = 		loops;
			_embed_class = 	embedClass;
			_sound_transform = 	new SoundTransform(_volume, _pan);
			
			//trace('[Embed(source="../../../../../bin/' + _file + '")] public static const ' + _id + ': Class;');
		}

		public function load(basePath: String):void	{
			if(_embed_class) {
				_sound = new _embed_class[_file.substr(0, _file.length - 4)]() as Sound;
				
				var t:Timer = new Timer(100, 1);
				t.addEventListener(TimerEvent.TIMER_COMPLETE, function():void {
					t.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
					dispatchEvent( new Event(Event.COMPLETE) );
				});
				t.start();
				
			} else {
				_sound = new Sound(new URLRequest(basePath + _file));
				_sound.addEventListener(Event.COMPLETE, handleSoundLoaded);
				_sound.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
				_sound.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			}
		}
		
		private function handleLoadProgress(e:ProgressEvent):void {
			dispatchEvent(e);
		}
		
		public function play():void	{
			_sound_channel = _sound.play(_startTime, _loops, _sound_transform);
		}
		
		public function stop():void	{
			if (!_sound_channel) return;
			_sound_channel.stop();
			_sound_channel = null;
		}
		
		private function handleSoundLoaded(event: Event):void {
			_sound.removeEventListener(Event.COMPLETE, handleSoundLoaded);
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		private function handleLoadError(e:IOErrorEvent):void {
			trace("could not load sound: ", _id);
		}
		
		public function get id():String	{ return _id; }
		
		
		public function get bytesTotal():int { return _sound.bytesTotal; }
		public function get bytesLoaded():int { return _sound.bytesLoaded; }
		
		public function get isPlaying():Boolean {
			return _sound_channel != null;
		}
	}
}