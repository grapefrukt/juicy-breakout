package com.grapefrukt.games.general.collections {

	import com.grapefrukt.games.general.events.GameObjectEvent;
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.grapefrukt.games.general.namespaces.grapelib;
	
	/**
	 * ...
	 * @author Martin Jonasson (grapefrukt@grapefrukt.com)
	 */
	public class GameObjectCollection extends Sprite {
		
		protected var _collection:Vector.<GameObject>;
		
		use namespace grapelib;
		
		public function GameObjectCollection() {
			_collection = new Vector.<GameObject>;
			addEventListener(GameObjectEvent.REMOVE, handleRemove, true);
		}
		
		protected function handleRemove(e:GameObjectEvent):void {
			remove(GameObject(e.target), false);
		}
		
		public function getClosest(x:Number, y:Number, maxDistance:Number = Number.MAX_VALUE, classFilter:Class = null, filterObject:GameObject = null):GameObject {
			var dist:Number = 0.0;
			var minDist:Number = maxDistance;
			if (minDist != Number.MAX_VALUE) minDist *= minDist;
			var minObj:GameObject;
			
			for each(var go:GameObject in _collection) {
				if (	(!classFilter || go is classFilter) && 
						(go != filterObject)
					){
					dist = (go.x - x) * (go.x - x) + (go.y - y) * (go.y - y);
					if (dist < minDist) {
						minDist = dist;
						minObj = go;
					}
				}
			}
			
			return minObj;
		}
		
		public function add(go:GameObject):GameObject {
			_collection.push(go);
			addChild(go);
			return go;
		}
		
		public function addAt(go:GameObject, index:uint):GameObject {
			_collection.splice(index - 1, 0, go);
			addChild(go);
			return go;
		}
			
		public function removeAtIndex(pos:uint, doRemove:Boolean):GameObject {
			var go:GameObject = _collection[pos];
			_collection.splice(pos, 1)
			go.handleDetach(this);
			removeChild(go);
			if (doRemove) go.remove();
			return go;
		}
		
		public function remove(go:GameObject, doRemove:Boolean):GameObject {
			var i:int = _collection.indexOf(go);
			if (_collection[i] && GameObject(_collection[i]) == go) {
				_collection.splice(i, 1);
				go.handleDetach(this);
				removeChild(go);
				if (doRemove) go.remove();
				return go;
			}
			
			return null;
		}
		
		public function getIndex(go:GameObject):int {
			for (var i:int = _collection.length - 1; i >= 0; --i) {
				if (_collection[i] && GameObject(_collection[i]) == go) return i;
			}
			return -1;
		}
		
		public function getRandom():GameObject {
			if (_collection.length == 0) return null;
			var go:GameObject;
			var tries:int = 0;
			while (!go && tries < 10) {
				go = _collection[int(Math.random() * _collection.length)];
				tries++;
			}
			return go;
		}
		
		public function checkCollision(x:Number, y:Number, classFilter:Class = null, filterObject:GameObject = null):GameObject{
			var hitGo:GameObject = getClosest(x, y, Number.MAX_VALUE, classFilter, filterObject);
			if (hitGo && !hitGo.flaggedForRemoval && hitGo.hitTestPoint(x, y, true)) return hitGo;
			return null;
		}
		
		public function hasItemOfClass(findClass:Class):Boolean {
			for each(var go:GameObject in _collection) {
				if (go is findClass) return true;
			}
			return false;
		}
		
		public function update(timeDelta:Number = 1):void {
			for (var i:int = _collection.length - 1; i >= 0; --i){
				_collection[i].update(timeDelta);
			}
		}
		
		public function clear():void {
			for (var i:int = _collection.length - 1; i >= 0; --i){
				_collection[i].remove();
			}
			_collection.length = 0;
		}
		
		public function get head():GameObject {
			if (_collection.length) return _collection[0];
			return null;
		}
		
		public function get tail():GameObject {
			if (_collection.length) return _collection[_collection.length - 1];
			return null;
		}
			
		public function get collection():Vector.<GameObject> { return _collection; }
		public function get size():uint { return _collection.length };
	}
	
}