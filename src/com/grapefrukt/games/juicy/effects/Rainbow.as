package com.grapefrukt.games.juicy.effects {
	
	import com.grapefrukt.games.juicy.Settings;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Martin Jonasson (grapefrukt@grapefrukt.com)
	 */
	public class Rainbow extends Shape {
		
		private var _segments	:Vector.<Segment>;
		private var _verts		:Vector.<Number>;
		private var _indices	:Vector.<int>;
	
		public function Rainbow() {
			_segments = new Vector.<Segment>;
			_verts = new Vector.<Number>();
			_indices = new Vector.<int>();
		}
		
		public function addSegment(x:Number, y:Number):void {
			var seg:Segment;
			while (_segments.length > Settings.EFFECT_BALL_TRAIL_LENGTH) seg = _segments.shift();
			if (!seg) seg = new Segment;
			seg.x = x;
			seg.y = y;
			
			_segments.push(seg);
		}
		
		public function redrawSegments(offsetX:Number = 0, offsetY:Number = 0):void {
			graphics.clear();
			if (!Settings.EFFECT_BALL_TRAIL) return;
			
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
				
				graphics.beginFill(Settings.COLOR_TRAIL);
				graphics.drawTriangles(_verts, _indices);
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