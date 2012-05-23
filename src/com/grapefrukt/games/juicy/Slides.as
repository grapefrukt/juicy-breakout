package com.grapefrukt.games.juicy {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Slides extends Sprite {
		
		private var _slides:SlidesClip;
		
		public function Slides() {
			_slides = new SlidesClip;
			_slides.gotoAndStop(1);
			addChild(_slides);
			_slides.x = Settings.STAGE_W / 2;
			_slides.y = Settings.STAGE_H / 2;
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function handleAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.TAB) visible = !visible;
			if (!visible) return;
			
			if (e.keyCode == Keyboard.LEFT) _slides.gotoAndStop(_slides.currentFrame - 1);
			if (e.keyCode == Keyboard.RIGHT) _slides.gotoAndStop(_slides.currentFrame + 1);
		}
		
	}

}