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
	public dynamic final class CMsgUseItemResponse extends com.netease.protobuf.Message {
		public static const ITEMID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgUseItemResponse.itemID", "itemID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var itemID$field:int;

		private var hasField$0:uint = 0;

		public function clearItemID():void {
			hasField$0 &= 0xfffffffe;
			itemID$field = new int();
		}

		public function get hasItemID():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set itemID(value:int):void {
			hasField$0 |= 0x1;
			itemID$field = value;
		}

		public function get itemID():int {
			return itemID$field;
		}

		public static const ITEMNUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgUseItemResponse.itemNum", "itemNum", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var itemNum$field:int;

		public function clearItemNum():void {
			hasField$0 &= 0xfffffffd;
			itemNum$field = new int();
		}

		public function get hasItemNum():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set itemNum(value:int):void {
			hasField$0 |= 0x2;
			itemNum$field = value;
		}

		public function get itemNum():int {
			return itemNum$field;
		}

		public static const USEREASON:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgUseItemResponse.useReason", "useReason", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var useReason$field:int;

		public function clearUseReason():void {
			hasField$0 &= 0xfffffffb;
			useReason$field = new int();
		}

		public function get hasUseReason():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set useReason(value:int):void {
			hasField$0 |= 0x4;
			useReason$field = value;
		}

		public function get useReason():int {
			return useReason$field;
		}

		public static const RESULT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgUseItemResponse.result", "result", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var result$field:int;

		public function clearResult():void {
			hasField$0 &= 0xfffffff7;
			result$field = new int();
		}

		public function get hasResult():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set result(value:int):void {
			hasField$0 |= 0x8;
			result$field = value;
		}

		public function get result():int {
			return result$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasItemID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, itemID$field);
			}
			if (hasItemNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, itemNum$field);
			}
			if (hasUseReason) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, useReason$field);
			}
			if (hasResult) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, result$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var itemID$count:uint = 0;
			var itemNum$count:uint = 0;
			var useReason$count:uint = 0;
			var result$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (itemID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgUseItemResponse.itemID cannot be set twice.');
					}
					++itemID$count;
					this.itemID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (itemNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgUseItemResponse.itemNum cannot be set twice.');
					}
					++itemNum$count;
					this.itemNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (useReason$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgUseItemResponse.useReason cannot be set twice.');
					}
					++useReason$count;
					this.useReason = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgUseItemResponse.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
