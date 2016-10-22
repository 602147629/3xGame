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
	public dynamic final class CMsgGetActivityInfoResponse extends com.netease.protobuf.Message {
		public static const ACTIVITYTYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetActivityInfoResponse.activityType", "activityType", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var activityType$field:int;

		private var hasField$0:uint = 0;

		public function clearActivityType():void {
			hasField$0 &= 0xfffffffe;
			activityType$field = new int();
		}

		public function get hasActivityType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set activityType(value:int):void {
			hasField$0 |= 0x1;
			activityType$field = value;
		}

		public function get activityType():int {
			return activityType$field;
		}

		public static const DAYENERGYGETCOUNT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetActivityInfoResponse.dayEnergyGetCount", "dayEnergyGetCount", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var dayEnergyGetCount$field:int;

		public function clearDayEnergyGetCount():void {
			hasField$0 &= 0xfffffffd;
			dayEnergyGetCount$field = new int();
		}

		public function get hasDayEnergyGetCount():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set dayEnergyGetCount(value:int):void {
			hasField$0 |= 0x2;
			dayEnergyGetCount$field = value;
		}

		public function get dayEnergyGetCount():int {
			return dayEnergyGetCount$field;
		}

		public static const RESULT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetActivityInfoResponse.result", "result", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var result$field:int;

		public function clearResult():void {
			hasField$0 &= 0xfffffffb;
			result$field = new int();
		}

		public function get hasResult():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set result(value:int):void {
			hasField$0 |= 0x4;
			result$field = value;
		}

		public function get result():int {
			return result$field;
		}

		public static const STARTTIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetActivityInfoResponse.startTime", "startTime", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var startTime$field:int;

		public function clearStartTime():void {
			hasField$0 &= 0xfffffff7;
			startTime$field = new int();
		}

		public function get hasStartTime():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set startTime(value:int):void {
			hasField$0 |= 0x8;
			startTime$field = value;
		}

		public function get startTime():int {
			return startTime$field;
		}

		public static const ENDTIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetActivityInfoResponse.endTime", "endTime", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var endTime$field:int;

		public function clearEndTime():void {
			hasField$0 &= 0xffffffef;
			endTime$field = new int();
		}

		public function get hasEndTime():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set endTime(value:int):void {
			hasField$0 |= 0x10;
			endTime$field = value;
		}

		public function get endTime():int {
			return endTime$field;
		}

		public static const CURTIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgGetActivityInfoResponse.curTime", "curTime", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var curTime$field:int;

		public function clearCurTime():void {
			hasField$0 &= 0xffffffdf;
			curTime$field = new int();
		}

		public function get hasCurTime():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set curTime(value:int):void {
			hasField$0 |= 0x20;
			curTime$field = value;
		}

		public function get curTime():int {
			return curTime$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasActivityType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, activityType$field);
			}
			if (hasDayEnergyGetCount) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, dayEnergyGetCount$field);
			}
			if (hasResult) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, result$field);
			}
			if (hasStartTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, startTime$field);
			}
			if (hasEndTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, endTime$field);
			}
			if (hasCurTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, curTime$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var activityType$count:uint = 0;
			var dayEnergyGetCount$count:uint = 0;
			var result$count:uint = 0;
			var startTime$count:uint = 0;
			var endTime$count:uint = 0;
			var curTime$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (activityType$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetActivityInfoResponse.activityType cannot be set twice.');
					}
					++activityType$count;
					this.activityType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (dayEnergyGetCount$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetActivityInfoResponse.dayEnergyGetCount cannot be set twice.');
					}
					++dayEnergyGetCount$count;
					this.dayEnergyGetCount = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetActivityInfoResponse.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (startTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetActivityInfoResponse.startTime cannot be set twice.');
					}
					++startTime$count;
					this.startTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (endTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetActivityInfoResponse.endTime cannot be set twice.');
					}
					++endTime$count;
					this.endTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (curTime$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgGetActivityInfoResponse.curTime cannot be set twice.');
					}
					++curTime$count;
					this.curTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
