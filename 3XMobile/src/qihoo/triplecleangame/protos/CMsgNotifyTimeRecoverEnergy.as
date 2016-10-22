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
	public dynamic final class CMsgNotifyTimeRecoverEnergy extends com.netease.protobuf.Message {
		public static const CURENERGY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgNotifyTimeRecoverEnergy.curEnergy", "curEnergy", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var curEnergy$field:int;

		private var hasField$0:uint = 0;

		public function clearCurEnergy():void {
			hasField$0 &= 0xfffffffe;
			curEnergy$field = new int();
		}

		public function get hasCurEnergy():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set curEnergy(value:int):void {
			hasField$0 |= 0x1;
			curEnergy$field = value;
		}

		public function get curEnergy():int {
			return curEnergy$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasCurEnergy) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, curEnergy$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var curEnergy$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (curEnergy$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgNotifyTimeRecoverEnergy.curEnergy cannot be set twice.');
					}
					++curEnergy$count;
					this.curEnergy = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
