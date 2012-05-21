package com.grapefrukt.games.juicy.effects {	
	/**
	 * Code based on http://wonderfl.net/c/7QyG ( MIT License )
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	public class SliceEffect extends Sprite {
		
		private var _container:Sprite;
		private var _slices:Vector.<LineSliceObject>;
		
		public function SliceEffect(source:DisplayObject, bounds:Rectangle = null) {
			
			var bounds:Rectangle = source.getBounds(source.parent);
			
			var rp:Point = source.getBounds(source).topLeft;
			rp.x *= -1;
			rp.y *= -1;
			
			var matrix:Matrix = new Matrix;
			matrix.scale(source.scaleX, source.scaleY);
			matrix.rotate(source.rotation / 180 * Math.PI);
			matrix.translate(source.x - bounds.topLeft.x, source.y - bounds.topLeft.y);
			
			var bmp:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
			bmp.draw(source, matrix);
			
			_container = new Sprite;
			addChild(_container);
			
			_slices = new Vector.<LineSliceObject>;
			
			_container.addEventListener(Event.ADDED, handleAdded);
			_container.addEventListener(Event.REMOVED, handleRemoved);
			
			// init
			this.x = source.x;
			this.y = source.y;
			
			var points:Vector.<Point> = new <Point>[	new Point(0, 			0), 
														new Point(bmp.width, 	0), 
														new Point(bmp.width, 	bmp.height), 
														new Point(0,			bmp.height), 
													];
			
			var offset:Point = new Point(bounds.topLeft.x - source.x, bounds.topLeft.y - source.y);
			for (var i:int = 0; i < points.length; i++) {
				points[i] = points[i].add(offset);
			} 
			
			var lso:LineSliceObject = new LineSliceObject(points, bmp, offset);
			_container.addChild(lso);
			
			//_container.opaqueBackground = 0xff00ff;
		}
		
		public function update( delta:Number ) : void {
			for each (var slice:LineSliceObject in _slices){
				slice.x += slice.velocity.x;
				slice.y += slice.velocity.y;
				slice.rotation += slice.velocityR;
				
				slice.velocity.x *= 0.99;
				slice.velocity.y *= 0.99;
				slice.velocityR *= 0.99;
			}
		}
		
		public function slice(p1:Point, p2:Point):void {	
			var toSlice:Vector.<LineSliceObject> = _slices.concat();
			for each (var slice:LineSliceObject in toSlice){
				slice.slice(p1, p2);
			}
		}
		
		private function handleAdded(e:Event):void {
			if (!(e.target is LineSliceObject)) return;
			_slices.push(e.target);
		}
		
		private function handleRemoved(e:Event):void {
			if (!(e.target is LineSliceObject)) return;
			_slices.splice(_slices.indexOf(e.target), 1);
		}
	}
}

import com.grapefrukt.games.juicy.Settings;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

class LineSliceObject extends Sprite {
	private var _points:Vector.<Point>;
	private var _point1:Point;
	private var _point2:Point;
	private var _length:int;
	private var _texture:BitmapData;
	private var _textureOffset:Point;
	
	public var velocity:Point;
	public var velocityR:Number = 0;
	
	public function LineSliceObject(points:Vector.<Point>, texture:BitmapData, textureOffset:Point){
		_textureOffset = textureOffset;
		_texture = texture;
		_points = points;
		velocity = new Point;
		render();
	}
	
	private function render():void {
		graphics.beginBitmapFill(_texture, new Matrix(1, 0, 0, 1, _textureOffset.x, _textureOffset.y), false, true);
		graphics.moveTo(_points[0].x, _points[0].y);
		_length = _points.length;
		for (var i:int = 1; i < _length; i++){
			graphics.lineTo(_points[i].x, _points[i].y);
		}
		graphics.endFill();
	}
	
	public function slice(point1:Point, point2:Point):void {
		var _pt1:Point = globalToLocal(parent.localToGlobal(point1));
		var _pt2:Point = globalToLocal(parent.localToGlobal(point2));
		var newPoints:Vector.<Vector.<Point>> = new <Vector.<Point>>[new <Point>[], new <Point>[]];
		var _numCross:int = 0;
		
		for (var i:int = 0; i < _length; i++){
			var _pt3:Point = _points[i];
			var _pt4:Point = (_points.length > i + 1) ? _points[i + 1] : _points[0];
			var _crossPt:Point = crossPoint(_pt1, _pt2, _pt3, _pt4);
			
			newPoints[0].push(_pt3);
			if (_crossPt){
				newPoints[0].push(_crossPt);
				newPoints[1].push(_crossPt);
				newPoints.reverse();
				_numCross++;
			}
		}
		if (_numCross == 2){
			var slice1:LineSliceObject = new LineSliceObject(newPoints[0], _texture, _textureOffset);
			var slice2:LineSliceObject = new LineSliceObject(newPoints[1], _texture, _textureOffset);
			slice1.x = slice2.x = this.x;
			slice1.y = slice2.y = this.y;
			slice1.rotation = slice2.rotation = this.rotation;
			
			parent.addChild(slice1);
			parent.addChild(slice2);
			parent.removeChild(this);
			
			var vector:Point = _pt2.subtract(_pt1);
			var angle:Number = Math.atan2(vector.y, vector.x);
			var force:Number = Settings.EFFECT_BLOCK_SHATTER_FORCE;
			var fx:Number = Math.abs(Math.sin(angle));
			var fy:Number = Math.abs(Math.cos(angle));
			var fx1:Number = (newPoints[0][0].x < newPoints[1][0].x) ? -fx : fx;
			var fx2:Number = (newPoints[1][0].x < newPoints[0][0].x) ? -fx : fx;
			var fy1:Number = (newPoints[0][0].y < newPoints[1][0].y) ? -fy : fy;
			var fy2:Number = (newPoints[1][0].y < newPoints[0][0].y) ? -fy : fy;
			
			slice1.velocity = this.velocity.clone();
			slice2.velocity = this.velocity.clone();
			
			slice1.velocityR = this.velocityR + Math.random() * Settings.EFFECT_BLOCK_SHATTER_ROTATION - Settings.EFFECT_BLOCK_SHATTER_ROTATION / 2;
			slice2.velocityR = this.velocityR + Math.random() * Settings.EFFECT_BLOCK_SHATTER_ROTATION - Settings.EFFECT_BLOCK_SHATTER_ROTATION / 2;
			
			slice1.velocity.x += fx1 * force;
			slice1.velocity.y += fy1 * force;
			
			slice2.velocity.x += fx2 * force;
			slice2.velocity.y += fy2 * force;
		}
	}
	
	private function crossPoint(pt1:Point, pt2:Point, pt3:Point, pt4:Point):Point {
		var _vector1:Point = pt2.subtract(pt1);
		var _vector2:Point = pt4.subtract(pt3);
		
		if (cross(_vector1, _vector2) == 0.0)
			return null;
		
		var _s:Number = cross(_vector2, pt3.subtract(pt1)) / cross(_vector2, _vector1);
		var _t:Number = cross(_vector1, pt1.subtract(pt3)) / cross(_vector1, _vector2);
		
		if (isCross(_s) && isCross(_t)){
			_vector1.x *= _s;
			_vector1.y *= _s;
			return pt1.add(_vector1);
		} else
			return null;
	}
	
	private function cross(vector1:Point, vector2:Point):Number {
		return (vector1.x * vector2.y - vector1.y * vector2.x);
	}
	
	public static function isCross(n:Number):Boolean {
		return ((0 <= n) && (n <= 1));
	}
}