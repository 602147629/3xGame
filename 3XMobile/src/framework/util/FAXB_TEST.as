
package framework.util
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * Example<br>
	 *     
	 * package com.playfish.game.empire.bean<br>
	 * {<br>
	 *     [XmlType(name="BuildingLevel", propOrder="startCondition,benefice")]<br>
	 *     public class BuildingLevel<br>
	 *     {<br>
	 *         [XmlElement(name="StartCondition", sequence="1", required="true")]<br>
	 *         public var startCondition:Vector.&lt;StartCondition&gt;;<br>
	 * 
	 *         [XmlElement(name="Benefice", sequence="2", required="true")]<br>
	 *         public var benefice:Benefice;<br>
	 * 
	 *         [XmlAttribute(name="id", sequence="3", required="true")]<br>
	 *         public var id:int;<br>
	 * 
	 *         [XmlAttribute(name="happiness", sequence="4", required="true")]<br>
	 *         public var happiness:int;<br>
	 *     }<br>
	 * }<br>
	 * attribute 的 sequence 在 element 之后
	 */ 
	public class FAXB_TEST
	{
		public static function marshal(object:*, xmlName:String = null):XML
		{
			if (object == null)
			{
				throw new Error("object is null.");
				return null;
			}

			var qualifiedName:String = getQualifiedClassName(object);
			var classType:ClassType = getClassType(qualifiedName);

			if (xmlName == null)
			{
				xmlName = classType.xmlName;
			}
			var xml:XML = <{xmlName}/>;

			var length:int = classType.variables.length;
			var variableType:VariableType;

			var j:int;
			for (var i:int = 0; i < length; i++)
			{
				variableType = classType.variables[i];
				if (classType.propOrder.indexOf(variableType.name) == -1)
				{
					if (variableType.isVector)
					{
						for (j = 0; j < object[variableType.name].length; j++)
						{
							xml.appendChild(<{variableType.xmlName}>{object[variableType.name][j]}</{variableType.xmlName}>);
						}
					}
					else
					{
						switch (variableType.xmlType)
						{
							case XML_ElEMENT:
								xml.appendChild(<{variableType.xmlName}>{object[variableType.name]}</{variableType.xmlName}>);
								break;

							case XML_ATTRIBUTE:
								xml.@[variableType.xmlName] = object[variableType.name];
								break;
						}
					}
				}
				else
				{
					if (variableType.isVector)
					{
						for (j = 0; j < object[variableType.name].length; j++)
						{
							xml.appendChild(marshal(object[variableType.name][j], variableType.xmlName));
						}
					}
					else
					{
						xml.appendChild(marshal(object[variableType.name], variableType.xmlName));
					}
				}
			}

			return xml;
		}

		public static function unmarshal(xmlNode:XML, qualifiedName:String):*
		{
			if (xmlNode == null)
			{
				return null;
			}
			
			var classType:ClassType = getClassType(qualifiedName);
			var classRef:Class = getDefinitionByName(qualifiedName) as Class;
			var classInstance:* = new classRef();

			var length:int = classType.variables.length;
			var variableType:VariableType;
			var variableClassRef:Class;
			var j:int;
			var xmlList:XMLList;
			for (var i:int = 0; i < length; i++)
			{
				variableType = classType.variables[i];
				if (classType.propOrder.indexOf(variableType.name) == -1)
				{
					if (variableType.isVector)
					{
						variableClassRef = getDefinitionByName(variableType.vectorType) as Class;
						classInstance[variableType.name] = new variableClassRef();
						xmlList = xmlNode.elements(variableType.xmlName);
						for (j = 0; j < xmlList.length(); j++)
						{
							classInstance[variableType.name].push(getValue(variableType.type, xmlList[j].text()[0]));
						}
					}
					else
					{
						switch (variableType.xmlType)
						{
							case XML_ElEMENT:
								classInstance[variableType.name] = getValue(variableType.type, xmlNode.elements(variableType.xmlName)[0].text()[0]);
								break;

							case XML_ATTRIBUTE:
								classInstance[variableType.name] = getValue(variableType.type, xmlNode.attribute(variableType.xmlName));
								break;
						}
					}
				}
				else
				{
					if (variableType.isVector)
					{
						variableClassRef = getDefinitionByName(variableType.vectorType) as Class;
						classInstance[variableType.name] = new variableClassRef();
						xmlList = xmlNode.elements(variableType.xmlName);
						for (j = 0; j < xmlList.length(); j++)
						{
							classInstance[variableType.name].push(unmarshal(xmlList[j], variableType.type));
						}
					}
					else
					{
						classInstance[variableType.name] = unmarshal(xmlNode.elements(variableType.xmlName)[0], variableType.type);
					}
				}
			}

			return classInstance;
		}

		private static function getValue(type:String, value:String):*
		{
			switch (type)
			{
				case "String":
					return String(value);

				case "int":
					return int(value);

				case "Number":
					return Number(value);

				case "Boolean":
					if (value == "true" || value == "1")
					{
						return true;
					}
					if (value == "false" || value == "0")
					{
						return false;
					}
					throw new Error("illegal boolean value");
					return false;

				case "*":
					throw new Error("unknow type");
					return String(value);
			}
		}

		public static function genSchema(qualifiedName:String, rootName:String = null):XML
		{
			var xml:XML = <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"/>;

			var rootClassType:ClassType = getClassType(qualifiedName);
			if (rootName == null)
			{
				rootName = rootClassType.xmlName;
			}
			xml.appendChild(<xs:element name={rootName} type={rootClassType.xmlName} xmlns:xs="http://www.w3.org/2001/XMLSchema"/>);

			xsdNodeCache = new Dictionary();
			genComplexType(qualifiedName);

			for each (var item:XML in xsdNodeCache)
			{
				xml.appendChild(item);
			}

			return xml;
		}

		private static var xsdNodeCache:Dictionary;

		private static function genComplexType(qualifiedName:String):void
		{
			if (xsdNodeCache[qualifiedName])
			{
				return;
			}

			var hasElement:Boolean = false;
			var classType:ClassType = getClassType(qualifiedName);
			var xml:XML = <xs:complexType name={classType.xmlName} xmlns:xs="http://www.w3.org/2001/XMLSchema"/>;

			var length:int = classType.variables.length;
			var variableType:VariableType;
			var xmlType:String;
			var xs:Namespace = xml.namespace();
			for (var i:int = 0; i < length; i++)
			{
				variableType = classType.variables[i];

				if (variableType.xmlType == XML_ElEMENT)
				{
					if (!hasElement)
					{
						xml.appendChild(<xs:sequence xmlns:xs="http://www.w3.org/2001/XMLSchema"/>);
						hasElement = true;
					}

					if (classType.propOrder.indexOf(variableType.name) == -1)
					{
						xmlType = getXSDType(variableType.type);
					}
					else
					{
						xmlType = getClassType(variableType.type).xmlName;
						genComplexType(variableType.type);
					}

					if (variableType.isVector)
					{
						if (variableType.required)
						{
							xml.xs::sequence[0].appendChild(<xs:element name={variableType.xmlName} type={xmlType} maxOccurs="unbounded" xmlns:xs="http://www.w3.org/2001/XMLSchema"/>);
						}
						else
						{
							xml.xs::sequence[0].appendChild(<xs:element name={variableType.xmlName} type={xmlType} minOccurs="0" maxOccurs="unbounded" xmlns:xs="http://www.w3.org/2001/XMLSchema"/>);
						}
					}
					else
					{
						if (variableType.required)
						{
							xml.xs::sequence[0].appendChild(<xs:element name={variableType.xmlName} type={xmlType} xmlns:xs="http://www.w3.org/2001/XMLSchema"/>);
						}
						else
						{
							xml.xs::sequence[0].appendChild(<xs:element name={variableType.xmlName} type={xmlType} minOccurs="0" xmlns:xs="http://www.w3.org/2001/XMLSchema"/>);
						}
					}
				}
				else
				{
					if (variableType.required)
					{
						xml.appendChild(<xs:attribute name={variableType.xmlName} type={getXSDType(variableType.type)} use="required" xmlns:xs="http://www.w3.org/2001/XMLSchema"/>);
					}
					else
					{
						xml.appendChild(<xs:attribute name={variableType.xmlName} type={getXSDType(variableType.type)} xmlns:xs="http://www.w3.org/2001/XMLSchema"/>);
					}
				}
			}
			xsdNodeCache[qualifiedName] = xml;
		}

		private static function getXSDType(type:String):String
		{
			switch (type)
			{
				case "String":
					return "xs:string";

				case "int":
					return "xs:int";

				case "Number":
					return "xs:double";

				case "Boolean":
					return "xs:boolean";

				case "*":
					throw new Error("unknow type");
					return "xs:string";

				default:
					return type;
			}
		}

		public static function genBean(xsd:XML, rootName:String, packageName:String):Dictionary
		{
			xsdTypeCache = new Dictionary();
			simpleTypeMap = new Dictionary();
			complexTypeMap = new Dictionary();
			refTypeMap = new Dictionary();

			packagePrefix = packageName;

			var rootNode:XML;
			var xs:Namespace = xsd.namespace();
			var elements:XMLList = xsd.elements();
			var length:int = elements.length();
			for (var i:int = 0; i < length; i++)
			{
				var name:String = String(elements[i].@name);
				if (name != "")
				{
					switch (String(elements[i].localName()))
					{
						case "complexType":
						case "element":
							complexTypeMap[name] = elements[i];
							break;

						case "simpleType":
							simpleTypeMap[name] = String(elements[i].xs::restriction[0].@base);
							break;

						case "group":
						case "attributeGroup":
							refTypeMap[name] = elements[i];
							break;
					}
					if (name == rootName)
					{
						rootNode = elements[i];
					}
				}
			}

			if (!rootNode)
			{
				return null;
			}

			parseXsd(rootNode);

			var classes:Dictionary = new Dictionary();
			for (var itemName:String in xsdTypeCache)
			{
				classes[toUpperName(itemName)] = xsdType2String(xsdTypeCache[itemName], itemName);
			}

			return classes;
		}

		private static var xsdTypeCache:Dictionary;
		private static var simpleTypeMap:Dictionary;
		private static var complexTypeMap:Dictionary;
		private static var refTypeMap:Dictionary;

		private static function parseXsd(xmlNode:XML, add2cache:Boolean = true):XsdType
		{
			var name:String = String(xmlNode.@name);
			var xs:Namespace = xmlNode.namespace();
			var xsdType:XsdType = new XsdType();
			xsdType.nodeType = (xmlNode.localName() == "attribute") ? XML_ATTRIBUTE : XML_ElEMENT;

			if (xsdType.nodeType == XML_ATTRIBUTE)
			{
				xsdType.minOccurs = (String(xmlNode.@["use"]) == "required") ? 1 : 0;
			}
			if (String(xmlNode.@minOccurs) != "")
			{
				xsdType.minOccurs = int(xmlNode.@minOccurs);
			}
			if (String(xmlNode.@maxOccurs) != "")
			{
				if (String(xmlNode.@maxOccurs) == "unbounded")
				{
					xsdType.maxOccurs = int.MAX_VALUE;
				}
				else
				{
					xsdType.maxOccurs = int(xmlNode.@maxOccurs);
				}
			}

			xsdType.children = new Vector.<XsdType>();

			var children:Array = getChildren(xmlNode);
			var length:int = children.length;
			for (var i:int = 0; i < length; i++)
			{
				xsdType.children.push(parseXsd(children[i]));
			}

			var type:String = String(xmlNode.@type);
			if (type != "" && complexTypeMap[type] && String(complexTypeMap[type].@name) != "")
			{
				xsdType.children = xsdType.children.concat(parseXsd(complexTypeMap[type], false).children);
			}

			if (xmlNode.xs::annotation.length() > 0 && xmlNode.xs::annotation[0].xs::documentation.length() > 0)
			{
				xsdType.documentation = String(xmlNode.xs::annotation[0].xs::documentation[0].text()[0]);
			}

			if (type != "")
			{
				xsdType.type = type;
			}
			if (name != "")
			{
				xsdType.name = name;
				if (typeMap[xsdType.type] == null && simpleTypeMap[xsdType.type] == null && add2cache)
				{
					if (xsdType.type == "" || xsdType.type == null)
					{
						xsdTypeCache[name] = xsdType;
					}
					else if (!xsdTypeCache[xsdType.type])
					{
						xsdTypeCache[xsdType.type] = xsdType;
					}
				}
			}

			return xsdType;
		}

		private static function getChildren(xmlNode:XML):Array
		{
			var children:Array = [];
			var elements:XMLList = xmlNode.elements();
			var length:int = elements.length();

			for (var i:int = 0; i < length; i++)
			{
				var child:XML = elements[i];
				if (String(child.@name) != "")
				{
					children.push(child);
				}
				else if (String(child.@ref) != "")
				{
					if(refTypeMap[String(child.@ref)])
					{
						children = children.concat(getChildren(refTypeMap[String(child.@ref)]));
					}
					else
					{
						child.@type = String(child.@ref);
						child.@name = String(child.@ref);
						children.push(child);
					}
				}
				else if (NODE_NAME_INDICATOR.indexOf(String(child.localName())) != -1)
				{
					children = children.concat(getChildren(child));

					if (String(child.localName()) == "extension")
					{
						if (String(child.@base) != "" && complexTypeMap[String(child.@base)])
						{
							children = children.concat(getChildren(complexTypeMap[String(child.@base)]));
						}
					}
				}
			}
			return children;
		}

		private static function xsdType2String(xsdType:XsdType, className:String):String
		{
			var sequence:int = 0;
			var asPackage:String = 'package ' + packagePrefix + '\n{\n';
			var asClass:String = '    public class ' + toUpperName(className)
			asClass += '\n    {\n'

			var orderProp:Array = [];
			var length:int = xsdType.children.length;
			var child:XsdType;
			for (var i:int = 0; i < length; i++)
			{
				sequence++;
				child = xsdType.children[i];

				if (child.documentation)
				{
					asClass += '        //' + child.documentation + "\n";
				}

				var required:Boolean = false;
				var xmlType:String = (child.nodeType == XML_ElEMENT) ? "XmlElement" : "XmlAttribute";
				if (child.minOccurs == 0)
				{
					asClass += '        [' + xmlType + '(name="' + child.name + '", sequence="' + sequence + '")]\n';
				}
				else
				{
					asClass += '        [' + xmlType + '(name="' + child.name + '", sequence="' + sequence + '", required="true")]\n';
				}

				var propName:String = (child.nodeType == XML_ElEMENT) ? toLowerName(child.name) : child.name;
				var typeName:String;
				if (child.type && typeMap[child.type])
				{
					typeName = typeMap[child.type];
				}
				else if (simpleTypeMap[child.type])
				{
					typeName = getSimpleType(child.type);
				}
				else if (child.type && child.type != "")
				{
					typeName = toUpperName(child.type);
					orderProp.push(propName);
				}
				else
				{
					typeName = toUpperName(child.name);
					orderProp.push(propName);
				}

				if (child.maxOccurs > 1)
				{
					typeName = 'Vector.<' + typeName + '>';
				}

				asClass += '        public var ' + propName + ':' + typeName + ';\n\n';
			}

			asClass = asClass.substring(0, asClass.length - 1);
			asClass += '    }\n'

			var classType:String;
			if (xsdType.type == "" || xsdType.type == null)
			{
				classType = '    [XmlType(name="' + xsdType.name + '", propOrder="';
			}
			else
			{
				classType = '    [XmlType(name="' + xsdType.type + '", propOrder="';
			}
			for each (var item:String in orderProp)
			{
				classType += item + ',';
			}
			if (orderProp.length > 0)
			{
				classType = classType.substring(0, classType.length - 1);
			}
			classType += '")]\n'

			asClass = classType + asClass

			if (xsdType.documentation)
			{
				asClass = '    //' + xsdType.documentation + "\n" + asClass
			}

			asPackage += asClass;
			asPackage += '}';

			return asPackage;
		}

		private static function getSimpleType(type:String):String
		{
			if (typeMap[type])
			{
				return typeMap[type];
			}
			else if (simpleTypeMap[type])
			{
				return getSimpleType(simpleTypeMap[type]);
			}
			else
			{
				return typeMap['xs:anySimpleType'];
			}
		}

		private static function toLowerName(name:String):String
		{
			return name.substring(0, 1).toLowerCase() + name.substring(1);
		}

		private static function toUpperName(name:String):String
		{
			return name.substring(0, 1).toUpperCase() + name.substring(1);
		}

		public static function registerClassHeritageAlias(qualifiedName:String):Array
		{
			registerClassAlias("String", String);
			registerClassAlias("Number", Number);
			registerClassAlias("int", int);
			registerClassAlias("uint", uint);
			registerClassAlias("Boolean", Boolean);

			registerClassTypeAlias(qualifiedName);

			return registeredClass;
		}

		private static function registerClassTypeAlias(qualifiedName:String):void
		{
			if (registeredClass.indexOf(qualifiedName) != -1)
			{
				return;
			}

			var classRef:Class = getDefinitionByName(qualifiedName) as Class;
			registerClassAlias(qualifiedName, classRef);
			registeredClass.push(qualifiedName);

			var classType:ClassType = getClassType(qualifiedName);
			var variableType:VariableType;
			var length:int = classType.variables.length;
			for (var i:int = 0; i < length; i++)
			{
				variableType = classType.variables[i];
				if (classType.propOrder.indexOf(variableType.name) != -1)
				{
					registerClassTypeAlias(variableType.type);
				}
			}
		}

		public static function registerClassesAlias(classes:Array):void
		{
			var length:int = classes.length;
			for (var i:int = 0; i < length; i++)
			{
				registerClassAlias(classes[i], getDefinitionByName(classes[i]) as Class);
			}
		}

		//TO-DO updateXML(xmlNode,flashBean)
		//TO-DO updateBean(xmlNode,flashBean)		

		private static function getClassType(qualifiedName:String):ClassType
		{
			if (classTypeCache[qualifiedName])
			{
				return classTypeCache[qualifiedName];
			}

			var classRef:Class = getDefinitionByName(qualifiedName) as Class;
			var time1:Number = getTimer();
			var classXML:XML = describeType(classRef).factory[0];
			var classType:ClassType = new ClassType();
			classType.xmlName = String(classXML.metadata.(@name == "XmlType")[0].arg.(@key == "name").@value);
			classType.propOrder = String(classXML.metadata.(@name == "XmlType")[0].arg.(@key == "propOrder").@value).split(",");
			classType.variables = new Vector.<VariableType>();

			var length:int = classXML.variable.length();
			var variableType:VariableType;
			for (var i:int = 0; i < length; i++)
			{
				variableType = new VariableType();
				variableType.xmlType = -1;

				if (classXML.variable[i].metadata.(@name == "XmlElement").length() > 0)
				{
					variableType.xmlName = String(classXML.variable[i].metadata.(@name == "XmlElement")[0].arg.(@key == "name").@value);
					variableType.sequence = int(classXML.variable[i].metadata.(@name == "XmlElement")[0].arg.(@key == "sequence").@value);
					variableType.required = classXML.variable[i].metadata.(@name == "XmlElement")[0].arg.(@key == "required").@value == "true";
					variableType.xmlType = XML_ElEMENT;
				}
				if (classXML.variable[i].metadata.(@name == "XmlAttribute").length() > 0)
				{
					variableType.xmlName = String(classXML.variable[i].metadata.(@name == "XmlAttribute")[0].arg.(@key == "name").@value);
					variableType.sequence = int(classXML.variable[i].metadata.(@name == "XmlAttribute")[0].arg.(@key == "sequence").@value);
					variableType.required = classXML.variable[i].metadata.(@name == "XmlAttribute")[0].arg.(@key == "required").@value == "true";
					variableType.xmlType = XML_ATTRIBUTE;
				}

				variableType.name = String(classXML.variable[i].@name);
				variableType.type = String(classXML.variable[i].@type);
				if (variableType.type.indexOf(VECTOR_TYPE) != -1)
				{
					variableType.isVector = true;
					variableType.vectorType = variableType.type;
					variableType.type = variableType.type.substring(variableType.type.indexOf("<") + 1, variableType.type.indexOf(">"));
				}

				if(variableType.xmlType != -1)
				{
					classType.variables.push(variableType);
				}
			}

			classType.variables.sort(compareSequence);
			
			if (classTypeCache[qualifiedName] == null)
			{				
				classTypeCache[qualifiedName] = classType;
			}
			return classType;
		}

		private static function compareSequence(variableType0:VariableType, variableType1:VariableType):int
		{
			if (variableType0.sequence > variableType1.sequence)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}

		private static var classTypeCache:Dictionary = new Dictionary();
		private static var registeredClass:Array = ["String", "Number", "int", "uint", "Boolean"];
		private static var typeMap:Dictionary = new Dictionary();
		private static var packagePrefix:String;

		private static const XML_ElEMENT:int = 0;
		private static const XML_ATTRIBUTE:int = 1;
		private static const VECTOR_TYPE:String = "__AS3__.vec::Vector";
		private static const SIMPLE_TYPE:Array = ["String", "int", "Number", "Boolean", "*"];
		private static const NODE_NAME_INDICATOR:Array = ["complexType", "complexContent", "simpleContent", "sequence", "choice", "all", "extension"];

		//string
		typeMap['xs:ENTITIES'] = 'String'
		typeMap['xs:ENTITY'] = 'String'
		typeMap['xs:ID'] = 'String'
		typeMap['xs:IDREF'] = 'String'
		typeMap['xs:IDREFS'] = 'String'
		typeMap['xs:Name'] = 'String'
		typeMap['xs:NCName'] = 'String'
		typeMap['xs:NMTOKEN'] = 'String'
		typeMap['xs:NMTOKENS'] = 'String'
		typeMap['xs:normalizedString'] = 'String'
		typeMap['xs:QName'] = 'String'
		typeMap['xs:string'] = 'String'
		typeMap['xs:token'] = 'String'

		//time
		typeMap['xs:date'] = 'String' //YYYY-MM-DD
		typeMap['xs:dateTime'] = 'String' //YYYY-MM-DDThh:mm:ss
		typeMap['xs:duration'] = 'String' //PnYnMnDTnHnMnS
		typeMap['xs:gDay'] = 'String'
		typeMap['xs:gMonth'] = 'String'
		typeMap['xs:gMonthDay'] = 'String'
		typeMap['xs:gYear'] = 'String'
		typeMap['xs:gYearMonth'] = 'String'
		typeMap['xs:time'] = 'String' //hh:mm:ss

		//Numeric
		typeMap['xs:byte'] = 'int'
		typeMap['xs:decimal'] = 'Number'
		typeMap['xs:int'] = 'int'
		typeMap['xs:integer'] = 'int'
		typeMap['xs:long'] = 'Number'
		typeMap['xs:negativeInteger'] = 'int'
		typeMap['xs:nonNegativeInteger'] = 'int'
		typeMap['xs:nonPositiveInteger'] = 'int'
		typeMap['xs:positiveInteger'] = 'int'
		typeMap['xs:short'] = 'int'
		typeMap['xs:unsignedLong'] = 'Number'
		typeMap['xs:unsignedInt'] = 'int'
		typeMap['xs:unsignedShort'] = 'int'
		typeMap['xs:unsignedByte'] = 'int'

		//other   
		typeMap['xs:boolean'] = 'Boolean' //true,false,1,0

		typeMap['xs:base64Binary'] = 'String'
		typeMap['xs:hexBinary'] = 'String'

		typeMap['xs:anyURI'] = 'String'

		typeMap['xs:double'] = 'Number'
		typeMap['xs:float'] = 'Number'

		typeMap['xs:NOTATION'] = 'String'
		typeMap['xs:QName'] = 'String'

		typeMap['xs:anySimpleType'] = '*'
	}
}

class ClassType
{
	public var xmlName:String;
	public var propOrder:Array;

	public var variables:Vector.<VariableType>;
}

class VariableType
{
	public var xmlName:String;
	public var xmlType:int;

	public var name:String;
	public var type:String;
	public var sequence:int;
	public var required:Boolean = false;
	public var isVector:Boolean = false;
	public var vectorType:String;
}

class XsdType
{
	public var name:String;
	public var type:String;
	public var minOccurs:int = 1;
	public var maxOccurs:int = 1;
	public var documentation:String;
	public var nodeType:int;
	public var children:Vector.<XsdType>;
}