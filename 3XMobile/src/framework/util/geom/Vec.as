//	------------------------------Vector.as------------------------
package framework.util.geom{
	public class Vec {
//	----------------------------------------------------------------------
//	属性
	private var xValue:Number;
	private var yValue:Number;
//	----------------------------------------------------------------------
//	构造函数
	public function Vec(xx:Number,yy:Number)
	{
		this.xValue=xx;
		this.yValue=yy;
	}
//	----------------toString----------------------------------------------
//	格式化输出向量坐标,取三位小数输出，原数值不变
	public function toString():String
	{
		var rx:Number = Math.round (this.xValue * 1000) / 1000;
		var ry:Number = Math.round (this.yValue * 1000) / 1000;
		return "[" + rx + ", " + ry + "]";
	}
//	----------------reset-------------------------------------------------
//	重置
	public function reset(xx:Number,yy:Number):void 
	{
		this.xValue=xx;
		this.yValue=yy;
	}
//	----------------getClone----------------------------------------------
//	复制
	public function getClone():Vec
	{
		return new Vec(this.xValue,this.yValue);
	}
//	----------------equals------------------------------------------------
//	比较是否相等
	public function equals(v:Vec):Boolean
	{
		return (this.xValue==v.xValue && this.yValue==v.yValue);
	}
//	----------------plus--------------------------------------------------
//	加法,改变当前对象
	public function plus(v:Vec):void
	{
		this.xValue += v.xValue;
		this.yValue += v.yValue;	
	}
//	----------------plusNew-----------------------------------------------
//	求和,返回新对象
	public function plusNew(v:Vec):Vec
	{
		return new Vec(this.xValue+v.xValue,this.yValue+v.yValue);
	}
//	----------------minus-------------------------------------------------
//	减法,改变当前对象
	public function minus(v:Vec):void
	{
		this.xValue -= v.xValue;
		this.yValue -= v.yValue;
	}
//	----------------minusNew----------------------------------------------
//	求差,返回新对象
	public function minusNew(v:Vec):Vec
	{
		return new Vec(this.xValue-v.xValue,this.yValue-v.yValue);
	}
//	----------------negate------------------------------------------------
//	求逆,改变当前对象
	public function negate():void
	{
		this.xValue = -xValue;
		this.yValue = -yValue;
	}
//	----------------negateNew---------------------------------------------
//	求逆,返回新对象
	public function negateNew():Vec
	{
		return new Vec(-this.xValue,-this.yValue);
	}
//	----------------scale-------------------------------------------------
//	缩放,改变当前对象
	public function scale(s:Number):void
	{
		this.xValue *= s;
		this.yValue *= s;
	}
//	----------------scaleNew----------------------------------------------
//	缩放,返回新对象
	public function scaleNew(s:Number):Vec
	{
		return new Vec(this.xValue * s, this.yValue * s);
	}
//	----------------getLength---------------------------------------------
//	获取向量长度
	public function getLength():Number
	{
		return Math.sqrt(this.xValue*this.xValue + this.yValue*this.yValue);
	}
//	----------------setLength---------------------------------------------	
//	设置向量长度
	public function setLength(len:Number):void{
		var r:Number = this.getLength();
		if (r) this.scale (len / r);
		else this.xValue = len;
	}
//	----------------getAngle----------------------------------------------
//	获取向量角度
	public function getAngle():Number
	{
		return Math.atan2(this.yValue, this.xValue);
	}
//	----------------setAngle----------------------------------------------
//	设置向量角度
	public function setAngle(ang:Number):void
	{
		var r:Number = this.getLength();
		this.xValue = r * Math.cos (ang);
		this.yValue = r * Math.sin (ang);
	}
//	----------------rotate------------------------------------------------
//	向量旋转，改变当前对象
	public function rotate(ang:Number):void
	{  
		var ca:Number = Math.cos (ang);
		var sa:Number = Math.sin (ang); 
		//trace(this.xValue * ca)
		//trace(this.yValue * sa)
		var rx:Number = this.xValue * ca - this.yValue * sa;
		var ry:Number = this.xValue * sa + this.yValue * ca;
		this.xValue = rx;
		this.yValue = ry;
	} 
//	----------------rotateNew---------------------------------------------
//	向量旋转，返回新对象
	public function rotateNew(ang:Number):Vec
	{
		var v:Vec=new Vec(this.xValue,this.yValue);
		v.rotate(ang);
		return v;
	}
//	----------------dot---------------------------------------------------
//	点积
	public function dot(v:Vec):Number{
		
		return this.xValue * v.xValue + this.yValue * v.yValue;
	}
//	----------------getNormal---------------------------------------------
//	法向量
	public function getNormal():Vec
	{
		return new Vec(-this.yValue,this.xValue);
	}
//	----------------isPerpTo----------------------------------------------
//	垂直验证
	public function isPerpTo(v:Vec):Boolean
	{
		return (this.dot (v) == 0);
	}
//	----------------angleBetween------------------------------------------
//	向量的夹角
	public function angleBetween(v:Vec):Number
	{
		var dp:Number = this.dot (v); 
		var cosAngle:Number = dp / (this.getLength() * v.getLength());
		return Math.acos (cosAngle); 
	}
//	----------------getter/setter-----------------------------------------
//	隐式获取/设置
	public function get xV():Number
	{
		return this.xValue;
	}
//	----------------------------------------------------------------------
	public function set xV(para:Number):void
	{
		this.xValue=para;
	}
//	----------------------------------------------------------------------
	public function get yV():Number
	{
		return this.yValue;
	}
//	----------------------------------------------------------------------
	public function set yV(para:Number):void{
		
		this.yValue=para;
	}
	
	
	public static function formatAngle(angle:Number):Number
	{
		while(angle < 0)
		{
			angle += Math.PI * 2;
		}
		
		while(angle > Math.PI * 2)
		{
			angle -= Math.PI * 2;
		}
		
		if(angle > Math.PI)
		{
			angle -= Math.PI * 2;
		}
		
		return angle;
	}
	
	public static function formatAnglePositive(angle:Number):Number
	{
		while(angle < 0)
		{
			angle += Math.PI* 2;
		}
		
		while(angle > Math.PI * 2)
		{
			angle -= Math.PI* 2;
		}
		
		return angle;
	}
}
}