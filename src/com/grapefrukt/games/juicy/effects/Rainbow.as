package com.grapefrukt.games.juicy.effects {
	
	import com.grapefrukt.games.juicy.Settings;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Martin Jonasson (grapefrukt@grapefrukt.com)
	 */
	public class Rainbow extends Shape {
		
		private var _segments	:Vector.<Segment>;	// holds the previous positions of the ball
		private var _verts		:Vector.<Number>;	// the vertices used for the draw call
		private var _indices	:Vector.<int>;		// the indices that form triangles, also used in the draw call
	
		public function Rainbow() {
			_segments = new Vector.<Segment>;
			_verts = new Vector.<Number>();
			_indices = new Vector.<int>();
		}
		
		public function addSegment(x:Number, y:Number):void {
			var seg:Segment;
			
			// first, pop off any segments that exceed the maximum trail length
			while (_segments.length > Settings.EFFECT_BALL_TRAIL_LENGTH) seg = _segments.shift();
			
			// if no segments were popped off, create a new one
			if (!seg) seg = new Segment;
			
			// move the segment to the new position
			seg.x = x;
			seg.y = y;
			
			// and move it to the other end of the list
			_segments.push(seg);
			
			// it's a good idea to reuse the segments to be easier on the garbage collection
			// creating and releasing a bunch of objects every frame can be expensive performance wise
		}
		
		public function redrawSegments(offsetX:Number = 0, offsetY:Number = 0):void {
			graphics.clear();
			if (!Settings.EFFECT_BALL_TRAIL) return;
			
			var s1			:Segment;		// current segment
			var s2			:Segment;		// previous segment
			var vertIndex	:int 	= 0;	// keeps track of which vertex index we're at
			var offset		:Number;		// temporary storage for amount to extend line outwards, bigger value = wider trail
			var ang			:Number;		// temporary storage of the inter-segment angles
			var sin			:Number = 0;	// as above
			var cos			:Number = 0;	// again, as above
			
			// first we make sure that the vertice list is the same length as we want
			// each segment (except the first) will create two vertices with two values (x/y) each
			if (_verts.length != (_segments.length - 1) * 4) {
				// if it's not the correct length we clear the entire list
				_verts.length = 0;
			}
			
			// now, we loop over all the segments, the list has the "youngest" segment at the end
			// so the loop starts at the "ball" and moves away
			for (var j:int = 0; j < _segments.length; ++j) {
				
				// store the active segment in a variable for convenience
				s1 = _segments[j];
				
				// if there's a previous segment, it's time to do some math
				if (s2) {
					// we calculate the angle between the two segments 
					// the result will be in radians, so adding half of pi will "turn" the angle 90 degrees
					// that means we can use the sin and cos values to "expand" the line outwards
					ang = Math.atan2(s1.y - s2.y, s1.x - s2.x) + Math.PI / 2;
					sin = Math.sin(ang);
					cos = Math.cos(ang);
					
					// now it's time to create the two vertices that will represent this pair of segments
					// using a loop here is probably a bit overkill since it's only two iterations
					
					for (var i:uint = 0; i < 2; ++i) {
						// this makes the first segment stand out to the "left" of the line
						// and the second to the right, changing that magic number at the end will alter the line width
						offset = ( -.5 + i / 1) * 9.0;
						
						// if the trail scale effect is enabled, we scale down the offset as we move down the list
						if (Settings.EFFECT_BALL_TRAIL_SCALE) {
							offset *= j / _segments.length;
						}
						
						// finally we put two values in the vert list
						// using the segment coordinates as a base we add the "extended" point
						// offsetX and offsetY are used here to move the entire trail
						_verts[vertIndex++] = s1.x + cos * offset - offsetX;
						_verts[vertIndex++] = s1.y + sin * offset - offsetY;
					}
				}
				
				// finally, store the current segment as the previous segment and go for another round
				s2 = s1;
			}
			
			// we need at least four vertices (eight values) to draw something
			if (_verts.length >= 8) {
				
				// now, we have a triangle "strip", but flash can't draw that without 
				// instructions for which vertices to connect, so it's time to make those
				
				// here, we loop over all the vertices and pair them together in triangles
				// each group of four vertices forms two triangles
				for (var k:int = 0; k < _verts.length / 2; k++) {
					_indices[k * 6 + 0] = k * 2 + 0;
					_indices[k * 6 + 1] = k * 2 + 1;
					_indices[k * 6 + 2] = k * 2 + 2;
					
					_indices[k * 6 + 3] = k * 2 + 1;
					_indices[k * 6 + 4] = k * 2 + 2;
					_indices[k * 6 + 5] = k * 2 + 3;
				}
				
				// and, finally, it's time to draw the entire thing
				graphics.beginFill(Settings.COLOR_TRAIL);
				graphics.drawTriangles(_verts, _indices);
			}
			
		}
		
		// convenience functions to get the first and last segments of the rainbow
		
		private function get head():Segment {
			return _segments.length ? _segments[int(_segments.length - 1)] : null;
		}
		
		private function get tail():Segment {
			return _segments.length ? _segments[0] : null;
		}
		
	}
	
}

// this is an internal class used to store the segment positions, 
// it's no different from a regular class except it's _only_ visible to the Rainbow class
class Segment  {
	public var x:Number = 0.0;
	public var y:Number = 0.0;	
}
