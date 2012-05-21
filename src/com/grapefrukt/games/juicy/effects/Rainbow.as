package com.grapefrukt.games.juicy.effects {
	
	import com.grapefrukt.display.utilities.ColorConverter;
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.Settings;
	import de.polygonal.core.ObjectPool;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	
	/**
	 * ...
	 * @author Martin Jonasson (grapefrukt@grapefrukt.com)
	 */
	public class Rainbow extends Shape {
		
		private var _segments	:Vector.<Segment>;
		
		private static var _objectPool:ObjectPool;
		
		private var _verts:Vector.<Number>;
		private var _indices:Vector.<int>;
		
		public static function init():void { 
			_objectPool = new ObjectPool(true);
			_objectPool.allocate(Segment, 100);
		}
		
		public function Rainbow() {
			_segments = new Vector.<Segment>;
			_verts = new Vector.<Number>();
			_indices = new Vector.<int>();
			
			if (!_objectPool) init();
		}
		
		public function addSegment(x:Number, y:Number):void {
			var seg:Segment;
			
			while (_segments.length > Settings.EFFECT_BALL_TRAIL_LENGTH) _objectPool.object = _segments.shift();
			seg = _objectPool.object
			seg.x = x;
			seg.y = y;
			
			_segments.push(seg);
		}
		
		public function redrawSegments(offsetX:Number = 0, offsetY:Number = 0):void {
			graphics.clear();
			if (Settings.EFFECT_BALL_TRAIL_LENGTH == 0) return;
			
			var ang		:Number;
			var s1		:Segment;	// current segment
			var s2		:Segment;	// current segment
			var step	:int 	= 0;
			var offset	:Number = 0.0;
			var sin		:Number = 0;
			var cos		:Number = 0;
			
			if (_verts.length != (_segments.length - 1) * 4) {
				_verts.length = 0;
			}
			
			for (var j:int = 0; j < _segments.length; ++j) {
				s1 = Segment(_segments[j]);
				
				if (s2) {
					ang = Math.atan2(s1.y - s2.y, s1.x - s2.x) + 1.57079633;
					sin = Math.sin(ang);
					cos = Math.cos(ang);
					
					for (var i:uint = 0; i < 2; ++i) {
						offset = ( -.5 + i / 1) * 9.0;
						if (Settings.EFFECT_BALL_TRAIL_SCALE) {
							offset *= j / _segments.length;
						}
						_verts[step++] = s1.x + cos * offset - offsetX;
						_verts[step++] = s1.y + sin * offset - offsetY;
					}
					
				}
				s2 = s1;
				
			}
			
			if (_verts.length >= 8) {
				
				for (var k:int = 0; k < _verts.length / 2; k++) {
					_indices[k * 6 + 0] = k * 2 + 0;
					_indices[k * 6 + 1] = k * 2 + 1;
					_indices[k * 6 + 2] = k * 2 + 2;
					
					_indices[k * 6 + 3] = k * 2 + 1;
					_indices[k * 6 + 4] = k * 2 + 2;
					_indices[k * 6 + 5] = k * 2 + 3;
				}
				
				
				//graphics.lineStyle(1, Settings.COLOR_TRAIL, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
				graphics.beginFill(Settings.COLOR_TRAIL);
				graphics.drawTriangles(_verts, _indices);
				
				//graphics.moveTo(_verts[0], _verts[1]);
				//for (var k:int = 0; k < _verts.length; k += 2) {
					//graphics.lineTo(_verts[k + 0], _verts[k + 1]);
				//}
				
			}
			
		}
		
		private function get head():Segment {
			return _segments.length ? _segments[int(_segments.length - 1)] : null;
		}
		
		private function get tail():Segment {
			return _segments.length ? _segments[0] : null;
		}
		
	}
	
}

class Segment  {
	public var x:Number = 0.0;
	public var y:Number = 0.0;	
}