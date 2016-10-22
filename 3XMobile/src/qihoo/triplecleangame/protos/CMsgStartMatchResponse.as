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
	public dynamic final class CMsgStartMatchResponse extends com.netease.protobuf.Message {
		public static const MAPID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStartMatchResponse.mapID", "mapID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mapID$field:int;

		private var hasField$0:uint = 0;

		public function clearMapID():void {
			hasField$0 &= 0xfffffffe;
			mapID$field = new int();
		}

		public function get hasMapID():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set mapID(value:int):void {
			hasField$0 |= 0x1;
			mapID$field = value;
		}

		public function get mapID():int {
			return mapID$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasMapID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mapID$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var mapID$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (mapID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStartMatchResponse.mapID cannot be set twice.');
					}
					++mapID$count;
					this.mapID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
