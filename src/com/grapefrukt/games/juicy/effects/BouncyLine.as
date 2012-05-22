package com.grapefrukt.games.juicy.effects 
{
	import com.bit101.charts.BarChart;
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.gameobjects.Ball;
	import com.grapefrukt.games.juicy.Settings;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * ...
	 * @author gummikana
	 */
	public class BouncyLine extends GameObject
	{
		
		public function BouncyLine( x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0 ) 
		{
			set( x1, y1, x2, y2 );
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
			
			// wobble_middle.y = 500;
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
		
		override public function update(imeDelta:Number = 1):void {
			
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
				wobble_middle.x *= 0.95;
			}
			
			wobble_middle = wobble_middle.add( wobble_velocity );
			
			/*
			if( ceng::math::Absolute( paddle_middle.x ) > 0 ) {
				paddle_middle.x *= bounciness;
			}

			paddle_middle += paddle_middle_velocity;
			*/
			
			graphics.clear();
			graphics.lineStyle( Settings.EFFECT_BOUNCY_LINES_WIDTH, Settings.COLOR_BOUNCY_LINES, 1, false, "normal", CapsStyle.SQUARE  );
			
			graphics.moveTo( pos1.x, pos1.y );
			var m:Point = middle;
			if( Settings.EFFECT_BOUNCY_LINES_ENABLED ) 
				graphics.curveTo( m.x, m.y, pos2.x, pos2.y );
			else
				graphics.lineTo( pos2.x, pos2.y );
			
			if ( collisionCounter > 0  ) collisionCounter--;
			
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

		public function checkCollision( ball:Ball ):void {
			
			if ( collisionCounter > 0 ) return;
			var dist:Number = distanceFromLine( pos1, pos2, new Point( ball.x, ball.y ) );
			// var col:Point = lineIntersectLine( pos1, pos2, new Point( ball.x, ball.y ), new Point( ball.exX, ball.exY ) );
			
			var max_distance:Number = 0.5 * Settings.EFFECT_BOUNCY_LINES_WIDTH + Settings.EFFECT_BOUNCY_LINES_DISTANCE_FROM_WALLS;
			// we collided
			if ( dist <= max_distance ) {
				
				// this wobble
				wobble( ball.x + Settings.EFFECT_BOUNCY_LINES_STRENGHT  * ball.velocityX, ball.y + Settings.EFFECT_BOUNCY_LINES_STRENGHT * ball.velocityY );
				
				/*
				var v:Point = new Point( ball.velocityX, ball.velocityY );
				var n:Point = pos2.subtract( pos1 ); // ( GetPaddleMaxPos() - GetPaddleMinPos() );
			
				n = new Point( -n.y, n.x );
				n.normalize( 1 );
				// n = types::vector2( -n.y , n.x );
				// n = n.Normalize();

				// float dotVec = ceng::math::Dot( v, n ) * 2.f;
				var dotVec:Number = ( v.x * n.x + v.y * n.y ) * 2.0;	
					
				n.normalize( dotVec );
				// n = n * dotVec;
				
				// var mvn:Point = new Point( v.x - n.x, v.y - n.y );
				ball.collideSet( v.x - n.x, v.y - n.y ); 
				// types::vector2 mvn = v - n;
				// ball_velocity = 1.0f *  mvn;
				*/
				
				collisionCounter = 2;
			}
		}

		public function closestPointOnLineSegment( a:Point, b:Point, p:Point ):Point
		{
			var c:Point = new Point( p.x - a.x, p.y - a.y );
			var v:Point = new Point( b.x - a.x, b.y - a.y );
			var distance:Number = v.length;
			
			// optimized normalized
			// v = v.Normalise();
			if( distance != 0 )
			{
				v.x /= distance;
				v.y /= distance;
			}

			var t:Number = v.x * c.x + v.y * c.y;
			// float t = Dot( v, c );

			if (t < 0)
				return a.clone();

			if (t > distance )
				return b.clone();

			v.x *= t;
			v.y *= t;
		
			return a.add( v );
		}
		
		public function distanceFromLine( a:Point, b:Point, p:Point ):Number
		{
			var delta:Point = closestPointOnLineSegment( a, b, p );
			delta.x = delta.x - p.x;
			delta.y = delta.y - p.y;
			
			return delta.length;
		}


		// Stolen from http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/
		//---------------------------------------------------------------
		//Checks for intersection of Segment if as_seg is true.
		//Checks for intersection of Line if as_seg is false.
		//Return intersection of Segment AB and Segment EF as a Point
		//Return null if there is no intersection
		//---------------------------------------------------------------
		private function lineIntersectLine(A:Point,B:Point,E:Point,F:Point,as_seg:Boolean=true):Point {
			var ip:Point;
			var a1:Number;
			var a2:Number;
			var b1:Number;
			var b2:Number;
			var c1:Number;
			var c2:Number;
		 
			a1= B.y-A.y;
			b1= A.x-B.x;
			c1= B.x*A.y - A.x*B.y;
			a2= F.y-E.y;
			b2= E.x-F.x;
			c2= F.x*E.y - E.x*F.y;
		 
			var denom:Number=a1*b2 - a2*b1;
			if (denom == 0) {
				return null;
			}
			ip=new Point();
			ip.x=(b1*c2 - b2*c1)/denom;
			ip.y=(a2*c1 - a1*c2)/denom;
		 
			//---------------------------------------------------
			//Do checks to see if intersection to endpoints
			//distance is longer than actual Segments.
			//Return null if it is with any.
			//---------------------------------------------------
			if(as_seg){
				if(Math.pow(ip.x - B.x, 2) + Math.pow(ip.y - B.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
				{
				   return null;
				}
				if(Math.pow(ip.x - A.x, 2) + Math.pow(ip.y - A.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
				{
				   return null;
				}
		 
				if(Math.pow(ip.x - F.x, 2) + Math.pow(ip.y - F.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
				{
				   return null;
				}
				if(Math.pow(ip.x - E.x, 2) + Math.pow(ip.y - E.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
				{
				   return null;
				}
			}
			return ip;
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

		private var collisionCounter:Number = 0;
	}

}