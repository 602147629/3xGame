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
	public dynamic final class CMsgQuickBuyRequest extends com.netease.protobuf.Message {
		public static const BUYTYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgQuickBuyRequest.buyType", "buyType", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var buyType$field:int;

		private var hasField$0:uint = 0;

		public function clearBuyType():void {
			hasField$0 &= 0xfffffffe;
			buyType$field = new int();
		}

		public function get hasBuyType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set buyType(value:int):void {
			hasField$0 |= 0x1;
			buyType$field = value;
		}

		public function get buyType():int {
			return buyType$field;
		}

		public static const ITEMID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgQuickBuyRequest.itemID", "itemID", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var itemID$field:int;

		public function clearItemID():void {
			hasField$0 &= 0xfffffffd;
			itemID$field = new int();
		}

		public function get hasItemID():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set itemID(value:int):void {
			hasField$0 |= 0x2;
			itemID$field = value;
		}

		public function get itemID():int {
			return itemID$field;
		}

		public static const BUYNUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgQuickBuyRequest.buyNum", "buyNum", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var buyNum$field:int;

		public function clearBuyNum():void {
			hasField$0 &= 0xfffffffb;
			buyNum$field = new int();
		}

		public function get hasBuyNum():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set buyNum(value:int):void {
			hasField$0 |= 0x4;
			buyNum$field = value;
		}

		public function get buyNum():int {
			return buyNum$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasBuyType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, buyType$field);
			}
			if (hasItemID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, itemID$field);
			}
			if (hasBuyNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, buyNum$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var buyType$count:uint = 0;
			var itemID$count:uint = 0;
			var buyNum$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (buyType$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgQuickBuyRequest.buyType cannot be set twice.');
					}
					++buyType$count;
					this.buyType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (itemID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgQuickBuyRequest.itemID cannot be set twice.');
					}
					++itemID$count;
					this.itemID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (buyNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgQuickBuyRequest.buyNum cannot be set twice.');
					}
					++buyNum$count;
					this.buyNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
