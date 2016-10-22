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
	public dynamic final class CMsgDebugRequest extends com.netease.protobuf.Message {
		public static const OPCODE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgDebugRequest.opcode", "opcode", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var opcode$field:int;

		private var hasField$0:uint = 0;

		public function clearOpcode():void {
			hasField$0 &= 0xfffffffe;
			opcode$field = new int();
		}

		public function get hasOpcode():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set opcode(value:int):void {
			hasField$0 |= 0x1;
			opcode$field = value;
		}

		public function get opcode():int {
			return opcode$field;
		}

		public static const PARAM1:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgDebugRequest.param1", "param1", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var param1$field:int;

		public function clearParam1():void {
			hasField$0 &= 0xfffffffd;
			param1$field = new int();
		}

		public function get hasParam1():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set param1(value:int):void {
			hasField$0 |= 0x2;
			param1$field = value;
		}

		public function get param1():int {
			return param1$field;
		}

		public static const PARAM2:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgDebugRequest.param2", "param2", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var param2$field:int;

		public function clearParam2():void {
			hasField$0 &= 0xfffffffb;
			param2$field = new int();
		}

		public function get hasParam2():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set param2(value:int):void {
			hasField$0 |= 0x4;
			param2$field = value;
		}

		public function get param2():int {
			return param2$field;
		}

		public static const PARAM3:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgDebugRequest.param3", "param3", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var param3$field:int;

		public function clearParam3():void {
			hasField$0 &= 0xfffffff7;
			param3$field = new int();
		}

		public function get hasParam3():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set param3(value:int):void {
			hasField$0 |= 0x8;
			param3$field = value;
		}

		public function get param3():int {
			return param3$field;
		}

		public static const PARAM4:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgDebugRequest.param4", "param4", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var param4$field:int;

		public function clearParam4():void {
			hasField$0 &= 0xffffffef;
			param4$field = new int();
		}

		public function get hasParam4():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set param4(value:int):void {
			hasField$0 |= 0x10;
			param4$field = value;
		}

		public function get param4():int {
			return param4$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasOpcode) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, opcode$field);
			}
			if (hasParam1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, param1$field);
			}
			if (hasParam2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, param2$field);
			}
			if (hasParam3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, param3$field);
			}
			if (hasParam4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, param4$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var opcode$count:uint = 0;
			var param1$count:uint = 0;
			var param2$count:uint = 0;
			var param3$count:uint = 0;
			var param4$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (opcode$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgDebugRequest.opcode cannot be set twice.');
					}
					++opcode$count;
					this.opcode = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (param1$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgDebugRequest.param1 cannot be set twice.');
					}
					++param1$count;
					this.param1 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (param2$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgDebugRequest.param2 cannot be set twice.');
					}
					++param2$count;
					this.param2 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (param3$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgDebugRequest.param3 cannot be set twice.');
					}
					++param3$count;
					this.param3 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (param4$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgDebugRequest.param4 cannot be set twice.');
					}
					++param4$count;
					this.param4 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
