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
	public dynamic final class PBRequestInfo extends com.netease.protobuf.Message {
		public static const QID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.PBRequestInfo.qid", "qid", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var qid$field:UInt64;

		public function clearQid():void {
			qid$field = null;
		}

		public function get hasQid():Boolean {
			return qid$field != null;
		}

		public function set qid(value:UInt64):void {
			qid$field = value;
		}

		public function get qid():UInt64 {
			return qid$field;
		}

		public static const ITEMID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBRequestInfo.itemID", "itemID", (2 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const ITEMNUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBRequestInfo.itemNum", "itemNum", (3 << 3) | com.netease.protobuf.WireType.VARINT);

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

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasQid) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, qid$field);
			}
			if (hasItemID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, itemID$field);
			}
			if (hasItemNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, itemNum$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var qid$count:uint = 0;
			var itemID$count:uint = 0;
			var itemNum$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (qid$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBRequestInfo.qid cannot be set twice.');
					}
					++qid$count;
					this.qid = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (itemID$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBRequestInfo.itemID cannot be set twice.');
					}
					++itemID$count;
					this.itemID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (itemNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBRequestInfo.itemNum cannot be set twice.');
					}
					++itemNum$count;
					this.itemNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
