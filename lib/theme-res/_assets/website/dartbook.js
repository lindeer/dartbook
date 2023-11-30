(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q))b[q]=a[q]}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++)inherit(b[s],a)}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazyOld(a,b,c,d){var s=a
a[b]=s
a[c]=function(){a[c]=function(){A.fp(b)}
var r
var q=d
try{if(a[b]===s){r=a[b]=q
r=a[b]=d()}else r=a[b]}finally{if(r===q)a[b]=null
a[c]=function(){return this[b]}}return r}}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s)a[b]=d()
a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s)A.fr(b)
a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a){a.immutable$list=Array
a.fixed$length=Array
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s)convertToFastObject(a[s])}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.cG(b)
return new s(c,this)}:function(){if(s===null)s=A.cG(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.cG(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number")h+=x
return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,lazyOld:lazyOld,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
cJ(a,b,c,d){return{i:a,p:b,e:c,x:d}},
cd(a){var s,r,q,p,o,n=a[v.dispatchPropertyName]
if(n==null)if($.cI==null){A.fe()
n=a[v.dispatchPropertyName]}if(n!=null){s=n.p
if(!1===s)return n.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return n.i
if(n.e===r)throw A.d(A.d_("Return interceptor for "+A.h(s(a,n))))}q=a.constructor
if(q==null)p=null
else{o=$.c_
if(o==null)o=$.c_=v.getIsolateTag("_$dart_js")
p=q[o]}if(p!=null)return p
p=A.fj(a)
if(p!=null)return p
if(typeof a=="function")return B.w
s=Object.getPrototypeOf(a)
if(s==null)return B.j
if(s===Object.prototype)return B.j
if(typeof q=="function"){o=$.c_
if(o==null)o=$.c_=v.getIsolateTag("_$dart_js")
Object.defineProperty(q,o,{value:B.f,enumerable:false,writable:true,configurable:true})
return B.f}return B.f},
cV(a,b){a.fixed$length=Array
return a},
aC(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.ae.prototype
return J.aW.prototype}if(typeof a=="string")return J.Z.prototype
if(a==null)return J.af.prototype
if(typeof a=="boolean")return J.aV.prototype
if(Array.isArray(a))return J.v.prototype
if(typeof a!="object"){if(typeof a=="function")return J.D.prototype
if(typeof a=="symbol")return J.a0.prototype
if(typeof a=="bigint")return J.a_.prototype
return a}if(a instanceof A.j)return a
return J.cd(a)},
cH(a){if(typeof a=="string")return J.Z.prototype
if(a==null)return a
if(Array.isArray(a))return J.v.prototype
if(typeof a!="object"){if(typeof a=="function")return J.D.prototype
if(typeof a=="symbol")return J.a0.prototype
if(typeof a=="bigint")return J.a_.prototype
return a}if(a instanceof A.j)return a
return J.cd(a)},
f9(a){if(a==null)return a
if(Array.isArray(a))return J.v.prototype
if(typeof a!="object"){if(typeof a=="function")return J.D.prototype
if(typeof a=="symbol")return J.a0.prototype
if(typeof a=="bigint")return J.a_.prototype
return a}if(a instanceof A.j)return a
return J.cd(a)},
aD(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.D.prototype
if(typeof a=="symbol")return J.a0.prototype
if(typeof a=="bigint")return J.a_.prototype
return a}if(a instanceof A.j)return a
return J.cd(a)},
dN(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.fh(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.cH(a).l(a,b)},
dO(a,b,c,d){return J.aD(a).ab(a,b,c,d)},
cL(a){return J.f9(a).gP(a)},
cp(a){return J.cH(a).gj(a)},
dP(a){return J.aD(a).gR(a)},
dQ(a){return J.aD(a).gS(a)},
dR(a){return J.aC(a).gn(a)},
aH(a){return J.aC(a).h(a)},
ad:function ad(){},
aV:function aV(){},
af:function af(){},
w:function w(){},
U:function U(){},
b0:function b0(){},
an:function an(){},
D:function D(){},
a_:function a_(){},
a0:function a0(){},
v:function v(a){this.$ti=a},
bA:function bA(a){this.$ti=a},
aK:function aK(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
ag:function ag(){},
ae:function ae(){},
aW:function aW(){},
Z:function Z(){}},A={ct:function ct(){},
cF(a,b,c){return a},
dx(a){var s,r
for(s=$.K.length,r=0;r<s;++r)if(a===$.K[r])return!0
return!1},
aZ:function aZ(a){this.a=a},
a1:function a1(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
dB(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
fh(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.D.b(a)},
h(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.aH(a)
return s},
bE(a){return A.e3(a)},
e3(a){var s,r,q,p
if(a instanceof A.j)return A.o(A.a9(a),null)
s=J.aC(a)
if(s===B.v||s===B.x||t.G.b(a)){r=B.h(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.o(A.a9(a),null)},
e4(a){if(typeof a=="number"||A.cD(a))return J.aH(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.M)return a.h(0)
return"Instance of '"+A.bE(a)+"'"},
W(a,b){if(a==null)J.cp(a)
throw A.d(A.ds(a,b))},
ds(a,b){var s,r="index"
if(!A.di(b))return new A.L(!0,b,r,null)
s=A.c8(J.cp(a))
if(b<0||b>=s)return A.cs(b,s,a,r)
return new A.aj(null,null,!0,b,r,"Value not in range")},
d(a){return A.dv(new Error(),a)},
dv(a,b){var s
if(b==null)b=new A.F()
a.dartException=b
s=A.fs
if("defineProperty" in Object){Object.defineProperty(a,"message",{get:s})
a.name=""}else a.toString=s
return a},
fs(){return J.aH(this.dartException)},
co(a){throw A.d(a)},
fq(a,b){throw A.dv(b,a)},
dA(a){throw A.d(A.cT(a))},
G(a){var s,r,q,p,o,n
a=A.fm(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.a6([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.bH(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
bI(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
cZ(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
cu(a,b){var s=b==null,r=s?null:b.method
return new A.aY(a,r,s?null:b.receiver)},
S(a){if(a==null)return new A.bD(a)
if(typeof a!=="object")return a
if("dartException" in a)return A.X(a,a.dartException)
return A.f0(a)},
X(a,b){if(t.R.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
f0(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.e.af(r,16)&8191)===10)switch(q){case 438:return A.X(a,A.cu(A.h(s)+" (Error "+q+")",null))
case 445:case 5007:A.h(s)
return A.X(a,new A.ai())}}if(a instanceof TypeError){p=$.dD()
o=$.dE()
n=$.dF()
m=$.dG()
l=$.dJ()
k=$.dK()
j=$.dI()
$.dH()
i=$.dM()
h=$.dL()
g=p.k(s)
if(g!=null)return A.X(a,A.cu(A.V(s),g))
else{g=o.k(s)
if(g!=null){g.method="call"
return A.X(a,A.cu(A.V(s),g))}else if(n.k(s)!=null||m.k(s)!=null||l.k(s)!=null||k.k(s)!=null||j.k(s)!=null||m.k(s)!=null||i.k(s)!=null||h.k(s)!=null){A.V(s)
return A.X(a,new A.ai())}}return A.X(a,new A.b7(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.al()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.X(a,new A.L(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.al()
return a},
R(a){var s
if(a==null)return new A.at(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.at(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
eH(a,b,c,d,e,f){t.Z.a(a)
switch(A.c8(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.d(new A.bQ("Unsupported number of arguments for wrapped closure"))},
bu(a,b){var s
if(a==null)return null
s=a.$identity
if(!!s)return s
s=A.f6(a,b)
a.$identity=s
return s},
f6(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.eH)},
dY(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.b3().constructor.prototype):Object.create(new A.ab(null,null).constructor.prototype)
s.$initialize=s.constructor
if(h)r=function static_tear_off(){this.$initialize()}
else r=function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.cS(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.dU(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.cS(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
dU(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.d("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.dS)}throw A.d("Error in functionType of tearoff")},
dV(a,b,c,d){var s=A.cR
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
cS(a,b,c,d){var s,r
if(c)return A.dX(a,b,d)
s=b.length
r=A.dV(s,d,a,b)
return r},
dW(a,b,c,d){var s=A.cR,r=A.dT
switch(b?-1:a){case 0:throw A.d(new A.b1("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
dX(a,b,c){var s,r
if($.cP==null)$.cP=A.cO("interceptor")
if($.cQ==null)$.cQ=A.cO("receiver")
s=b.length
r=A.dW(s,c,a,b)
return r},
cG(a){return A.dY(a)},
dS(a,b){return A.c6(v.typeUniverse,A.a9(a.a),b)},
cR(a){return a.a},
dT(a){return a.b},
cO(a){var s,r,q,p=new A.ab("receiver","interceptor"),o=J.cV(Object.getOwnPropertyNames(p),t.X)
for(s=o.length,r=0;r<s;++r){q=o[r]
if(p[q]===a)return q}throw A.d(A.cq("Field name "+a+" not found.",null))},
fp(a){throw A.d(new A.bc(a))},
fa(a){return v.getIsolateTag(a)},
h5(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
fj(a){var s,r,q,p,o,n=A.V($.du.$1(a)),m=$.cc[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.ch[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.ey($.dp.$2(a,n))
if(q!=null){m=$.cc[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.ch[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.cj(s)
$.cc[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.ch[n]=s
return s}if(p==="-"){o=A.cj(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.dy(a,s)
if(p==="*")throw A.d(A.d_(n))
if(v.leafTags[n]===true){o=A.cj(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.dy(a,s)},
dy(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.cJ(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
cj(a){return J.cJ(a,!1,null,!!a.$iaX)},
fl(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.cj(s)
else return J.cJ(s,c,null,null)},
fe(){if(!0===$.cI)return
$.cI=!0
A.ff()},
ff(){var s,r,q,p,o,n,m,l
$.cc=Object.create(null)
$.ch=Object.create(null)
A.fd()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.dz.$1(o)
if(n!=null){m=A.fl(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
fd(){var s,r,q,p,o,n,m=B.k()
m=A.a7(B.l,A.a7(B.m,A.a7(B.i,A.a7(B.i,A.a7(B.n,A.a7(B.o,A.a7(B.p(B.h),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.du=new A.ce(p)
$.dp=new A.cf(o)
$.dz=new A.cg(n)},
a7(a,b){return a(b)||b},
f7(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
fm(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
bH:function bH(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
ai:function ai(){},
aY:function aY(a,b,c){this.a=a
this.b=b
this.c=c},
b7:function b7(a){this.a=a},
bD:function bD(a){this.a=a},
at:function at(a){this.a=a
this.b=null},
M:function M(){},
aN:function aN(){},
aO:function aO(){},
b5:function b5(){},
b3:function b3(){},
ab:function ab(a,b){this.a=a
this.b=b},
bc:function bc(a){this.a=a},
b1:function b1(a){this.a=a},
ce:function ce(a){this.a=a},
cf:function cf(a){this.a=a},
cg:function cg(a){this.a=a},
cX(a,b){var s=b.c
return s==null?b.c=A.cA(a,b.y,!0):s},
cw(a,b){var s=b.c
return s==null?b.c=A.aw(a,"Y",[b.y]):s},
e7(a){var s=a.d
if(s!=null)return s
return a.d=new Map()},
cY(a){var s=a.x
if(s===6||s===7||s===8)return A.cY(a.y)
return s===12||s===13},
e6(a){return a.at},
dt(a){return A.c5(v.typeUniverse,a,!1)},
Q(a,b,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=b.x
switch(c){case 5:case 1:case 2:case 3:case 4:return b
case 6:s=b.y
r=A.Q(a,s,a0,a1)
if(r===s)return b
return A.db(a,r,!0)
case 7:s=b.y
r=A.Q(a,s,a0,a1)
if(r===s)return b
return A.cA(a,r,!0)
case 8:s=b.y
r=A.Q(a,s,a0,a1)
if(r===s)return b
return A.da(a,r,!0)
case 9:q=b.z
p=A.aB(a,q,a0,a1)
if(p===q)return b
return A.aw(a,b.y,p)
case 10:o=b.y
n=A.Q(a,o,a0,a1)
m=b.z
l=A.aB(a,m,a0,a1)
if(n===o&&l===m)return b
return A.cy(a,n,l)
case 12:k=b.y
j=A.Q(a,k,a0,a1)
i=b.z
h=A.eY(a,i,a0,a1)
if(j===k&&h===i)return b
return A.d9(a,j,h)
case 13:g=b.z
a1+=g.length
f=A.aB(a,g,a0,a1)
o=b.y
n=A.Q(a,o,a0,a1)
if(f===g&&n===o)return b
return A.cz(a,n,f,!0)
case 14:e=b.y
if(e<a1)return b
d=a0[e-a1]
if(d==null)return b
return d
default:throw A.d(A.aM("Attempted to substitute unexpected RTI kind "+c))}},
aB(a,b,c,d){var s,r,q,p,o=b.length,n=A.c7(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.Q(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
eZ(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.c7(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.Q(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
eY(a,b,c,d){var s,r=b.a,q=A.aB(a,r,c,d),p=b.b,o=A.aB(a,p,c,d),n=b.c,m=A.eZ(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.bj()
s.a=q
s.b=o
s.c=m
return s},
a6(a,b){a[v.arrayRti]=b
return a},
dr(a){var s,r=a.$S
if(r!=null){if(typeof r=="number")return A.fc(r)
s=a.$S()
return s}return null},
fg(a,b){var s
if(A.cY(b))if(a instanceof A.M){s=A.dr(a)
if(s!=null)return s}return A.a9(a)},
a9(a){if(a instanceof A.j)return A.cB(a)
if(Array.isArray(a))return A.br(a)
return A.cC(J.aC(a))},
br(a){var s=a[v.arrayRti],r=t.b
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
cB(a){var s=a.$ti
return s!=null?s:A.cC(a)},
cC(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.eG(a,s)},
eG(a,b){var s=a instanceof A.M?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.eu(v.typeUniverse,s.name)
b.$ccache=r
return r},
fc(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.c5(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
fb(a){return A.a8(A.cB(a))},
eX(a){var s=a instanceof A.M?A.dr(a):null
if(s!=null)return s
if(t.k.b(a))return J.dR(a).a
if(Array.isArray(a))return A.br(a)
return A.a9(a)},
a8(a){var s=a.w
return s==null?a.w=A.de(a):s},
de(a){var s,r,q=a.at,p=q.replace(/\*/g,"")
if(p===q)return a.w=new A.c4(a)
s=A.c5(v.typeUniverse,p,!0)
r=s.w
return r==null?s.w=A.de(s):r},
eF(a){var s,r,q,p,o,n,m=this
if(m===t.K)return A.I(m,a,A.eM)
if(!A.J(m))if(!(m===t._))s=!1
else s=!0
else s=!0
if(s)return A.I(m,a,A.eQ)
s=m.x
if(s===7)return A.I(m,a,A.eD)
if(s===1)return A.I(m,a,A.dj)
r=s===6?m.y:m
q=r.x
if(q===8)return A.I(m,a,A.eI)
if(r===t.S)p=A.di
else if(r===t.i||r===t.H)p=A.eL
else if(r===t.N)p=A.eO
else p=r===t.y?A.cD:null
if(p!=null)return A.I(m,a,p)
if(q===9){o=r.y
if(r.z.every(A.fi)){m.r="$i"+o
if(o==="B")return A.I(m,a,A.eK)
return A.I(m,a,A.eP)}}else if(q===11){n=A.f7(r.y,r.z)
return A.I(m,a,n==null?A.dj:n)}return A.I(m,a,A.eB)},
I(a,b,c){a.b=c
return a.b(b)},
eE(a){var s,r=this,q=A.eA
if(!A.J(r))if(!(r===t._))s=!1
else s=!0
else s=!0
if(s)q=A.ez
else if(r===t.K)q=A.ex
else{s=A.aF(r)
if(s)q=A.eC}r.a=q
return r.a(a)},
bs(a){var s,r=a.x
if(!A.J(a))if(!(a===t._))if(!(a===t.A))if(r!==7)if(!(r===6&&A.bs(a.y)))s=r===8&&A.bs(a.y)||a===t.P||a===t.T
else s=!0
else s=!0
else s=!0
else s=!0
else s=!0
return s},
eB(a){var s=this
if(a==null)return A.bs(s)
return A.dw(v.typeUniverse,A.fg(a,s),s)},
eD(a){if(a==null)return!0
return this.y.b(a)},
eP(a){var s,r=this
if(a==null)return A.bs(r)
s=r.r
if(a instanceof A.j)return!!a[s]
return!!J.aC(a)[s]},
eK(a){var s,r=this
if(a==null)return A.bs(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.r
if(a instanceof A.j)return!!a[s]
return!!J.aC(a)[s]},
eA(a){var s,r=this
if(a==null){s=A.aF(r)
if(s)return a}else if(r.b(a))return a
A.df(a,r)},
eC(a){var s=this
if(a==null)return a
else if(s.b(a))return a
A.df(a,s)},
df(a,b){throw A.d(A.d8(A.d1(a,A.o(b,null))))},
f5(a,b,c,d){if(A.dw(v.typeUniverse,a,b))return a
throw A.d(A.d8("The type argument '"+A.o(a,null)+"' is not a subtype of the type variable bound '"+A.o(b,null)+"' of type variable '"+c+"' in '"+d+"'."))},
d1(a,b){return A.by(a)+": type '"+A.o(A.eX(a),null)+"' is not a subtype of type '"+b+"'"},
d8(a){return new A.au("TypeError: "+a)},
t(a,b){return new A.au("TypeError: "+A.d1(a,b))},
eI(a){var s=this,r=s.x===6?s.y:s
return r.y.b(a)||A.cw(v.typeUniverse,r).b(a)},
eM(a){return a!=null},
ex(a){if(a!=null)return a
throw A.d(A.t(a,"Object"))},
eQ(a){return!0},
ez(a){return a},
dj(a){return!1},
cD(a){return!0===a||!1===a},
fV(a){if(!0===a)return!0
if(!1===a)return!1
throw A.d(A.t(a,"bool"))},
fX(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.d(A.t(a,"bool"))},
fW(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.d(A.t(a,"bool?"))},
fY(a){if(typeof a=="number")return a
throw A.d(A.t(a,"double"))},
h_(a){if(typeof a=="number")return a
if(a==null)return a
throw A.d(A.t(a,"double"))},
fZ(a){if(typeof a=="number")return a
if(a==null)return a
throw A.d(A.t(a,"double?"))},
di(a){return typeof a=="number"&&Math.floor(a)===a},
c8(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.d(A.t(a,"int"))},
h1(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.d(A.t(a,"int"))},
h0(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.d(A.t(a,"int?"))},
eL(a){return typeof a=="number"},
h2(a){if(typeof a=="number")return a
throw A.d(A.t(a,"num"))},
h3(a){if(typeof a=="number")return a
if(a==null)return a
throw A.d(A.t(a,"num"))},
ew(a){if(typeof a=="number")return a
if(a==null)return a
throw A.d(A.t(a,"num?"))},
eO(a){return typeof a=="string"},
V(a){if(typeof a=="string")return a
throw A.d(A.t(a,"String"))},
h4(a){if(typeof a=="string")return a
if(a==null)return a
throw A.d(A.t(a,"String"))},
ey(a){if(typeof a=="string")return a
if(a==null)return a
throw A.d(A.t(a,"String?"))},
dm(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.o(a[q],b)
return s},
eS(a,b){var s,r,q,p,o,n,m=a.y,l=a.z
if(""===m)return"("+A.dm(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.o(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
dg(a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=", "
if(a6!=null){s=a6.length
if(a5==null){a5=A.a6([],t.s)
r=null}else r=a5.length
q=a5.length
for(p=s;p>0;--p)B.b.v(a5,"T"+(q+p))
for(o=t.X,n=t._,m="<",l="",p=0;p<s;++p,l=a3){k=a5.length
j=k-1-p
if(!(j>=0))return A.W(a5,j)
m=B.d.a5(m+l,a5[j])
i=a6[p]
h=i.x
if(!(h===2||h===3||h===4||h===5||i===o))if(!(i===n))k=!1
else k=!0
else k=!0
if(!k)m+=" extends "+A.o(i,a5)}m+=">"}else{m=""
r=null}o=a4.y
g=a4.z
f=g.a
e=f.length
d=g.b
c=d.length
b=g.c
a=b.length
a0=A.o(o,a5)
for(a1="",a2="",p=0;p<e;++p,a2=a3)a1+=a2+A.o(f[p],a5)
if(c>0){a1+=a2+"["
for(a2="",p=0;p<c;++p,a2=a3)a1+=a2+A.o(d[p],a5)
a1+="]"}if(a>0){a1+=a2+"{"
for(a2="",p=0;p<a;p+=3,a2=a3){a1+=a2
if(b[p+1])a1+="required "
a1+=A.o(b[p+2],a5)+" "+b[p]}a1+="}"}if(r!=null){a5.toString
a5.length=r}return m+"("+a1+") => "+a0},
o(a,b){var s,r,q,p,o,n,m,l=a.x
if(l===5)return"erased"
if(l===2)return"dynamic"
if(l===3)return"void"
if(l===1)return"Never"
if(l===4)return"any"
if(l===6){s=A.o(a.y,b)
return s}if(l===7){r=a.y
s=A.o(r,b)
q=r.x
return(q===12||q===13?"("+s+")":s)+"?"}if(l===8)return"FutureOr<"+A.o(a.y,b)+">"
if(l===9){p=A.f_(a.y)
o=a.z
return o.length>0?p+("<"+A.dm(o,b)+">"):p}if(l===11)return A.eS(a,b)
if(l===12)return A.dg(a,b,null)
if(l===13)return A.dg(a.y,b,a.z)
if(l===14){n=a.y
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.W(b,n)
return b[n]}return"?"},
f_(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
ev(a,b){var s=a.tR[b]
for(;typeof s=="string";)s=a.tR[s]
return s},
eu(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.c5(a,b,!1)
else if(typeof m=="number"){s=m
r=A.ax(a,5,"#")
q=A.c7(s)
for(p=0;p<s;++p)q[p]=r
o=A.aw(a,b,q)
n[b]=o
return o}else return m},
es(a,b){return A.dc(a.tR,b)},
fU(a,b){return A.dc(a.eT,b)},
c5(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.d6(A.d4(a,null,b,c))
r.set(b,s)
return s},
c6(a,b,c){var s,r,q=b.Q
if(q==null)q=b.Q=new Map()
s=q.get(c)
if(s!=null)return s
r=A.d6(A.d4(a,b,c,!0))
q.set(c,r)
return r},
et(a,b,c){var s,r,q,p=b.as
if(p==null)p=b.as=new Map()
s=c.at
r=p.get(s)
if(r!=null)return r
q=A.cy(a,b,c.x===10?c.z:[c])
p.set(s,q)
return q},
H(a,b){b.a=A.eE
b.b=A.eF
return b},
ax(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.y(null,null)
s.x=b
s.at=c
r=A.H(a,s)
a.eC.set(c,r)
return r},
db(a,b,c){var s,r=b.at+"*",q=a.eC.get(r)
if(q!=null)return q
s=A.ep(a,b,r,c)
a.eC.set(r,s)
return s},
ep(a,b,c,d){var s,r,q
if(d){s=b.x
if(!A.J(b))r=b===t.P||b===t.T||s===7||s===6
else r=!0
if(r)return b}q=new A.y(null,null)
q.x=6
q.y=b
q.at=c
return A.H(a,q)},
cA(a,b,c){var s,r=b.at+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.eo(a,b,r,c)
a.eC.set(r,s)
return s},
eo(a,b,c,d){var s,r,q,p
if(d){s=b.x
if(!A.J(b))if(!(b===t.P||b===t.T))if(s!==7)r=s===8&&A.aF(b.y)
else r=!0
else r=!0
else r=!0
if(r)return b
else if(s===1||b===t.A)return t.P
else if(s===6){q=b.y
if(q.x===8&&A.aF(q.y))return q
else return A.cX(a,b)}}p=new A.y(null,null)
p.x=7
p.y=b
p.at=c
return A.H(a,p)},
da(a,b,c){var s,r=b.at+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.em(a,b,r,c)
a.eC.set(r,s)
return s},
em(a,b,c,d){var s,r,q
if(d){s=b.x
if(!A.J(b))if(!(b===t._))r=!1
else r=!0
else r=!0
if(r||b===t.K)return b
else if(s===1)return A.aw(a,"Y",[b])
else if(b===t.P||b===t.T)return t.Y}q=new A.y(null,null)
q.x=8
q.y=b
q.at=c
return A.H(a,q)},
eq(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.y(null,null)
s.x=14
s.y=b
s.at=q
r=A.H(a,s)
a.eC.set(q,r)
return r},
av(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].at
return s},
el(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].at}return s},
aw(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.av(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.y(null,null)
r.x=9
r.y=b
r.z=c
if(c.length>0)r.c=c[0]
r.at=p
q=A.H(a,r)
a.eC.set(p,q)
return q},
cy(a,b,c){var s,r,q,p,o,n
if(b.x===10){s=b.y
r=b.z.concat(c)}else{r=c
s=b}q=s.at+(";<"+A.av(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.y(null,null)
o.x=10
o.y=s
o.z=r
o.at=q
n=A.H(a,o)
a.eC.set(q,n)
return n},
er(a,b,c){var s,r,q="+"+(b+"("+A.av(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.y(null,null)
s.x=11
s.y=b
s.z=c
s.at=q
r=A.H(a,s)
a.eC.set(q,r)
return r},
d9(a,b,c){var s,r,q,p,o,n=b.at,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.av(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.av(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.el(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.y(null,null)
p.x=12
p.y=b
p.z=c
p.at=r
o=A.H(a,p)
a.eC.set(r,o)
return o},
cz(a,b,c,d){var s,r=b.at+("<"+A.av(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.en(a,b,c,r,d)
a.eC.set(r,s)
return s},
en(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.c7(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.x===1){r[p]=o;++q}}if(q>0){n=A.Q(a,b,r,0)
m=A.aB(a,c,r,0)
return A.cz(a,n,m,c!==m)}}l=new A.y(null,null)
l.x=13
l.y=b
l.z=c
l.at=d
return A.H(a,l)},
d4(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
d6(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.ef(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.d5(a,r,l,k,!1)
else if(q===46)r=A.d5(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.P(a.u,a.e,k.pop()))
break
case 94:k.push(A.eq(a.u,k.pop()))
break
case 35:k.push(A.ax(a.u,5,"#"))
break
case 64:k.push(A.ax(a.u,2,"@"))
break
case 126:k.push(A.ax(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.eh(a,k)
break
case 38:A.eg(a,k)
break
case 42:p=a.u
k.push(A.db(p,A.P(p,a.e,k.pop()),a.n))
break
case 63:p=a.u
k.push(A.cA(p,A.P(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.da(p,A.P(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.ee(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.d7(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.ej(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.P(a.u,a.e,m)},
ef(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
d5(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.x===10)o=o.y
n=A.ev(s,o.y)[p]
if(n==null)A.co('No "'+p+'" in "'+A.e6(o)+'"')
d.push(A.c6(s,o,n))}else d.push(p)
return m},
eh(a,b){var s,r=a.u,q=A.d3(a,b),p=b.pop()
if(typeof p=="string")b.push(A.aw(r,p,q))
else{s=A.P(r,a.e,p)
switch(s.x){case 12:b.push(A.cz(r,s,q,a.n))
break
default:b.push(A.cy(r,s,q))
break}}},
ee(a,b){var s,r,q,p,o,n=null,m=a.u,l=b.pop()
if(typeof l=="number")switch(l){case-1:s=b.pop()
r=n
break
case-2:r=b.pop()
s=n
break
default:b.push(l)
r=n
s=r
break}else{b.push(l)
r=n
s=r}q=A.d3(a,b)
l=b.pop()
switch(l){case-3:l=b.pop()
if(s==null)s=m.sEA
if(r==null)r=m.sEA
p=A.P(m,a.e,l)
o=new A.bj()
o.a=q
o.b=s
o.c=r
b.push(A.d9(m,p,o))
return
case-4:b.push(A.er(m,b.pop(),q))
return
default:throw A.d(A.aM("Unexpected state under `()`: "+A.h(l)))}},
eg(a,b){var s=b.pop()
if(0===s){b.push(A.ax(a.u,1,"0&"))
return}if(1===s){b.push(A.ax(a.u,4,"1&"))
return}throw A.d(A.aM("Unexpected extended operation "+A.h(s)))},
d3(a,b){var s=b.splice(a.p)
A.d7(a.u,a.e,s)
a.p=b.pop()
return s},
P(a,b,c){if(typeof c=="string")return A.aw(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.ei(a,b,c)}else return c},
d7(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.P(a,b,c[s])},
ej(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.P(a,b,c[s])},
ei(a,b,c){var s,r,q=b.x
if(q===10){if(c===0)return b.y
s=b.z
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.y
q=b.x}else if(c===0)return b
if(q!==9)throw A.d(A.aM("Indexed base must be an interface type"))
s=b.z
if(c<=s.length)return s[c-1]
throw A.d(A.aM("Bad index "+c+" for "+b.h(0)))},
dw(a,b,c){var s,r=A.e7(b),q=r.get(c)
if(q!=null)return q
s=A.k(a,b,null,c,null)
r.set(c,s)
return s},
k(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(!A.J(d))if(!(d===t._))s=!1
else s=!0
else s=!0
if(s)return!0
r=b.x
if(r===4)return!0
if(A.J(b))return!1
if(b.x!==1)s=!1
else s=!0
if(s)return!0
q=r===14
if(q)if(A.k(a,c[b.y],c,d,e))return!0
p=d.x
s=b===t.P||b===t.T
if(s){if(p===8)return A.k(a,b,c,d.y,e)
return d===t.P||d===t.T||p===7||p===6}if(d===t.K){if(r===8)return A.k(a,b.y,c,d,e)
if(r===6)return A.k(a,b.y,c,d,e)
return r!==7}if(r===6)return A.k(a,b.y,c,d,e)
if(p===6){s=A.cX(a,d)
return A.k(a,b,c,s,e)}if(r===8){if(!A.k(a,b.y,c,d,e))return!1
return A.k(a,A.cw(a,b),c,d,e)}if(r===7){s=A.k(a,t.P,c,d,e)
return s&&A.k(a,b.y,c,d,e)}if(p===8){if(A.k(a,b,c,d.y,e))return!0
return A.k(a,b,c,A.cw(a,d),e)}if(p===7){s=A.k(a,b,c,t.P,e)
return s||A.k(a,b,c,d.y,e)}if(q)return!1
s=r!==12
if((!s||r===13)&&d===t.Z)return!0
o=r===11
if(o&&d===t.L)return!0
if(p===13){if(b===t.g)return!0
if(r!==13)return!1
n=b.z
m=d.z
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.k(a,j,c,i,e)||!A.k(a,i,e,j,c))return!1}return A.dh(a,b.y,c,d.y,e)}if(p===12){if(b===t.g)return!0
if(s)return!1
return A.dh(a,b,c,d,e)}if(r===9){if(p!==9)return!1
return A.eJ(a,b,c,d,e)}if(o&&p===11)return A.eN(a,b,c,d,e)
return!1},
dh(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.k(a3,a4.y,a5,a6.y,a7))return!1
s=a4.z
r=a6.z
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.k(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.k(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.k(a3,k[h],a7,g,a5))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;!0;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.k(a3,e[a+2],a7,g,a5))return!1
break}}for(;b<d;){if(f[b+1])return!1
b+=3}return!0},
eJ(a,b,c,d,e){var s,r,q,p,o,n,m,l=b.y,k=d.y
for(;l!==k;){s=a.tR[l]
if(s==null)return!1
if(typeof s=="string"){l=s
continue}r=s[k]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.c6(a,b,r[o])
return A.dd(a,p,null,c,d.z,e)}n=b.z
m=d.z
return A.dd(a,n,null,c,m,e)},
dd(a,b,c,d,e,f){var s,r,q,p=b.length
for(s=0;s<p;++s){r=b[s]
q=e[s]
if(!A.k(a,r,d,q,f))return!1}return!0},
eN(a,b,c,d,e){var s,r=b.z,q=d.z,p=r.length
if(p!==q.length)return!1
if(b.y!==d.y)return!1
for(s=0;s<p;++s)if(!A.k(a,r[s],c,q[s],e))return!1
return!0},
aF(a){var s,r=a.x
if(!(a===t.P||a===t.T))if(!A.J(a))if(r!==7)if(!(r===6&&A.aF(a.y)))s=r===8&&A.aF(a.y)
else s=!0
else s=!0
else s=!0
else s=!0
return s},
fi(a){var s
if(!A.J(a))if(!(a===t._))s=!1
else s=!0
else s=!0
return s},
J(a){var s=a.x
return s===2||s===3||s===4||s===5||a===t.X},
dc(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
c7(a){return a>0?new Array(a):v.typeUniverse.sEA},
y:function y(a,b){var _=this
_.a=a
_.b=b
_.w=_.r=_.e=_.d=_.c=null
_.x=0
_.at=_.as=_.Q=_.z=_.y=null},
bj:function bj(){this.c=this.b=this.a=null},
c4:function c4(a){this.a=a},
bg:function bg(){},
au:function au(a){this.a=a},
ea(){var s,r,q={}
if(self.scheduleImmediate!=null)return A.f2()
if(self.MutationObserver!=null&&self.document!=null){s=self.document.createElement("div")
r=self.document.createElement("span")
q.a=null
new self.MutationObserver(A.bu(new A.bK(q),1)).observe(s,{childList:true})
return new A.bJ(q,s,r)}else if(self.setImmediate!=null)return A.f3()
return A.f4()},
eb(a){self.scheduleImmediate(A.bu(new A.bL(t.M.a(a)),0))},
ec(a){self.setImmediate(A.bu(new A.bM(t.M.a(a)),0))},
ed(a){A.cx(B.t,t.M.a(a))},
cx(a,b){var s=B.e.F(a.a,1000)
return A.ek(s<0?0:s,b)},
ek(a,b){var s=new A.c2()
s.aa(a,b)
return s},
bv(a,b){var s=A.cF(a,"error",t.K)
return new A.aa(s,b==null?A.cN(a):b)},
cN(a){var s
if(t.R.b(a)){s=a.gB()
if(s!=null)return s}return B.r},
e0(a,b,c){var s=new A.r($.l,c.i("r<0>"))
A.e9(a,new A.bz(b,s,c))
return s},
d2(a,b){var s,r,q
for(s=t.c;r=a.a,(r&4)!==0;)a=s.a(a.c)
if((r&24)!==0){q=b.D()
b.I(a)
A.a4(b,q)}else{q=t.F.a(b.c)
b.a=b.a&1|4
b.c=a
a.a0(q)}},
a4(a,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c={},b=c.a=a
for(s=t.n,r=t.F,q=t.d;!0;){p={}
o=b.a
n=(o&16)===0
m=!n
if(a0==null){if(m&&(o&1)===0){l=s.a(b.c)
A.c9(l.a,l.b)}return}p.a=a0
k=a0.a
for(b=a0;k!=null;b=k,k=j){b.a=null
A.a4(c.a,b)
p.a=k
j=k.a}o=c.a
i=o.c
p.b=m
p.c=i
if(n){h=b.c
h=(h&1)!==0||(h&15)===8}else h=!0
if(h){g=b.b.b
if(m){o=o.b===g
o=!(o||o)}else o=!1
if(o){s.a(i)
A.c9(i.a,i.b)
return}f=$.l
if(f!==g)$.l=g
else f=null
b=b.c
if((b&15)===8)new A.bY(p,c,m).$0()
else if(n){if((b&1)!==0)new A.bX(p,i).$0()}else if((b&2)!==0)new A.bW(c,p).$0()
if(f!=null)$.l=f
b=p.c
if(b instanceof A.r){o=p.a.$ti
o=o.i("Y<2>").b(b)||!o.z[1].b(b)}else o=!1
if(o){q.a(b)
e=p.a.b
if((b.a&24)!==0){d=r.a(e.c)
e.c=null
a0=e.E(d)
e.a=b.a&30|e.a&1
e.c=b.c
c.a=b
continue}else A.d2(b,e)
return}}e=p.a.b
d=r.a(e.c)
e.c=null
a0=e.E(d)
b=p.b
o=p.c
if(!b){e.$ti.c.a(o)
e.a=8
e.c=o}else{s.a(o)
e.a=e.a&1|16
e.c=o}c.a=e
b=e}},
eT(a,b){var s=t.Q
if(s.b(a))return s.a(a)
s=t.v
if(s.b(a))return s.a(a)
throw A.d(A.cM(a,"onError",u.c))},
eR(){var s,r
for(s=$.a5;s!=null;s=$.a5){$.aA=null
r=s.b
$.a5=r
if(r==null)$.az=null
s.a.$0()}},
eW(){$.cE=!0
try{A.eR()}finally{$.aA=null
$.cE=!1
if($.a5!=null)$.cK().$1(A.dq())}},
dn(a){var s=new A.b9(a),r=$.az
if(r==null){$.a5=$.az=s
if(!$.cE)$.cK().$1(A.dq())}else $.az=r.b=s},
eV(a){var s,r,q,p=$.a5
if(p==null){A.dn(a)
$.aA=$.az
return}s=new A.b9(a)
r=$.aA
if(r==null){s.b=p
$.a5=$.aA=s}else{q=r.b
s.b=q
$.aA=r.b=s
if(q==null)$.az=s}},
fn(a){var s,r=null,q=$.l
if(B.a===q){A.bt(r,r,B.a,a)
return}s=!1
if(s){A.bt(r,r,q,t.M.a(a))
return}A.bt(r,r,q,t.M.a(q.M(a)))},
e9(a,b){var s=$.l
if(s===B.a)return A.cx(a,t.M.a(b))
return A.cx(a,t.M.a(s.M(b)))},
c9(a,b){A.eV(new A.ca(a,b))},
dk(a,b,c,d,e){var s,r=$.l
if(r===c)return d.$0()
$.l=c
s=r
try{r=d.$0()
return r}finally{$.l=s}},
dl(a,b,c,d,e,f,g){var s,r=$.l
if(r===c)return d.$1(e)
$.l=c
s=r
try{r=d.$1(e)
return r}finally{$.l=s}},
eU(a,b,c,d,e,f,g,h,i){var s,r=$.l
if(r===c)return d.$2(e,f)
$.l=c
s=r
try{r=d.$2(e,f)
return r}finally{$.l=s}},
bt(a,b,c,d){t.M.a(d)
if(B.a!==c)d=c.M(d)
A.dn(d)},
bK:function bK(a){this.a=a},
bJ:function bJ(a,b,c){this.a=a
this.b=b
this.c=c},
bL:function bL(a){this.a=a},
bM:function bM(a){this.a=a},
c2:function c2(){},
c3:function c3(a,b){this.a=a
this.b=b},
aa:function aa(a,b){this.a=a
this.b=b},
bz:function bz(a,b,c){this.a=a
this.b=b
this.c=c},
ar:function ar(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
r:function r(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
bR:function bR(a,b){this.a=a
this.b=b},
bV:function bV(a,b){this.a=a
this.b=b},
bS:function bS(a){this.a=a},
bT:function bT(a){this.a=a},
bU:function bU(a,b,c){this.a=a
this.b=b
this.c=c},
bY:function bY(a,b,c){this.a=a
this.b=b
this.c=c},
bZ:function bZ(a){this.a=a},
bX:function bX(a,b){this.a=a
this.b=b},
bW:function bW(a,b){this.a=a
this.b=b},
b9:function b9(a){this.a=a
this.b=null},
am:function am(){},
bF:function bF(a,b){this.a=a
this.b=b},
bG:function bG(a,b){this.a=a
this.b=b},
ay:function ay(){},
ca:function ca(a,b){this.a=a
this.b=b},
bn:function bn(){},
c0:function c0(a,b){this.a=a
this.b=b},
c1:function c1(a,b,c){this.a=a
this.b=b
this.c=c},
e2(a){var s,r={}
if(A.dx(a))return"{...}"
s=new A.b4("")
try{B.b.v($.K,a)
s.a+="{"
r.a=!0
a.A(0,new A.bC(r,s))
s.a+="}"}finally{if(0>=$.K.length)return A.W($.K,-1)
$.K.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
p:function p(){},
u:function u(){},
bC:function bC(a,b){this.a=a
this.b=b},
dZ(a,b){a=A.d(a)
if(a==null)a=t.K.a(a)
a.stack=b.h(0)
throw a
throw A.d("unreachable")},
e1(a,b,c){var s,r,q
if(a>4294967295)A.co(A.cv(a,0,4294967295,"length",null))
s=J.cV(A.a6(new Array(a),c.i("v<0>")),c)
if(a!==0&&!0)for(r=s.length,q=0;q<r;++q)s[q]=b
return s},
e8(a,b,c){var s=J.cL(b)
if(!s.m())return a
if(c.length===0){do a+=A.h(s.gq())
while(s.m())}else{a+=A.h(s.gq())
for(;s.m();)a=a+c+A.h(s.gq())}return a},
by(a){if(typeof a=="number"||A.cD(a)||a==null)return J.aH(a)
if(typeof a=="string")return JSON.stringify(a)
return A.e4(a)},
e_(a,b){A.cF(a,"error",t.K)
A.cF(b,"stackTrace",t.l)
A.dZ(a,b)},
aM(a){return new A.aL(a)},
cq(a,b){return new A.L(!1,null,b,a)},
cM(a,b,c){return new A.L(!0,a,b,c)},
cv(a,b,c,d,e){return new A.aj(b,c,!0,a,d,"Invalid value")},
e5(a,b,c){if(0>a||a>c)throw A.d(A.cv(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.d(A.cv(b,a,c,"end",null))
return b}return c},
cs(a,b,c,d){return new A.aU(b,!0,a,d,"Index out of range")},
ao(a){return new A.b8(a)},
d_(a){return new A.b6(a)},
cT(a){return new A.aP(a)},
cU(a,b,c){var s,r
if(A.dx(a))return b+"..."+c
s=new A.b4(b)
B.b.v($.K,a)
try{r=s
r.a=A.e8(r.a,a,", ")}finally{if(0>=$.K.length)return A.W($.K,-1)
$.K.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
aR:function aR(a){this.a=a},
i:function i(){},
aL:function aL(a){this.a=a},
F:function F(){},
L:function L(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
aj:function aj(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
aU:function aU(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
b8:function b8(a){this.a=a},
b6:function b6(a){this.a=a},
aP:function aP(a){this.a=a},
b_:function b_(){},
al:function al(){},
bQ:function bQ(a){this.a=a},
q:function q(){},
j:function j(){},
bo:function bo(){},
b4:function b4(a){this.a=a},
bi(a,b,c,d,e){var s=A.f1(new A.bP(c),t.B),r=s!=null
if(r&&!0){t.o.a(s)
if(r)J.dO(a,b,s,!1)}return new A.bh(a,b,s,!1,e.i("bh<0>"))},
f1(a,b){var s=$.l
if(s===B.a)return a
return s.ah(a,b)},
b:function b(){},
aI:function aI(){},
aJ:function aJ(){},
A:function A(){},
ac:function ac(){},
bw:function bw(){},
bx:function bx(){},
aQ:function aQ(){},
aq:function aq(a,b){this.a=a
this.$ti=b},
n:function n(){},
a:function a(){},
m:function m(){},
aT:function aT(){},
x:function x(){},
e:function e(){},
ah:function ah(){},
b2:function b2(){},
z:function z(){},
a3:function a3(){},
be:function be(){},
as:function as(){},
ba:function ba(){},
bf:function bf(a){this.a=a},
bd:function bd(a){this.a=a},
bN:function bN(a,b){this.a=a
this.b=b},
bO:function bO(a,b){this.a=a
this.b=b},
cr:function cr(a,b){this.a=a
this.$ti=b},
ap:function ap(){},
O:function O(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
bh:function bh(a,b,c,d,e){var _=this
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
bP:function bP(a){this.a=a},
C:function C(){},
aS:function aS(a,b,c){var _=this
_.a=a
_.b=b
_.c=-1
_.d=null
_.$ti=c},
bb:function bb(){},
bk:function bk(){},
bl:function bl(){},
bp:function bp(){},
bq:function bq(){},
bm:function bm(){},
ak:function ak(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.$ti=e},
c:function c(){},
fo(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null,f={},e=window.screenLeft
if(e==null)e=0
s=window.screenTop
if(s==null)s=0
r=window.screen
r=r==null?g:r.width
if(r==null)r=0
q=window.screen
q=q==null?g:q.height
if(q==null)q=0
if(r<0)r=r===-1/0?0:-r*0
if(q<0)q=q===-1/0?0:-q*0
p=new A.ak(e,s,r,q,t.E)
o=a.getAttribute("data-"+new A.bd(new A.bf(a)).a2("target"))
n=o==null?g:document.getElementById(o)
if(n==null)return
e=a.offsetParent
if(e==null)m=g
else{e=e.getBoundingClientRect()
e.toString
m=e}if(m==null)m=p
e=a.offsetLeft
e.toString
e=B.c.u(e)
s=a.offsetWidth
s.toString
s=B.c.u(s)
r=n.offsetWidth
r.toString
r=Math.max(0,B.c.ar(e+s/2-B.c.u(r)/2))
s=J.aD(m)
e=s.ga3(m)
q=n.offsetWidth
q.toString
l=Math.min(r,e-B.c.u(q)-s.gG(m))
q=a.offsetTop
q.toString
q=B.c.u(q)
e=a.offsetHeight
e.toString
e=B.c.u(e)
r=n.offsetParent
if(r==null)k=g
else{r=r.getBoundingClientRect()
r.toString
k=r}if(k==null)k=p
r=s.gG(m)
j=J.aD(k)
i=j.gG(k)
s=s.gU(m)
j=j.gU(k)
h=n.style
h.visibility="visible"
h.left=A.h(l+(r-i))+"px"
h.top=A.h(q+e+(s-j))+"px"
f.a=!1
e=J.dQ(a)
s=e.$ti
A.bi(e.a,e.b,s.i("~(1)?").a(new A.cl(f,n)),!1,s.c)
s=J.aD(n)
e=s.gR(n)
r=e.$ti
A.bi(e.a,e.b,r.i("~(1)?").a(new A.cm(f)),!1,r.c)
s=s.gS(n)
r=s.$ti
A.bi(s.a,s.b,r.i("~(1)?").a(new A.cn(f,n)),!1,r.c)},
fk(){var s,r,q,p,o=t.h,n=document
n.toString
A.f5(o,o,"T","querySelectorAll")
n=n.querySelectorAll(".glossary-item")
n.toString
o=t.W
s=new A.aq(n,o)
for(n=new A.a1(s,s.gj(s),o.i("a1<p.E>")),o=o.i("p.E");n.m();){r=n.d
if(r==null)r=o.a(r)
q=J.dP(r)
p=q.$ti
A.bi(q.a,q.b,p.i("~(1)?").a(new A.ci(r)),!1,p.c)}},
cl:function cl(a,b){this.a=a
this.b=b},
ck:function ck(a,b){this.a=a
this.b=b},
cm:function cm(a){this.a=a},
cn:function cn(a,b){this.a=a
this.b=b},
ci:function ci(a){this.a=a},
fr(a){A.fq(new A.aZ("Field '"+a+"' has been assigned during initialization."),new Error())}},B={}
var w=[A,J,B]
var $={}
A.ct.prototype={}
J.ad.prototype={
h(a){return"Instance of '"+A.bE(a)+"'"},
gn(a){return A.a8(A.cC(this))}}
J.aV.prototype={
h(a){return String(a)},
gn(a){return A.a8(t.y)},
$iE:1,
$icb:1}
J.af.prototype={
h(a){return"null"},
$iE:1,
$iq:1}
J.w.prototype={}
J.U.prototype={
h(a){return String(a)}}
J.b0.prototype={}
J.an.prototype={}
J.D.prototype={
h(a){var s=a[$.dC()]
if(s==null)return this.a9(a)
return"JavaScript function for "+J.aH(s)},
$iT:1}
J.a_.prototype={
h(a){return String(a)}}
J.a0.prototype={
h(a){return String(a)}}
J.v.prototype={
v(a,b){A.br(a).c.a(b)
if(!!a.fixed$length)A.co(A.ao("add"))
a.push(b)},
aj(a,b){var s,r=A.e1(a.length,"",t.N)
for(s=0;s<a.length;++s)this.V(r,s,A.h(a[s]))
return r.join(b)},
h(a){return A.cU(a,"[","]")},
gP(a){return new J.aK(a,a.length,A.br(a).i("aK<1>"))},
gj(a){return a.length},
V(a,b,c){var s
A.br(a).c.a(c)
if(!!a.immutable$list)A.co(A.ao("indexed set"))
s=a.length
if(b>=s)throw A.d(A.ds(a,b))
a[b]=c},
$iN:1,
$iB:1}
J.bA.prototype={}
J.aK.prototype={
gq(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.dA(q)
throw A.d(q)}s=r.c
if(s>=p){r.sZ(null)
return!1}r.sZ(q[s]);++r.c
return!0},
sZ(a){this.d=this.$ti.i("1?").a(a)}}
J.ag.prototype={
ar(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.d(A.ao(""+a+".toInt()"))},
u(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw A.d(A.ao(""+a+".round()"))},
h(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
F(a,b){return(a|0)===a?a/b|0:this.ag(a,b)},
ag(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.d(A.ao("Result of truncating division is "+A.h(s)+": "+A.h(a)+" ~/ "+b))},
af(a,b){var s
if(a>0)s=this.ae(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
ae(a,b){return b>31?0:a>>>b},
gn(a){return A.a8(t.H)},
$iaG:1}
J.ae.prototype={
gn(a){return A.a8(t.S)},
$iE:1,
$iaE:1}
J.aW.prototype={
gn(a){return A.a8(t.i)},
$iE:1}
J.Z.prototype={
a5(a,b){return a+b},
W(a,b){var s=a.length,r=b.length
if(r>s)return!1
return b===a.substring(0,r)},
a7(a,b,c){return a.substring(b,A.e5(b,c,a.length))},
H(a,b){return this.a7(a,b,null)},
a6(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.d(B.q)
for(s=a,r="";!0;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
al(a,b,c){var s=b-a.length
if(s<=0)return a
return this.a6(c,s)+a},
h(a){return a},
gn(a){return A.a8(t.N)},
gj(a){return a.length},
$iE:1,
$icW:1,
$if:1}
A.aZ.prototype={
h(a){return"LateInitializationError: "+this.a}}
A.a1.prototype={
gq(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a,p=J.cH(q),o=p.gj(q)
if(r.b!==o)throw A.d(A.cT(q))
s=r.c
if(s>=o){r.sX(null)
return!1}r.sX(p.N(q,s));++r.c
return!0},
sX(a){this.d=this.$ti.i("1?").a(a)}}
A.bH.prototype={
k(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.ai.prototype={
h(a){return"Null check operator used on a null value"}}
A.aY.prototype={
h(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.b7.prototype={
h(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.bD.prototype={
h(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.at.prototype={
h(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$ia2:1}
A.M.prototype={
h(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.dB(r==null?"unknown":r)+"'"},
$iT:1,
gau(){return this},
$C:"$1",
$R:1,
$D:null}
A.aN.prototype={$C:"$0",$R:0}
A.aO.prototype={$C:"$2",$R:2}
A.b5.prototype={}
A.b3.prototype={
h(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.dB(s)+"'"}}
A.ab.prototype={
h(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.bE(this.a)+"'")}}
A.bc.prototype={
h(a){return"Reading static variable '"+this.a+"' during its initialization"}}
A.b1.prototype={
h(a){return"RuntimeError: "+this.a}}
A.ce.prototype={
$1(a){return this.a(a)},
$S:6}
A.cf.prototype={
$2(a,b){return this.a(a,b)},
$S:7}
A.cg.prototype={
$1(a){return this.a(A.V(a))},
$S:8}
A.y.prototype={
i(a){return A.c6(v.typeUniverse,this,a)},
p(a){return A.et(v.typeUniverse,this,a)}}
A.bj.prototype={}
A.c4.prototype={
h(a){return A.o(this.a,null)}}
A.bg.prototype={
h(a){return this.a}}
A.au.prototype={$iF:1}
A.bK.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:4}
A.bJ.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:9}
A.bL.prototype={
$0(){this.a.$0()},
$S:2}
A.bM.prototype={
$0(){this.a.$0()},
$S:2}
A.c2.prototype={
aa(a,b){if(self.setTimeout!=null)self.setTimeout(A.bu(new A.c3(this,b),0),a)
else throw A.d(A.ao("`setTimeout()` not found."))}}
A.c3.prototype={
$0(){this.b.$0()},
$S:0}
A.aa.prototype={
h(a){return A.h(this.a)},
$ii:1,
gB(){return this.b}}
A.bz.prototype={
$0(){var s,r,q,p,o=this,n=o.a
if(n==null){o.c.a(null)
o.b.J(null)}else try{o.b.J(n.$0())}catch(q){s=A.S(q)
r=A.R(q)
n=s
p=r
if(p==null)p=A.cN(n)
o.b.C(n,p)}},
$S:0}
A.ar.prototype={
ak(a){if((this.c&15)!==6)return!0
return this.b.b.T(t.m.a(this.d),a.a,t.y,t.K)},
ai(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Q.b(q))p=l.an(q,m,a.b,o,n,t.l)
else p=l.T(t.v.a(q),m,o,n)
try{o=r.$ti.i("2/").a(p)
return o}catch(s){if(t.e.b(A.S(s))){if((r.c&1)!==0)throw A.d(A.cq("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.d(A.cq("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.r.prototype={
a4(a,b,c){var s,r,q,p=this.$ti
p.p(c).i("1/(2)").a(a)
s=$.l
if(s===B.a){if(b!=null&&!t.Q.b(b)&&!t.v.b(b))throw A.d(A.cM(b,"onError",u.c))}else{c.i("@<0/>").p(p.c).i("1(2)").a(a)
if(b!=null)b=A.eT(b,s)}r=new A.r(s,c.i("r<0>"))
q=b==null?1:3
this.Y(new A.ar(r,q,a,b,p.i("@<1>").p(c).i("ar<1,2>")))
return r},
aq(a,b){return this.a4(a,null,b)},
ad(a){this.a=this.a&1|16
this.c=a},
I(a){this.a=a.a&30|this.a&1
this.c=a.c},
Y(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t.c.a(r.c)
if((s.a&24)===0){s.Y(a)
return}r.I(s)}A.bt(null,null,r.b,t.M.a(new A.bR(r,a)))}},
a0(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t.c.a(m.c)
if((n.a&24)===0){n.a0(a)
return}m.I(n)}l.a=m.E(a)
A.bt(null,null,m.b,t.M.a(new A.bV(l,m)))}},
D(){var s=t.F.a(this.c)
this.c=null
return this.E(s)},
E(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
ac(a){var s,r,q,p=this
p.a^=2
try{a.a4(new A.bS(p),new A.bT(p),t.P)}catch(q){s=A.S(q)
r=A.R(q)
A.fn(new A.bU(p,s,r))}},
J(a){var s,r=this,q=r.$ti
q.i("1/").a(a)
if(q.i("Y<1>").b(a))if(q.b(a))A.d2(a,r)
else r.ac(a)
else{s=r.D()
q.c.a(a)
r.a=8
r.c=a
A.a4(r,s)}},
C(a,b){var s
t.l.a(b)
s=this.D()
this.ad(A.bv(a,b))
A.a4(this,s)},
$iY:1}
A.bR.prototype={
$0(){A.a4(this.a,this.b)},
$S:0}
A.bV.prototype={
$0(){A.a4(this.b,this.a.a)},
$S:0}
A.bS.prototype={
$1(a){var s,r,q,p,o,n=this.a
n.a^=2
try{q=n.$ti.c
a=q.a(q.a(a))
p=n.D()
n.a=8
n.c=a
A.a4(n,p)}catch(o){s=A.S(o)
r=A.R(o)
n.C(s,r)}},
$S:4}
A.bT.prototype={
$2(a,b){this.a.C(t.K.a(a),t.l.a(b))},
$S:10}
A.bU.prototype={
$0(){this.a.C(this.b,this.c)},
$S:0}
A.bY.prototype={
$0(){var s,r,q,p,o,n,m=this,l=null
try{q=m.a.a
l=q.b.b.am(t.O.a(q.d),t.z)}catch(p){s=A.S(p)
r=A.R(p)
q=m.c&&t.n.a(m.b.a.c).a===s
o=m.a
if(q)o.c=t.n.a(m.b.a.c)
else o.c=A.bv(s,r)
o.b=!0
return}if(l instanceof A.r&&(l.a&24)!==0){if((l.a&16)!==0){q=m.a
q.c=t.n.a(l.c)
q.b=!0}return}if(l instanceof A.r){n=m.b.a
q=m.a
q.c=l.aq(new A.bZ(n),t.z)
q.b=!1}},
$S:0}
A.bZ.prototype={
$1(a){return this.a},
$S:11}
A.bX.prototype={
$0(){var s,r,q,p,o,n,m,l
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
q.c=p.b.b.T(o.i("2/(1)").a(p.d),m,o.i("2/"),n)}catch(l){s=A.S(l)
r=A.R(l)
q=this.a
q.c=A.bv(s,r)
q.b=!0}},
$S:0}
A.bW.prototype={
$0(){var s,r,q,p,o,n,m=this
try{s=t.n.a(m.a.a.c)
p=m.b
if(p.a.ak(s)&&p.a.e!=null){p.c=p.a.ai(s)
p.b=!1}}catch(o){r=A.S(o)
q=A.R(o)
p=t.n.a(m.a.a.c)
n=m.b
if(p.a===r)n.c=p
else n.c=A.bv(r,q)
n.b=!0}},
$S:0}
A.b9.prototype={}
A.am.prototype={
gj(a){var s,r,q=this,p={},o=new A.r($.l,t.a)
p.a=0
s=q.$ti
r=s.i("~(1)?").a(new A.bF(p,q))
t.f.a(new A.bG(p,o))
A.bi(q.a,q.b,r,!1,s.c)
return o}}
A.bF.prototype={
$1(a){this.b.$ti.c.a(a);++this.a.a},
$S(){return this.b.$ti.i("~(1)")}}
A.bG.prototype={
$0(){this.b.J(this.a.a)},
$S:0}
A.ay.prototype={$id0:1}
A.ca.prototype={
$0(){A.e_(this.a,this.b)},
$S:0}
A.bn.prototype={
ao(a){var s,r,q
t.M.a(a)
try{if(B.a===$.l){a.$0()
return}A.dk(null,null,this,a,t.p)}catch(q){s=A.S(q)
r=A.R(q)
A.c9(t.K.a(s),t.l.a(r))}},
ap(a,b,c){var s,r,q
c.i("~(0)").a(a)
c.a(b)
try{if(B.a===$.l){a.$1(b)
return}A.dl(null,null,this,a,b,t.p,c)}catch(q){s=A.S(q)
r=A.R(q)
A.c9(t.K.a(s),t.l.a(r))}},
M(a){return new A.c0(this,t.M.a(a))},
ah(a,b){return new A.c1(this,b.i("~(0)").a(a),b)},
am(a,b){b.i("0()").a(a)
if($.l===B.a)return a.$0()
return A.dk(null,null,this,a,b)},
T(a,b,c,d){c.i("@<0>").p(d).i("1(2)").a(a)
d.a(b)
if($.l===B.a)return a.$1(b)
return A.dl(null,null,this,a,b,c,d)},
an(a,b,c,d,e,f){d.i("@<0>").p(e).p(f).i("1(2,3)").a(a)
e.a(b)
f.a(c)
if($.l===B.a)return a.$2(b,c)
return A.eU(null,null,this,a,b,c,d,e,f)}}
A.c0.prototype={
$0(){return this.a.ao(this.b)},
$S:0}
A.c1.prototype={
$1(a){var s=this.c
return this.a.ap(this.b,s.a(a),s)},
$S(){return this.c.i("~(0)")}}
A.p.prototype={
gP(a){return new A.a1(a,this.gj(a),A.a9(a).i("a1<p.E>"))},
N(a,b){return this.l(a,b)},
h(a){return A.cU(a,"[","]")},
$iN:1,
$iB:1}
A.u.prototype={
A(a,b){var s,r,q,p=A.cB(this)
p.i("~(u.K,u.V)").a(b)
for(s=J.cL(this.gt()),p=p.i("u.V");s.m();){r=s.gq()
q=this.l(0,r)
b.$2(r,q==null?p.a(q):q)}},
gj(a){return J.cp(this.gt())},
h(a){return A.e2(this)},
$ibB:1}
A.bC.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=r.a+=A.h(a)
r.a=s+": "
r.a+=A.h(b)},
$S:12}
A.aR.prototype={
h(a){var s,r,q,p,o,n=this.a,m=B.e.F(n,36e8),l=n%36e8
if(n<0){m=0-m
n=0-l
s="-"}else{n=l
s=""}r=B.e.F(n,6e7)
n%=6e7
q=r<10?"0":""
p=B.e.F(n,1e6)
o=p<10?"0":""
return s+m+":"+q+r+":"+o+p+"."+B.d.al(B.e.h(n%1e6),6,"0")}}
A.i.prototype={
gB(){return A.R(this.$thrownJsError)}}
A.aL.prototype={
h(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.by(s)
return"Assertion failed"}}
A.F.prototype={}
A.L.prototype={
gL(){return"Invalid argument"+(!this.a?"(s)":"")},
gK(){return""},
h(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+p,n=s.gL()+q+o
if(!s.a)return n
return n+s.gK()+": "+A.by(s.gO())},
gO(){return this.b}}
A.aj.prototype={
gO(){return A.ew(this.b)},
gL(){return"RangeError"},
gK(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.h(q):""
else if(q==null)s=": Not greater than or equal to "+A.h(r)
else if(q>r)s=": Not in inclusive range "+A.h(r)+".."+A.h(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.h(r)
return s}}
A.aU.prototype={
gO(){return A.c8(this.b)},
gL(){return"RangeError"},
gK(){if(A.c8(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gj(a){return this.f}}
A.b8.prototype={
h(a){return"Unsupported operation: "+this.a}}
A.b6.prototype={
h(a){return"UnimplementedError: "+this.a}}
A.aP.prototype={
h(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.by(s)+"."}}
A.b_.prototype={
h(a){return"Out of Memory"},
gB(){return null},
$ii:1}
A.al.prototype={
h(a){return"Stack Overflow"},
gB(){return null},
$ii:1}
A.bQ.prototype={
h(a){return"Exception: "+this.a}}
A.q.prototype={
h(a){return"null"}}
A.j.prototype={$ij:1,
h(a){return"Instance of '"+A.bE(this)+"'"},
gn(a){return A.fb(this)},
toString(){return this.h(this)}}
A.bo.prototype={
h(a){return""},
$ia2:1}
A.b4.prototype={
gj(a){return this.a.length},
h(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.b.prototype={}
A.aI.prototype={
h(a){var s=String(a)
s.toString
return s}}
A.aJ.prototype={
h(a){var s=String(a)
s.toString
return s}}
A.A.prototype={
gj(a){return a.length}}
A.ac.prototype={
gj(a){var s=a.length
s.toString
return s}}
A.bw.prototype={}
A.bx.prototype={
h(a){var s=String(a)
s.toString
return s}}
A.aQ.prototype={
h(a){var s,r,q,p=a.left
p.toString
s=a.top
s.toString
r=a.width
r.toString
q=a.height
q.toString
return"Rectangle ("+A.h(p)+", "+A.h(s)+") "+A.h(r)+" x "+A.h(q)},
gG(a){var s=a.left
s.toString
return s},
ga3(a){var s=a.right
s.toString
return s},
gU(a){var s=a.top
s.toString
return s}}
A.aq.prototype={
gj(a){return this.a.length},
l(a,b){var s=this.a
if(!(b>=0&&b<s.length))return A.W(s,b)
return this.$ti.c.a(s[b])}}
A.n.prototype={
h(a){var s=a.localName
s.toString
return s},
gR(a){return new A.O(a,"mouseenter",!1,t.C)},
gS(a){return new A.O(a,"mouseleave",!1,t.C)},
$in:1}
A.a.prototype={$ia:1}
A.m.prototype={
ab(a,b,c,d){return a.addEventListener(b,A.bu(t.o.a(c),1),!1)},
$im:1}
A.aT.prototype={
gj(a){return a.length}}
A.x.prototype={$ix:1}
A.e.prototype={
h(a){var s=a.nodeValue
return s==null?this.a8(a):s},
$ie:1}
A.ah.prototype={
gj(a){var s=a.length
s.toString
return s},
l(a,b){var s=a.length,r=b>>>0!==b||b>=s
r.toString
if(r)throw A.d(A.cs(b,s,a,null))
s=a[b]
s.toString
return s},
N(a,b){if(!(b<a.length))return A.W(a,b)
return a[b]},
$iaX:1,
$iN:1,
$iB:1}
A.b2.prototype={
gj(a){return a.length}}
A.z.prototype={}
A.a3.prototype={$ia3:1}
A.be.prototype={
h(a){var s,r,q,p=a.left
p.toString
s=a.top
s.toString
r=a.width
r.toString
q=a.height
q.toString
return"Rectangle ("+A.h(p)+", "+A.h(s)+") "+A.h(r)+" x "+A.h(q)}}
A.as.prototype={
gj(a){var s=a.length
s.toString
return s},
l(a,b){var s=a.length,r=b>>>0!==b||b>=s
r.toString
if(r)throw A.d(A.cs(b,s,a,null))
s=a[b]
s.toString
return s},
N(a,b){if(!(b<a.length))return A.W(a,b)
return a[b]},
$iaX:1,
$iN:1,
$iB:1}
A.ba.prototype={
A(a,b){var s,r,q,p,o,n
t.U.a(b)
for(s=this.gt(),r=s.length,q=this.a,p=0;p<s.length;s.length===r||(0,A.dA)(s),++p){o=s[p]
n=q.getAttribute(o)
b.$2(o,n==null?A.V(n):n)}},
gt(){var s,r,q,p,o,n,m=this.a.attributes
m.toString
s=A.a6([],t.s)
for(r=m.length,q=t.x,p=0;p<r;++p){if(!(p<m.length))return A.W(m,p)
o=q.a(m[p])
if(o.namespaceURI==null){n=o.name
n.toString
B.b.v(s,n)}}return s}}
A.bf.prototype={
l(a,b){return this.a.getAttribute(A.V(b))},
gj(a){return this.gt().length}}
A.bd.prototype={
l(a,b){return this.a.a.getAttribute("data-"+this.a2(A.V(b)))},
A(a,b){this.a.A(0,new A.bN(this,t.U.a(b)))},
gt(){var s=A.a6([],t.s)
this.a.A(0,new A.bO(this,s))
return s},
gj(a){return this.gt().length},
a1(a){var s,r,q=A.a6(a.split("-"),t.s)
for(s=1;s<q.length;++s){r=q[s]
if(r.length>0)B.b.V(q,s,r[0].toUpperCase()+B.d.H(r,1))}return B.b.aj(q,"")},
a2(a){var s,r,q,p,o
for(s=a.length,r=0,q="";r<s;++r){p=a[r]
o=p.toLowerCase()
q=(p!==o&&r>0?q+"-":q)+o}return q.charCodeAt(0)==0?q:q}}
A.bN.prototype={
$2(a,b){if(B.d.W(a,"data-"))this.b.$2(this.a.a1(B.d.H(a,5)),b)},
$S:5}
A.bO.prototype={
$2(a,b){if(B.d.W(a,"data-"))B.b.v(this.b,this.a.a1(B.d.H(a,5)))},
$S:5}
A.cr.prototype={}
A.ap.prototype={}
A.O.prototype={}
A.bh.prototype={}
A.bP.prototype={
$1(a){return this.a.$1(t.B.a(a))},
$S:13}
A.C.prototype={
gP(a){return new A.aS(a,this.gj(a),A.a9(a).i("aS<C.E>"))}}
A.aS.prototype={
m(){var s=this,r=s.c+1,q=s.b
if(r<q){s.sa_(J.dN(s.a,r))
s.c=r
return!0}s.sa_(null)
s.c=q
return!1},
gq(){var s=this.d
return s==null?this.$ti.c.a(s):s},
sa_(a){this.d=this.$ti.i("1?").a(a)}}
A.bb.prototype={}
A.bk.prototype={}
A.bl.prototype={}
A.bp.prototype={}
A.bq.prototype={}
A.bm.prototype={
ga3(a){return this.$ti.c.a(this.a+this.c)},
h(a){var s=this
return"Rectangle ("+s.a+", "+s.b+") "+s.c+" x "+s.d}}
A.ak.prototype={
gG(a){return this.a},
gU(a){return this.b}}
A.c.prototype={
gR(a){return new A.O(a,"mouseenter",!1,t.C)},
gS(a){return new A.O(a,"mouseleave",!1,t.C)}}
A.cl.prototype={
$1(a){t.V.a(a)
A.e0(B.u,new A.ck(this.a,this.b),t.P)},
$S:1}
A.ck.prototype={
$0(){if(!this.a.a){var s=this.b.style
s.visibility="hidden"}},
$S:2}
A.cm.prototype={
$1(a){t.V.a(a)
this.a.a=!0},
$S:1}
A.cn.prototype={
$1(a){var s
t.V.a(a)
this.a.a=!1
s=this.b.style
s.visibility="hidden"},
$S:1}
A.ci.prototype={
$1(a){t.V.a(a)
A.fo(this.a)},
$S:1};(function aliases(){var s=J.ad.prototype
s.a8=s.h
s=J.U.prototype
s.a9=s.h})();(function installTearOffs(){var s=hunkHelpers._static_1,r=hunkHelpers._static_0
s(A,"f2","eb",3)
s(A,"f3","ec",3)
s(A,"f4","ed",3)
r(A,"dq","eW",0)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.j,null)
q(A.j,[A.ct,J.ad,J.aK,A.i,A.a1,A.bH,A.bD,A.at,A.M,A.y,A.bj,A.c4,A.c2,A.aa,A.ar,A.r,A.b9,A.am,A.ay,A.p,A.u,A.aR,A.b_,A.al,A.bQ,A.q,A.bo,A.b4,A.bw,A.cr,A.bh,A.C,A.aS,A.bm])
q(J.ad,[J.aV,J.af,J.w,J.a_,J.a0,J.ag,J.Z])
q(J.w,[J.U,J.v,A.m,A.bb,A.bx,A.aQ,A.a,A.bk,A.bp])
q(J.U,[J.b0,J.an,J.D])
r(J.bA,J.v)
q(J.ag,[J.ae,J.aW])
q(A.i,[A.aZ,A.F,A.aY,A.b7,A.bc,A.b1,A.bg,A.aL,A.L,A.b8,A.b6,A.aP])
r(A.ai,A.F)
q(A.M,[A.aN,A.aO,A.b5,A.ce,A.cg,A.bK,A.bJ,A.bS,A.bZ,A.bF,A.c1,A.bP,A.cl,A.cm,A.cn,A.ci])
q(A.b5,[A.b3,A.ab])
q(A.aO,[A.cf,A.bT,A.bC,A.bN,A.bO])
r(A.au,A.bg)
q(A.aN,[A.bL,A.bM,A.c3,A.bz,A.bR,A.bV,A.bU,A.bY,A.bX,A.bW,A.bG,A.ca,A.c0,A.ck])
r(A.bn,A.ay)
q(A.L,[A.aj,A.aU])
r(A.e,A.m)
q(A.e,[A.n,A.A,A.a3])
q(A.n,[A.b,A.c])
q(A.b,[A.aI,A.aJ,A.aT,A.b2])
r(A.ac,A.bb)
r(A.aq,A.p)
r(A.z,A.a)
r(A.x,A.z)
r(A.bl,A.bk)
r(A.ah,A.bl)
r(A.be,A.aQ)
r(A.bq,A.bp)
r(A.as,A.bq)
q(A.u,[A.ba,A.bd])
r(A.bf,A.ba)
r(A.ap,A.am)
r(A.O,A.ap)
r(A.ak,A.bm)
s(A.bb,A.bw)
s(A.bk,A.p)
s(A.bl,A.C)
s(A.bp,A.p)
s(A.bq,A.C)})()
var v={typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{aE:"int",f8:"double",aG:"num",f:"String",cb:"bool",q:"Null",B:"List"},mangledNames:{},types:["~()","~(x)","q()","~(~())","q(@)","~(f,f)","@(@)","@(@,f)","@(f)","q(~())","q(j,a2)","r<@>(@)","~(j?,j?)","~(a)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.es(v.typeUniverse,JSON.parse('{"b0":"U","an":"U","D":"U","fu":"a","fA":"a","ft":"c","fB":"c","fv":"b","fE":"b","fC":"e","fz":"e","fS":"m","fF":"x","fx":"z","fw":"A","fH":"A","fD":"n","aV":{"cb":[],"E":[]},"af":{"q":[],"E":[]},"v":{"B":["1"],"N":["1"]},"bA":{"v":["1"],"B":["1"],"N":["1"]},"ag":{"aG":[]},"ae":{"aE":[],"aG":[],"E":[]},"aW":{"aG":[],"E":[]},"Z":{"f":[],"cW":[],"E":[]},"aZ":{"i":[]},"ai":{"F":[],"i":[]},"aY":{"i":[]},"b7":{"i":[]},"at":{"a2":[]},"M":{"T":[]},"aN":{"T":[]},"aO":{"T":[]},"b5":{"T":[]},"b3":{"T":[]},"ab":{"T":[]},"bc":{"i":[]},"b1":{"i":[]},"bg":{"i":[]},"au":{"F":[],"i":[]},"r":{"Y":["1"]},"aa":{"i":[]},"ay":{"d0":[]},"bn":{"ay":[],"d0":[]},"p":{"B":["1"],"N":["1"]},"u":{"bB":["1","2"]},"aE":{"aG":[]},"f":{"cW":[]},"aL":{"i":[]},"F":{"i":[]},"L":{"i":[]},"aj":{"i":[]},"aU":{"i":[]},"b8":{"i":[]},"b6":{"i":[]},"aP":{"i":[]},"b_":{"i":[]},"al":{"i":[]},"bo":{"a2":[]},"n":{"e":[],"m":[]},"x":{"a":[]},"e":{"m":[]},"b":{"n":[],"e":[],"m":[]},"aI":{"n":[],"e":[],"m":[]},"aJ":{"n":[],"e":[],"m":[]},"A":{"e":[],"m":[]},"aq":{"p":["1"],"B":["1"],"N":["1"],"p.E":"1"},"aT":{"n":[],"e":[],"m":[]},"ah":{"p":["e"],"C":["e"],"B":["e"],"aX":["e"],"N":["e"],"p.E":"e","C.E":"e"},"b2":{"n":[],"e":[],"m":[]},"z":{"a":[]},"a3":{"e":[],"m":[]},"as":{"p":["e"],"C":["e"],"B":["e"],"aX":["e"],"N":["e"],"p.E":"e","C.E":"e"},"ba":{"u":["f","f"],"bB":["f","f"]},"bf":{"u":["f","f"],"bB":["f","f"],"u.K":"f","u.V":"f"},"bd":{"u":["f","f"],"bB":["f","f"],"u.K":"f","u.V":"f"},"ap":{"am":["1"]},"O":{"ap":["1"],"am":["1"]},"ak":{"bm":["1"]},"c":{"n":[],"e":[],"m":[]}}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type"}
var t=(function rtii(){var s=A.dt
return{n:s("aa"),h:s("n"),R:s("i"),B:s("a"),Z:s("T"),d:s("Y<@>"),s:s("v<f>"),b:s("v<@>"),T:s("af"),g:s("D"),D:s("aX<@>"),V:s("x"),P:s("q"),K:s("j"),L:s("fG"),E:s("ak<aE>"),l:s("a2"),N:s("f"),k:s("E"),e:s("F"),G:s("an"),x:s("a3"),C:s("O<x>"),W:s("aq<n>"),c:s("r<@>"),a:s("r<aE>"),y:s("cb"),m:s("cb(j)"),i:s("f8"),z:s("@"),O:s("@()"),v:s("@(j)"),Q:s("@(j,a2)"),S:s("aE"),A:s("0&*"),_:s("j*"),Y:s("Y<q>?"),X:s("j?"),F:s("ar<@,@>?"),o:s("@(a)?"),f:s("~()?"),H:s("aG"),p:s("~"),M:s("~()"),U:s("~(f,f)")}})();(function constants(){B.v=J.ad.prototype
B.b=J.v.prototype
B.e=J.ae.prototype
B.c=J.ag.prototype
B.d=J.Z.prototype
B.w=J.D.prototype
B.x=J.w.prototype
B.j=J.b0.prototype
B.f=J.an.prototype
B.h=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.k=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (self.HTMLElement && object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof navigator == "object";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.p=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var ua = navigator.userAgent;
    if (ua.indexOf("DumpRenderTree") >= 0) return hooks;
    if (ua.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.l=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.m=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.o=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.n=function(hooks) {
  var userAgent = typeof navigator == "object" ? navigator.userAgent : "";
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.i=function(hooks) { return hooks; }

B.q=new A.b_()
B.a=new A.bn()
B.r=new A.bo()
B.t=new A.aR(0)
B.u=new A.aR(16e3)})();(function staticFields(){$.c_=null
$.K=A.a6([],A.dt("v<j>"))
$.cQ=null
$.cP=null
$.du=null
$.dp=null
$.dz=null
$.cc=null
$.ch=null
$.cI=null
$.a5=null
$.az=null
$.aA=null
$.cE=!1
$.l=B.a})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal
s($,"fy","dC",()=>A.fa("_$dart_dartClosure"))
s($,"fI","dD",()=>A.G(A.bI({
toString:function(){return"$receiver$"}})))
s($,"fJ","dE",()=>A.G(A.bI({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"fK","dF",()=>A.G(A.bI(null)))
s($,"fL","dG",()=>A.G(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"fO","dJ",()=>A.G(A.bI(void 0)))
s($,"fP","dK",()=>A.G(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"fN","dI",()=>A.G(A.cZ(null)))
s($,"fM","dH",()=>A.G(function(){try{null.$method$}catch(r){return r.message}}()))
s($,"fR","dM",()=>A.G(A.cZ(void 0)))
s($,"fQ","dL",()=>A.G(function(){try{(void 0).$method$}catch(r){return r.message}}()))
s($,"fT","cK",()=>A.ea())})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({DOMError:J.w,MediaError:J.w,Navigator:J.w,NavigatorConcurrentHardware:J.w,NavigatorUserMediaError:J.w,OverconstrainedError:J.w,PositionError:J.w,GeolocationPositionError:J.w,Screen:J.w,HTMLAudioElement:A.b,HTMLBRElement:A.b,HTMLBaseElement:A.b,HTMLBodyElement:A.b,HTMLButtonElement:A.b,HTMLCanvasElement:A.b,HTMLContentElement:A.b,HTMLDListElement:A.b,HTMLDataElement:A.b,HTMLDataListElement:A.b,HTMLDetailsElement:A.b,HTMLDialogElement:A.b,HTMLDivElement:A.b,HTMLEmbedElement:A.b,HTMLFieldSetElement:A.b,HTMLHRElement:A.b,HTMLHeadElement:A.b,HTMLHeadingElement:A.b,HTMLHtmlElement:A.b,HTMLIFrameElement:A.b,HTMLImageElement:A.b,HTMLInputElement:A.b,HTMLLIElement:A.b,HTMLLabelElement:A.b,HTMLLegendElement:A.b,HTMLLinkElement:A.b,HTMLMapElement:A.b,HTMLMediaElement:A.b,HTMLMenuElement:A.b,HTMLMetaElement:A.b,HTMLMeterElement:A.b,HTMLModElement:A.b,HTMLOListElement:A.b,HTMLObjectElement:A.b,HTMLOptGroupElement:A.b,HTMLOptionElement:A.b,HTMLOutputElement:A.b,HTMLParagraphElement:A.b,HTMLParamElement:A.b,HTMLPictureElement:A.b,HTMLPreElement:A.b,HTMLProgressElement:A.b,HTMLQuoteElement:A.b,HTMLScriptElement:A.b,HTMLShadowElement:A.b,HTMLSlotElement:A.b,HTMLSourceElement:A.b,HTMLSpanElement:A.b,HTMLStyleElement:A.b,HTMLTableCaptionElement:A.b,HTMLTableCellElement:A.b,HTMLTableDataCellElement:A.b,HTMLTableHeaderCellElement:A.b,HTMLTableColElement:A.b,HTMLTableElement:A.b,HTMLTableRowElement:A.b,HTMLTableSectionElement:A.b,HTMLTemplateElement:A.b,HTMLTextAreaElement:A.b,HTMLTimeElement:A.b,HTMLTitleElement:A.b,HTMLTrackElement:A.b,HTMLUListElement:A.b,HTMLUnknownElement:A.b,HTMLVideoElement:A.b,HTMLDirectoryElement:A.b,HTMLFontElement:A.b,HTMLFrameElement:A.b,HTMLFrameSetElement:A.b,HTMLMarqueeElement:A.b,HTMLElement:A.b,HTMLAnchorElement:A.aI,HTMLAreaElement:A.aJ,CDATASection:A.A,CharacterData:A.A,Comment:A.A,ProcessingInstruction:A.A,Text:A.A,CSSStyleDeclaration:A.ac,MSStyleCSSProperties:A.ac,CSS2Properties:A.ac,DOMException:A.bx,DOMRectReadOnly:A.aQ,MathMLElement:A.n,Element:A.n,AbortPaymentEvent:A.a,AnimationEvent:A.a,AnimationPlaybackEvent:A.a,ApplicationCacheErrorEvent:A.a,BackgroundFetchClickEvent:A.a,BackgroundFetchEvent:A.a,BackgroundFetchFailEvent:A.a,BackgroundFetchedEvent:A.a,BeforeInstallPromptEvent:A.a,BeforeUnloadEvent:A.a,BlobEvent:A.a,CanMakePaymentEvent:A.a,ClipboardEvent:A.a,CloseEvent:A.a,CustomEvent:A.a,DeviceMotionEvent:A.a,DeviceOrientationEvent:A.a,ErrorEvent:A.a,ExtendableEvent:A.a,ExtendableMessageEvent:A.a,FetchEvent:A.a,FontFaceSetLoadEvent:A.a,ForeignFetchEvent:A.a,GamepadEvent:A.a,HashChangeEvent:A.a,InstallEvent:A.a,MediaEncryptedEvent:A.a,MediaKeyMessageEvent:A.a,MediaQueryListEvent:A.a,MediaStreamEvent:A.a,MediaStreamTrackEvent:A.a,MessageEvent:A.a,MIDIConnectionEvent:A.a,MIDIMessageEvent:A.a,MutationEvent:A.a,NotificationEvent:A.a,PageTransitionEvent:A.a,PaymentRequestEvent:A.a,PaymentRequestUpdateEvent:A.a,PopStateEvent:A.a,PresentationConnectionAvailableEvent:A.a,PresentationConnectionCloseEvent:A.a,ProgressEvent:A.a,PromiseRejectionEvent:A.a,PushEvent:A.a,RTCDataChannelEvent:A.a,RTCDTMFToneChangeEvent:A.a,RTCPeerConnectionIceEvent:A.a,RTCTrackEvent:A.a,SecurityPolicyViolationEvent:A.a,SensorErrorEvent:A.a,SpeechRecognitionError:A.a,SpeechRecognitionEvent:A.a,SpeechSynthesisEvent:A.a,StorageEvent:A.a,SyncEvent:A.a,TrackEvent:A.a,TransitionEvent:A.a,WebKitTransitionEvent:A.a,VRDeviceEvent:A.a,VRDisplayEvent:A.a,VRSessionEvent:A.a,MojoInterfaceRequestEvent:A.a,ResourceProgressEvent:A.a,USBConnectionEvent:A.a,IDBVersionChangeEvent:A.a,AudioProcessingEvent:A.a,OfflineAudioCompletionEvent:A.a,WebGLContextEvent:A.a,Event:A.a,InputEvent:A.a,SubmitEvent:A.a,Window:A.m,DOMWindow:A.m,EventTarget:A.m,HTMLFormElement:A.aT,MouseEvent:A.x,DragEvent:A.x,PointerEvent:A.x,WheelEvent:A.x,Document:A.e,DocumentFragment:A.e,HTMLDocument:A.e,ShadowRoot:A.e,XMLDocument:A.e,DocumentType:A.e,Node:A.e,NodeList:A.ah,RadioNodeList:A.ah,HTMLSelectElement:A.b2,CompositionEvent:A.z,FocusEvent:A.z,KeyboardEvent:A.z,TextEvent:A.z,TouchEvent:A.z,UIEvent:A.z,Attr:A.a3,ClientRect:A.be,DOMRect:A.be,NamedNodeMap:A.as,MozNamedAttrMap:A.as,SVGAElement:A.c,SVGAnimateElement:A.c,SVGAnimateMotionElement:A.c,SVGAnimateTransformElement:A.c,SVGAnimationElement:A.c,SVGCircleElement:A.c,SVGClipPathElement:A.c,SVGDefsElement:A.c,SVGDescElement:A.c,SVGDiscardElement:A.c,SVGEllipseElement:A.c,SVGFEBlendElement:A.c,SVGFEColorMatrixElement:A.c,SVGFEComponentTransferElement:A.c,SVGFECompositeElement:A.c,SVGFEConvolveMatrixElement:A.c,SVGFEDiffuseLightingElement:A.c,SVGFEDisplacementMapElement:A.c,SVGFEDistantLightElement:A.c,SVGFEFloodElement:A.c,SVGFEFuncAElement:A.c,SVGFEFuncBElement:A.c,SVGFEFuncGElement:A.c,SVGFEFuncRElement:A.c,SVGFEGaussianBlurElement:A.c,SVGFEImageElement:A.c,SVGFEMergeElement:A.c,SVGFEMergeNodeElement:A.c,SVGFEMorphologyElement:A.c,SVGFEOffsetElement:A.c,SVGFEPointLightElement:A.c,SVGFESpecularLightingElement:A.c,SVGFESpotLightElement:A.c,SVGFETileElement:A.c,SVGFETurbulenceElement:A.c,SVGFilterElement:A.c,SVGForeignObjectElement:A.c,SVGGElement:A.c,SVGGeometryElement:A.c,SVGGraphicsElement:A.c,SVGImageElement:A.c,SVGLineElement:A.c,SVGLinearGradientElement:A.c,SVGMarkerElement:A.c,SVGMaskElement:A.c,SVGMetadataElement:A.c,SVGPathElement:A.c,SVGPatternElement:A.c,SVGPolygonElement:A.c,SVGPolylineElement:A.c,SVGRadialGradientElement:A.c,SVGRectElement:A.c,SVGScriptElement:A.c,SVGSetElement:A.c,SVGStopElement:A.c,SVGStyleElement:A.c,SVGElement:A.c,SVGSVGElement:A.c,SVGSwitchElement:A.c,SVGSymbolElement:A.c,SVGTSpanElement:A.c,SVGTextContentElement:A.c,SVGTextElement:A.c,SVGTextPathElement:A.c,SVGTextPositioningElement:A.c,SVGTitleElement:A.c,SVGUseElement:A.c,SVGViewElement:A.c,SVGGradientElement:A.c,SVGComponentTransferFunctionElement:A.c,SVGFEDropShadowElement:A.c,SVGMPathElement:A.c})
hunkHelpers.setOrUpdateLeafTags({DOMError:true,MediaError:true,Navigator:true,NavigatorConcurrentHardware:true,NavigatorUserMediaError:true,OverconstrainedError:true,PositionError:true,GeolocationPositionError:true,Screen:true,HTMLAudioElement:true,HTMLBRElement:true,HTMLBaseElement:true,HTMLBodyElement:true,HTMLButtonElement:true,HTMLCanvasElement:true,HTMLContentElement:true,HTMLDListElement:true,HTMLDataElement:true,HTMLDataListElement:true,HTMLDetailsElement:true,HTMLDialogElement:true,HTMLDivElement:true,HTMLEmbedElement:true,HTMLFieldSetElement:true,HTMLHRElement:true,HTMLHeadElement:true,HTMLHeadingElement:true,HTMLHtmlElement:true,HTMLIFrameElement:true,HTMLImageElement:true,HTMLInputElement:true,HTMLLIElement:true,HTMLLabelElement:true,HTMLLegendElement:true,HTMLLinkElement:true,HTMLMapElement:true,HTMLMediaElement:true,HTMLMenuElement:true,HTMLMetaElement:true,HTMLMeterElement:true,HTMLModElement:true,HTMLOListElement:true,HTMLObjectElement:true,HTMLOptGroupElement:true,HTMLOptionElement:true,HTMLOutputElement:true,HTMLParagraphElement:true,HTMLParamElement:true,HTMLPictureElement:true,HTMLPreElement:true,HTMLProgressElement:true,HTMLQuoteElement:true,HTMLScriptElement:true,HTMLShadowElement:true,HTMLSlotElement:true,HTMLSourceElement:true,HTMLSpanElement:true,HTMLStyleElement:true,HTMLTableCaptionElement:true,HTMLTableCellElement:true,HTMLTableDataCellElement:true,HTMLTableHeaderCellElement:true,HTMLTableColElement:true,HTMLTableElement:true,HTMLTableRowElement:true,HTMLTableSectionElement:true,HTMLTemplateElement:true,HTMLTextAreaElement:true,HTMLTimeElement:true,HTMLTitleElement:true,HTMLTrackElement:true,HTMLUListElement:true,HTMLUnknownElement:true,HTMLVideoElement:true,HTMLDirectoryElement:true,HTMLFontElement:true,HTMLFrameElement:true,HTMLFrameSetElement:true,HTMLMarqueeElement:true,HTMLElement:false,HTMLAnchorElement:true,HTMLAreaElement:true,CDATASection:true,CharacterData:true,Comment:true,ProcessingInstruction:true,Text:true,CSSStyleDeclaration:true,MSStyleCSSProperties:true,CSS2Properties:true,DOMException:true,DOMRectReadOnly:false,MathMLElement:true,Element:false,AbortPaymentEvent:true,AnimationEvent:true,AnimationPlaybackEvent:true,ApplicationCacheErrorEvent:true,BackgroundFetchClickEvent:true,BackgroundFetchEvent:true,BackgroundFetchFailEvent:true,BackgroundFetchedEvent:true,BeforeInstallPromptEvent:true,BeforeUnloadEvent:true,BlobEvent:true,CanMakePaymentEvent:true,ClipboardEvent:true,CloseEvent:true,CustomEvent:true,DeviceMotionEvent:true,DeviceOrientationEvent:true,ErrorEvent:true,ExtendableEvent:true,ExtendableMessageEvent:true,FetchEvent:true,FontFaceSetLoadEvent:true,ForeignFetchEvent:true,GamepadEvent:true,HashChangeEvent:true,InstallEvent:true,MediaEncryptedEvent:true,MediaKeyMessageEvent:true,MediaQueryListEvent:true,MediaStreamEvent:true,MediaStreamTrackEvent:true,MessageEvent:true,MIDIConnectionEvent:true,MIDIMessageEvent:true,MutationEvent:true,NotificationEvent:true,PageTransitionEvent:true,PaymentRequestEvent:true,PaymentRequestUpdateEvent:true,PopStateEvent:true,PresentationConnectionAvailableEvent:true,PresentationConnectionCloseEvent:true,ProgressEvent:true,PromiseRejectionEvent:true,PushEvent:true,RTCDataChannelEvent:true,RTCDTMFToneChangeEvent:true,RTCPeerConnectionIceEvent:true,RTCTrackEvent:true,SecurityPolicyViolationEvent:true,SensorErrorEvent:true,SpeechRecognitionError:true,SpeechRecognitionEvent:true,SpeechSynthesisEvent:true,StorageEvent:true,SyncEvent:true,TrackEvent:true,TransitionEvent:true,WebKitTransitionEvent:true,VRDeviceEvent:true,VRDisplayEvent:true,VRSessionEvent:true,MojoInterfaceRequestEvent:true,ResourceProgressEvent:true,USBConnectionEvent:true,IDBVersionChangeEvent:true,AudioProcessingEvent:true,OfflineAudioCompletionEvent:true,WebGLContextEvent:true,Event:false,InputEvent:false,SubmitEvent:false,Window:true,DOMWindow:true,EventTarget:false,HTMLFormElement:true,MouseEvent:true,DragEvent:true,PointerEvent:true,WheelEvent:true,Document:true,DocumentFragment:true,HTMLDocument:true,ShadowRoot:true,XMLDocument:true,DocumentType:true,Node:false,NodeList:true,RadioNodeList:true,HTMLSelectElement:true,CompositionEvent:true,FocusEvent:true,KeyboardEvent:true,TextEvent:true,TouchEvent:true,UIEvent:false,Attr:true,ClientRect:true,DOMRect:true,NamedNodeMap:true,MozNamedAttrMap:true,SVGAElement:true,SVGAnimateElement:true,SVGAnimateMotionElement:true,SVGAnimateTransformElement:true,SVGAnimationElement:true,SVGCircleElement:true,SVGClipPathElement:true,SVGDefsElement:true,SVGDescElement:true,SVGDiscardElement:true,SVGEllipseElement:true,SVGFEBlendElement:true,SVGFEColorMatrixElement:true,SVGFEComponentTransferElement:true,SVGFECompositeElement:true,SVGFEConvolveMatrixElement:true,SVGFEDiffuseLightingElement:true,SVGFEDisplacementMapElement:true,SVGFEDistantLightElement:true,SVGFEFloodElement:true,SVGFEFuncAElement:true,SVGFEFuncBElement:true,SVGFEFuncGElement:true,SVGFEFuncRElement:true,SVGFEGaussianBlurElement:true,SVGFEImageElement:true,SVGFEMergeElement:true,SVGFEMergeNodeElement:true,SVGFEMorphologyElement:true,SVGFEOffsetElement:true,SVGFEPointLightElement:true,SVGFESpecularLightingElement:true,SVGFESpotLightElement:true,SVGFETileElement:true,SVGFETurbulenceElement:true,SVGFilterElement:true,SVGForeignObjectElement:true,SVGGElement:true,SVGGeometryElement:true,SVGGraphicsElement:true,SVGImageElement:true,SVGLineElement:true,SVGLinearGradientElement:true,SVGMarkerElement:true,SVGMaskElement:true,SVGMetadataElement:true,SVGPathElement:true,SVGPatternElement:true,SVGPolygonElement:true,SVGPolylineElement:true,SVGRadialGradientElement:true,SVGRectElement:true,SVGScriptElement:true,SVGSetElement:true,SVGStopElement:true,SVGStyleElement:true,SVGElement:true,SVGSVGElement:true,SVGSwitchElement:true,SVGSymbolElement:true,SVGTSpanElement:true,SVGTextContentElement:true,SVGTextElement:true,SVGTextPathElement:true,SVGTextPositioningElement:true,SVGTitleElement:true,SVGUseElement:true,SVGViewElement:true,SVGGradientElement:true,SVGComponentTransferFunctionElement:true,SVGFEDropShadowElement:true,SVGMPathElement:true})})()
Function.prototype.$0=function(){return this()}
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q)s[q].removeEventListener("load",onLoad,false)
a(b.target)}for(var r=0;r<s.length;++r)s[r].addEventListener("load",onLoad,false)})(function(a){v.currentScript=a
var s=A.fk
if(typeof dartMainRunner==="function")dartMainRunner(s,[])
else s([])})})()
//# sourceMappingURL=main.dart.js.map
