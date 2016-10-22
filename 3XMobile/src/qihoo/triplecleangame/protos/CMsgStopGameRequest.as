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
	public dynamic final class CMsgStopGameRequest extends com.netease.protobuf.Message {
		public static const LEVELID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStopGameRequest.levelID", "levelID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var levelID$field:int;

		private var hasField$0:uint = 0;

		public function clearLevelID():void {
			hasField$0 &= 0xfffffffe;
			levelID$field = new int();
		}

		public function get hasLevelID():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set levelID(value:int):void {
			hasField$0 |= 0x1;
			levelID$field = value;
		}

		public function get levelID():int {
			return levelID$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasLevelID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, levelID$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var levelID$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (levelID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStopGameRequest.levelID cannot be set twice.');
					}
					++levelID$count;
					this.levelID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
