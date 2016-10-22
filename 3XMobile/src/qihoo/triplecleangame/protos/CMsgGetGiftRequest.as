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
	public dynamic final class CMsgGetGiftRequest extends com.netease.protobuf.Message {
		public static const USERQID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgGetGiftRequest.userQID", "userQID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var userQID$field:UInt64;

		public function clearUserQID():void {
			userQID$field = null;
		}

		public function get hasUserQID():Boolean {
			return userQID$field != null;
		}

		public function set userQID(value:UInt64):void {
			userQID$field = value;
		}

		public function get userQID():UInt64 {
			return userQID$field;
		}

		public static const FRIENDQID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgGetGiftRequest.friendQID", "friendQID", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var friendQID$field:UInt64;

		public function clearFriendQID():void {
			friendQID$field = null;
		}

		public function get hasFriendQID():Boolean {
			return friendQID$field != null;
		}

		public function set friendQID(value:UInt64):void {
			friendQID$field = value;
		}

		public function get friendQID():UInt64 {
			return friendQID$field;
		}

		public static const REQUESTTYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetGiftRequest.requestType", "requestType", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var requestType$field:int;

		private var hasField$0:uint = 0;

		public function clearRequestType():void {
			hasField$0 &= 0xfffffffe;
			requestType$field = new int();
		}

		public function get hasRequestType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set requestType(value:int):void {
			hasField$0 |= 0x1;
			requestType$field = value;
		}

		public function get requestType():int {
			return requestType$field;
		}

		public static const ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetGiftRequest.id", "id", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var id$field:int;

		public function clearId():void {
			hasField$0 &= 0xfffffffd;
			id$field = new int();
		}

		public function get hasId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set id(value:int):void {
			hasField$0 |= 0x2;
			id$field = value;
		}

		public function get id():int {
			return id$field;
		}

		public static const REQUESTNUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetGiftRequest.requestNum", "requestNum", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var requestNum$field:int;

		public function clearRequestNum():void {
			hasField$0 &= 0xfffffffb;
			requestNum$field = new int();
		}

		public function get hasRequestNum():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set requestNum(value:int):void {
			hasField$0 |= 0x4;
			requestNum$field = value;
		}

		public function get requestNum():int {
			return requestNum$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasUserQID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, userQID$field);
			}
			if (hasFriendQID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, friendQID$field);
			}
			if (hasRequestType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, requestType$field);
			}
			if (hasId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, id$field);
			}
			if (hasRequestNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, requestNum$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var userQID$count:uint = 0;
			var friendQID$count:uint = 0;
			var requestType$count:uint = 0;
			var id$count:uint = 0;
			var requestNum$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (userQID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetGiftRequest.userQID cannot be set twice.');
					}
					++userQID$count;
					this.userQID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (friendQID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetGiftRequest.friendQID cannot be set twice.');
					}
					++friendQID$count;
					this.friendQID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 3:
					if (requestType$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetGiftRequest.requestType cannot be set twice.');
					}
					++requestType$count;
					this.requestType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetGiftRequest.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (requestNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetGiftRequest.requestNum cannot be set twice.');
					}
					++requestNum$count;
					this.requestNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
