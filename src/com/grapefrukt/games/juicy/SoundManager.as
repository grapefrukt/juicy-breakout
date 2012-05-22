package com.grapefrukt.games.juicy {
	import de.pixelate.pelikan.sound.SoundControl;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class SoundManager {
		
		private static var _sound_control	:SoundControl;
		
		public static function init():void {			
			_sound_control = new SoundControl();
			_sound_control.basePath = "sfx/";
			_sound_control.addEventListener(Event.INIT, handleSoundControlInit);
			_sound_control.loadXMLConfig("sound.xml");
			//_sound_control.embedSoundsClass = Assets;
			//_sound_control.setXMLConfig(Assets.SoundXML.data);
		}
		
		static public function play(id:String):void {
			_sound_control.play(id);
		}
		
		private static function handleSoundControlInit(e:Event):void {
			_sound_control.removeEventListener(Event.INIT, handleSoundControlInit);
		}	
		
		public static function get mute():Boolean { return _sound_control.mute; }
		
		public static function set mute(value:Boolean):void {
			_sound_control.mute = value;
		}
		
		public static function get bytesTotal():int { return _sound_control.bytesTotal; }
		public static function get bytesLoaded():int { return _sound_control.bytesLoaded; }
		
		static public function get soundControl():SoundControl {
			return _sound_control;
		}
		
	}

}