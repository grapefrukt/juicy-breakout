package com.grapefrukt.games.juicy {
	import com.gskinner.motion.GTween;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class Freezer {
		
		private static var frozeAt:int;
		
		public static function freeze():void {
			frozeAt = getTimer();
		}
		
		public static function get multiplier():Number {
			var time:int = getTimer() - frozeAt;
			
			if (time < Settings.EFFECT_FREEZE_FADE_IN_MS) {
				return lerp(1, Settings.EFFECT_FREEZE_SPEED_MULTIPLIER, time / Settings.EFFECT_FREEZE_FADE_IN_MS);
			}
			
			time -= Settings.EFFECT_FREEZE_FADE_IN_MS;
			
			if (time < Settings.EFFECT_FREEZE_DURATION_MS) {
				return Settings.EFFECT_FREEZE_SPEED_MULTIPLIER;
			}
			
			time -= Settings.EFFECT_FREEZE_DURATION_MS;
			
			if (time < Settings.EFFECT_FREEZE_FADE_OUT_MS) {
				return lerp(Settings.EFFECT_FREEZE_SPEED_MULTIPLIER, 1, time / Settings.EFFECT_FREEZE_FADE_OUT_MS);
			}
			
			return 1;
		}
		
		private static function lerp(start:Number, end:Number, f:Number):Number {
			return start + (end - start) * f;
		}
		
	}

}