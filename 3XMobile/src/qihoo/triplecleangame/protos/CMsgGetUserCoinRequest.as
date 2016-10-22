package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgGetUserCoinRequest extends com.netease.protobuf.Message {
		public static const COINTYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetUserCoinRequest.coinType", "coinType", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var coinType$field:int;

		private var hasField$0:uint = 0;

		public function clearCoinType():void {
			hasField$0 &= 0xfffffffe;
			coinType$field = new int();
		}

		public function get hasCoinType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set coinType(value:int):void {
			hasField$0 |= 0x1;
			coinType$field = value;
		}

		public function get coinType():int {
			return coinType$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasCoinType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, coinType$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var coinType$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (coinType$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetUserCoinRequest.coinType cannot be set twice.');
					}
					++coinType$count;
					this.coinType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
