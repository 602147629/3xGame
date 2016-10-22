package framework.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.describeType;
	
	public class Util
	{
		public function Util()
		{
		}
		
		public static function removeDuplicateAttributeElementFromArray(arr:Array,attribute:String):void
		{
			for(var i :int = arr.length - 1 ; i >= 0  ; i-- )
			{
				var index:int = Util.indexOfDeep(arr,arr[i][attribute],attribute);
				if(index != i)
				{
					arr.splice(i,1);
				}	
			}
		}
		
		public static function newURLLoader(path:String, autoLoad:Boolean=true, completeCallback:Function=null, 
										errorCallback:Function=null, progressCallback:Function=null):URLLoader
		{
			var loader:URLLoader = new URLLoader(); 
			if(completeCallback != null)
				loader.addEventListener(Event.COMPLETE, completeCallback); 
			if(errorCallback != null)
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorCallback); 
			if(progressCallback != null)
				loader.addEventListener(ProgressEvent.PROGRESS, progressCallback);
			if(autoLoad)
				loader.load(new URLRequest(path)); 
			return loader;
		}
		
		public static function checkAllNotBigger(a1:Array, a2:Array):Boolean
		{
			var len:int = a1.length;	
			if(len > a2.length)
				return false;
			
			for(var i:int=0; i<len; i++)
			{
				if(a1[i] > a2[i])
					return false;
			}
			return true;
		}
		
		public static function minusAll(a1:Array, a2:Array):void
		{
			var len:int = a1.length;
			for(var i:int=0; i<len; i++)
			{
				a1[i] = a1[i] - a2[i];
			}
		}
		
		public static function addAll(a1:Array, a2:Array):void
		{
			var len:int = a1.length;
			for(var i:int=0; i<len; i++)
			{
				a1[i] = a1[i] + a2[i];
			}
		}
		
		public static function binarySearchArray(array:Array, compareFunc:Function, object:Object):int
		{
			var start:int = 0;
			var	end:int = array.length - 1;
			var middle:int = 0;
			var compare:Number = 0;
			
			while(start <= end)
			{
				middle = (start + end) / 2;
				compare = compareFunc(array[middle], object);
		 
				if (compare == 0)
				{
					return middle;
				}
				else if(compare > 0)
				{
					end = middle - 1;
				}
				else // if(compare < 0)
				{
					start = middle + 1;
				}
			}
			return compare > 0 ? -middle-1 : -middle-2;
		}
		
		public static function addToArray(ary:Array, obj:Object, indexProp:String):void
		{
			if(obj[indexProp] >= 0)
				return ;
			ary.push(obj);
			obj[indexProp] = ary.length-1;
		}
		
		public static function removeFromArray(ary:Array, obj:Object, indexProp:String):void
		{	
			var index:int = obj[indexProp];
			if(index < 0)
				return ;
			if(index < ary.length - 1)
			{
				var last:Object = ary[ary.length-1];
				ary[index] = last;
				last[indexProp] = index;
			}
			--ary.length;
			obj[indexProp] = -1;
		}
		
		public static function addUniqueElementToArray(array:Array, element:Object):void
		{
			if(array.indexOf(element) < 0)
			{
				array.push(element);
			}
		}
		
		public static function removeElementFromArray(ary : Array, ele : Object) : void
		{
			var index : int = ary.indexOf(ele);
			if(index >= 0)
			{
				ary.splice(index, 1);
			}
		}
		
		public static function getRandomElementFromArray(array:Array):Object
		{
			var randomIndex:int = array.length * Math.random();
			return array[randomIndex];
		}
		
		public static function getRandomArrayFromArray(array:Array, length:int):Array
		{
			array = array.concat();
			var count:int = array.length;
			var randomCount:int = 0;
			var randomArray:Array = [];
			
			while(count > 0 && randomCount < length)
			{
				var randomIndex:int = array.length * Math.random();
				randomArray.push(array[randomIndex]);
				array.splice(randomIndex, 1);
				-- count;
				++ randomCount;
			}
			
			return randomArray;
		}
		
		public static function addUniqueElementToVector(vector:Object, element:Object):void
		{
			if(vector.indexOf(element) == -1)
			{
				vector.push(element);
			}
		}
		
		public static function removeElementFromVector(vector:Object, element:Object):void
		{
			var index : int = vector.indexOf(element);
			if(index >= 0)
			{
				vector.splice(index, 1);
			}
		}
		
		public static function swapElementInVector(vector:Object, index1:int, index2:int):void
		{
			var objTmp:Object = vector[index1];
			vector[index1] = vector[index2];
			vector[index2] = objTmp;
		}
		
		public static function fillArray(array:Array, value:Object, length:int = 0):Array
		{
			if(array == null)
				array = new Array(length);
			else
				length = array.length;
			for(var i:int=0; i<length; i++)
			{
				array[i] = value;
			}
			return array;
		}
		
		public static function removeChild(array:Array, obj:Object, index:int=-1):Array
		{
			if(index == -1)
				index = array.indexOf(obj);
			if(index >= 0)
			{
				array[index] = array[array.length-1];
				--array.length;
			}
			return array;
		}
		
		public static function shuffArray(array:Array):void
		{
			for(var i:int = 1; i <= 20 ; i ++)
			{
				var aIndex:int = Math.random() * array.length;
				var bIndex:int = Math.random() * array.length;
				var temp:* = array[aIndex];
				array[aIndex] = array[bIndex];
				array[bIndex] = temp;
			}
		}
		
		public static function shuffVector(v:Object):void
		{
			for(var i:int = 1; i <= v.length / 2 ; i++)
			{
				var aIndex:int = Math.random() * v.length;
				var bIndex:int = Math.random() * v.length;
				var temp:Object = v[aIndex];
				v[aIndex] = v[bIndex];
				v[bIndex] = temp;
			}
		}
		

		
		/*
		public static function wrapBitmapData(bd:BitmapData):Sprite
		{
			var bmp:Bitmap = new Bitmap();
			bmp.bitmapData = bd;
			var sprite:Sprite = new Sprite();
			sprite.addChild(bmp);
			return sprite;
		}*/
		
		public static function randomSort(objectA:Object, objectB:Object):int
		{
			return (int)(Math.random() * 3) - 1;
		}
		
		public static function randomArray(array:Array):void
		{
			array.sortOn(randomSort);
		}
		
		public static function getAllAsInt(enum:Object):Vector.<int>
		{
			var all:Vector.<int> = new Vector.<int>();
			
			var description:XML = describeType(enum);
			for each(var constantNode:XML in description.constant)
			{
				all.push(enum[constantNode.@name]);
			}
			
			return all;
		}
		
		public static function getAllAsString(enum:Object):Vector.<String>
		{
			var all:Vector.<String> = new Vector.<String>();
			
			var description:XML = describeType(enum);
			for each(var constantNode:XML in description.constant)
			{
				all.push(enum[constantNode.@name]);
			}
			
			return all;
		}
		
//		public static function canSendBackGiftToFriend(friendId:String):Boolean
//		{
//			return SimCityMessageCentreManager.filterIdsToGameFriendsOnly([friendId], LettersConstants.LETTER_TYPE_GIFT_BACK).length > 0;
//		}
		
		public static function indexOfDeep(arr:Array ,target:*, attribute:String):int
		{
			for(var i:int = 0 ; i < arr.length ; i++)
			{
				if(arr[i][attribute] == target)
				{
					return i;
				}
			}
			return -1;
		}
		
		public static function indexOfDeepSame(arr:Array,target:*,sameFun:Function):int
		{
			for(var i:int = 0 ; i < arr.length ; i++)
			{
				if(sameFun(target,arr[i]))
				{
					return i;
				}
			}
			return -1;
		}
		
		public static function indexOfDeepSameVector(vector:Vector.<Object>, target:*, sameFun:Function):int
		{
			for(var i:int = 0 ; i < vector.length ; i++)
			{
				if(sameFun(target, vector[i]))
				{
					return i;
				}
			}
			return -1;
		}
		
		public static function getRandomEntry(vector:Vector.<Object>):Object
		{
			if (vector == null || vector.length == 0)
			{
				return null;
			}
			else
			{
				return vector[uint(Math.random() * vector.length)];
			}
		}

	}
}