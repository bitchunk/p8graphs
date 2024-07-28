pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--knutil_0.14.0
--@shiftalow / bitchunk
version='v0.14.0'
--set1:basic
function amid(...)
	return mid(-...,...)
end

function bpack(w,s,b,...)
return b and flr(0x.ffff<<add(w,deli(w,1))&b)<<s|bpack(w,s-w[1],...) or 0
end

function bunpack(b,s,w,...)
if w then
return flr(0x.ffff<<w&b>>>s),bunpack(b,s-(... or 0),...)
end
end

function cat(f,...)
foreach({...},function(s)
for k,v in pairs(s) do
if tonum(k) then
add(f,v)
else
f[k]=v
end
end
end)
return f
end

function comb(k,v)
local a={}
for i=1,#k do
a[k[i]]=v[i]
end
return a
end

function ecpalt(p)
	palt()
	tmap(p,function(v,i)
		palt(i,v==0)
	end)
end

function htd(b,n)
	local a={}
	foreach(msplit(b,n or 2),function(v)
		add(a,tonum('0x'..v))
	end)
	return a
end

function htbl(ht,c)
local t,k,rt={}
ht,c=split(ht,'') or ht,c or 1
while 1 do
local p=ht[c]
c+=1
if p=='{' or p=='=' then
rt,c=htbl(ht,c)
if not k then
add(t,rt)
else
t[k],k=p=='{' and rt or rt[1]
end
elseif not p or p=='}' or p==';' or p==' ' then
if k=='false' then k=false
elseif k=='nil' then k=nil
else k=k=='true' or tonum(k) or k
end
add(t,k)
rt,k=p and c or nil
if p~=' ' then
break
end
elseif p~="\n" then
k=(k or '')..p
end
end
return t,rt
end

function inrng(...)
return mid(...)==...
end

function join(d,s,...)
return not s and '' or not ... and s or s..d..join(d,...)
end
function join(d,s,...)
	local a={...}
	while a[1] do
	s..=d..deli(a,1)
	end
	return s or ''
end

function mkpal(p,s,...)
	if s then
		return comb(htd(p,1) or p,htd(s,1) or s),mkpal(p,...)
	end
end

function msplit(s,d,...)
	local t=split(s,d or ' ',false)
	if ... then
		for i,v in pairs(t) do
			t[i]=msplit(v,...)
		end
	end
	return t
end

function oprint(s,x,y,f,o,p)
 foreach(split(p or '\+ff\^h,\+gf\^h,\+hf\^h,\+fg\^h,\+hg\^h,\+fh\^h,\+gh\^h,\+hh\^h,'),function(v)
  ?v..s,x,y,v~='' and o or f
 end)
end

function rceach(p,f)
p=_rfmt(p)
for y=p.y,p.ey do
for x=p.x,p.ex do
f(x,y,p)
end
end
end

function replace(s,f,r,...)
local a,i='',1
while i<=#s do
if sub(s,i,i+#f-1)~=f then
a..=sub(s,i,i)
i+=1
else
a..=r or ''
i+=#f
end
end
return ... and replace(a,...) or a
end

function tbfill(v,s,e,...)
local t={}
for i=s,e do
t[i]=... and tbfill(v,...) or v
end
return t
end

function tmap(t,f)
for i,v in pairs(t) do
v=f(v,i)
if v~=nil then
t[i]=v
end
end
return t
end

function tohex(v,d)
v=sub(tostr(tonum(v),1),3,6)
while v[1]=='0' and #v>(d or 0) do
v=sub(v,2)
end
return v
end

function ttable(p)
return count(p) and p
end
-->8
--set2:objects
--exrect
_mkrs,_hovk,_mnb=htbl'x y w h ex ey r p'
,htbl'{x y}{x ey}{ex y}{ex ey}'
,htbl'con hov ud rs rf cs cf os of cam'
function _rfmt(p)
local x,y,w,h=unpack(ttable(p) or split(p,' ',true))
return comb(_mkrs,{x,y,w,h,x+w-1,y+h-1,w/2,p})
end

function exrect(p)
local o=_rfmt(p)
return cat(o,comb(_mnb,{
function(p,y)
if y then
return inrng(p,o.x,o.ex) and inrng(y,o.y,o.ey)
else
return o.con(p.x,p.y) and o.con(p.ex,p.ey)
end
end
,function(r,i)
local h
for i,v in pairs(_hovk) do
h=h or o.con(r[v[1]],r[v[2]])
end
return h or i==nil and r.hov(o,true)
end
,function(p,y,w,h)
return cat(
o,_rfmt((tonum(p) or not p) and {p or o.x,y or o.y,w or o.w,h or o.h} or p
))
end
,function(col,f)
local c=o.cam
f=(f or rect)(o.x-c.x,o.y-c.y,o.ex-c.x,o.ey-c.y,col)
return o
end
,function(col)
return o.rs(col,rectfill)
end
,function(col,f)
(f or circ)(o.x+o.r-o.cam.x,o.y+o.r-o.cam.y,o.w/2,col)
return o
end
,function(col)
return o.cs(col,circfill)
end
,function(col)
return o.rs(col,oval)
end
,function(col)
return o.rs(col,ovalfill)
end
,{x=0,y=0}
}))
end

--scenes
_odkey=msplit'_rate _cnt _rm _fst _lst _nm _dur _prm'
function scorder(...)
local o={}
return cat(o,comb(_odkey,{
function(d,r,c)
local f,t=unpack(ttable(d) or msplit(d))
r=r or _dur
return min(c or _cnt,r)/max(r,1)*(t-f)+f
end
,0,false,true,false
,...
}))
end

_scal={}
function mkscenes(keys)
return tmap(ttable(keys) or {keys},function(v)
local o={}
_scal[v]=cat(o,comb(msplit'ps st rm cl fi cu us env tra ords nm',{
function(...)
return add(o.ords,scorder(...))
end
,function(...)
o.cl()
return o.ps(...)
end
,function(s)
s=s and o.fi(s) or not s and o.cu()
if s then
del(o.ords,s)._rm=true
end
return s
end
,function()
local s={}
while add(s,o.rm()) do
end
return s
end
,function(key)
for v in all(o.ords) do
if v._nm==key or _nm==key or key==v then
return v end
end
end
,function(n)
return o.ords[n or 1]
end
,function(...)
return add(o.ords,scorder(...),1)
end
,function(c)
foreach(_odkey,function(v)
_ENV[v],c[v]=c[v],_ENV[v]
end)
return c
end
,function(n)
local c=o.cu(n)
if c then
o.env(c)
_cnt+=1
_cnt,_fst,_lst=_cnt==0x7fff and 1 or _cnt,_cnt==1,inrng(_dur,1,_cnt)
if _rm or _nm and _ENV[_nm] and _ENV[_nm](c) or _lst then
o.rm(o.env(c))
else
o.env(c)
end
end
end
,{},v
}))
return o
end)
end

function scmd(b,p,...)
return tmap(msplit(replace(b,"\t",""),"\n",' '),function(v)
local s,m,f,d=unpack(v)
return _scal[s] and _scal[s][m](f,tonum(d),p or {}) or false
end)
,... and scmd(...)
end
cmdscenes=scmd

function transition(v)
 v.tra()
end
-->8
--set3:debugging
--dmp
function dmp(v,q,s)
	if not s then
	 q,s,_dmpx,_dmpy="\f6","\n",0,-1
	end
	local p,t=s
	tmap(ttable(v) or {v},function(str,i)
		t=type(str)
		if ttable(str) then
			q,p=dmp(str,q..s..i.."{",s.." ")..s.."\f6}",s
		else
		 q..=join('',p,i
		 ,comb(msplit"number string boolean function nil"
		 ,msplit"\ff#\f6:\ff \fc$\f6:\fc \fe%\f6:\fe \fb*\f6:\fb \f2!\f6:\f2"
			)[t],tostr(str),"\f6 ")
			p=""
		end
	end)
	q..=t and "" or s.."\f2!\f6:\f2nil"
	::dmp::
	_update_buttons()
	if s=="\n" and not btnp'5' then
		flip()
		cls()
		?q,_dmpx*4,_dmpy*6
		_dmpx+=_kd'0'-_kd'1'
		_dmpy+=_kd'2'-_kd'3'
		goto dmp
	end
	return q
end

function _kd(d)
return tonum(btn(d))
end

--dbg
function dbg(...)
	local p,d={},{...}
	for i=1,#d do
		if add(p,tostr(d[i]))=='d?' then
			tmap(_dbgv,function(v,i)
				oprint(join(' ',unpack(v)),0,128-i*6,5,7)
			end)
			_dbgv,p={}
		end
	end
	add(_dbgv,p,1)
end
dbg'd?'
-->8


function _init()
upd=mkscenes(msplit'fsc set key flc ftr')
drw=mkscenes(msplit'drw')
flws={}

scmd([[
key st keycheck 0
drw st flowerd 0
ftr st flowert 0
]]
)
flowerofseed()
--stop()
--sample()
--pal(tbfill(7,0,15))
--pal(4,4)
--pal(2,2)
--pal(11,11)
--pal(7,9)
--pal(5,10)
--pal(10,15)
--pal(9,7)
--pal(15,11)


local t=htbl[[
{{
{1 1 0 11 0 0}
{2 6 0 11 0 0.0}
{3 6 0 11 0 0.0}
{4 6 0 11 0 0.25}
{5 6 0 11 0 0.0}
{6 6 0 11 0 0.11}
{7 6 0 11 0 0.39}
} 1}
{{
{1 1 0 11 0 0}
{2 6 0 11 16 0.0}
{3 6 0 11 32 0.0}
{4 6 0 11 28 0.25}
{5 6 0 11 48 0.0}
{6 6 0 11 42 0.11}
{7 6 0 11 42 0.39}
} 60}
{{
{1 1 16 11 0 0}
{2 6 16 14 16 0.0}
{3 6 16 10 32 0.0}
{4 6 16 9 28 0.25}
{5 6 16 6 48 0.0}
{6 6 16 5 42 0.11}
{7 6 16 5 42 0.39}
} 60}
]]
scmd([[
fsc st fsetscript 1
]],t)

t=htbl[[
{{
{1 1 128 11 0 0}
{2 6 16 14 128 0.0}
{3 6 16 10 160 0.0}
{4 6 16 9 152 0.25}
{5 6 16 6 224 0.0}
{6 6 16 5 212 0.11}
{7 6 16 5 212 0.39}
} 60}
{{
} 4}
{{
{1 1 16 11 0 0}
{2 6 16 14 16 0.0}
{3 6 16 10 32 0.0}
{4 6 16 9 28 0.25}
{5 6 16 6 48 0.0}
{6 6 16 5 42 0.11}
{7 6 16 5 42 0.39}
} 1}
]]
scmd([[
fsc ps fsetscript 0
]],t)
--id,number,radius,col,distance,angle

end
function _update60()
	foreach(upd,transition)
end
function _draw()

	foreach(drw,transition)
--	for i=1,15 do
--	rectfill(i*4,0,i*4+4,4,i)
--	?tohex(i,1),i*4,5
--	end

--	dbg(stat(0))
	?dbg'd?'
end
-->8
function flowert()
	
end

function ftrace(f,t,ofs)
--	ofs=10
	local fl={}
	for i=f,t do
		add(fls,tmap(clone(flws[i]),function(v)
			v[1]+=ofs
		end))
	end
	flowers()
--	
end

function flset(ps,w)
scmd(replace([[
set ps flowers 1
set ps nil -w-
flc ps nil 1
flc ps flowerc -w-
]],'-w-',w)
,ps
)
end

function fsetscript(o)
	if _fst then
	tmap(_prm,function(v)
		flset(unpack(v))
	end)
	elseif #_scal.set.ords==0 then
		scmd([[
			fsc st fsetscript 0
		]],_prm)
	end
end

function flowers(fp)
	tmap(_prm or fp,function(v,i)
		local i,n,r,c,d,a=unpack(v)
		local f,sc={}
		for j=1,n do
			local pf,x,y,sr,sa,sd=flws[i] and flws[i][j],64,64,0,0,0
			if pf then
				x,y,sr,sc,sa,sd=unpack(pf)
			end
		 --sx,sy,ex,ey,distance,radius,col,wait
			f[j]={
				x,y,sr,c,sa,sd --current
				,sr,sa,sd  --start
				,r,a,d,n				--end & prms
			}
			
		end
		flws[i]=f
	end)
end

function flowerc()
	tmap(flws,function(v)
		tmap(v,function(v,j)
--			local x,y,r,c,a,sx,sy,sr,sa,er,ea,d,n=unpack(v)
			local pr
			,x,y,r,c,a,d
			,sr,sa,sd
			,er,ea,ed,n=(sin(_rate'0 -0.25')),unpack(v)
			a=_rate({sa,ea},_dur,_cnt*pr)
			d=_rate({sd,ed},_dur,_cnt*pr)
			local ex,ey=
			d*sin(j/n+a)+64
			,d*cos(j/n+a)+64
			r=(_rate({sr,er},_dur,_cnt*pr))\1
--dbg(_cnt*pr/_dur)
--			dbg(x,y,r,sr,er)
--			dbg(sx,sy,sr,er)
			if _lst then
				sr,sa,sd=er,ea,ed
			end
			return {ex,ey,r,c,a,d,sr,sa,sd,er,ea,ed,n}
		end)
	end)

	if _lst then
--		scmd([[
--		drw st flowerd 0
--		set st flowers 1
--		]],_prm)
	end
end

function flowerd()
	cls()
--	foreach()
	
	tmap(flws,function(v)
		tmap(v,function(v)
--			local sx,sy,sr,sa,er,ea,c,d,n=unpack(v)
			circ(unpack(v))
		end)
	end)
	
end
-->8
function flowerofseed()
pal(htd'f202f404f9fe070809ff0af7',1)

local t=htbl[[
{{
{1 1 0 11 0 0}
{2 6 0 11 0 0.0}
{3 6 0 11 0 0.0}
{4 6 0 11 0 0.25}
{5 6 0 11 0 0.0}
{6 6 0 11 0 0.11}
{7 6 0 11 0 0.39}
{11 1 0 11 0 0}
{12 6 0 11 0 0.0}
{13 6 0 11 0 0.0}
{14 6 0 11 0 0.25}
{15 6 0 11 0 0.0}
{16 6 0 11 0 0.11}
{17 6 0 11 0 0.39}
{21 1 0 11 0 0}
{22 6 0 11 0 0.0}
{23 6 0 11 0 0.0}
{24 6 0 11 0 0.25}
{25 6 0 11 0 0.0}
{26 6 0 11 0 0.11}
{27 6 0 11 0 0.39}
} 1}
{{
{1 1 0 11 0 0}
{2 6 0 11 16 0.0}
{3 6 0 11 32 0.0}
{4 6 0 11 28 0.25}
{5 6 0 11 48 0.0}
{6 6 0 11 42 0.11}
{7 6 0 11 42 0.39}
} 60}
{{
{1 1 16 11 0 0}
{2 6 16 14 16 0.0}
{3 6 16 10 32 0.0}
{4 6 16 9 28 0.25}
{5 6 16 6 48 0.0}
{6 6 16 5 42 0.11}
{7 6 16 5 42 0.39}
{11 1 0 11 0 0}
{12 6 0 11 16 0.0}
{13 6 0 11 32 0.0}
{14 6 0 11 28 0.25}
{15 6 0 11 48 0.0}
{16 6 0 11 42 0.11}
{17 6 0 11 42 0.39}
} 60}
]]
scmd([[
fsc st fsetscript 1
]],t)

t=htbl[[
{{
{1 1 128 11 0 0}
{2 6 16 14 128 0.0}
{3 6 16 10 160 0.0}
{4 6 16 9 152 0.25}
{5 6 16 6 224 0.0}
{6 6 16 5 212 0.11}
{7 6 16 5 212 0.39}
{11 1 16 11 0 0}
{12 6 16 14 16 0.0}
{13 6 16 10 32 0.0}
{14 6 16 9 28 0.25}
{15 6 16 6 48 0.0}
{16 6 16 5 42 0.11}
{17 6 16 5 42 0.39}
{21 1 0 11 0 0}
{22 6 0 11 16 0.0}
{23 6 0 11 32 0.0}
{24 6 0 11 28 0.25}
{25 6 0 11 48 0.0}
{26 6 0 11 42 0.11}
{27 6 0 11 42 0.39}
} 60}
{{
} 4}
{{
{21 1 0 11 0 0}
{22 6 0 14 0 0.0}
{23 6 0 10 0 0.0}
{24 6 0 9 0 0.25}
{25 6 0 6 0 0.0}
{26 6 0 5 0 0.11}
{27 6 0 5 0 0.39}
{1 1 16 11 0 0}
{2 6 16 14 16 0.0}
{3 6 16 10 32 0.0}
{4 6 16 9 28 0.25}
{5 6 16 6 48 0.0}
{6 6 16 5 42 0.11}
{7 6 16 5 42 0.39}
{11 1 0 11 0 0}
{12 6 0 14 16 0.0}
{13 6 0 10 32 0.0}
{14 6 0 9 28 0.25}
{15 6 0 6 48 0.0}
{16 6 0 5 42 0.11}
{17 6 0 5 42 0.39}
} 1}
]]
scmd([[
fsc ps fsetscript 0
]],t)
end

function sample()
local t=htbl[[
{{
{1 1 0 7 0 0}
{2 6 0 10 0 0.5}
{3 12 0 9 0 -0.5}
{4 18 0 4 0 1.0}
} 1}
{{
{1 1 8 7 0 0}
{2 6 16 10 16 0.5}
{3 12 16 9 32 -0.5}
{4 18 16 4 48 1.0}
} 15}
]]

scmd([[
fsc st fsetscript 1
]],t)
--id,number,radius,col,distance,angle

t=htbl[[
{{
{1 1 16 7 0 0}
{2 6 16 10 16 0.5}
{3 12 16 9 32 -0.5}
{4 18 16 4 48 1.0}
{5 6 16 10 0 0.5}
{6 12 16 9 0 -0.5}
{7 18 16 4 0 1.0}
} 1}
{{
{1 1 20 7 0 0}
{2 6 20 10 20 0.6}
{3 12 20 9 40 -0.6}
{4 18 20 4 60 1.0}
{5 6 20 7 0 0.5}
{6 12 20 7 0 -0.5}
{7 18 20 7 0 1.0}
} 16}
{{
{1 1 16 7 0 0}
{2 6 16 10 16 0.5}
{3 12 16 9 32 -0.5}
{4 18 16 4 48 1.0}
{5 6 16 7 0 0.5}
{6 12 16 7 0 -0.5}
{7 18 16 7 0 1.0}
} 30}
{{
{1 1 16 7 0 0}
{2 6 16 10 112 0.5}
{3 12 16 9 128 -0.5}
{4 18 16 4 144 1.0}
{5 6 16 10 16 0.5}
{6 12 16 9 32 -0.5}
{7 18 16 4 48 1.0}
} 60}
]]
scmd([[
fsc ps fsetscript 0
]],t)
end

function clone(t)
	return tmap(cat({},t),function(v)
	if ttable(v) then
		return clone(v)
	end
	return v
	end)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
