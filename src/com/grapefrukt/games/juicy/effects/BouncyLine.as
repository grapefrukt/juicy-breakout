package com.grapefrukt.games.juicy.effects 
{
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * ...
	 * @author gummikana
	 */
	public class BouncyLine extends Shape
	{
		
		public function BouncyLine() 
		{
			
		}
		
		public function set( x1:Number, y1:Number, x2:Number, y2:Number ):void {
			pos1.x = x1;
			pos1.y = y1;
			pos2.x = x2;
			pos2.y = y2;

			var delta:Point;
			delta = pos2.clone();
			delta = delta.subtract( pos1 ); // pos2 - pos1 ?
			
			length = delta.length;
			delta.normalize( 1 );
			line_rotation = Math.atan2( delta.y, delta.x );
		
			delta.normalize( length * 0.5 );
			
			pos_middle = pos1.clone();
			pos_middle = pos_middle.add( delta );
			
			wobble_middle.y = 500;
		}
		
		// wobble pos is the new position of the anchor, that is going to be wobbled to the middle
		public function wobble( x:Number, y:Number ): void {

			// move this to local coordinate system
			var wobble_pos:Point = new Point( x - pos_middle.x, y - pos_middle.y );
			
			var tx:Number = wobble_pos.x;
			wobble_pos.x = wobble_pos.x * Math.cos( line_rotation ) - wobble_pos.y * Math.sin( line_rotation );
			wobble_pos.y = tx * Math.sin( line_rotation ) + wobble_pos.y * Math.cos( line_rotation );

			// wobble_pos = wobble_pos.add( pos_middle );
			
			wobble_middle = wobble_pos; // wobble_middle.add( wobble_pos );
			/*
			CVector2< Type > D = *this - centre;
			D.Rotate( angle );

			D += centre;
			Set( D.x, D.y );
			*/
			/*types::vector2 middle_result = end_pos.Rotate( paddle_pos_middle, paddle_rotation );
			paddle_middle += middle_result - paddle_pos_middle;*/

		}
		
		public function update(imeDelta:Number = 1):void {
			
			if ( Math.abs( wobble_middle.y ) > 0 ) {
				wobble_velocity.y += -bounce_speed * wobble_middle.y;
				wobble_velocity.y *= bounciness;
			}
			/*
			if( ceng::math::Absolute( paddle_middle.y ) > 0 ) {
				paddle_middle_velocity.y += -bounce_speed * paddle_middle.y;
				paddle_middle_velocity.y *= bounciness;
			}*/

			if ( Math.abs( wobble_middle.x ) > 0 ) {
				wobble_middle.x *= bounciness;
			}
			
			wobble_middle = wobble_middle.add( wobble_velocity );
			
			/*
			if( ceng::math::Absolute( paddle_middle.x ) > 0 ) {
				paddle_middle.x *= bounciness;
			}

			paddle_middle += paddle_middle_velocity;
			*/
			
			graphics.clear();
			graphics.lineStyle( 3, 0xffffff, 1 );
			
			graphics.moveTo( pos1.x, pos1.y );
			var m:Point = middle;
			graphics.curveTo( m.x, m.y, pos2.x, pos2.y );
			
		}

		public function get position1():Point {
			return pos1;
		}
		
		public function get position2():Point {
			return pos2;
		}
		
		public function get middle():Point {
			var temp:Point;
			temp = wobble_middle.clone();
			
			var angle:Number;
			angle = -line_rotation;
			var tx:Number;
			tx = temp.x;
			temp.x = temp.x * Math.cos( angle ) - temp.y * Math.sin( angle );
			temp.y = tx * Math.sin( angle ) + temp.y * Math.cos( angle );
			// x = (Type)x * (Type)cos(angle) - y * (Type)sin(angle);
			// y = (Type)tx * (Type)sin(angle) + y * (Type)cos(angle);
			
			temp = temp.add( pos_middle );
			return temp;
		}


		private var pos1:Point = new Point;
		private var pos2:Point = new Point;
		private var pos_middle:Point = new Point;
		private var length:Number = 0;
		
		// offset from the center ...
		private var wobble_middle:Point = new Point;
		private var wobble_velocity:Point = new Point;
		private var line_rotation:Number = 0;
		
		// 
		private var bounce_speed:Number = 0.25;	// 0.25f default
		private var bounciness:Number = 0.85; 		//  0.85f default bigger the number, the longer the vibrations... over 1 adds to the vibrations

	}

}