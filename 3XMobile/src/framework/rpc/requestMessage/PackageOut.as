package framework.rpc.requestMessage
{
	import flash.utils.ByteArray;
	
	import framework.model.NetDataVo;

	/**
	 * 给服务器发送数据的包 
	 * @author melody
	 */
	public class PackageOut extends ByteArray
	{
		private var _netVos:Vector.<NetDataVo > ;

		private var _type:int;

		private var _cmdListLength:int;

		public function PackageOut(netVos:Vector.<NetDataVo > ,type:int=1 )
		{
			this._netVos = netVos;
			this._type = type;
			this._cmdListLength = netVos.length;

			this.init();
		}
		
		override public function toString():String
		{
			var str:String = "";
			
			for each(var data:Object in _netVos[0].param)
			{
				str += data.toString() +" ";
			}
			
			return str;
		}
		
		private function init():void
		{
			this.writeByte(_cmdListLength);
			for (var i:int = 0; i < _cmdListLength; i +=  1)
			{
				var netVo:NetDataVo = _netVos[i];
				var dataByteArray:ByteArray = new ByteArray();
				var len:int = netVo.param.length;
				for each (var flag:* in netVo.param)
				{
					if (flag is String)
					{
						CONFIG::debug
						{
							ASSERT(flag != null,"packageout parameter cannot be null")
						}
						dataByteArray.writeUnsignedInt(getStrByteLen(flag));
						dataByteArray.writeUTFBytes(flag);
					}
					else if(flag is Short)
					{
						dataByteArray.writeShort(flag.num);
					}
					else if(flag is Byte)
					{
						dataByteArray.writeByte(flag.num);
					}
					else if(flag is Double) 
					{
						dataByteArray.writeDouble(flag.num);
					}
					else if(flag is Float) 
					{
						dataByteArray.writeFloat(flag.num);
					}
					else if(flag is int)
					{
						dataByteArray.writeInt(flag);
					}
					
				}
				
				this.writeUnsignedInt(netVo.cmdid);
				this.writeByte(this._type);
				this.writeUnsignedInt(dataByteArray.length);
				this.writeBytes(dataByteArray,0,dataByteArray.length);
			}
		}
		//获取字符串长度
		private function getStrByteLen(str:String):int
		{
			var byte:ByteArray = new ByteArray();
			byte.writeUTFBytes(str);
			return byte.length;
		}
		//写入long
		public function writeLong(value:Number):void
		{
			var str:String = value.toString(16);
			var length:int = 16 - str.length;
			for( var i:int = 0; i < length; i++)
			{
				str = "0" + str;
			}

			var subStr:String = str.substr(0,8);
			this.writeUnsignedInt(parseInt(("0x" + subStr)));
			subStr = str.substr(8,8);
			this.writeUnsignedInt(parseInt(("0x" + subStr)));
		}

	}
}