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
	public dynamic final class CMsgUnlockLevelGroupRequest extends com.netease.protobuf.Message {
		public static const USERID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgUnlockLevelGroupRequest.userID", "userID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var userID$field:UInt64;

		public function clearUserID():void {
			userID$field = null;
		}

		public function get hasUserID():Boolean {
			return userID$field != null;
		}

		public function set userID(value:UInt64):void {
			userID$field = value;
		}

		public function get userID():UInt64 {
			return userID$field;
		}

		public static const LEVELID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgUnlockLevelGroupRequest.levelID", "levelID", (2 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgUnlockLevelGroupRequest.type", "type", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var type$field:int;

		public function clearType():void {
			hasField$0 &= 0xfffffffd;
			type$field = new int();
		}

		public function get hasType():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set type(value:int):void {
			hasField$0 |= 0x2;
			type$field = value;
		}

		public function get type():int {
			return type$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasUserID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, userID$field);
			}
			if (hasLevelID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, levelID$field);
			}
			if (hasType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, type$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var userID$count:uint = 0;
			var levelID$count:uint = 0;
			var type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (userID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgUnlockLevelGroupRequest.userID cannot be set twice.');
					}
					++userID$count;
					this.userID = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (levelID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgUnlockLevelGroupRequest.levelID cannot be set twice.');
					}
					++levelID$count;
					this.levelID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgUnlockLevelGroupRequest.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
