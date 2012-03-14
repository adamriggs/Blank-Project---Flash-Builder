﻿package away3d.loaders{    import away3d.arcane;    import away3d.containers.*;    import away3d.core.base.*;	import away3d.core.geom.*;	import away3d.core.math.*;	import away3d.core.utils.*;	import away3d.graphs.bsp.*;	import away3d.loaders.utils.*;	import away3d.materials.*;		//custom	import away3d.loaders.utils.CentralMaterialLibrary;	use namespace arcane;	    /**    * File loader/parser for the native .awd data file format.<br/>    */	    public class AWData extends AbstractParser    {		private var objs:Array = [];		private var geos:Array = [];		private var nodes:Array = [];		private var nodeObjs:Array = [];		private var oList:Array =[];		private var aC:Array = [];		private var resolvedP:String = "";		private var _materials : Array = [];		public static var url:String = "";		public static var customPath:String = "";		 		/** @private */		arcane override function prepareData(data:*):void        {        	var awdData:String = Cast.string(data);			var lines:Array = awdData.split('\n');			if(lines.length == 1) lines = awdData.split(String.fromCharCode(13));			var trunk:Array;			var state:String = "";			var isMesh:Boolean;			var isBSP:Boolean;			var isMaterial:Boolean;			var id:int = 0;			var buffer:int=0;			var oData:Object;			var dline:Array;			var m:MatrixAway3D;			var cont:ObjectContainer3D;			var i:uint;			var version:String = "";			var tree : BSPTree;						if(customPath != ""){				resolvedP = customPath;			} else if(url != ""){				var pathArray:Array = url.split("/");				pathArray.pop();				resolvedP = (pathArray.length>0)?pathArray.join("/")+"/":pathArray.join("/");				trace(resolvedP);			}			            for each (var line:String in lines)            {				if(line.substring(0,1) == "#" && state != line.substring(0,2)){					state = line.substring(0,2);					id = 0;					buffer = 0;					if(state == "#v")						version = line.substring(3,line.length-1);					if(state == "#f")						isMaterial = (parseInt(line.substring(3,4)) == 2) as Boolean;					if(state == "#t") {						isMesh = (line.substring(3,7) == "mesh");						isBSP = (line.substring(3,6) == "bsp");						if (isBSP)							tree = new BSPTree();					}					continue;				}				dline = line.split(",");				if(dline.length <= 1 && !(state == "#m" || state == "#d"))					continue;				if(state == "#o"){					if(buffer == 0){						id = dline[0];						m = new MatrixAway3D();						m.sxx = parseFloat(dline[1]);						m.sxy = parseFloat(dline[2]);						m.sxz = parseFloat(dline[3]);						m.tx = parseFloat(dline[4]);						m.syx = parseFloat(dline[5]);						m.syy = parseFloat(dline[6]);						m.syz = parseFloat(dline[7]);						m.ty = parseFloat(dline[8]);						m.szx = parseFloat(dline[9]);						m.szy = parseFloat(dline[10]);						m.szz = parseFloat(dline[11]);						m.tz = parseFloat(dline[12]);						++buffer;					} else {						if(customPath != "")							var standardURL:Array = dline[12].split("/");							 						oData = {name:(dline[0] == "")? "m_"+id: dline[0] ,									transform:m,									pivotPoint:new Number3D(parseFloat(dline[1]), parseFloat(dline[2]), parseFloat(dline[3])),									container:parseInt(dline[4]),									bothsides:(dline[5] == "true")? true : false,									ownCanvas:(dline[6] == "true")? true : false,									pushfront:(dline[7] == "true")? true : false,									pushback:(dline[8] == "true")? true : false,									x:parseFloat(dline[9]),									y:parseFloat(dline[10]),									z:parseFloat(dline[11]),									material:(isMaterial && dline[12] != null && dline[12] != "")? resolvedP+((customPath != "")? standardURL[standardURL.length-1] : dline[12]) : null};						objs.push(oData);						buffer = 0;					}				}				if(state == "#d"){					switch(buffer){						case 0:							id = geos.length;							geos.push({});							geos[id].aVstr = line.substring(2,line.length);							++buffer;							break;						case 1:							geos[id].aUstr = line.substring(2,line.length);							geos[id].aV= read(geos[id].aVstr).split(",");							geos[id].aU= read(geos[id].aUstr).split(",");							++buffer;							break;						case 2:							geos[id].f= line.substring(2,line.length);							if (objs[id])								objs[id].geo = geos[id];							if (isBSP) ++buffer;							else buffer = 0;							break;						case 3:							// bsp only							geos[id].m = line.substring(2,line.length);							buffer = 0;							break;					}				}				var plane : Plane3D;				var len : int;				var planes : Array;				var vis : Array;				// BSP branch				if (state == "#b") {//					trace (dline);					switch (buffer) {						case 0:							id = parseInt(dline[0]);							//trace ("nId: "+id);							nodes[id] = {};							nodes[id].nodeId = id;							nodes[id].isLeaf = false;							nodes[id].positiveChildId = parseInt(dline[1]);							nodes[id].negativeChildId = parseInt(dline[2]);							plane = new Plane3D();							plane._alignment = parseInt(dline[3]);							plane.a = parseFloat(dline[4]);							plane.b = parseFloat(dline[5]);							plane.c = parseFloat(dline[6]);							plane.d = parseFloat(dline[7]);							nodes[id].partitionPlane = plane;							++buffer;							break;						case 1:							if (dline.length > 3) {								var index : int;								planes = [];								len = dline.length % 4;								for (i = 0; i < len; ++i) {									plane = new Plane3D();									plane.a = parseFloat(dline[index]);									plane.b = parseFloat(dline[index+1]);									plane.c = parseFloat(dline[index+2]);									plane.d = parseFloat(dline[index+3]);									planes.push(plane);									index += 4;								}								nodes[id].bevelPlanes = planes;							}							buffer = 0;							break;					}				}				if (state == "#l") {					switch (buffer) {						case 0:							id = parseInt(dline[0]);							nodes[id] = {};							nodes[id].isLeaf = true;							nodes[id].nodeId = id;							nodes[id].leafId = parseInt(dline[1]);							nodes[id].meshId = parseInt(dline[2]);							++buffer;							break;						case 1:							vis = [];							len = dline.length;							for (i = 0; i < len; ++i)								vis.push(parseInt(dline[i], 16));															nodes[id].visList = vis;							buffer = 0;							break;					}				}				if(state == "#m" && isBSP) {					//line = line.substring(0, line.length-1);					if(customPath != "" && line.indexOf("images/") != -1){						line = line.substring(7, line.length);					}										if(resolvedP != "" && resolvedP.substring(resolvedP.length-1, resolvedP.length) != "/")							resolvedP +="/";										var matBitmap:BitmapFileMaterial = new BitmapFileMaterial(resolvedP+line)					_materials.push(matBitmap);										var splitedUrl:Array = line.split("/");					var filename:String = (splitedUrl[splitedUrl.length-1]);					filename = filename.substring(0, filename.length-4);					CentralMaterialLibrary.addMaterial(matBitmap, null, filename, line);				}				if(state == "#c" && !isMesh){					id = parseInt(dline[0]);					cont = new ObjectContainer3D();					m = new MatrixAway3D();					m.sxx = parseFloat(dline[1]);					m.sxy = parseFloat(dline[2]);					m.sxz = parseFloat(dline[3]);					m.tx = parseFloat(dline[4]);					m.syx = parseFloat(dline[5]);					m.syy = parseFloat(dline[6]);					m.syz = parseFloat(dline[7]);					m.ty = parseFloat(dline[8]);					m.szx = parseFloat(dline[9]);					m.szy = parseFloat(dline[10]);					m.szz = parseFloat(dline[11]);					m.tz = parseFloat(dline[12]);					cont.transform = m;					cont.name = (dline[13] == "null" || dline[13] == undefined)? "cont_"+id: dline[13];					aC.push(cont);					if(aC.length > 1)						aC[0].addChild(cont);				}            }			if (isBSP) {				// build nodes				len = nodes.length;				tree._leaves = new Vector.<BSPNode>();				for (i = 0; i < len; ++i) {					if (!nodes[i]) continue;					if (nodes[i].isLeaf)						nodeObjs[i] = buildBSPLeaf(nodes[i], tree);					else						nodeObjs[i] = buildBSPNode(nodes[i]);				}				linkBSPNodes(tree);			}			// buildMeshes			var ref:Object;			var mesh:Mesh;			for(i = 0;i<objs.length;++i){				ref = objs[i];				if(ref != null){					mesh = new Mesh();					mesh.type = ".awd";					mesh.bothsides = ref.bothsides;					mesh.name = ref.name;					mesh.pushfront = ref.pushfront;					mesh.pushback = ref.pushback;					mesh.ownCanvas = ref.ownCanvas;					if(ref.container != -1 && !isMesh)						aC[ref.container].addChild(mesh);					mesh.transform = ref.transform;					mesh.movePivot(ref.pivotPoint.x, ref.pivotPoint.y, ref.pivotPoint.z);					mesh.material = (ref.material == null)? ref.material : new BitmapFileMaterial(ref.material);										CentralMaterialLibrary.addMaterial(mesh.material, mesh, ref.name, ref.material);					parseFacesToMesh(ref.geo, mesh);				}			}			if (isBSP)				_container = tree;			else				_container = isMesh? mesh : aC[0];			cleanUp();		}		private function parseFacesToMesh(geo : Object, mesh : Mesh) : void		{			var j:int;			var av:Array;			var au:Array;			var v0:Vertex;			var v1:Vertex;			var v2:Vertex;			var u0:UV;			var u1:UV;			var u2:UV;			var aRef:Array;			var mRef:Array;			var m : int;			var mat : Material;			var index : int;			aRef = geo.f.split(",");			if (geo.m) mRef = geo.m.split(",");			for(j = 0;j<aRef.length;j+=6){				av = geo.aV[parseInt(aRef[j], 16)].split("/");				v0 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));				av = geo.aV[parseInt(aRef[j+1],16)].split("/");				v1 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));				av = geo.aV[parseInt(aRef[j+2],16)].split("/");				v2 = new Vertex(parseFloat(av[0]), parseFloat(av[1]), parseFloat(av[2]));				au = geo.aU[parseInt(aRef[j+3],16)].split("/");				u0 = new UV(parseFloat(au[0]), parseFloat(au[1]));				au = geo.aU[parseInt(aRef[j+4],16)].split("/");				u1 = new UV(parseFloat(au[0]), parseFloat(au[1]));				au = geo.aU[parseInt(aRef[j+5],16)].split("/");				u2 = new UV(parseFloat(au[0]), parseFloat(au[1]));				mat = mRef? _materials[parseInt(mRef[m++])] : null;				mesh.addFace( new Face(v0, v1, v2, mat, u0, u1, u2) );			}		}		private function buildBSPLeaf(data : Object, tree : BSPTree) : BSPNode		{			var node : BSPNode = new BSPNode(null);			var i : int;			node._isLeaf = true;			node.leafId = data.leafId;			node.nodeId = data.nodeId;			tree._leaves.push(node);			if (data.visList) {				i = data.visList.length;				node._visList = new Vector.<int>(i, true);				while (--i >= 0) node._visList[i] = data.visList[i];			}			tree._leaves.sort(sortLeaves);			return node;		}		private function sortLeaves(a : BSPNode, b : BSPNode) : int		{			return (a.leafId < b.leafId)? -1 : 1;		}		private function buildBSPNode(data : Object) : BSPNode		{			var node : BSPNode = new BSPNode(null);			var i : int;			node.nodeId = data.nodeId;			node._partitionPlane = data.partitionPlane;			if (data.bevelPlanes) {				i = data.bevelPlanes.length;				node._bevelPlanes = new Vector.<Plane3D>(i, true);				while (--i >= 0)					node._bevelPlanes.push(data.bevelPlanes[i]);			}						return node;		}		private function linkBSPNodes(tree : BSPTree) : void		{			var len : int = nodes.length;			var data : Object;			var pos : BSPNode;			var neg : BSPNode;			var node : BSPNode;			for (var i : int = 0; i < len; ++i) {				if (!nodes[i]) continue;				data = nodes[i];				node = nodeObjs[i];				if (i == 0) {					node.name = "root";					tree._rootNode = node;				}				if (node._isLeaf) {					// link mesh					node._mesh = new Mesh();					node._mesh._preCulled = true;					node._mesh._preSorted = true;					// faster screenZ calc if needed					node._mesh.pushback = true;					parseFacesToMesh(geos[data.meshId], node._mesh);				}				else {					if (data.positiveChildId != -1) {						pos = nodeObjs[data.positiveChildId];						node._positiveNode = pos;						pos._parent = node;						pos.name = node.name + " -> +";					}					if (data.negativeChildId != -1) {						neg = nodeObjs[data.negativeChildId];						node._negativeNode = neg;						neg._parent = node;						neg.name = node.name + " -> -";					}				}			}			tree.init();		}		private function cleanUp():void		{			for(var i:int = 0;i<objs.length;++i){				objs[i] == null;			}			objs = geos = oList = aC = null;		}		private function read(str:String):String		{			var start:int= 0;			var chunk:String;			var end:int= 0;			var dec:String = "";			var charcount:int = str.length;			for(var i:int = 0;i<charcount;++i){				if (str.charCodeAt(i)>=44 && str.charCodeAt(i)<= 48 ){					dec+= str.substring(i, i+1);				}else{					start = i;					chunk = "";					while(str.charCodeAt(i)!=44 && str.charCodeAt(i)!= 45 && str.charCodeAt(i)!= 46 && str.charCodeAt(i)!= 47 && i<=charcount){						i++;					}					chunk = ""+parseInt("0x"+str.substring(start, i), 16 );					dec+= chunk;					i--;				}			}			return dec;		}		 		/**		 * Creates a new <code>AWData</code> object.		 * @see away3d.loaders.AWData#parse()		 * @see away3d.loaders.AWData#load()		 */		public function AWData(init:Object = null)        {				super(init);			url = ini.getString("url", "");			customPath = ini.getString("customPath", "");			binary = false;        }		/**		 * Creates an Object3D from the raw ascii data of an .awd file. The Away3D native.awd data files.		 * Exporters to awd format are available in Away3d exporters package and in PreFab3D export options.		 * 		 * @param	data				The ascii data of a .awd file.		 * @param	init				[optional]	An initialisation object for specifying default instance properties.		 * 		 * @return						An Object3D representation of the .awd file.		 */        public static function parse(data:*, init:Object = null):Object3D        {			if(init== null)				init = {};						if(init.url != null)				AWData.url = init.url;						if(init.customPath != null)				AWData.customPath = init.customPath;				            return Loader3D.parse(data, AWData, init).handle;        }    	    	/**    	 * Loads and parses a .awd file (The Away3D native.awd data files) into an Object3D object.		 * @param	url					The url location of the .awd file to load.    	 * @param	init				[optional]	An initialisation object for specifying default instance properties.    	 *     	 * @return						A 3d loader object that can be used as a placeholder in a scene while the file is loading.    	 */        public static function load(url:String, init:Object = null):Loader3D        {			if(init== null)				init = {};							if(init.url == null)				init.url = url;				            return Loader3D.load(url, AWData, init);        }		/**		 * Allows to set custom path to source(s) map(s) other than set in file		 * Standard output url from Prefab awd files is "images/filename.jpg"		 * when set pathToSources, url becomes  [newurl]filename.jpg.		 * Example: AWData.pathToSources = "mydisc/myfiles/";		 */		public function set pathToSources(url:String):void		{			customPath = url;		}    }}