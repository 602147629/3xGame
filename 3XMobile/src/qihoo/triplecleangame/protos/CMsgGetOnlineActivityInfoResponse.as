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
	public dynamic final class CMsgGetOnlineActivityInfoResponse extends com.netease.protobuf.Message {
		public static const STARTTIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetOnlineActivityInfoResponse.startTime", "startTime", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var startTime$field:int;

		private var hasField$0:uint = 0;

		public function clearStartTime():void {
			hasField$0 &= 0xfffffffe;
			startTime$field = new int();
		}

		public function get hasStartTime():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set startTime(value:int):void {
			hasField$0 |= 0x1;
			startTime$field = value;
		}

		public function get startTime():int {
			return startTime$field;
		}

		public static const ENDTIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetOnlineActivityInfoResponse.endTime", "endTime", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var endTime$field:int;

		public function clearEndTime():void {
			hasField$0 &= 0xfffffffd;
			endTime$field = new int();
		}

		public function get hasEndTime():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set endTime(value:int):void {
			hasField$0 |= 0x2;
			endTime$field = value;
		}

		public function get endTime():int {
			return endTime$field;
		}

		public static const TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetOnlineActivityInfoResponse.type", "type", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var type$field:int;

		public function clearType():void {
			hasField$0 &= 0xfffffffb;
			type$field = new int();
		}

		public function get hasType():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set type(value:int):void {
			hasField$0 |= 0x4;
			type$field = value;
		}

		public function get type():int {
			return type$field;
		}

		public static const ONLINETIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetOnlineActivityInfoResponse.onlineTime", "onlineTime", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var onlineTime$field:int;

		public function clearOnlineTime():void {
			hasField$0 &= 0xfffffff7;
			onlineTime$field = new int();
		}

		public function get hasOnlineTime():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set onlineTime(value:int):void {
			hasField$0 |= 0x8;
			onlineTime$field = value;
		}

		public function get onlineTime():int {
			return onlineTime$field;
		}

		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetOnlineActivityInfoResponse.level", "level", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var level$field:int;

		public function clearLevel():void {
			hasField$0 &= 0xffffffef;
			level$field = new int();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set level(value:int):void {
			hasField$0 |= 0x10;
			level$field = value;
		}

		public function get level():int {
			return level$field;
		}

		public static const DAYCOUNT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetOnlineActivityInfoResponse.dayCount", "dayCount", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var dayCount$field:int;

		public function clearDayCount():void {
			hasField$0 &= 0xffffffdf;
			dayCount$field = new int();
		}

		public function get hasDayCount():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set dayCount(value:int):void {
			hasField$0 |= 0x20;
			dayCount$field = value;
		}

		public function get dayCount():int {
			return dayCount$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasStartTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, startTime$field);
			}
			if (hasEndTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, endTime$field);
			}
			if (hasType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, type$field);
			}
			if (hasOnlineTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, onlineTime$field);
			}
			if (hasLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, level$field);
			}
			if (hasDayCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, dayCount$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var startTime$count:uint = 0;
			var endTime$count:uint = 0;
			var type$count:uint = 0;
			var onlineTime$count:uint = 0;
			var level$count:uint = 0;
			var dayCount$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (startTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetOnlineActivityInfoResponse.startTime cannot be set twice.');
					}
					++startTime$count;
					this.startTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (endTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetOnlineActivityInfoResponse.endTime cannot be set twice.');
					}
					++endTime$count;
					this.endTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetOnlineActivityInfoResponse.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (onlineTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetOnlineActivityInfoResponse.onlineTime cannot be set twice.');
					}
					++onlineTime$count;
					this.onlineTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetOnlineActivityInfoResponse.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (dayCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetOnlineActivityInfoResponse.dayCount cannot be set twice.');
					}
					++dayCount$count;
					this.dayCount = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
